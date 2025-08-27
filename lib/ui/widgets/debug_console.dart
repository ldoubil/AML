import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 命令处理器，支持注册和执行命令
class DebugCommandRegistry {
  static final DebugCommandRegistry _instance =
      DebugCommandRegistry._internal();
  factory DebugCommandRegistry() => _instance;
  DebugCommandRegistry._internal();

  final Map<String, Future<String> Function(List<String> args)> _commands = {};

  DebugCommandRegistry register(
      String name, Future<String> Function(List<String> args) handler) {
    _commands[name] = handler;
    return this;
  }

  Future<String> execute(String input) async {
    final parts =
        input.trim().split(RegExp(r'\s+')).map((e) => e.toString()).toList();
    if (parts.isEmpty || parts[0].isEmpty) return '请输入命令';
    final cmd = parts[0];
    final args =
        parts.length > 1 ? parts.sublist(1).cast<String>() : <String>[];
    final handler = _commands[cmd];
    if (handler == null) return '未知命令: $cmd';
    try {
      return await handler(args);
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
  const DebugConsoleOverlay({super.key, this.width = 500, this.height = 260});

  @override
  State<DebugConsoleOverlay> createState() => _DebugConsoleOverlayState();
}

class _DebugConsoleOverlayState extends State<DebugConsoleOverlay> {
  // 用于命令自动补全提示
  final FocusNode _focusNode = FocusNode();
  List<String> _suggestions = [];
  int _selectedSuggestion = -1;
  final TextEditingController _controller = TextEditingController();
  final List<String> _output = [];
  final ScrollController _scrollController = ScrollController();
  bool _minimized = false;

  void _runCommand(String cmd) async {
    setState(() {
      _output.add('Aml> $cmd');
      _output.add('执行中...');
    });
    _controller.clear();
    _suggestions = [];
    _selectedSuggestion = -1;
    
    try {
      final result = await DebugCommandRegistry().execute(cmd);
      setState(() {
        _output.removeLast(); // 移除 "执行中..." 消息
        _output.add(result);
      });
    } catch (e) {
      setState(() {
        _output.removeLast(); // 移除 "执行中..." 消息
        _output.add('执行错误: $e');
      });
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _updateSuggestions(String input) {
    final cmd = input.trim();
    if (cmd.isEmpty) {
      setState(() {
        _suggestions = [];
        _selectedSuggestion = -1;
      });
      return;
    }
    final allCmds = DebugCommandRegistry().commandList;
    final matches = allCmds.where((c) => c.startsWith(cmd)).toList();
    setState(() {
      _suggestions = matches;
      _selectedSuggestion = matches.isNotEmpty ? 0 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: Colors.black87,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _minimized ? 120 : widget.width,
        height: _minimized ? 40 : widget.height,
        padding: const EdgeInsets.all(8),
        child: _minimized
            ? Row(
                children: [
                  const Icon(Icons.terminal, color: Colors.white, size: 18),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text('Console',
                        style: TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.open_in_full,
                        color: Colors.white, size: 18),
                    tooltip: '展开',
                    onPressed: () => setState(() => _minimized = false),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.terminal, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text('调试控制台',
                          style: TextStyle(color: Colors.white)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.minimize, color: Colors.white),
                        tooltip: '最小化',
                        onPressed: () => setState(() => _minimized = true),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 8),
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: ListView(
                        controller: _scrollController,
                        children: _output
                            .map((e) => Text(e,
                                style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontFamily: 'Consolas',
                                    fontSize: 15)))
                            .toList(),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Aml>',
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontFamily: 'Consolas',
                                    fontSize: 15)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: RawKeyboardListener(
                                focusNode: _focusNode,
                                onKey: (event) {
                                  if (_suggestions.isEmpty) return;
                                  if (event.isKeyPressed(
                                      LogicalKeyboardKey.arrowDown)) {
                                    setState(() {
                                      _selectedSuggestion =
                                          (_selectedSuggestion + 1) %
                                              _suggestions.length;
                                    });
                                  } else if (event.isKeyPressed(
                                      LogicalKeyboardKey.arrowUp)) {
                                    setState(() {
                                      _selectedSuggestion =
                                          (_selectedSuggestion -
                                                  1 +
                                                  _suggestions.length) %
                                              _suggestions.length;
                                    });
                                  } else if (event
                                      .isKeyPressed(LogicalKeyboardKey.enter)) {
                                    if (_selectedSuggestion >= 0 &&
                                        _selectedSuggestion <
                                            _suggestions.length) {
                                      _controller.text =
                                          _suggestions[_selectedSuggestion];
                                      _controller.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset:
                                                      _controller.text.length));
                                      _suggestions = [];
                                      _selectedSuggestion = -1;
                                    }
                                  }
                                },
                                child: TextField(
                                  controller: _controller,
                                  style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontFamily: 'Consolas',
                                      fontSize: 15),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    border: InputBorder.none,
                                    hintText: '',
                                  ),
                                  onChanged: _updateSuggestions,
                                  onSubmitted: _runCommand,
                                  autofocus: true,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send,
                                  color: Colors.greenAccent),
                              tooltip: '执行',
                              onPressed: () => _runCommand(_controller.text),
                            ),
                          ],
                        ),
                        if (_suggestions.isNotEmpty)
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 2)
                              ],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _suggestions.length,
                              itemBuilder: (context, idx) {
                                final selected = idx == _selectedSuggestion;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _controller.text = _suggestions[idx];
                                      _controller.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset:
                                                      _controller.text.length));
                                      _suggestions = [];
                                      _selectedSuggestion = -1;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    color: selected
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.transparent,
                                    child: Text(
                                      _suggestions[idx],
                                      style: TextStyle(
                                        color: selected
                                            ? Colors.greenAccent
                                            : Colors.white,
                                        fontFamily: 'Consolas',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
