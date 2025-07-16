import 'package:aml/ui/widgets/custom_tooltop.dart';
import 'package:flutter/material.dart';

class NavButton extends StatefulWidget {
  final IconData? icon;
  final ImageProvider? image;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    this.icon,
    this.image,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _hoverAnimationController;
  late Animation<double> _backgroundScaleAnimation;

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
    final colorScheme = Theme.of(context).colorScheme;
    Widget button = MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        // 只有未选中的按钮才执行悬停动画
        if (!widget.isSelected) {
          _hoverAnimationController.forward();
        }
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        if (!widget.isSelected) {
          _hoverAnimationController.reverse();
        }
      },
      cursor: _isHovered ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 背景层 - 应用缩放动画
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: _hoverAnimationController,
                  builder: (context, child) {
                    // 组合两种动画效果：悬停缩放和点击缩放
                    // 当按下时，无论是否悬停，都应用_scaleAnimation
                    // 当未选中且悬停时，应用_backgroundScaleAnimation
                    // 当选中时，不应用悬停动画
                    return Transform.scale(
                      scale:
                          _animationController.status ==
                                      AnimationStatus.forward ||
                                  _animationController.status ==
                                      AnimationStatus.completed
                              ? _scaleAnimation
                                  .value // 按下状态优先
                              : (!widget.isSelected && _isHovered
                                  ? _backgroundScaleAnimation.value
                                  : 1.0), // 只有未选中的按钮才应用悬停动画
                      child: Container(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color:
                              widget.isSelected
                                  ? colorScheme.onTertiary.withAlpha(76)
                                  : (_isHovered
                                      ? colorScheme.tertiary
                                      : colorScheme.tertiary.withAlpha(0)),
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // 内容层 - 不应用缩放动画
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.image != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(51),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image(
                          image: widget.image!,
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else if (widget.icon != null)
                    Icon(
                      widget.icon,
                      size: 24,
                      color:
                          widget.isSelected
                              ? colorScheme.onTertiary
                              : (_isHovered
                                  ? colorScheme.onTertiaryContainer
                                  : colorScheme.tertiaryContainer),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    
    // 如果 label 不为空，使用 Tooltip 包裹
    if (widget.label.isNotEmpty) {
      return CustomTooltip(message: widget.label, child: button);
    } else {
      return button;
    }
  }
}
