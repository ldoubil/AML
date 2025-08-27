import 'package:aml/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:aml/ui/widgets/nav_button.dart';
import 'package:aml/ui/widgets/custom_button.dart';
import 'package:aml/storage/main_config.dart';
import 'package:aml/ui/screen/settings_screen.dart';

class SideNavigation extends StatelessWidget {
  final ColorScheme colorScheme;

  const SideNavigation({
    super.key,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      color: colorScheme.primary,
      child: Column(
        children: [
          // 动态生成主要导航按钮
          ...MainConfig.pages.asMap().entries.map((entry) {
            final pageConfig = entry.value;
            return NavButton(
              icon: pageConfig.icon,
              label: pageConfig.label,
              isSelected:
                  AppState().currentPage.watch(context) == pageConfig.id,
              onTap: () => AppState().currentPage.value = pageConfig.id,
            );
          }),
          // 添加一个带有上下边距的分割线
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
          ),
          NavButton(
            image: const AssetImage('assets/logo.png'),
            label: '设置',
            isSelected: AppState().currentPage.watch(context) == 'settings',
            onTap: () => AppState().currentPage.value = 'settings',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
          ),
          CustomButton(
            icon: Icons.add_outlined,
            onTap: () {},
          ),
          const Spacer(),
          CustomButton(
            icon: Icons.tune_outlined,
            label: "设置",
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, __, ___) => const SettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
