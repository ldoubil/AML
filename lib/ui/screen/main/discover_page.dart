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
  final List<String> _tabs = ['整合包', '模组', '资源包', '数据包', '着色器'];
  String _selectedDropdownValue = '整合包'; // Add this line
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
                DropdownButtonWidget(
                  width: 250,
                  items: const [
                    DropdownItem(display: '整合包', value: '整合包'),
                    DropdownItem(display: '模组', value: '模组'),
                    DropdownItem(display: '资源包', value: '资源包'),
                    DropdownItem(display: '数据包', value: '数据包'),
                    DropdownItem(display: '着色器', value: '着色器'),
                  ],
                  selectedValue: _selectedDropdownValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedDropdownValue = value;
                      _selectedTabIndex = _tabs.indexOf(value);
                    });
                    _searchProjects();
                  },
                  colorScheme: colorScheme,
                ),
                const SizedBox(width: 12),
                DropdownButtonWidget(
                  width: 250,
                  items: const [
                    DropdownItem(display: '整合包', value: '整合包'),
                    DropdownItem(display: '模组', value: '模组'),
                    DropdownItem(display: '资源包', value: '资源包'),
                    DropdownItem(display: '数据包', value: '数据包'),
                    DropdownItem(display: '着色器', value: '着色器'),
                  ],
                  selectedValue: _selectedDropdownValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedDropdownValue = value;
                      _selectedTabIndex = _tabs.indexOf(value);
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
