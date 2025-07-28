import 'package:flutter/material.dart';
import '../ui/screen/main/home_page.dart';
import '../ui/screen/main/discover_page.dart';
import '../ui/screen/main/wardrobe_page.dart';
import '../ui/screen/main/resource_page.dart';

class MainPageConfig {
  final String id;
  final IconData icon;
  final String label;
  final Widget page;
  final bool keepState;

  const MainPageConfig({
    required this.id,
    required this.icon,
    required this.label,
    required this.page,
    this.keepState = false,
  });
}

class MainConfig {
  static const List<MainPageConfig> pages = [
    MainPageConfig(
      id: 'home',
      icon: Icons.home_outlined,
      label: '首页',
      page: HomePage(),
      keepState: true,
    ),
    MainPageConfig(
      id: 'discover',
      icon: Icons.explore_outlined,
      label: '发现',
      page: DiscoverPage(),
      keepState: true,
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