import 'package:aml/data/api/modrinth_api.dart';
import 'package:aml/presentation/theme/app_colors.dart';
import 'package:aml/presentation/components/cards/discover_box.dart';
import 'package:aml/presentation/components/cards/game_back_hover_card.dart';
import 'package:aml/presentation/components/common/hover_text_with_arrow.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ModrinthSearchResult? _modpackResult;
  ModrinthSearchResult? _modResult;
  bool _isLoadingModpacks = true;
  bool _isLoadingMods = true;

  @override
  void initState() {
    super.initState();
    _fetchModpacks();
    _fetchMods();
  }

  Future<void> _fetchModpacks() async {
    try {
      final result = await ModrinthApiService.searchProjects(
        query: '',
        facets: [
          ['project_type:modpack'],
        ],
        index: 'follows',
        limit: 3,
      );
      setState(() {
        _modpackResult = result;
        _isLoadingModpacks = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingModpacks = false;
      });
    }
  }

  Future<void> _fetchMods() async {
    try {
      final result = await ModrinthApiService.searchProjects(
        query: '',
        facets: [
          ['project_type:mod'],
        ],
        index: 'follows',
        limit: 3,
      );
      setState(() {
        _modResult = result;
        _isLoadingMods = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMods = false;
      });
    }
  }

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
                      color: AppColors.heroTitle,
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
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
                  _isLoadingModpacks
                      ? const Center(child: CircularProgressIndicator())
                      : _modpackResult == null || _modpackResult!.hits.isEmpty
                          ? const Center(child: Text('暂无数据'))
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 390, // 每个网格最大宽度
                                childAspectRatio: 320 / 310, // 宽高比 (320:310)
                                crossAxisSpacing: 8, // 水平间距
                                mainAxisSpacing: 8, // 垂直间距
                              ),
                              itemCount: _modpackResult?.hits.length ?? 0,
                              itemBuilder: (context, index) {
                                final project = _modpackResult!.hits[index];
                                return DiscoverBox(result: project);
                              },
                            ),
                  const SizedBox(height: 16),
                  HoverTextWithArrow(text: "发现更多MOD", onTap: () {}),
                  const SizedBox(height: 16),
                  _isLoadingMods
                      ? const Center(child: CircularProgressIndicator())
                      : _modResult == null || _modResult!.hits.isEmpty
                          ? const Center(child: Text('暂无数据'))
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 390, // 每个网格最大宽度
                                childAspectRatio: 320 / 310, // 宽高比 (320:310)
                                crossAxisSpacing: 8, // 水平间距
                                mainAxisSpacing: 8, // 垂直间距
                              ),
                              itemCount: _modResult?.hits.length ?? 0,
                              itemBuilder: (context, index) {
                                final project = _modResult!.hits[index];
                                return DiscoverBox(result: project);
                              },
                            ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
