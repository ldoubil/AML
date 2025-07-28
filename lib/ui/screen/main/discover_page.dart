import 'package:aml/api/modrinth_api.dart';
import 'package:aml/ui/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import '../../widgets/animated_tab_bar.dart';
import '../../widgets/app_card.dart';
import 'package:aml/ui/widgets/dropdown_button_widget.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  int _selectedTabIndex = 0;
  String _selectedSortValue = 'relevance';
  int _selectedPageSize = 20; 
  final List<String> _tabs = ['整合包', '模组', '资源包', '数据包', '着色器'];
  final List<String> _tabsFacets = [
    'modpack',
    'mod',
    'resourcepack',
    'datapack',
    'shader',
  ];
  //
  String searchName = "";
  // 储存 ModrinthSearchResult list
  ModrinthSearchResult? _modrinthSearchResultList;
  bool _isLoading = true;

  // 搜索项目的方法
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
        )
        .then((value) {
          setState(() {
            _modrinthSearchResultList = value;
            _isLoading = false;
          });
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
          });
          print('搜索失败: $error');
        });
  }

  // init
  @override
  void initState() {
    super.initState();
    // 初始化时获取数据
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
                    )
                  ],
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
                      final project = _modrinthSearchResultList!.hits[index];
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
