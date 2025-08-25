import 'dart:io';
import 'package:aml/aml_app.dart';
import 'package:aml/core/window_manager.dart';
import 'package:flutter/material.dart';
import 'package:aml/src/rust/frb_generated.dart';

import 'storage/debug_commands.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await WindowManagerUtils.initializeWindow();
  }
  registerDebugCommands();
  runApp(const AmlApp());
}
