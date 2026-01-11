import 'package:aml/src/shared/widgets/components/dialogs/modal_animated_dialog.dart';
import 'package:aml/src/shared/widgets/components/settings/settings_navigation_panel.dart';
import 'package:aml/src/features/settings/ui/settings_pages.dart';
import 'package:flutter/material.dart';

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

  String _selectedPageId = SettingsPages.pages.first.id;

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
    setState(() => _selectedPageId = pageId);
  }

  Widget _getCurrentPage() {
    final currentConfig = SettingsPages.pages.firstWhere(
      (config) => config.id == _selectedPageId,
      orElse: () => SettingsPages.pages.first,
    );
    return currentConfig.page;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedModalDialog(
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
              color: colorScheme.onSurface.withAlpha(35),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 285,
                    child: SettingsNavigationPanel(
                      selectedPageId: _selectedPageId,
                      onPageSelected: _selectPage,
                    ),
                  ),
                  SizedBox(
                    height: double.infinity,
                    child: FractionallySizedBox(
                      heightFactor: 1,
                      child: VerticalDivider(
                        thickness: 1,
                        color: colorScheme.onSurface.withAlpha(35),
                      ),
                    ),
                  ),
                  Expanded(child: _getCurrentPage()),
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
