import 'package:aml/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

// 设置页面Widget
class CreateNewInstance extends StatefulWidget {
  const CreateNewInstance({super.key});

  @override
  State<CreateNewInstance> createState() => _CreateNewInstanceState();
}

class _CreateNewInstanceState extends State<CreateNewInstance>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _translateAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _translateAnimation = Tween<Offset>(
      begin: const Offset(-0.04, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _backgroundColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: const Color.fromARGB(77, 0, 0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _close() {
    _animationController.reverse();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ModalAnimatedDialog(
      animationController: _animationController,
      scaleAnimation: _scaleAnimation,
      opacityAnimation: _opacityAnimation,
      translateAnimation: _translateAnimation,
      backgroundColorAnimation: _backgroundColorAnimation,
      onClose: _close,
      child: Container(
        width: 520,
        height: 630,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.zero,
        child: Column(
          children: [ SizedBox(
              height: 84,
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(width: 30),
                    const Text(
                      '创建游戏实例',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(), // 添加Spacer来将按钮推到最右边
                    CustomButton(
                      icon: Icons.close,
                      size: ButtonSize.medium,
                      backgroundColor: colorScheme.tertiary.withAlpha(80),
                      onTap: _close,
                    ),
                    const SizedBox(width: 30), // 添加右边距，保持对称
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(35),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  
                ],
              ),
            ),
            const SizedBox(height: 20),],
        ),
      ),
    );
  }
}

class ModalAnimatedDialog extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;
  final Animation<Offset> translateAnimation;
  final Animation<Color?> backgroundColorAnimation;
  final VoidCallback onClose;
  final Widget child;

  const ModalAnimatedDialog({
    super.key,
    required this.animationController,
    required this.scaleAnimation,
    required this.opacityAnimation,
    required this.translateAnimation,
    required this.backgroundColorAnimation,
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: onClose,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, _) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, _) {
                    return Container(
                      color: backgroundColorAnimation.value,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {}, // 阻止点击事件冒泡
                          child: FadeTransition(
                            opacity: opacityAnimation,
                            child: SlideTransition(
                              position: translateAnimation,
                              child: ScaleTransition(
                                scale: scaleAnimation,
                                child: child,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
