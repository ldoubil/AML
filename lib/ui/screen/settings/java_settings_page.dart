import 'package:aml/ui/widgets/input_bar.dart';
import 'package:aml/ui/widgets/nav_rect_button.dart';
import 'package:aml/util/java_download.dart';
import 'package:aml/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'dart:io';

// Java版本配置类
class JavaVersionConfig {
  final int version;
  final TextEditingController controller;
  final Signal<bool> isDownloading;
  final Signal<bool> isTesting;
  
  JavaVersionConfig({
    required this.version,
    required this.controller,
    required this.isDownloading,
    required this.isTesting,
  });
  
  void dispose() {
    controller.dispose();
    isDownloading.dispose();
    isTesting.dispose();
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
        controller: TextEditingController(text: _appStore.java21Directory.value),
        isDownloading: signal(false),
        isTesting: signal(false),
      ),
      17: JavaVersionConfig(
        version: 17,
        controller: TextEditingController(text: _appStore.java17Directory.value),
        isDownloading: signal(false),
        isTesting: signal(false),
      ),
      8: JavaVersionConfig(
        version: 8,
        controller: TextEditingController(text: _appStore.java8Directory.value),
        isDownloading: signal(false),
        isTesting: signal(false),
      ),
    };
    
    // 为每个控制器添加监听器
    _javaConfigs.forEach((version, config) {
      config.controller.addListener(() {
        _updateJavaPath(version, config.controller.text);
      });
    });
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
      await JavaDownloadUtil.autoInstallJava(
        version,
        onProgress: (progress, message) {
        },
        onComplete: (success, result) {
          if (!mounted) return;
          
          if (success && result != null) {
            config.controller.text = result;
            _showSnackBar('Java $version 安装成功！');
          } else {
            _showSnackBar('Java $version 安装失败！');
          }
        },
      );
    } catch (e) {
      _showSnackBar('安装过程中发生错误: $e');
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
      final javaVersion = await JavaDownloadUtil.checkJavaInstallation();
      if (javaVersion != null) {
        _javaConfigs[version]!.controller.text = javaVersion.path;
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
        _javaConfigs[version]!.controller.text = result.files.single.path!;
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
      final javaPath = config.controller.text;
      if (javaPath.isEmpty) {
        _showSnackBar('请先设置Java路径');
        return;
      }

      final isValid = await JavaDownloadUtil.testJRE(javaPath, version);
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
        InputBarWidget(
          colorScheme: Theme.of(context).colorScheme,
          size: InputBarSize.medium,
          hintText: 'Java $version 路径',
          controller: config.controller,
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Watch((context) => NavRectButton(
                  text: config.isDownloading.value ? "下载中..." : "安装JAVA",
                  defaultBackgroundColor: const Color(0xFF33363D),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  icon: config.isDownloading.value ? Icons.downloading : Icons.download,
                  isSelected: false,
                  onMouseEnter: () {},
                  onMouseExit: () {},
                  onTap: config.isDownloading.value ? () {} : () => _installJava(version),
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
                  text: config.isTesting.value ? "测试中..." : "测试",
                  defaultBackgroundColor: const Color(0xFF33363D),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  icon: config.isTesting.value ? Icons.hourglass_empty : Icons.check_circle,
                  isSelected: false,
                  width: 80,
                  onMouseEnter: () {},
                  onMouseExit: () {},
                  onTap: config.isTesting.value ? () {} : () => _testJava(version),
                )),
          ],
        ),
      ],
    );
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
