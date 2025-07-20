import 'package:flutter/material.dart';
import '../../widgets/game_back_hover_card.dart';
import '../../widgets/hover_text_with_arrow.dart';
import '../../widgets/discover_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    '欢迎回家冒险者!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFECF9FB),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '游玩记录',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.tertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return GameBackHoverCard(
                        onTap: () {
                          // 在这里添加点击事件处理
                          print('卡片被点击了');
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  HoverTextWithArrow(text: "发现更多整合包"),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 390, // 每个网格最大宽度
                          childAspectRatio: 320 / 310, // 宽高比 (320:310)
                          crossAxisSpacing: 8, // 水平间距
                          mainAxisSpacing: 8, // 垂直间距
                        ),
                    itemCount: 3, // 显示5个盒子
                    itemBuilder: (context, index) {
                      return DiscoverBox();
                    },
                  ),

                  const SizedBox(height: 16),
                  HoverTextWithArrow(text: "发现更多MOD"),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 390, // 每个网格最大宽度
                          childAspectRatio: 320 / 310, // 宽高比 (320:310)
                          crossAxisSpacing: 8, // 水平间距
                          mainAxisSpacing: 8, // 垂直间距
                        ),
                    itemCount: 3, // 显示5个盒子
                    itemBuilder: (context, index) {
                      return DiscoverBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
