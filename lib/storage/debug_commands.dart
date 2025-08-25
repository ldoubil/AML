import 'package:aml/ui/widgets/debug_console.dart';

void registerDebugCommands() {
  DebugCommandRegistry()
    ..register('hello', (args) => '你好，调试命令！')
    ..register('add', (args) {
      if (args.length < 2) return '用法: add 数字1 数字2';
      final a = int.tryParse(args[0]);
      final b = int.tryParse(args[1]);
      if (a == null || b == null) return '参数必须是数字';
      return '结果: ${a + b}';
    })
    ..register('echo', (args) => args.join(' '));
}
