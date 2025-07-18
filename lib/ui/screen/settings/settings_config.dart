import 'package:flutter/material.dart';
import 'package:aml/ui/screen/settings/theme_settings_page.dart';
import 'package:aml/ui/screen/settings/privacy_settings_page.dart';
import 'package:aml/ui/screen/settings/java_settings_page.dart';
import 'package:aml/ui/screen/settings/game_instance_settings_page.dart';
import 'package:aml/ui/screen/settings/resource_settings_page.dart';

// 设置页面配置项
class SettingsPageConfig {
  final String id;
  final String title;
  final IconData icon;
  final Widget page;

  const SettingsPageConfig({
    required this.id,
    required this.title,
    required this.icon,
    required this.page,
  });
}

// 设置页面配置
class SettingsConfig {
  static const List<SettingsPageConfig> pages = [
    SettingsPageConfig(
      id: 'theme',
      title: '主题',
      icon: Icons.palette,
      page: ThemeSettingsPage(),
    ),
    SettingsPageConfig(
      id: 'privacy',
      title: '隐私',
      icon: Icons.privacy_tip,
      page: PrivacySettingsPage(),
    ),
    SettingsPageConfig(
      id: 'java',
      title: 'JAVA配置',
      icon: Icons.code,
      page: JavaSettingsPage(),
    ),
    SettingsPageConfig(
      id: 'game_instance',
      title: '默认游戏实例配置',
      icon: Icons.games,
      page: GameInstanceSettingsPage(),
    ),
    SettingsPageConfig(
      id: 'resource',
      title: '资源管理',
      icon: Icons.folder,
      page: ResourceSettingsPage(),
    ),
  ];
}
