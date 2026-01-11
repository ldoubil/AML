import 'package:flutter/material.dart';

import 'package:aml/presentation/screens/settings/game_instance_settings_page.dart';
import 'package:aml/presentation/screens/settings/java_settings_page.dart';
import 'package:aml/presentation/screens/settings/privacy_settings_page.dart';
import 'package:aml/presentation/screens/settings/resource_settings_page.dart';
import 'package:aml/presentation/screens/settings/theme_settings_page.dart';

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

class SettingsRegistry {
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
