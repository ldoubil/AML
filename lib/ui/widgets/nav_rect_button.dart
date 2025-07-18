import 'dart:async';
import 'package:aml/ui/widgets/custom_tooltop.dart';
import 'package:flutter/material.dart';

class NavRectButton extends StatefulWidget {
  /// 图标数据
  final IconData? icon;

  /// 图片资源
  final ImageProvider? image;

  /// 按钮文本
  final String? text;

  /// 按钮标签(用于tooltip提示)
  final String label;

  /// 是否选中状态
  final bool isSelected;

  /// 点击回调
  final VoidCallback onTap;

  /// 长按回调
  final VoidCallback? onLongPress;

  /// 按钮宽度
  final double? width;

  /// 默认文本和图标颜色
  final Color? defaultColor;

  /// 悬停时的背景颜色
  final Color? hoverColor;

  /// 悬停时的文本和图标颜色
  final Color? hoverTextColor;

  /// 选中状态的文本和图标颜色
  final Color? selectedColor;

  /// 默认背景色
  final Color? defaultBackgroundColor;

  /// 选中状态的背景色
  final Color? selectedBackgroundColor;

  /// 默认边框颜色
  final Color? defaultBorderColor;

  /// 选中状态的边框颜色
  final Color? selectedBorderColor;

  const NavRectButton({
    super.key,
    this.icon,
    this.image,
    this.text,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
    this.width,
    this.defaultColor,
    this.hoverColor,
    this.hoverTextColor,
    this.selectedColor,
    this.defaultBackgroundColor,
    this.selectedBackgroundColor,
    this.defaultBorderColor,
    this.selectedBorderColor,
  });

  @override
  State<NavRectButton> createState() => _NavRectButtonState();
}

class _NavRectButtonState extends State<NavRectButton>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Timer? _longPressTimer;
  bool _isLongPressed = false;
  DateTime? _tapDownTime;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
    _isLongPressed = false;
    _tapDownTime = DateTime.now();

    // 启动长按计时器
    if (widget.onLongPress != null) {
      _longPressTimer = Timer(const Duration(milliseconds: 500), () {
        _isLongPressed = true;
        widget.onLongPress!();
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _longPressTimer?.cancel();

    // 计算已经过去的时间
    final elapsedTime =
        _tapDownTime != null
            ? DateTime.now().difference(_tapDownTime!).inMilliseconds
            : 0;

    // 确保动画至少播放0.1秒（100毫秒）
    const minAnimationTime = 100;
    final remainingTime = minAnimationTime - elapsedTime;

    if (remainingTime > 0) {
      // 如果还没有达到最小动画时间，延迟执行reverse
      Timer(Duration(milliseconds: remainingTime), () {
        _animationController.reverse();
      });
    } else {
      // 已经达到最小时间，立即执行reverse
      _animationController.reverse();
    }

    // 如果不是长按，则执行点击回调
    if (!_isLongPressed) {
      widget.onTap();
    }
  }

  void _handleTapCancel() {
    _longPressTimer?.cancel();

    // 计算已经过去的时间
    final elapsedTime =
        _tapDownTime != null
            ? DateTime.now().difference(_tapDownTime!).inMilliseconds
            : 0;

    // 确保动画至少播放0.1秒（100毫秒）
    const minAnimationTime = 100;
    final remainingTime = minAnimationTime - elapsedTime;

    if (remainingTime > 0) {
      // 如果还没有达到最小动画时间，延迟执行reverse
      Timer(Duration(milliseconds: remainingTime), () {
        _animationController.reverse();
      });
    } else {
      // 已经达到最小时间，立即执行reverse
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 定义默认颜色
    final defaultTextColor =
        widget.defaultColor ?? colorScheme.tertiaryContainer;
    final hoverTextColor =
        widget.hoverTextColor ?? colorScheme.onTertiaryContainer;
    final selectedTextColor = widget.selectedColor ?? colorScheme.onTertiary;
    final defaultBgColor = widget.defaultBackgroundColor ?? Colors.transparent;
    final hoverBgColor = widget.hoverColor ?? colorScheme.tertiary;
    final selectedBgColor =
        widget.selectedBackgroundColor ?? colorScheme.onTertiary.withAlpha(50);
    final defaultBorderColor = widget.defaultBorderColor ?? Colors.transparent;
    final selectedBorderColor =
        widget.selectedBorderColor ?? colorScheme.primary;

    // 根据状态确定当前颜色
    Color currentTextColor;
    Color currentBgColor;
    Color currentBorderColor;

    if (widget.isSelected) {
      currentTextColor = selectedTextColor;
      currentBgColor = selectedBgColor;
      currentBorderColor = selectedBorderColor;
    } else if (_isHovered) {
      currentTextColor = hoverTextColor;
      currentBgColor = hoverBgColor;
      currentBorderColor = defaultBorderColor;
    } else {
      currentTextColor = defaultTextColor;
      currentBgColor = defaultBgColor;
      currentBorderColor = defaultBorderColor;
    }

    return CustomTooltip(
      message: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click, // 添加手型光标
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  width: widget.width,
                  height: 37,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  constraints:
                      widget.width != null
                          ? BoxConstraints(maxWidth: widget.width!)
                          : null,
                  decoration: BoxDecoration(
                    color: currentBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: currentBorderColor, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.icon != null)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          child: Icon(
                            widget.icon,
                            key: ValueKey(currentTextColor),
                            size: 20,
                            color: currentTextColor,
                          ),
                        ),
                      if (widget.image != null)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          child: Image(
                            key: ValueKey(currentTextColor),
                            image: widget.image!,
                            width: 20,
                            height: 20,
                            color: currentTextColor,
                          ),
                        ),
                      if (widget.text != null) ...[
                        if (widget.icon != null || widget.image != null)
                          const SizedBox(width: 8),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: currentTextColor,
                          ),
                          child: Text(widget.text!),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
