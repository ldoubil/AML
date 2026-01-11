import 'package:aml/src/features/debug/domain/command_registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugConsoleOverlay extends StatefulWidget {
  final double width;
  final double height;
  const DebugConsoleOverlay({super.key, this.width = 500, this.height = 260});

  @override
  State<DebugConsoleOverlay> createState() => _DebugConsoleOverlayState();
}

class _DebugConsoleOverlayState extends State<DebugConsoleOverlay> {
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
        _output.removeLast();
        _output.add(result);
      });
    } catch (e) {
      setState(() {
        _output.removeLast();
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
                    child: Text(
                      'Console',
                      style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.open_in_full,
                      color: Colors.white,
                      size: 18,
                    ),
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
                      const Text(
                        '调试控制台',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.minimize,
                          color: Colors.white,
                        ),
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
                            .map(
                              (e) => Text(
                                e,
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontFamily: 'Consolas',
                                  fontSize: 15,
                                ),
                              ),
                            )
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
                            const Text(
                              'Aml>',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontFamily: 'Consolas',
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: RawKeyboardListener(
                                focusNode: _focusNode,
                                onKey: (event) {
                                  if (_suggestions.isEmpty) return;
                                  if (event.isKeyPressed(
                                    LogicalKeyboardKey.arrowDown,
                                  )) {
                                    setState(() {
                                      _selectedSuggestion =
                                          (_selectedSuggestion + 1) %
                                              _suggestions.length;
                                    });
                                  } else if (event.isKeyPressed(
                                    LogicalKeyboardKey.arrowUp,
                                  )) {
                                    setState(() {
                                      _selectedSuggestion =
                                          (_selectedSuggestion -
                                                  1 +
                                                  _suggestions.length) %
                                              _suggestions.length;
                                    });
                                  } else if (event.isKeyPressed(
                                    LogicalKeyboardKey.enter,
                                  )) {
                                    if (_selectedSuggestion >= 0 &&
                                        _selectedSuggestion <
                                            _suggestions.length) {
                                      _controller.text =
                                          _suggestions[_selectedSuggestion];
                                      _controller.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                          offset: _controller.text.length,
                                        ),
                                      );
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
                                    fontSize: 15,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
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
                              icon: const Icon(
                                Icons.send,
                                color: Colors.greenAccent,
                              ),
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
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _suggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = _suggestions[index];
                                final selected = index == _selectedSuggestion;
                                return Container(
                                  color: selected
                                      ? Colors.greenAccent.withOpacity(0.2)
                                      : Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    suggestion,
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontFamily: 'Consolas',
                                      fontSize: 14,
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
