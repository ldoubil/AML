// 导入所需的包
import 'package:aml/ui/screen/status_bar.dart';
import 'package:flutter/material.dart';

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
                // 这里可以添加菜单项
                // Icon(Icons.menu, size: 32),
                // SizedBox(height: 16),
                // Icon(Icons.home, size: 32),
                // SizedBox(height: 16),
                // Icon(Icons.settings, size: 32),
              ],
            ),
          ),
          // 右侧内容区域，自适应宽度
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
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
                child: Text('你好世界', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
