import 'package:aml/ui/widgets/custom_tooltop.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? hoverBackgroundColor;
  final Color? hoverIconColor;
  final String? label; // 新增可选 label 参数

  const CustomButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.hoverBackgroundColor,
    this.hoverIconColor,
    this.label, // 添加到构造函数
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
      duration: const Duration(milliseconds: 100), // 增加动画时长使渐变更明显
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
      begin: colorScheme.tertiary.withAlpha(0),
      end: widget.hoverBackgroundColor ?? colorScheme.tertiary,
    ).animate(CurvedAnimation(
      parent: _hoverAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _iconColorAnimation = ColorTween(
      begin: colorScheme.tertiaryContainer,
      end: widget.hoverIconColor ?? colorScheme.onTertiaryContainer,
    ).animate(CurvedAnimation(
      parent: _hoverAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverAnimationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverAnimationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverAnimationController.reverse();
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
                      scale:
                          _animationController.status ==
                                      AnimationStatus.forward ||
                                  _animationController.status ==
                                      AnimationStatus.completed
                              ? _scaleAnimation
                                  .value // 按下状态优先
                              : (_isHovered
                                  ? _backgroundScaleAnimation.value
                                  : 1.0),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _backgroundColorAnimation.value,
                          borderRadius: BorderRadius.circular(24),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    widget.icon,
                    size: 24,
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
