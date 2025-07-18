import 'package:flutter/material.dart';
import 'home_page.dart';
import 'discover_page.dart';
import 'wardrobe_page.dart';
import 'resource_page.dart';

class MainPageConfig {
  final String id;
  final IconData icon;
  final String label;
  final Widget page;

  const MainPageConfig({
    required this.id,
    required this.icon,
    required this.label,
    required this.page,
  });
}

class MainConfig {
  static const List<MainPageConfig> pages = [
    MainPageConfig(
      id: 'home',
      icon: Icons.home_outlined,
      label: '首页',
      page: HomePage(),
    ),
    MainPageConfig(
      id: 'discover',
      icon: Icons.explore_outlined,
      label: '发现',
      page: DiscoverPage(),
    ),
    MainPageConfig(
      id: 'wardrobe',
      icon: Icons.checkroom_outlined,
      label: '衣柜',
      page: WardrobePage(),
    ),
    MainPageConfig(
      id: 'resource',
      icon: Icons.folder_outlined,
      label: '资源库',
      page: ResourcePage(),
    ),
  ];
}