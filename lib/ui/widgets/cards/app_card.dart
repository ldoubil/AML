import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final String title;
  final String description;
  final String downloadCount;
  final String iconUrl;
  final bool isFavorite;

  const AppCard({
    super.key,
    required this.title,
    required this.description,
    required this.downloadCount,
    required this.iconUrl,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 128,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 图标区域
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              color: colorScheme.onPrimary,
              border: Border.all(
                color: colorScheme.onTertiaryContainer.withOpacity(0.1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                image: Uri.tryParse(iconUrl)?.hasAbsolutePath ?? false 
                  ? NetworkImage(iconUrl) 
                  : const AssetImage('assets/logo.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 标题、简介、下载量区域
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.tertiaryContainer,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // 简介
                Text(
                  description,
                  style: TextStyle(
                    color: colorScheme.tertiaryContainer.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Text(
                downloadCount,
                style: TextStyle(
                  color: colorScheme.tertiaryContainer.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              // 下载按钮
              ElevatedButton(
                onPressed: () {
                  // 处理下载逻辑
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.tertiaryContainer,
                  foregroundColor: colorScheme.tertiaryContainer,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('下载'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
