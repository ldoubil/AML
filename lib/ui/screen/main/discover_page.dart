import 'dart:math';

import 'package:aml/api/modrinth_api.dart';
import 'package:flutter/material.dart';
import '../../widgets/animated_tab_bar.dart';
import '../../widgets/app_card.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['模组整合包', '模组', '资源包', '数据包', '着色器'];
  final List<String> _tabsFacets = ['modpack', 'mod', 'resourcepack', 'datapack', 'shader'];
  // 储存 ModrinthSearchResult list
  ModrinthSearchResult? _modrinthSearchResultList;
  bool _isLoading = true;

  // 搜索项目的方法
  void _searchProjects() {
    setState(() {
      _isLoading = true;
    });
    
    final currentFacet = _tabsFacets[_selectedTabIndex];
    ModrinthApiService.searchProjects(facets: [['project_type:$currentFacet']])
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
      child: Align(
        alignment: Alignment.centerLeft,
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
            const SizedBox(height: 20),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _modrinthSearchResultList == null ||
                          _modrinthSearchResultList!.hits.isEmpty
                      ? const Center(child: Text('暂无数据'))
                      : ListView.builder(
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
