import 'dart:async';
import 'package:aml/presentation/components/buttons/custom_tooltip.dart';
import 'package:flutter/material.dart';

enum ButtonSize {
  large, // 48x48
  medium, // 36x36
  small, // 24x24
}

class CustomButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? hoverBackgroundColor;
  final Color? hoverIconColor;
  final Color? IconColor;
  final String? label;
  final ButtonSize size; // 新增尺寸参数
  final VoidCallback? onMouseEnter; // 鼠标进入回调
  final VoidCallback? onMouseExit; // 鼠标离开回调

  const CustomButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.hoverIconColor,
    this.IconColor,
    this.label,
    this.size = ButtonSize.large, // 默认大尺寸
    this.onMouseEnter,
    this.onMouseExit,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _hoverAnimationController;
  late Animation<double> _backgroundScaleAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<Color?> _iconColorAnimation;

  /// 按下时间记录
  DateTime? _tapDownTime;

  // 根据尺寸获取对应的数值
  double get _buttonSize {
    switch (widget.size) {
      case ButtonSize.large:
        return 48;
      case ButtonSize.medium:
        return 36;
      case ButtonSize.small:
        return 24;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case ButtonSize.large:
        return 24;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.small:
        return 12;
    }
  }

  double get _padding {
    switch (widget.size) {
      case ButtonSize.large:
        return 8.0;
      case ButtonSize.medium:
        return 6.0;
      case ButtonSize.small:
        return 4.0;
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _backgroundScaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _hoverAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final colorScheme = Theme.of(context).colorScheme;

    // 初始化颜色动画
    _backgroundColorAnimation = ColorTween(
      begin: widget.backgroundColor ?? colorScheme.tertiary.withAlpha(0),
      end: widget.hoverBackgroundColor ?? colorScheme.tertiary,
    ).animate(
      CurvedAnimation(
        parent: _hoverAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _iconColorAnimation = ColorTween(
      begin: widget.IconColor ?? colorScheme.tertiaryContainer,
      end: widget.hoverIconColor ?? colorScheme.onTertiaryContainer,
    ).animate(
      CurvedAnimation(
        parent: _hoverAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverAnimationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
    _tapDownTime = DateTime.now();
  }

  void _handleTapUp(TapUpDetails details) {
    // 计算已经过去的时间
    final elapsedTime = _tapDownTime != null
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

    // 执行点击回调
    widget.onTap();
  }

  void _handleTapCancel() {
    // 计算已经过去的时间
    final elapsedTime = _tapDownTime != null
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
    Widget button = MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverAnimationController.forward();
        widget.onMouseEnter?.call();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverAnimationController.reverse();
        widget.onMouseExit?.call();
      },
      cursor: _isHovered ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 背景层 - 应用缩放和颜色渐变动画
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: _hoverAnimationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.status ==
                                  AnimationStatus.forward ||
                              _animationController.status ==
                                  AnimationStatus.completed
                          ? _scaleAnimation.value // 按下状态优先
                          : (_isHovered
                              ? _backgroundScaleAnimation.value
                              : 1.0),
                      child: Container(
                        width: _buttonSize,
                        height: _buttonSize,
                        decoration: BoxDecoration(
                          color: _backgroundColorAnimation.value,
                          borderRadius: BorderRadius.circular(_buttonSize / 2),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // 内容层 - 应用图标颜色渐变动画
            AnimatedBuilder(
              animation: _hoverAnimationController,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.all(_padding),
                  child: Icon(
                    widget.icon,
                    size: _iconSize,
                    color: _iconColorAnimation.value,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    // 如果 label 不为空，使用 Tooltip 包裹
    if (widget.label != null && widget.label!.isNotEmpty) {
      return CustomTooltip(message: widget.label!, child: button);
    } else {
      return button;
    }
  }
}
