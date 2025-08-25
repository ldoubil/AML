import 'package:aml/ui/widgets/input_bar.dart';
import 'package:aml/ui/widgets/nav_rect_button.dart';
import 'package:flutter/material.dart';

class ResourceSettingsPage extends StatelessWidget {
  const ResourceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '数据目录',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '在这里管理游戏资源和文件',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Theme.of(context)
                  .colorScheme
                  .tertiaryContainer
                  .withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: InputBarWidget(
                  colorScheme: Theme.of(context).colorScheme,
                  size: InputBarSize.medium,
                  hintText: '',
                ),
              ),
              const SizedBox(width: 10),
              NavRectButton(
                text: "目录",
                defaultBackgroundColor: const Color(0xFF33363D),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.folder_open,
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
