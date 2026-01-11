import 'dart:io';

import 'package:aml/src/app/app_store.dart';
import 'package:aml/core/window_manager.dart';
import 'package:aml/src/rust/frb_generated.dart';
import 'package:aml/src/features/debug/application/debug_commands.dart';
import 'package:flutter/widgets.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RustLib.init();
  await AppStore().initialize();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await WindowManagerUtils.initializeWindow();
  }

  registerDebugCommands();
}
