import 'package:aml/src/shared/widgets/components/cards/app_card.dart';
import 'package:aml/src/shared/widgets/components/common/pagination_widget.dart';
import 'package:aml/src/shared/widgets/components/inputs/dropdown_button_widget.dart';
import 'package:aml/src/shared/widgets/components/inputs/search_bar.dart';
import 'package:aml/src/shared/widgets/components/tabs/animated_tab_bar.dart';
import 'package:aml/src/features/discover/data/modrinth_api.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  int _selectedTabIndex = 0;
  String _selectedSortValue = 'relevance';
  int _selectedPageSize = 20;
  final List<int> _currentPages = [1, 1, 1, 1, 1];
  int get _currentPage => _currentPages[_selectedTabIndex];

  final List<String> _tabs = ['整合包', '模组', '资源包', '数据包', '着色器'];
  final List<String> _tabsFacets = [
    'modpack',
    'mod',
    'resourcepack',
    'datapack',
    'shader',
  ];

  String searchName = "";
  ModrinthSearchResult? _modrinthSearchResultList;
  bool _isLoading = true;

  void _searchProjects() {
    setState(() {
      _isLoading = true;
    });

    final currentFacet = _tabsFacets[_selectedTabIndex];
    ModrinthApiService.searchProjects(
      query: searchName,
      facets: [
        ['project_type:$currentFacet'],
      ],
      index: _selectedSortValue,
      limit: _selectedPageSize,
      offset: (_currentPage - 1) * _selectedPageSize,
    ).then((value) {
      setState(() {
        _modrinthSearchResultList = value;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
      print('搜索失败: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    _searchProjects();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            AnimatedTabBar(
              tabs: _tabs,
              selectedIndex: _selectedTabIndex,
              onTabChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
                _searchProjects();
              },
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            SearchBarWidget(
              prefixIcon: const Icon(Icons.search),
              colorScheme: colorScheme,
              onChanged: (value) {
                setState(() {
                  searchName = value;
                });
                _searchProjects();
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    DropdownButtonWidget(
                      width: 150,
                      items: const [
                        DropdownItem(display: '相关性', value: 'relevance'),
                        DropdownItem(display: '下载量', value: 'downloads'),
                        DropdownItem(display: '关注数', value: 'follows'),
                        DropdownItem(display: '最新', value: 'newest'),
                        DropdownItem(display: '最近更新', value: 'updated'),
                      ],
                      selectedValue: _selectedSortValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedSortValue = value;
                        });
                        _searchProjects();
                      },
                      colorScheme: colorScheme,
                      prefix: '排序：',
                    ),
                    const SizedBox(width: 16),
                    DropdownButtonWidget(
                      width: 120,
                      items: const [
                        DropdownItem(display: '5', value: '5'),
                        DropdownItem(display: '10', value: '10'),
                        DropdownItem(display: '15', value: '15'),
                        DropdownItem(display: '20', value: '20'),
                        DropdownItem(display: '50', value: '50'),
                        DropdownItem(display: '100', value: '100'),
                      ],
                      selectedValue: _selectedPageSize.toString(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPageSize = int.tryParse(value) ?? 20;
                        });
                        _searchProjects();
                      },
                      colorScheme: colorScheme,
                      prefix: '每页：',
                    ),
                  ],
                ),
                const Spacer(),
                PaginationWidget(
                  totalPages: (_modrinthSearchResultList?.totalHits ?? 0) ~/
                          _selectedPageSize +
                      1,
                  currentPage: _currentPage,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPages[_selectedTabIndex] = page;
                    });
                    _searchProjects();
                  },
                  colorScheme: colorScheme,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('正在加载中...', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  )
                : _modrinthSearchResultList == null ||
                        _modrinthSearchResultList!.hits.isEmpty
                    ? const Center(child: Text('暂无数据'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _modrinthSearchResultList!.hits.length,
                          itemBuilder: (context, index) {
                            final project =
                                _modrinthSearchResultList!.hits[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AppCard(
                                title: project.title,
                                description: project.description,
                                downloadCount: '${project.downloads} 下载',
                                iconUrl: project.iconUrl ?? '',
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
