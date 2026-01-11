import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aml/data/cache/cache_service.dart';

// 搜索结果数据模型
class ModrinthSearchResult {
  final List<ModrinthProject> hits;
  final int offset;
  final int limit;
  final int totalHits;

  ModrinthSearchResult({
    required this.hits,
    required this.offset,
    required this.limit,
    required this.totalHits,
  });

  factory ModrinthSearchResult.fromJson(Map<String, dynamic> json) {
    return ModrinthSearchResult(
      hits: (json['hits'] as List)
          .map((item) => ModrinthProject.fromJson(item))
          .toList(),
      offset: json['offset'] ?? 0,
      limit: json['limit'] ?? 10,
      totalHits: json['total_hits'] ?? 0,
    );
  }
}

// 项目数据模型
class ModrinthProject {
  final String slug;
  final String title;
  final String description;
  final List<String> categories;
  final String clientSide;
  final String serverSide;
  final String projectType;
  final int downloads;
  final String? iconUrl;
  final int? color;
  final String? threadId;
  final String? monetizationStatus;
  final String projectId;
  final String author;
  final List<String>? displayCategories;
  final List<String> versions;
  final int follows;
  final String dateCreated;
  final String dateModified;
  final String? latestVersion;
  final String license;
  final List<String>? gallery;
  final String? featuredGallery;

  ModrinthProject({
    required this.slug,
    required this.title,
    required this.description,
    required this.categories,
    required this.clientSide,
    required this.serverSide,
    required this.projectType,
    required this.downloads,
    this.iconUrl,
    this.color,
    this.threadId,
    this.monetizationStatus,
    required this.projectId,
    required this.author,
    this.displayCategories,
    required this.versions,
    required this.follows,
    required this.dateCreated,
    required this.dateModified,
    this.latestVersion,
    required this.license,
    this.gallery,
    this.featuredGallery,
  });

  factory ModrinthProject.fromJson(Map<String, dynamic> json) {
    return ModrinthProject(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      clientSide: json['client_side'] ?? 'unknown',
      serverSide: json['server_side'] ?? 'unknown',
      projectType: json['project_type'] ?? '',
      downloads: json['downloads'] ?? 0,
      iconUrl: json['icon_url'],
      color: json['color'],
      threadId: json['thread_id'],
      monetizationStatus: json['monetization_status'],
      projectId: json['project_id'] ?? '',
      author: json['author'] ?? '',
      displayCategories: json['display_categories'] != null
          ? List<String>.from(json['display_categories'])
          : null,
      versions: List<String>.from(json['versions'] ?? []),
      follows: json['follows'] ?? 0,
      dateCreated: json['date_created'] ?? '',
      dateModified: json['date_modified'] ?? '',
      latestVersion: json['latest_version'],
      license: json['license'] ?? '',
      gallery:
          json['gallery'] != null ? List<String>.from(json['gallery']) : null,
      featuredGallery: json['featured_gallery'],
    );
  }
}

// Modrinth API 服务类
class ModrinthApiService {
  static const String baseUrl = 'https://api.modrinth.com/v2';
  static final CacheService _cacheService = CacheService();

  /// 搜索项目
  ///
  /// [query] 搜索关键词
  /// [limit] 返回结果数量限制 (默认: 10)
  /// [offset] 跳过的结果数量 (默认: 0)
  /// [index] 搜索索引 (可选: relevance, downloads, follows, newest, updated)
  /// [facets] 搜索过滤器 (可选)
  /// [cacheDuration] 缓存时间 (默认: 60秒)
  static Future<ModrinthSearchResult> searchProjects({
    String? query,
    int limit = 10,
    int offset = 0,
    String? index,
    List<List<String>>? facets,
    Duration cacheDuration = const Duration(seconds: 60),
  }) async {
    final cacheKey =
        'searchProjects_query=$query&limit=$limit&offset=$offset&index=$index&facets=${jsonEncode(facets)}';

    final cachedData = _cacheService.get(cacheKey, cacheDuration);
    if (cachedData != null) {
      return ModrinthSearchResult.fromJson(jsonDecode(cachedData));
    }

    try {
      // 构建查询参数
      final Map<String, String> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }

      if (index != null) {
        queryParams['index'] = index;
      }

      if (facets != null && facets.isNotEmpty) {
        queryParams['facets'] = jsonEncode(facets);
        // 打印queryParams['facets']
        print(queryParams['facets']);
      }

      // 构建URL
      final uri = Uri.parse('$baseUrl/search').replace(
        queryParameters: queryParams,
      );

      // 发送HTTP请求
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'AML-App/1.0.0',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _cacheService.put(cacheKey, response.body);
        return ModrinthSearchResult.fromJson(jsonData);
      } else {
        throw Exception('Failed to search projects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching projects: $e');
    }
  }

  /// 格式化下载数量显示
  static String formatDownloadCount(int downloads) {
    if (downloads >= 1000000) {
      return '${(downloads / 1000000).toStringAsFixed(1)}M';
    } else if (downloads >= 1000) {
      return '${(downloads / 1000).toStringAsFixed(1)}K';
    } else {
      return downloads.toString();
    }
  }
}
