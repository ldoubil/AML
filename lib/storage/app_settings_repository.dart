import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../model/app_settings.dart';

/// 负责以 UTF-8 JSON 文件读写应用设置（不再保留旧版 Hive 存储）。
class AppSettingsRepository {
  AppSettingsRepository({required this.baseDir});

  final String baseDir;

  File get _settingsFile => File(p.join(baseDir, 'app_settings.json'));

  Future<AppSettings> load() async {
    try {
      final file = _settingsFile;
      if (!await file.exists()) {
        return AppSettings.defaults(baseDir);
      }

      final content = await file.readAsString(encoding: utf8);
      final json = jsonDecode(content) as Map<String, dynamic>;
      return AppSettings.fromJson(json, baseDir: baseDir);
    } catch (_) {
      // 解析失败时回退到默认配置，避免启动阻塞。
      return AppSettings.defaults(baseDir);
    }
  }

  Future<void> save(AppSettings settings) async {
    final file = _settingsFile;
    await file.parent.create(recursive: true);
    await file.writeAsString(
      jsonEncode(settings.toJson()),
      encoding: utf8,
    );
  }
}
