import 'package:aml/ui/widgets/input_bar.dart';
import 'package:aml/ui/widgets/nav_rect_button.dart';
import 'package:aml/state/app_state.dart';
import 'package:aml/util/java_download_rust.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'dart:io';

// Java版本配置类
class JavaVersionConfig {
  final int version;
  final Signal<bool> isDownloading;
  final Signal<bool> isTesting;
  final TextEditingController controller = TextEditingController();
  
  JavaVersionConfig({
    required this.version,
    required this.isDownloading,
    required this.isTesting,
  });
  
  void dispose() {
    isDownloading.dispose();
    isTesting.dispose();
    controller.dispose();
  }
}

class JavaSettingsPage extends StatefulWidget {
  const JavaSettingsPage({super.key});

  @override
  State<JavaSettingsPage> createState() => _JavaSettingsPageState();
}

class _JavaSettingsPageState extends State<JavaSettingsPage> {
  final _appStore = AppState();
  late final Map<int, JavaVersionConfig> _javaConfigs;

  @override
  void initState() {
    super.initState();
    
    // 初始化Java版本配置
    _javaConfigs = {
      21: JavaVersionConfig(
        version: 21,
        isDownloading: signal(false),
        isTesting: signal(false),
      ),
      17: JavaVersionConfig(
        version: 17,
        isDownloading: signal(false),
        isTesting: signal(false),
      ),
      8: JavaVersionConfig(
        version: 8,
        isDownloading: signal(false),
        isTesting: signal(false),
      ),
    };
    
    // 设置controller的初始值
    for (int version in [21, 17, 8]) {
      _javaConfigs[version]!.controller.text = _getJavaPath(version).value;
    }
  }

  // 更新Java路径到signal状态
  void _updateJavaPath(int version, String path) {
    switch (version) {
      case 21:
        _appStore.java21Directory.value = path;
        break;
      case 17:
        _appStore.java17Directory.value = path;
        break;
      case 8:
        _appStore.java8Directory.value = path;
        break;
    }
  }

  @override
  void dispose() {
    _javaConfigs.values.forEach((config) => config.dispose());
    super.dispose();
  }

  // 安装Java
  Future<void> _installJava(int version) async {
    if (!mounted) return;
    
    final config = _javaConfigs[version]!;
    config.isDownloading.value = true;

    try {
      await JavaDownloadRustUtil.autoInstallJava(
        version,
        onProgress: (progress, message) {
          // 打印
          print('安装进度: $progress, $message');
        },
        onComplete: (success, result) {
          // 无论页面是否销毁，都要更新全局状态
          if (success && result != null) {
            // 直接更新AppState，不依赖页面状态
            _updateJavaPath(version, result);
            // 只有页面未销毁时才显示SnackBar
            if (mounted) {
              _showSnackBar('Java $version 安装成功！');
            }
          } else {
            if (mounted) {
              _showSnackBar('Java $version 安装失败！');
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        _showSnackBar('安装过程中发生错误: $e');
      }
    } finally {
      if (mounted) {
        config.isDownloading.value = false;
      }
    }
  }

  // 显示SnackBar的辅助方法
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // 搜索Java
  Future<void> _searchJava(int version) async {
    try {
      final javaVersion = await JavaDownloadRustUtil.checkJavaInstallation();
      if (javaVersion != null) {
        // 只更新AppState，UI会通过Watch自动响应
        _updateJavaPath(version, javaVersion.path);
        _showSnackBar('找到系统Java: ${javaVersion.version}');
      } else {
        _showSnackBar('未找到系统Java安装');
      }
    } catch (e) {
      _showSnackBar('搜索Java时发生错误: $e');
    }
  }

  // 选择Java路径
  Future<void> _selectJavaPath(int version) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: Platform.isWindows ? ['exe'] : [],
        dialogTitle: '选择Java可执行文件',
      );

      if (result != null && result.files.single.path != null) {
        // 只更新AppState，UI会通过Watch自动响应
        _updateJavaPath(version, result.files.single.path!);
        _showSnackBar('Java路径已选择');
      }
    } catch (e) {
      _showSnackBar('选择文件时发生错误: $e');
    }
  }

  // 测试Java
  Future<void> _testJava(int version) async {
    if (!mounted) return;
    
    final config = _javaConfigs[version]!;
    config.isTesting.value = true;

    try {
      // 从AppState中获取Java路径，而不是从controller
      final javaPath = _getJavaPath(version).value;
      if (javaPath.isEmpty) {
        _showSnackBar('请先设置Java路径');
        return;
      }

      final isValid = await JavaDownloadRustUtil.testJRE(javaPath, version);
      if (isValid) {
        _showSnackBar('Java $version 测试通过！');
      } else {
        _showSnackBar('Java $version 测试失败，版本不匹配或路径无效');
      }
    } catch (e) {
      _showSnackBar('测试Java时发生错误: $e');
    } finally {
      if (mounted) {
        config.isTesting.value = false;
      }
    }
  }

  // 构建Java版本设置UI的辅助方法
  Widget _buildJavaVersionSection(int version) {
    final config = _javaConfigs[version]!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Java $version',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        // 使用Watch监听AppState中的Java路径，当路径变化时更新controller的文本
        Watch((context) {
          final javaPath = _getJavaPath(version).watch(context);
          // 只有当路径与当前controller文本不同时才更新，避免循环更新
          if (config.controller.text != javaPath) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              config.controller.text = javaPath;
            });
          }
          return InputBarWidget(
            colorScheme: Theme.of(context).colorScheme,
            size: InputBarSize.medium,
            hintText: 'Java $version 路径',
            onChanged: (value) => _updateJavaPath(version, value),
            controller: config.controller,
          );
        }),
        const SizedBox(height: 5),
        Row(
          children: [
            Watch((context) => NavRectButton(
                  text: config.isDownloading.watch(context) ? "下载中..." : "安装JAVA",
                  defaultBackgroundColor: const Color(0xFF33363D),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  icon: config.isDownloading.watch(context) ? Icons.downloading : Icons.download,
                  isSelected: false,
                  onMouseEnter: () {},
                  onMouseExit: () {},
                  onTap: config.isDownloading.watch(context) ? () {} : () => _installJava(version),
                )),
            const SizedBox(width: 5),
            NavRectButton(
              text: "搜索",
              defaultBackgroundColor: const Color(0xFF33363D),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              icon: Icons.search,
              isSelected: false,
              width: 80,
              onMouseEnter: () {},
              onMouseExit: () {},
              onTap: () => _searchJava(version),
            ),
            const SizedBox(width: 5),
            NavRectButton(
              text: "选择",
              defaultBackgroundColor: const Color(0xFF33363D),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              icon: Icons.folder_open,
              isSelected: false,
              width: 80,
              onMouseEnter: () {},
              onMouseExit: () {},
              onTap: () => _selectJavaPath(version),
            ),
            const SizedBox(width: 5),
            Watch((context) => NavRectButton(
                  text: config.isTesting.watch(context) ? "测试中..." : "测试",
                  defaultBackgroundColor: const Color(0xFF33363D),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  icon: config.isTesting.watch(context) ? Icons.hourglass_empty : Icons.check_circle,
                  isSelected: false,
                  width: 80,
                  onMouseEnter: () {},
                  onMouseExit: () {},
                  onTap: config.isTesting.watch(context) ? () {} : () => _testJava(version),
                )),
          ],
        ),
      ],
    );
  }

  // 获取对应版本的Java路径Signal
  Signal<String> _getJavaPath(int version) {
    switch (version) {
      case 21:
        return _appStore.java21Directory;
      case 17:
        return _appStore.java17Directory;
      case 8:
        return _appStore.java8Directory;
      default:
        throw ArgumentError('Unsupported Java version: $version');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJavaVersionSection(21),
          const SizedBox(height: 10),
          _buildJavaVersionSection(17),
          const SizedBox(height: 10),
          _buildJavaVersionSection(8),
        ],
      ),
    );
  }
}
