import 'dart:io';

import 'package:aml/app/app_store.dart';
import 'package:aml/src/shared/widgets/components/inputs/input_bar.dart';
import 'package:aml/src/shared/widgets/components/navigation/nav_rect_button.dart';
import 'package:aml/src/features/java/application/java_download_service.dart';
import 'package:aml/src/shared/theme/app_colors.dart';
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
  final _appStore = AppStore().settings.java;
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

    for (final version in [21, 17, 8]) {
      _javaConfigs[version]!.controller.text = _getJavaPath(version).value;
    }
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
        return _appStore.java21Directory;
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
      await JavaDownloadService.autoInstallJava(
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _selectJavaPath(int version) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['exe'],
      );
      if (result != null && result.files.single.path != null) {
        _updateJavaPath(version, result.files.single.path!);
        _javaConfigs[version]!.controller.text = result.files.single.path!;
      }
    } catch (e) {
      _showSnackBar('选择文件失败: $e');
    }
  }

  Future<void> _testJava(int version) async {
    if (!mounted) return;
    final config = _javaConfigs[version]!;
    config.isTesting.value = true;

    try {
      final javaPath = _getJavaPath(version).value;
      if (javaPath.isEmpty) {
        _showSnackBar('请先选择 Java 路径');
        return;
      }

      final result = await JavaDownloadService.testJRE(javaPath, version);
      if (mounted) {
        _showSnackBar(result ? 'Java $version 测试通过' : 'Java $version 测试失败');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('测试过程中发生错误: $e');
      }
    } finally {
      if (mounted) {
        config.isTesting.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Java 配置',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '配置不同版本 Java 路径，用于启动不同版本 Minecraft',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colorScheme.tertiaryContainer.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [21, 17, 8].map((version) {
                final config = _javaConfigs[version]!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Java $version',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: InputBarWidget(
                                colorScheme: colorScheme,
                                size: InputBarSize.medium,
                                hintText: '选择 Java 可执行文件路径',
                                controller: config.controller,
                                onChanged: (value) =>
                                    _updateJavaPath(version, value),
                              ),
                            ),
                            const SizedBox(width: 10),
                            NavRectButton(
                              text: "选择",
                              defaultBackgroundColor: AppColors.neutralPanel,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              icon: Icons.folder_open,
                              isSelected: false,
                              width: 80,
                              onMouseEnter: () {},
                              onMouseExit: () {},
                              onTap: () => _selectJavaPath(version),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Watch(
                                (_) {
                                  final downloading =
                                      config.isDownloading.watch(context);
                                  return ElevatedButton(
                                    onPressed: downloading
                                        ? null
                                        : () => _installJava(version),
                                    child: Text(
                                      downloading ? '安装中...' : '自动安装',
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Watch(
                                (_) {
                                  final testing =
                                      config.isTesting.watch(context);
                                  return ElevatedButton(
                                    onPressed: testing
                                        ? null
                                        : () => _testJava(version),
                                    child: Text(testing ? '测试中...' : '测试'),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        if (Platform.isWindows)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Windows 推荐选择 javaw.exe',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
