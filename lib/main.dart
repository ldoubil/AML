import 'dart:io';

import 'package:aml/aml_app.dart';
import 'package:aml/core/window_manager.dart';
import 'package:aml/state/app_state.dart';
import 'package:aml/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';

import 'storage/debug_commands.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Rust 库
  await RustLib.init();

  // 初始化全局状态与配置
  await AppState().initialize();

  // 初始化窗口管理器（桌面平台）
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await WindowManagerUtils.initializeWindow();
  }

  // 注册调试命令
  registerDebugCommands();

  // 启动应用
  runApp(const AmlApp());
}
