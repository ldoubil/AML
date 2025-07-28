// 导入所需的包
import 'package:aml/ui/screen/main/status_bar.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:aml/store/app_store.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:aml/storage/main_config.dart';
import 'package:aml/ui/widgets/side_navigation.dart';

// 主屏幕Widget，使用StatefulWidget以管理状态
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// MainScreen的状态管理类
class _MainScreenState extends State<MainScreen> with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  Widget _getCurrentPage() {
    final currentPage = AppStore().currentPage.watch(context);
    final selectedIndex = MainConfig.pages.indexWhere((page) => page.id == currentPage);

    return IndexedStack(
      index: selectedIndex != -1 ? selectedIndex : 0,
      children: MainConfig.pages.map((pageConfig) {
        return Offstage(
          offstage: pageConfig.id != currentPage,
          child: pageConfig.page,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary, // 设置浅灰色背景
      appBar: const StatusBar(),
      body: Row(
        children: [
          // 左侧菜单，固定宽度64
          SideNavigation(
            colorScheme: colorScheme,
          ),
          // 右侧内容区域，自适应宽度
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    // 阴影的偏移量，x轴1像素，y轴2像素
                    offset: Offset(2, 2),
                    // 阴影的模糊半径为5像素
                    blurRadius: 6,
                    // 阴影的扩散半径为2像素
                    spreadRadius: 5,
                    // 阴影颜色为纯黑色，完全不透明
                    color: const Color.fromARGB(47, 0, 0, 0),
                    // 设置为内阴影
                    inset: true,
                  ),
                ],
                border: Border(
                  left: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 128),
                    width: 1,
                  ),
                  top: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 128),
                    width: 1,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                ),
              ),
              child: _getCurrentPage(),
            ),
          ),
        ],
      ),
    );
  }
}
