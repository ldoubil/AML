import 'package:aml/src/features/settings/ui/game_instance_settings_page.dart';
import 'package:aml/src/features/settings/ui/java_settings_page.dart';
import 'package:aml/src/features/settings/ui/privacy_settings_page.dart';
import 'package:aml/src/features/settings/ui/resource_settings_page.dart';
import 'package:aml/src/features/settings/ui/theme_settings_page.dart';
import 'package:flutter/material.dart';

class SettingsPageEntry {
  final String id;
  final String title;
  final IconData icon;
  final Widget page;

  const SettingsPageEntry({
    required this.id,
    required this.title,
    required this.icon,
    required this.page,
  });
}

class SettingsPages {
  static const List<SettingsPageEntry> pages = [
    SettingsPageEntry(
      id: 'theme',
      title: '主题',
      icon: Icons.palette,
      page: ThemeSettingsPage(),
    ),
    SettingsPageEntry(
      id: 'privacy',
      title: '隐私',
      icon: Icons.privacy_tip,
      page: PrivacySettingsPage(),
    ),
    SettingsPageEntry(
      id: 'java',
      title: 'JAVA 配置',
      icon: Icons.code,
      page: JavaSettingsPage(),
    ),
    SettingsPageEntry(
      id: 'game_instance',
      title: '默认游戏实例配置',
      icon: Icons.games,
      page: GameInstanceSettingsPage(),
    ),
    SettingsPageEntry(
      id: 'resource',
      title: '资源管理',
      icon: Icons.folder,
      page: ResourceSettingsPage(),
    ),
  ];
}
