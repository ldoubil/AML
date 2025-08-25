import 'package:flutter/material.dart';

/// 命令处理器，支持注册和执行命令
class DebugCommandRegistry {
  static final DebugCommandRegistry _instance =
      DebugCommandRegistry._internal();
  factory DebugCommandRegistry() => _instance;
  DebugCommandRegistry._internal();

  final Map<String, String Function(List<String> args)> _commands = {};

  DebugCommandRegistry register(
      String name, String Function(List<String> args) handler) {
    _commands[name] = handler;
    return this;
  }

  String execute(String input) {
    final parts =
        input.trim().split(RegExp(r'\s+')).map((e) => e.toString()).toList();
    if (parts.isEmpty || parts[0].isEmpty) return '请输入命令';
    final cmd = parts[0];
    final args =
        parts.length > 1 ? parts.sublist(1).cast<String>() : <String>[];
    final handler = _commands[cmd];
    if (handler == null) return '未知命令: $cmd';
    try {
      return handler(args);
    } catch (e) {
      return '命令执行错误: $e';
    }
  }

  List<String> get commandList => _commands.keys.toList();
}

/// 调试命令行悬浮窗口
class DebugConsoleOverlay extends StatefulWidget {
  final double width;
  final double height;
  const DebugConsoleOverlay({super.key, this.width = 400, this.height = 300});

  @override
  State<DebugConsoleOverlay> createState() => _DebugConsoleOverlayState();
}

class _DebugConsoleOverlayState extends State<DebugConsoleOverlay> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _output = [];
  final ScrollController _scrollController = ScrollController();

  void _runCommand(String cmd) {
    setState(() {
      _output.add('> $cmd');
      final result = DebugCommandRegistry().execute(cmd);
      _output.add(result);
    });
    _controller.clear();
    // 自动滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: Colors.black87,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: _output
                    .map((e) =>
                        Text(e, style: const TextStyle(color: Colors.white)))
                    .toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: '输入调试命令',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _runCommand,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () => _runCommand(_controller.text),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: DebugCommandRegistry()
                  .commandList
                  .map((cmd) => Chip(
                      label: Text(cmd,
                          style: const TextStyle(color: Colors.white))))
                  .toList(),
            ),
          ],
        ),
      ),
    );
   
  }
}
