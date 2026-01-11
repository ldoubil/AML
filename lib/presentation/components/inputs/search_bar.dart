import 'package:flutter/material.dart';

enum SearchBarSize { large, medium, small }

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    required this.colorScheme,
    this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.size = SearchBarSize.large,
    this.tailIcon,
    this.tailIconOnTap,
  });

  final ColorScheme colorScheme;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final Widget? prefixIcon;
  final SearchBarSize size;
  final Widget? tailIcon;
  final VoidCallback? tailIconOnTap;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height;
    double iconSize;
    double fontSize;
    EdgeInsets contentPadding;
    String hintText;
    switch (widget.size) {
      case SearchBarSize.large:
        height = 48;
        iconSize = 24;
        fontSize = 20;
        contentPadding =
            const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12);
        hintText = widget.hintText ?? '搜索';
        break;
      case SearchBarSize.medium:
        height = 35;
        iconSize = 20;
        fontSize = 15;
        contentPadding =
            const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6);
        hintText = widget.hintText ?? '输入关键字';
        break;
      case SearchBarSize.small:
        height = 20;
        iconSize = 16;
        fontSize = 12;
        contentPadding =
            const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2);
        hintText = widget.hintText ?? '搜';
        break;
    }
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: widget.colorScheme.primaryContainer,
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
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: widget.prefixIcon != null
                ? IconTheme(
                    data: IconThemeData(
                        size: iconSize,
                        color: widget.colorScheme.tertiaryContainer),
                    child: widget.prefixIcon!,
                  )
                : null,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.clear, size: iconSize),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged?.call('');
                    },
                  ),
                if (widget.tailIcon != null)
                  GestureDetector(
                    onTap: widget.tailIconOnTap,
                    child: IconTheme(
                      data: IconThemeData(size: iconSize),
                      child: widget.tailIcon!,
                    ),
                  ),
              ],
            ),
            border: InputBorder.none,
            contentPadding: contentPadding,
          ),
          style: TextStyle(
            color: widget.colorScheme.tertiaryContainer,
            fontSize: fontSize,
          ),
          cursorColor: widget.colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}
