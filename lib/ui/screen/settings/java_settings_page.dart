import 'package:aml/ui/widgets/input_bar.dart';
import 'package:aml/ui/widgets/nav_rect_button.dart';
import 'package:aml/util/java_download.dart';
import 'package:aml/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'dart:io';

class JavaSettingsPage extends StatefulWidget {
  const JavaSettingsPage({super.key});

  @override
  State<JavaSettingsPage> createState() => _JavaSettingsPageState();
}

class _JavaSettingsPageState extends State<JavaSettingsPage> {
  // 获取应用状态实例
  final _appStore = AppStore();

  // Java路径控制器
  late final TextEditingController _java21Controller;
  late final TextEditingController _java17Controller;
  late final TextEditingController _java8Controller;

  // 下载状态信号
  final _isDownloading21 = signal(false);
  final _isDownloading17 = signal(false);
  final _isDownloading8 = signal(false);

  // 测试状态信号
  final _isTesting21 = signal(false);
  final _isTesting17 = signal(false);
  final _isTesting8 = signal(false);

  @override
  void initState() {
    super.initState();
    // 初始化控制器并与signal同步
    _java21Controller = TextEditingController(
        text: _appStore.appBaseState.value.java21Directory ?? '');
    _java17Controller = TextEditingController(
        text: _appStore.appBaseState.value.java17Directory ?? '');
    _java8Controller = TextEditingController(
        text: _appStore.appBaseState.value.java8Directory ?? '');

    // 监听控制器变化并更新signal
    _java21Controller.addListener(() {
      _updateJavaPath(21, _java21Controller.text);
    });
    _java17Controller.addListener(() {
      _updateJavaPath(17, _java17Controller.text);
    });
    _java8Controller.addListener(() {
      _updateJavaPath(8, _java8Controller.text);
    });
  }

  // 更新Java路径到signal状态
  void _updateJavaPath(int version, String path) {
    final currentState = _appStore.appBaseState.value;
    switch (version) {
      case 21:
        _appStore.appBaseState.value =
            currentState.copyWith(java21Directory: path);
        break;
      case 17:
        _appStore.appBaseState.value =
            currentState.copyWith(java17Directory: path);
        break;
      case 8:
        _appStore.appBaseState.value =
            currentState.copyWith(java8Directory: path);
        break;
    }
  }

  @override
  void dispose() {
    _java21Controller.dispose();
    _java17Controller.dispose();
    _java8Controller.dispose();
    _isDownloading21.dispose();
    _isDownloading17.dispose();
    _isDownloading8.dispose();
    _isTesting21.dispose();
    _isTesting17.dispose();
    _isTesting8.dispose();
    super.dispose();
  }

  // 安装Java
  Future<void> _installJava(int version) async {
    // 检查widget是否仍然mounted
    if (!mounted) return;

    // 使用signal更新下载状态
    switch (version) {
      case 21:
        _isDownloading21.value = true;
        break;
      case 17:
        _isDownloading17.value = true;
        break;
      case 8:
        _isDownloading8.value = true;
        break;
    }

    try {
      final javaPath = await JavaDownloadUtil.autoInstallJava(
        version,
        onProgress: (progress, message) {
          // 可以在这里显示进度
          print('下载进度: ${(progress * 100).toStringAsFixed(1)}% - $message');
        },
        onComplete: (success, result) {
          // 检查widget是否仍然mounted
          if (!mounted) return;

          if (success && result != null) {
            // 更新控制器文本，这会自动触发signal更新
            switch (version) {
              case 21:
                _java21Controller.text = result;
                break;
              case 17:
                _java17Controller.text = result;
                break;
              case 8:
                _java8Controller.text = result;
                break;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Java $version 安装成功！')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Java $version 安装失败！')),
            );
          }
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('安装过程中发生错误: $e')),
      );
    } finally {
      // 检查widget是否仍然mounted，防止在dispose后修改signal
      if (mounted) {
        // 使用signal更新下载状态
        switch (version) {
          case 21:
            _isDownloading21.value = false;
            break;
          case 17:
            _isDownloading17.value = false;
            break;
          case 8:
            _isDownloading8.value = false;
            break;
        }
      }
    }
  }

  // 搜索Java
  Future<void> _searchJava(int version) async {
    try {
      final javaVersion = await JavaDownloadUtil.checkJavaInstallation();
      if (javaVersion != null) {
        // 更新控制器文本，这会自动触发signal更新
        switch (version) {
          case 21:
            _java21Controller.text = javaVersion.path;
            break;
          case 17:
            _java17Controller.text = javaVersion.path;
            break;
          case 8:
            _java8Controller.text = javaVersion.path;
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('找到系统Java: ${javaVersion.version}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('未找到系统Java安装')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('搜索Java时发生错误: $e')),
      );
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
        final selectedPath = result.files.single.path!;
        // 更新控制器文本，这会自动触发signal更新
        switch (version) {
          case 21:
            _java21Controller.text = selectedPath;
            break;
          case 17:
            _java17Controller.text = selectedPath;
            break;
          case 8:
            _java8Controller.text = selectedPath;
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Java路径已选择')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择文件时发生错误: $e')),
      );
    }
  }

  // 测试Java
  Future<void> _testJava(int version) async {
    // 检查widget是否仍然mounted
    if (!mounted) return;

    // 使用signal更新测试状态
    switch (version) {
      case 21:
        _isTesting21.value = true;
        break;
      case 17:
        _isTesting17.value = true;
        break;
      case 8:
        _isTesting8.value = true;
        break;
    }

    try {
      String javaPath;
      switch (version) {
        case 21:
          javaPath = _java21Controller.text;
          break;
        case 17:
          javaPath = _java17Controller.text;
          break;
        case 8:
          javaPath = _java8Controller.text;
          break;
        default:
          return;
      }

      if (javaPath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请先设置Java路径')),
        );
        return;
      }

      final isValid = await JavaDownloadUtil.testJRE(javaPath, version);
      if (isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Java $version 测试通过！')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Java $version 测试失败，版本不匹配或路径无效')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('测试Java时发生错误: $e')),
      );
    } finally {
      // 检查widget是否仍然mounted，防止在dispose后修改signal
      if (mounted) {
        // 使用signal更新测试状态
        switch (version) {
          case 21:
            _isTesting21.value = false;
            break;
          case 17:
            _isTesting17.value = false;
            break;
          case 8:
            _isTesting8.value = false;
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Java 21',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          InputBarWidget(
            colorScheme: Theme.of(context).colorScheme,
            size: InputBarSize.medium,
            hintText: 'Java 21 路径',
            controller: _java21Controller,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Watch((context) => NavRectButton(
                    text: _isDownloading21.value ? "下载中..." : "安装JAVA",
                    defaultBackgroundColor: const Color(0xFF33363D),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    icon: _isDownloading21.value
                        ? Icons.downloading
                        : Icons.download,
                    isSelected: false,
                    onMouseEnter: () {},
                    onMouseExit: () {},
                    onTap:
                        _isDownloading21.value ? () {} : () => _installJava(21),
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
                onTap: () => _searchJava(21),
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
                onTap: () => _selectJavaPath(21),
              ),
              const SizedBox(width: 5),
              Watch((context) => NavRectButton(
                    text: _isTesting21.value ? "测试中..." : "测试",
                    defaultBackgroundColor: const Color(0xFF33363D),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    icon: _isTesting21.value
                        ? Icons.hourglass_empty
                        : Icons.check_circle,
                    isSelected: false,
                    width: 80,
                    onMouseEnter: () {},
                    onMouseExit: () {},
                    onTap: _isTesting21.value ? () {} : () => _testJava(21),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Java 17',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          InputBarWidget(
            colorScheme: Theme.of(context).colorScheme,
            size: InputBarSize.medium,
            hintText: 'Java 17 路径',
            controller: _java17Controller,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Watch((context) => NavRectButton(
                    text: _isDownloading17.value ? "下载中..." : "安装JAVA",
                    defaultBackgroundColor: const Color(0xFF33363D),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    icon: _isDownloading17.value
                        ? Icons.downloading
                        : Icons.download,
                    isSelected: false,
                    onMouseEnter: () {},
                    onMouseExit: () {},
                    onTap:
                        _isDownloading17.value ? () {} : () => _installJava(17),
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
                onTap: () => _searchJava(17),
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
                onTap: () => _selectJavaPath(17),
              ),
              const SizedBox(width: 5),
              Watch((context) => NavRectButton(
                    text: _isTesting17.value ? "测试中..." : "测试",
                    defaultBackgroundColor: const Color(0xFF33363D),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    icon: _isTesting17.value
                        ? Icons.hourglass_empty
                        : Icons.check_circle,
                    isSelected: false,
                    width: 80,
                    onMouseEnter: () {},
                    onMouseExit: () {},
                    onTap: _isTesting17.value ? () {} : () => _testJava(17),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Java 8',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          InputBarWidget(
            colorScheme: Theme.of(context).colorScheme,
            size: InputBarSize.medium,
            hintText: 'Java 8 路径',
            controller: _java8Controller,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Watch((context) => NavRectButton(
                    text: _isDownloading8.value ? "下载中..." : "安装JAVA",
                    defaultBackgroundColor: const Color(0xFF33363D),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    icon: _isDownloading8.value
                        ? Icons.downloading
                        : Icons.download,
                    isSelected: false,
                    onMouseEnter: () {},
                    onMouseExit: () {},
                    onTap:
                        _isDownloading8.value ? () {} : () => _installJava(8),
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
                onTap: () => _searchJava(8),
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
                onTap: () => _selectJavaPath(8),
              ),
              const SizedBox(width: 5),
              Watch((context) => NavRectButton(
                    text: _isTesting8.value ? "测试中..." : "测试",
                    defaultBackgroundColor: const Color(0xFF33363D),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    icon: _isTesting8.value
                        ? Icons.hourglass_empty
                        : Icons.check_circle,
                    isSelected: false,
                    width: 80,
                    onMouseEnter: () {},
                    onMouseExit: () {},
                    onTap: _isTesting8.value ? () {} : () => _testJava(8),
                  )),
            ],
          ),
          // 添加更多JAVA设置选项
        ],
      ),
    );
  }
}
