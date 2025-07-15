// 导入所需的包
import 'package:aml/ui/screen/status_bar.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

// 主屏幕Widget，使用StatefulWidget以管理状态
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// MainScreen的状态管理类
class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary, // 设置浅灰色背景
      appBar: const StatusBar(),
      body: Row(
        children: [
          // 左侧菜单，固定宽度64
          Container(
            width: 64,
            color: colorScheme.primary,
            child: const Column(
              children: [
              
              ],
            ),
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
              child: const Center(
                child: Text('', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
