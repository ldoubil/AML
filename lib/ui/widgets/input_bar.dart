import 'package:flutter/material.dart';

enum InputBarSize { large, medium, small }

class InputBarWidget extends StatefulWidget {
  const InputBarWidget({
    super.key,
    required this.colorScheme,
    this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.size = InputBarSize.large,
    this.tailIcon,
    this.tailIconOnTap,
    this.obscureText = false,
    this.controller,
  });

  final ColorScheme colorScheme;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final Widget? prefixIcon;
  final InputBarSize size;
  final Widget? tailIcon;
  final VoidCallback? tailIconOnTap;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  State<InputBarWidget> createState() => _InputBarWidgetState();
}

class _InputBarWidgetState extends State<InputBarWidget> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // 只有当controller是内部创建的时候才dispose
    if (widget.controller == null) {
      _controller.dispose();
    }
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
      case InputBarSize.large:
        height = 48;
        iconSize = 24;
        fontSize = 20;
        contentPadding =
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10);
        hintText = widget.hintText ?? '输入内容';
        break;
      case InputBarSize.medium:
        height = 35;
        iconSize = 20;
        fontSize = 18;
        contentPadding =
            const EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 12);
        hintText = widget.hintText ?? '请输入';
        break;
      case InputBarSize.small:
        height = 20;
        iconSize = 16;
        fontSize = 12;
        contentPadding =
            const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2);
        hintText = widget.hintText ?? '填';
        break;
    }
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: widget.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
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
          obscureText: widget.obscureText,
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
            suffixIcon: widget.tailIcon != null
                ? GestureDetector(
                    onTap: widget.tailIconOnTap,
                    child: IconTheme(
                      data: IconThemeData(size: iconSize),
                      child: widget.tailIcon!,
                    ),
                  )
                : null,
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
