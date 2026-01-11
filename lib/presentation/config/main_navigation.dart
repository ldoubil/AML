import 'package:flutter/material.dart';

import 'package:aml/presentation/screens/main/discover_page.dart';
import 'package:aml/presentation/screens/main/home_page.dart';
import 'package:aml/presentation/screens/main/resource_page.dart';
import 'package:aml/presentation/screens/main/wardrobe_page.dart';

class MainNavigationItem {
  final String id;
  final IconData icon;
  final String label;
  final Widget page;
  final bool keepState;

  const MainNavigationItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.page,
    this.keepState = false,
  });
}

class MainNavigationConfig {
  static const List<MainNavigationItem> pages = [
    MainNavigationItem(
      id: 'home',
      icon: Icons.home_outlined,
      label: '首页',
      page: HomePage(),
      keepState: true,
    ),
    MainNavigationItem(
      id: 'discover',
      icon: Icons.explore_outlined,
      label: '发现',
      page: DiscoverPage(),
      keepState: true,
    ),
    MainNavigationItem(
      id: 'wardrobe',
      icon: Icons.checkroom_outlined,
      label: '衣柜',
      page: WardrobePage(),
    ),
    MainNavigationItem(
      id: 'resource',
      icon: Icons.folder_outlined,
      label: '资源库',
      page: ResourcePage(),
    ),
  ];
}
