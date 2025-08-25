import 'package:aml/ui/widgets/nav_rect_button.dart';
import 'package:aml/ui/screen/settings/settings_config.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io'; // 添加导入以获取系统信息

// 设置页面Widget
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _translateAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  // 当前选中的页面ID
  String _selectedPageId = SettingsConfig.pages.first.id;

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

  void _closeSettings() {
    _animationController.reverse();
    Navigator.of(context).pop();
  }

  void _selectPage(String pageId) {
    setState(() {
      _selectedPageId = pageId;
    });
  }

  Widget _buildNavigationItem(SettingsPageConfig config) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 2, right: 0, bottom: 1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: NavRectButton(
          icon: config.icon,
          text: config.title,
          label: config.title,
          isSelected: _selectedPageId == config.id,
          width: 245,
          onTap: () => _selectPage(config.id),
        ),
      ),
    );
  }

  Widget _getCurrentPage() {
    final currentConfig = SettingsConfig.pages.firstWhere(
      (config) => config.id == _selectedPageId,
      orElse: () => SettingsConfig.pages.first,
    );
    return currentConfig.page;
  }

  // 构建应用信息组件
  Widget _buildAppInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 10),
      child: Container(
        width: 235,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // 应用图标
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.rocket_launch,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            // 应用信息文本
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'AstralMC App 0.10.3',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      onClose: _closeSettings,
      child: Container(
        width: 900,
        height: 630,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            const SizedBox(
              height: 84,
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(width: 30),
                    Icon(Icons.settings, size: 25),
                    SizedBox(width: 8),
                    Text(
                      '设置',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(35),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 285,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: SettingsConfig.pages
                                .map(
                                  (config) => _buildNavigationItem(config),
                                )
                                .toList(),
                          ),
                        ),
                        // 在底部添加应用信息
                        _buildAppInfo(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: double.infinity,
                    child: FractionallySizedBox(
                      heightFactor: 1,
                      child: VerticalDivider(
                        thickness: 1,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(35),
                      ),
                    ),
                  ),
                  Expanded(child: _getCurrentPage()),
                ],
              ),
            ),
            SizedBox(height: 20),
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
