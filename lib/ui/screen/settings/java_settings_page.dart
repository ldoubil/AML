import 'dart:io';

import 'package:aml/state/app_state.dart';
import 'package:aml/ui/widgets/input_bar.dart';
import 'package:aml/ui/widgets/nav_rect_button.dart';
import 'package:aml/util/java_download_rust.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

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

    for (int version in [21, 17, 8]) {
      _javaConfigs[version]!.controller.text = _getJavaPath(version).value;
    }
  }

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
    for (final config in _javaConfigs.values) {
      config.dispose();
    }
    super.dispose();
  }

  Future<void> _installJava(int version) async {
    if (!mounted) return;

    final config = _javaConfigs[version]!;
    config.isDownloading.value = true;

    try {
      await JavaDownloadRustUtil.autoInstallJava(
        version,
        onProgress: (progress, message) {
          debugPrint('安装进度: $progress, $message');
        },
        onComplete: (success, result) {
          if (success && result != null) {
            _updateJavaPath(version, result);
            if (mounted) {
              _showSnackBar('Java $version 安装成功');
            }
          } else {
            if (mounted) {
              _showSnackBar('Java $version 安装失败');
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _searchJava(int version) async {
    try {
      final javaVersion = await JavaDownloadRustUtil.checkJavaInstallation();
      if (javaVersion != null) {
        _updateJavaPath(version, javaVersion.path);
        _showSnackBar('找到系统 Java: ${javaVersion.version}');
      } else {
        _showSnackBar('未找到系统 Java 安装');
      }
    } catch (e) {
      _showSnackBar('搜索 Java 时发生错误: $e');
    }
  }

  Future<void> _selectJavaPath(int version) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: Platform.isWindows ? ['exe'] : [],
        dialogTitle: '选择 Java 可执行文件',
      );

      if (result != null && result.files.single.path != null) {
        _updateJavaPath(version, result.files.single.path!);
        _showSnackBar('Java 路径已选择');
      }
    } catch (e) {
      _showSnackBar('选择文件时发生错误: $e');
    }
  }

  Future<void> _testJava(int version) async {
    if (!mounted) return;

    final config = _javaConfigs[version]!;
    config.isTesting.value = true;

    try {
      final javaPath = _getJavaPath(version).value;
      if (javaPath.isEmpty) {
        _showSnackBar('请先设置 Java 路径');
        return;
      }

      final isValid = await JavaDownloadRustUtil.testJRE(javaPath, version);
      if (isValid) {
        _showSnackBar('Java $version 测试通过');
      } else {
        _showSnackBar('Java $version 测试失败，版本不匹配或路径无效');
      }
    } catch (e) {
      _showSnackBar('测试 Java 时发生错误: $e');
    } finally {
      if (mounted) {
        config.isTesting.value = false;
      }
    }
  }

  Widget _buildJavaVersionSection(int version) {
    final config = _javaConfigs[version]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Java $version',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Watch((context) {
          final javaPath = _getJavaPath(version).watch(context);
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
            Watch(
              (context) => NavRectButton(
                text:
                    config.isDownloading.watch(context) ? "下载中..." : "安装 JAVA",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: config.isDownloading.watch(context)
                    ? Icons.downloading
                    : Icons.download,
                isSelected: false,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: config.isDownloading.watch(context)
                    ? () {}
                    : () => _installJava(version),
              ),
            ),
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
            Watch(
              (context) => NavRectButton(
                text: config.isTesting.watch(context) ? "测试中..." : "测试",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: config.isTesting.watch(context)
                    ? Icons.hourglass_empty
                    : Icons.check_circle,
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: config.isTesting.watch(context)
                    ? () {}
                    : () => _testJava(version),
              ),
            ),
          ],
        ),
      ],
    );
  }

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
