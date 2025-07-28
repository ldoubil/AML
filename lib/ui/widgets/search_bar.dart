import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: widget.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused
                ? widget.colorScheme.onTertiary.withOpacity(0.40)
                : Colors.transparent,
            width: 4,
          ),
        ),
        child: TextField(
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '搜索',
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: TextStyle(
            color: widget.colorScheme.tertiaryContainer,
          ), // 文字颜色设为在主题色上可见的颜色
          cursorColor: widget.colorScheme.onTertiaryContainer, // 设置光标颜色
        ),
      ),
    );
  }
}