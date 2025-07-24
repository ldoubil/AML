import 'dart:async';
import 'package:aml/ui/widgets/custom_button.dart';
import 'package:aml/ui/widgets/nav_rect_button.dart';
import 'package:flutter/material.dart';
import 'custom_tooltop.dart';

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
  // 在其他按钮上
  bool isHoveredOnOther = false;
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
    // 如果鼠标在其他按钮上，则不触发缩放动画
    if (!isHoveredOnOther) {
      _animationController.forward();
    }
    _tapDownTime = DateTime.now();
  }

  void _handleTapUp(TapUpDetails details) {
    // 只有在没有悬停其他按钮且动画已启动时才恢复动画
    if (!isHoveredOnOther) {
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

    // 执行点击回调（只有在没有悬停其他按钮时）
    if (!isHoveredOnOther && widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    // 只有在没有悬停其他按钮且动画已启动时才恢复动画
    if (!isHoveredOnOther) {
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              // 第一个部分：游戏图片
                              Container(
                                width: 47,
                                height: 47,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey[400]!,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: AssetImage('assets/2.webp'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // 第二个部分：标题和简介
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 上半部分：游戏标题
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Row(
                                          children: [
                                            Text(
                                              '游戏标题',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              Icons.person,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.7),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '单人模式',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // 下半部分：游戏简介
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            CustomTooltip(
                                              position: TooltipPosition.top,
                                              message: '2024年12月15日 14:30:25',
                                              child: MouseRegion(
                                                cursor: SystemMouseCursors.help,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      '3天前',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface
                                                            .withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              child: Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: Colors.grey[400]!,
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 2,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/2.webp',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                '游戏名称',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.7),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), // 左侧自适应内容区域
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
                              onMouseEnter: () {
                                setState(() {
                                  isHoveredOnOther = true;
                                });
                              },
                              onMouseExit: () {
                                setState(() {
                                  isHoveredOnOther = false;
                                });
                              },
                              onTap: () {},
                            ),
                            SizedBox(width: 4),
                            CustomButton(
                              icon: Icons.more_vert,
                              onTap: () {},
                              size: ButtonSize.medium,
                              onMouseEnter: () {
                                setState(() {
                                  isHoveredOnOther = true;
                                });
                              },
                              onMouseExit: () {
                                setState(() {
                                  isHoveredOnOther = false;
                                });
                              },
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
