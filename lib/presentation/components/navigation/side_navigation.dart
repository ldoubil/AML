import 'package:aml/app/app_store.dart';
import 'package:aml/presentation/config/main_navigation.dart';
import 'package:aml/presentation/screens/dialogs/create_new_instance.dart';
import 'package:aml/presentation/screens/settings/settings_screen.dart';
import 'package:aml/presentation/components/buttons/custom_button.dart';
import 'package:aml/presentation/components/navigation/nav_button.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
          ...MainNavigationConfig.pages.asMap().entries.map((entry) {
            final pageConfig = entry.value;
            return NavButton(
              icon: pageConfig.icon,
              label: pageConfig.label,
              isSelected: AppStore().navigation.currentPage.watch(context) ==
                  pageConfig.id,
              onTap: () =>
                  AppStore().navigation.currentPage.value = pageConfig.id,
            );
          }),
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
            isSelected:
                AppStore().navigation.currentPage.watch(context) == 'settings',
            onTap: () => AppStore().navigation.currentPage.value = 'settings',
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
            label: "添加",
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, __, ___) => const CreateNewInstance(),
                ),
              );
            },
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
