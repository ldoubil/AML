import 'package:flutter/material.dart';

class GameInstanceSettingsPage extends StatelessWidget {
  const GameInstanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '默认游戏实例配置',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '在这里配置默认游戏实例参数',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          // 添加更多游戏实例设置选项
        ],
      ),
    );
  }
}
