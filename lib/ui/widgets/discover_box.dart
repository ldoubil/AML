import 'package:flutter/material.dart';
import 'package:aml/api/modrinth_api.dart';

class DiscoverBox extends StatelessWidget {
  final ModrinthProject result;

  const DiscoverBox({super.key, required this.result});

  // 私有方法 返回可用的图片url
  Widget _getAvailableImageUrl() {
    // 优先返回result.featured_gallery
    if (result.featuredGallery != null && result.featuredGallery!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          result.featuredGallery!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    if (result.gallery != null && result.gallery!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          result.gallery![0],
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    } else {
      return const Icon(Icons.image_not_supported);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 上半部分：图片 (占45%高度)
            SizedBox(
              height: 150, // 固定高度
              child: _getAvailableImageUrl(),
            ),
            const SizedBox(height: 8),
            // 下半部分：图标、名称、简介、下载次数、收藏次数 (占55%高度)
            Flexible(
              flex: 55,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                    // 图标和名称
                    Row(
                      children: [
                        // 这里可以放置图标，如果ModrinthProject有图标字段的话
                        // Icon(Icons.category, size: 20),
                        // const SizedBox(width: 4),
                        Expanded(
                           child: Text(
                             result.title,
                             style: TextStyle(
                                 color: colorScheme.onPrimaryContainer, fontSize: 16),
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                           ),
                         ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // 简介
                    Text(
                      result.description,
                      style: TextStyle(
                          color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                          fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(), // 填充剩余空间，将下面的信息推到底部
                    // 下载次数和收藏次数
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Downloads: ${result.downloads}',
                          style: TextStyle(
                              color: colorScheme.onPrimaryContainer.withOpacity(0.6),
                              fontSize: 10),
                        ),
                        Text(
                          'Follows: ${result.follows}',
                          style: TextStyle(
                              color: colorScheme.onPrimaryContainer.withOpacity(0.6),
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        )],
        ),
      ),
    );
  }
}
