import 'package:aml/ui/widgets/input_bar.dart';
import 'package:aml/ui/widgets/nav_rect_button.dart';
import 'package:flutter/material.dart';

class JavaSettingsPage extends StatelessWidget {
  const JavaSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Java 21',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          InputBarWidget(
            colorScheme: Theme.of(context).colorScheme,
            size: InputBarSize.medium,
            hintText: '',
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              NavRectButton(
                text: "安装JAVA",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.download, // 安装用下载图标
                isSelected: false,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
              const SizedBox(width: 5),
              NavRectButton(
                text: "搜索",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.search, // 搜索用放大镜图标
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
              const SizedBox(width: 5),
              NavRectButton(
                text: "选择",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.folder_open, // 选择目录用文件夹图标
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
              const SizedBox(width: 5),
              NavRectButton(
                text: "测试",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.check_circle, // 测试用对号图标
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Java 17',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          InputBarWidget(
            colorScheme: Theme.of(context).colorScheme,
            size: InputBarSize.medium,
            hintText: '',
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              NavRectButton(
                text: "安装JAVA",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.download, // 安装用下载图标
                isSelected: false,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
              const SizedBox(width: 5),
              NavRectButton(
                text: "搜索",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.search, // 搜索用放大镜图标
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
              const SizedBox(width: 5),
              NavRectButton(
                text: "选择",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.folder_open, // 选择目录用文件夹图标
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
              const SizedBox(width: 5),
              NavRectButton(
                text: "测试",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.check_circle, // 测试用对号图标
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Java 8',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          InputBarWidget(
            colorScheme: Theme.of(context).colorScheme,
            size: InputBarSize.medium,
            hintText: '',
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              NavRectButton(
                text: "安装JAVA",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.download, // 安装用下载图标
                isSelected: false,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
              const SizedBox(width: 5),
              NavRectButton(
                text: "搜索",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.search, // 搜索用放大镜图标
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
              const SizedBox(width: 5),
              NavRectButton(
                text: "选择",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.folder_open, // 选择目录用文件夹图标
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
              const SizedBox(width: 5),
              NavRectButton(
                text: "测试",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.check_circle, // 测试用对号图标
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
            ],
          ),
          // 添加更多JAVA设置选项
        ],
      ),
    );
  }
}
