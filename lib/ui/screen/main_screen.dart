// 导入所需的包
import 'package:aml/ui/screen/status_bar.dart';
import 'package:aml/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:aml/ui/widgets/nav_button.dart';

// 主屏幕Widget，使用StatefulWidget以管理状态
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// MainScreen的状态管理类
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
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
            child: Column(
              // 移除 const
              children: [
                NavButton(
                  icon: Icons.home_outlined,
                  label: '首页',
                  isSelected: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                NavButton(
                  icon: Icons.explore_outlined,
                  label: '发现',
                  isSelected: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                NavButton(
                  icon: Icons.checkroom_outlined,
                  label: '衣柜',
                  isSelected: _selectedIndex == 2,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                NavButton(
                  icon: Icons.folder_outlined,
                  label: '资源库',
                  isSelected: _selectedIndex == 3,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
                // 添加一个带有上下边距的分割线
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
                  image: AssetImage('assets/logo.png'),
                  label: '设置',
                  isSelected: _selectedIndex == 4,
                  onTap: () => setState(() => _selectedIndex = 4),
                ),
                NavButton(
                  image: AssetImage('assets/2.webp'),
                  label: '设置',
                  isSelected: _selectedIndex == 5,
                  onTap: () => setState(() => _selectedIndex = 5),
                ),
                NavButton(
                  image: AssetImage('assets/logo.png'),
                  label: '设置',
                  isSelected: _selectedIndex == 6,
                  onTap: () => setState(() => _selectedIndex = 6),
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
                  onTap: () => setState(() => {}),
                ),
                Spacer(),
                CustomButton(
                  icon: Icons.tune_outlined,
                  label: "设置",
                  onTap: () => setState(() => {}),
                ), // 分割线上下边距20
                SizedBox(height: 10),
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
