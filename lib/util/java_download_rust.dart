import 'package:aml/src/rust/api/java_download.dart' as rust_java;
import 'package:aml/state/app_state.dart';
import 'package:aml/state/progress_state.dart';

/// Rust版本的Java下载工具类
class JavaDownloadRustUtil {
  /// 自动安装 Java (使用Rust实现)
  /// 返回安装路径，如果失败返回 null
  static Future<String?> autoInstallJava(
    int javaVersion, {
    Function(double progress, String message)? onProgress,
    Function(bool success, String? result)? onComplete,
  }) async {
    // 创建进度项
    final progressStore = ProgressStore();
    final progressItem = progressStore.createProgressItem('Java $javaVersion 安装');
    
    try {
      final appDataDir = AppState().appDataDirectory.value ?? "";
      
      if (appDataDir.isEmpty) {
        progressItem.dispose();
        throw Exception('应用数据目录未设置');
      }
      
      final result = await rust_java.autoInstallJava(
        javaVersion: javaVersion,
        appDataDir: appDataDir,
        onProgress: (double progress, String message) async {
          // 更新进度项
          progressItem.setProgress(progress, message);
          // 调用原有回调
          onProgress?.call(progress, message);
        },
        onComplete: (bool success, String? result) async {
          // 完成后移除进度项
          progressItem.dispose();
          // 调用原有回调
          onComplete?.call(success, result);
        },
      );
      
      return result;
    } catch (e) {
      // 出错时也要移除进度项
      progressItem.dispose();
      onComplete?.call(false, null);
      return null;
    }
  }
  
  /// 检查指定路径的 JRE
  static Future<JavaRuntimeVersion?> checkJRE(String javaPath) async {
    try {
      final result = await rust_java.checkJre(javaPath: javaPath);
      if (result != null) {
        return JavaRuntimeVersion(
          version: result.version,
          path: result.path,
          majorVersion: result.majorVersion,
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
      return await rust_java.testJre(
        javaPath: javaPath,
        expectedMajorVersion: expectedMajorVersion,
      );
    } catch (e) {
      return false;
    }
  }
  
  /// 检查系统中已安装的 Java
  static Future<JavaRuntimeVersion?> checkJavaInstallation() async {
    try {
      final result = await rust_java.checkJavaInstallation();
      if (result != null) {
        return JavaRuntimeVersion(
          version: result.version,
          path: result.path,
          majorVersion: result.majorVersion,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// 获取系统最大内存 (KB)
  static Future<int> getMaxMemory() async {
    try {
      final result = await rust_java.getMaxMemory();
      return result.toInt();
    } catch (e) {
      return 8 * 1024 * 1024; // 默认返回 8GB
    }
  }
  
  /// 从版本字符串中提取主版本号
  static Future<int> extractJavaVersion(String version) async {
    try {
      return await rust_java.extractJavaVersion(version: version);
    } catch (e) {
      throw FormatException('无法解析 Java 版本: $version');
    }
  }
}

/// Java 运行时版本信息类 (与原Dart版本兼容)
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