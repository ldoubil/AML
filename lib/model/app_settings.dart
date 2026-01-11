import 'package:path/path.dart' as p;

/// 应用设置的统一数据模型，使用 UTF-8 JSON 进行持久化。
class AppSettings {
  final String resourceDirectory;
  final String java8Path;
  final String java17Path;
  final String java21Path;
  final bool showDebugConsole;

  const AppSettings({
    required this.resourceDirectory,
    required this.java8Path,
    required this.java17Path,
    required this.java21Path,
    required this.showDebugConsole,
  });

  factory AppSettings.defaults(String baseDir) => AppSettings(
        resourceDirectory: p.join(baseDir, 'resourceDirectory'),
        java8Path: '',
        java17Path: '',
        java21Path: '',
        showDebugConsole: true,
      );

  AppSettings copyWith({
    String? resourceDirectory,
    String? java8Path,
    String? java17Path,
    String? java21Path,
    bool? showDebugConsole,
  }) {
    return AppSettings(
      resourceDirectory: resourceDirectory ?? this.resourceDirectory,
      java8Path: java8Path ?? this.java8Path,
      java17Path: java17Path ?? this.java17Path,
      java21Path: java21Path ?? this.java21Path,
      showDebugConsole: showDebugConsole ?? this.showDebugConsole,
    );
  }

  Map<String, dynamic> toJson() => {
        'resourceDirectory': resourceDirectory,
        'java8Path': java8Path,
        'java17Path': java17Path,
        'java21Path': java21Path,
        'showDebugConsole': showDebugConsole,
      };

  factory AppSettings.fromJson(
    Map<String, dynamic> json, {
    required String baseDir,
  }) {
    return AppSettings(
      resourceDirectory: _nonEmpty(json['resourceDirectory'] as String?) ??
          p.join(baseDir, 'resourceDirectory'),
      java8Path: _nonEmpty(json['java8Path'] as String?) ?? '',
      java17Path: _nonEmpty(json['java17Path'] as String?) ?? '',
      java21Path: _nonEmpty(json['java21Path'] as String?) ?? '',
      showDebugConsole: json['showDebugConsole'] as bool? ?? true,
    );
  }
}

String? _nonEmpty(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
