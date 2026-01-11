import 'dart:io';

import 'package:aml/app/app.dart';
import 'package:aml/core/window_manager.dart';
import 'package:aml/app/app_store.dart';
import 'package:aml/app/debug/debug_commands.dart';
import 'package:aml/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Rust 库
  await RustLib.init();

  // 初始化全局状态与配置
  await AppStore().initialize();

  // 初始化窗口管理器（桌面平台）
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await WindowManagerUtils.initializeWindow();
  }

  // 注册调试命令
  registerDebugCommands();

  // 启动应用
  runApp(const AmlApp());
}
