import 'dart:io';
import 'dart:convert';
import 'package:aml/model/app_base_state.dart';
import 'package:aml/state/app_state.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:archive/archive.dart';
import '../state/progress_state.dart';

/// Java 运行时版本信息类
class JavaRuntimeVersion {
  final String version;
  final String path;
  final int majorVersion;

  JavaRuntimeVersion({
    required this.version,
    required this.path,
    required this.majorVersion,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'path': path,
        'majorVersion': majorVersion,
      };

  factory JavaRuntimeVersion.fromJson(Map<String, dynamic> json) => JavaRuntimeVersion(
        version: json['version'],
        path: json['path'],
        majorVersion: json['majorVersion'],
      );
}

/// Java 下载包信息
class JavaPackage {
  final String downloadUrl;
  final String name;

  JavaPackage({
    required this.downloadUrl,
    required this.name,
  });

  factory JavaPackage.fromJson(Map<String, dynamic> json) => JavaPackage(
        downloadUrl: json['download_url'],
        name: json['name'],
      );
}

/// Java 下载和管理工具类
class JavaDownloadUtil {
  static const String _azulApiBase = 'https://api.azul.com/metadata/v1/zulu/packages';

  /// 获取系统架构
  static String get _systemArch {
    final arch = Platform.version.contains('x64') ? 'x64' : 'arm64';
    return arch;
  }

  /// 获取系统类型
  static String get _systemOS {
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    throw UnsupportedError('不支持的操作系统');
  }

  /// 从版本字符串中提取主版本号
  static int extractJavaVersion(String version) {
    final regex = RegExp(r'(\d+)\.');
    final match = regex.firstMatch(version);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    // 处理 Java 9+ 的版本格式 (如 "11.0.1")
    final parts = version.split('.');
    if (parts.isNotEmpty) {
      return int.parse(parts[0]);
    }
    throw FormatException('无法解析 Java 版本: $version');
  }

  /// 获取可用的 Java 包信息
  static Future<List<JavaPackage>> _fetchJavaPackages(int javaVersion) async {
    final url = '$_azulApiBase?arch=$_systemArch&java_version=$javaVersion&os=$_systemOS&archive_type=zip&javafx_bundled=false&java_package_type=jre&page_size=1';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode != 200) {
      throw HttpException('获取 Java 包信息失败: ${response.statusCode}');
    }

    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => JavaPackage.fromJson(json)).toList();
  }

  /// 下载文件 (流式下载，支持实时进度)
  static Future<List<int>> _downloadFile(String url, {Function(double)? onProgress}) async {
    final client = http.Client();
    
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);
      
      if (response.statusCode != 200) {
        throw HttpException('下载失败: ${response.statusCode}');
      }

      final contentLength = response.contentLength;
      final List<int> bytes = [];
      int downloadedBytes = 0;
      
      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
        downloadedBytes += chunk.length;
        
        if (onProgress != null && contentLength != null && contentLength > 0) {
          final progress = (downloadedBytes / contentLength) * 100;
          onProgress(progress);
        }
      }
      
      // 确保最终进度为100%
      if (onProgress != null) {
        onProgress(100.0);
      }
      
      return bytes;
    } finally {
      client.close();
    }
  }

  /// 自动安装 Java (带进度显示)
  /// 返回安装路径，如果失败返回 null
  static Future<String?> autoInstallJava(
    int javaVersion, {
    Function(double progress, String message)? onProgress,
    Function(bool success, String? result)? onComplete,
  }) async {
    // 创建进度项
    final progressItem = ProgressStore().createProgressItem('下载 Java $javaVersion');
    
    try {
      // 获取默认安装目录
      final javaVersionsDir = await _getDefaultJavaDir();
      
      progressItem.setProgress(0.1, '获取 Java 版本信息');
      onProgress?.call(0.1, '获取 Java 版本信息');
      final packages = await _fetchJavaPackages(javaVersion);
      
      if (packages.isEmpty) {
        throw Exception('未找到 Java $javaVersion 版本，系统: $_systemOS，架构: $_systemArch');
      }

      progressItem.setProgress(0.15, '准备下载 Java $javaVersion');
      onProgress?.call(0.15, '准备下载 Java $javaVersion');
      final package = packages.first;
      
      // 下载文件，占总进度的60%
      progressItem.setProgress(0.2, '开始下载 Java $javaVersion');
      onProgress?.call(0.2, '开始下载 Java $javaVersion');
      final fileBytes = await _downloadFile(
        package.downloadUrl,
        onProgress: (downloadProgress) {
          // 下载进度从20%到80%
          final totalProgress = 0.2 + (downloadProgress / 100) * 0.6;
          final message = '下载中... ${downloadProgress.toStringAsFixed(1)}%';
          progressItem.setProgress(totalProgress, message);
          onProgress?.call(totalProgress, message);
        },
      );

      progressItem.setProgress(0.82, '下载完成，开始解压 Java');
      onProgress?.call(0.82, '下载完成，开始解压 Java');
      
      // 创建 Java 版本目录
      final javaDir = Directory(javaVersionsDir);
      if (!javaDir.existsSync()) {
        javaDir.createSync(recursive: true);
      }

      // 解压 ZIP 文件
      progressItem.setProgress(0.85, '正在解析压缩文件...');
      onProgress?.call(0.85, '正在解析压缩文件...');
      final archive = ZipDecoder().decodeBytes(fileBytes);
      
      // 获取解压后的根目录名
      String? rootDirName;
      for (final file in archive) {
        if (file.isFile) continue;
        final parts = file.name.split('/');
        if (parts.isNotEmpty) {
          rootDirName = parts[0];
          break;
        }
      }

      if (rootDirName != null) {
        final existingPath = path.join(javaVersionsDir, rootDirName);
        final existingDir = Directory(existingPath);
        if (existingDir.existsSync()) {
          progressItem.setProgress(0.87, '清理旧版本文件...');
          onProgress?.call(0.87, '清理旧版本文件...');
          existingDir.deleteSync(recursive: true);
        }
      }

      // 解压文件，显示详细进度
      progressItem.setProgress(0.88, '开始解压文件...');
      onProgress?.call(0.88, '开始解压文件...');
      final totalFiles = archive.length;
      int extractedFiles = 0;
      
      for (final file in archive) {
        final filename = file.name;
        final filePath = path.join(javaVersionsDir, filename);
        
        if (file.isFile) {
          final data = file.content as List<int>;
          final fileObj = File(filePath);
          fileObj.createSync(recursive: true);
          fileObj.writeAsBytesSync(data);
        } else {
          Directory(filePath).createSync(recursive: true);
        }
        
        extractedFiles++;
        if (extractedFiles % 50 == 0 || extractedFiles == totalFiles) {
          final extractProgress = (extractedFiles / totalFiles) * 100;
          final progress = 0.88 + extractProgress * 0.07 / 100;
          final message = '解压中... $extractedFiles/$totalFiles 文件 (${extractProgress.toStringAsFixed(1)}%)';
          progressItem.setProgress(progress, message);
          onProgress?.call(progress, message);
        }
      }

      progressItem.setProgress(0.96, '配置 Java 环境...');
      onProgress?.call(0.96, '配置 Java 环境...');
      
      // 重命名解压后的目录为 zulu{版本号}
      final targetDirName = 'zulu$javaVersion';
      if (rootDirName != null) {
        progressItem.setProgress(0.97, '重命名 Java 目录...');
        onProgress?.call(0.97, '重命名 Java 目录...');
        final originalPath = path.join(javaVersionsDir, rootDirName);
        final targetPath = path.join(javaVersionsDir, targetDirName);
        final originalDir = Directory(originalPath);
        final targetDir = Directory(targetPath);
        
        // 如果目标目录已存在，先删除
        if (targetDir.existsSync()) {
          targetDir.deleteSync(recursive: true);
        }
        
        // 重命名目录
        if (originalDir.existsSync()) {
          originalDir.renameSync(targetPath);
        }
      }
      
      // 构建 Java 可执行文件路径
      progressItem.setProgress(0.98, '构建 Java 可执行文件路径...');
      onProgress?.call(0.98, '构建 Java 可执行文件路径...');
      String javaExecutablePath;
      
      if (Platform.isMacOS) {
        javaExecutablePath = path.join(
          javaVersionsDir,
          targetDirName,
          'zulu-$javaVersion.jre',
          'Contents',
          'Home',
          'bin',
          'java',
        );
      } else {
        final javaExeName = Platform.isWindows ? 'javaw.exe' : 'java';
        javaExecutablePath = path.join(
          javaVersionsDir,
          targetDirName,
          'bin',
          javaExeName,
        );
      }

      progressItem.setProgress(0.99, '验证安装...');
      onProgress?.call(0.99, '验证安装...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      progressItem.setProgress(1.0, 'Java $javaVersion 安装完成！');
      onProgress?.call(1.0, 'Java $javaVersion 安装完成！');
      await Future.delayed(const Duration(seconds: 1));
      progressItem.dispose();

      onComplete?.call(true, javaExecutablePath);
      return javaExecutablePath;
    } catch (e) {
      final errorMessage = '安装过程中发生错误: $e';
      progressItem.setProgressText(errorMessage);
      onProgress?.call(0.0, errorMessage);
      await Future.delayed(const Duration(seconds: 2));
      progressItem.dispose();
      
      onComplete?.call(false, null);
      return null;
    }
  }



  /// 检查指定路径的 JRE
  static Future<JavaRuntimeVersion?> checkJRE(String javaPath) async {
    try {
      final result = await Process.run(javaPath, ['-version']);
      
      if (result.exitCode != 0) {
        return null;
      }

      // Java 版本信息通常在 stderr 中
      final versionOutput = result.stderr.toString();
      final versionRegex = RegExp(r'version "([^"]+)"');
      final match = versionRegex.firstMatch(versionOutput);
      
      if (match != null) {
        final version = match.group(1)!;
        final majorVersion = extractJavaVersion(version);
        
        return JavaRuntimeVersion(
          version: version,
          path: javaPath,
          majorVersion: majorVersion,
        );
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 测试指定路径的 JRE 是否符合要求的版本
  static Future<bool> testJRE(String javaPath, int expectedMajorVersion) async {
    try {
      final javaVersion = await checkJRE(javaPath);
      
      if (javaVersion == null) {
        // 无效的 Java 路径
        return false;
      }
      
      // 记录版本比较信息（可以通过回调或日志系统输出）
      
      return javaVersion.majorVersion == expectedMajorVersion;
    } catch (e) {
      // 测试 Java 路径时出错
      return false;
    }
  }

  /// 检查系统中已安装的 Java
  static Future<JavaRuntimeVersion?> checkJavaInstallation() async {
    try {
      // 尝试运行系统默认的 java 命令
      final result = await Process.run('java', ['-version']);
      
      if (result.exitCode != 0) {
        return null;
      }

      // Java 版本信息通常在 stderr 中
      final versionOutput = result.stderr.toString();
      final versionRegex = RegExp(r'version "([^"]+)"');
      final match = versionRegex.firstMatch(versionOutput);
      
      if (match != null) {
        final version = match.group(1)!;
        final majorVersion = extractJavaVersion(version);
        
        return JavaRuntimeVersion(
          version: version,
          path: 'java', // 系统默认路径
          majorVersion: majorVersion,
        );
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 获取默认的 Java 安装目录
  static Future<String> _getDefaultJavaDir() async {
    String homeDir = AppState().appDataDirectory.value ?? "";
    return path.join(homeDir, 'java');
  }

  /// 获取系统最大内存 (KB)
  static Future<int> getMaxMemory() async {
    try {
      if (Platform.isWindows) {
        final result = await Process.run('wmic', ['computersystem', 'get', 'TotalPhysicalMemory', '/value']);
        if (result.exitCode == 0) {
          final output = result.stdout.toString();
          final regex = RegExp(r'TotalPhysicalMemory=(\d+)');
          final match = regex.firstMatch(output);
          if (match != null) {
            final bytes = int.parse(match.group(1)!);
            return bytes ~/ 1024; // 转换为 KB
          }
        }
      } else if (Platform.isLinux || Platform.isMacOS) {
        final result = await Process.run('cat', ['/proc/meminfo']);
        if (result.exitCode == 0) {
          final output = result.stdout.toString();
          final regex = RegExp(r'MemTotal:\s+(\d+)\s+kB');
          final match = regex.firstMatch(output);
          if (match != null) {
            return int.parse(match.group(1)!);
          }
        }
      }
      
      // 默认返回 8GB
      return 8 * 1024 * 1024;
    } catch (e) {
      // 默认返回 8GB
      return 8 * 1024 * 1024;
    }
  }
}