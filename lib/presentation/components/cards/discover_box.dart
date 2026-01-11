import 'package:flutter/material.dart';
import 'package:aml/data/api/modrinth_api.dart';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 图标和名称
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(
                              0.5,
                            ),
                            border: Border.all(
                              color: colorScheme.outline,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: result.iconUrl != null &&
                                  result.iconUrl!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.network(
                                    result.iconUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.extension,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              result.title,
                              style: TextStyle(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // 简介
                    Text(
                      result.description,
                      style: TextStyle(
                          color: colorScheme.onPrimaryContainer.withOpacity(
                            0.7,
                          ),
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
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
                            color: colorScheme.onPrimaryContainer.withOpacity(
                              0.6,
                            ),
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Follows: ${result.follows}',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer.withOpacity(
                              0.6,
                            ),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
