import 'dart:async';
import 'package:aml/ui/widgets/custom_button.dart';
import 'package:aml/ui/widgets/nav_rect_button.dart';
import 'package:flutter/material.dart';

class GameBackHoverCard extends StatefulWidget {
  final double height;
  final double? width;
  final Color? normalColor;
  final Color? hoverColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  const GameBackHoverCard({
    super.key,
    this.height = 72,
    this.width,
    this.normalColor,
    this.hoverColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  State<GameBackHoverCard> createState() => _GameBackHoverCardState();
}

class _GameBackHoverCardState extends State<GameBackHoverCard>
    with TickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  DateTime? _tapDownTime;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
    _tapDownTime = DateTime.now();
  }

  void _handleTapUp(TapUpDetails details) {
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

    // 执行点击回调
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
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

    return Semantics(
      excludeSemantics: true, // 添加这一行
      child: MouseRegion(
        cursor: SystemMouseCursors.click, // 添加手型光标
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  height: widget.height,
                  width: widget.width ?? double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(15),
                    color:
                        isHovered
                            ? (widget.hoverColor ?? const Color(0xFF2F333B))
                            : (widget.normalColor ?? colorScheme.primary),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(), // 左侧自适应内容区域
                      ),
                      SizedBox(
                        width: 400, // 右侧固定宽度
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            NavRectButton(
                              text: "启动",
                              defaultBackgroundColor: const Color(0xFF33363D),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              icon: Icons.play_arrow,
                              isSelected: false,
                              width: 80,
                              onTap: () {},
                            ),
                            CustomButton(
                              icon: Icons.more_vert,
                              onTap: () {},
                              size: ButtonSize.medium,
                            ), // 右侧第一个按钮
                            SizedBox(width: 12),
                          ],
                        ), // 右侧固定内容区域
                      ),
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
