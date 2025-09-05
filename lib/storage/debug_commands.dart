import 'dart:async';

import 'package:aml/ui/widgets/debug_console.dart';
import 'package:aml/state/progress_state.dart';
import 'package:aml/util/java_download_rust.dart';

void registerDebugCommands() {
  DebugCommandRegistry()
    ..register('hello', (args) async => '你好，调试命令！')
    ..register('add', (args) {
      if (args.length < 2) return Future.value('用法: add 数字1 数字2');
      final a = int.tryParse(args[0]);
      final b = int.tryParse(args[1]);
      if (a == null || b == null) return Future.value('参数必须是数字');
      return Future.value('结果: ${a + b}');
    })
    ..register('echo', (args) async => args.join(' '))
    ..register('createProgressItem', (args) {
      if (args.isEmpty) return Future.value('用法: createProgressItem 名称');
      try {
        final item = ProgressStore().createProgressItem(args[0]);
        item.progress.value = 0;
        Timer.periodic(const Duration(seconds: 1), (timer) {
          if (item.progress.value >= 100) {
            timer.cancel();
          } else {
            item.progress.value += 0.01;
            // 打印
            print('进度: ${item.progress.value}%');
          }
        });
        return Future.value('已创建进度项: ${item.name}');
      } catch (e) {
        return Future.value('创建失败: $e');
      }
    })
    ..register('autoInstallJava', (args) async {
      if (args.isEmpty) return '用法: autoInstallJava 版本号';
      final javaVersion = int.tryParse(args[0]);
      if (javaVersion == null) return '版本号必须是数字';
      final javaPath = await JavaDownloadRustUtil.autoInstallJava(javaVersion);
      return '已安装 Java $javaVersion: $javaPath';
    });
}
