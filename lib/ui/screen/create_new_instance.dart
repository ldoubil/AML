import 'package:aml/ui/widgets/buttons/button_group_widget.dart';
import 'package:aml/ui/widgets/buttons/custom_button.dart';
import 'package:aml/ui/widgets/input/input_bar.dart';
import 'package:aml/ui/widgets/navigation/nav_rect_button.dart';
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

  // 选中的版本类型
  String _selectedVersionType = 'custom';

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
          children: [
            SizedBox(
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
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题文本

                        // 版本类型选择按钮组
                        ButtonGroupWidget(
                          items: const [
                            ButtonGroupItem(
                              text: '自定义',
                              value: 'custom',
                            ),
                            ButtonGroupItem(
                              text: '从文件导入',
                              value: 'from_file',
                            ),
                            ButtonGroupItem(
                              text: '从启动器导入',
                              value: 'from_launcher',
                            ),
                          ],
                          selectedValue: _selectedVersionType,
                          onChanged: (value) {
                            setState(() {
                              _selectedVersionType = value;
                            });
                          },
                          fitContent: true,
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(35),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // 左侧图片容器
                            Container(
                              width: 94,
                              height: 94,
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary,
                                border: Border.all(
                                  color: colorScheme.onTertiaryContainer
                                      .withOpacity(0.1),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                image: const DecorationImage(
                                  image: AssetImage('assets/logo.png')
                                      as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 右侧按钮列
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                NavRectButton(
                                    isSelected: false,
                                    icon: Icons.upload_file,
                                    defaultBackgroundColor:
                                        colorScheme.onPrimary,
                                    text: "选择图标",
                                    label: "选择图标",
                                    onTap: () {}),
                                const SizedBox(height: 8),
                                NavRectButton(
                                    isSelected: false,
                                    icon: Icons.delete_outline,
                                    defaultBackgroundColor:
                                        colorScheme.onPrimary,
                                    text: "选择图标",
                                    label: "取消设置",
                                    onTap: () {}),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          '实例名称',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 9),
                        InputBarWidget(
                          colorScheme: Theme.of(context).colorScheme,
                          size: InputBarSize.medium,
                          hintText: '输入实例名称',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
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
