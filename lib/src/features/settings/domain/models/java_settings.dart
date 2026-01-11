class JavaSettings {
  final String java8Path;
  final String java17Path;
  final String java21Path;

  const JavaSettings({
    required this.java8Path,
    required this.java17Path,
    required this.java21Path,
  });

  factory JavaSettings.defaults() => const JavaSettings(
        java8Path: '',
        java17Path: '',
        java21Path: '',
      );

  JavaSettings copyWith({
    String? java8Path,
    String? java17Path,
    String? java21Path,
  }) {
    return JavaSettings(
      java8Path: java8Path ?? this.java8Path,
      java17Path: java17Path ?? this.java17Path,
      java21Path: java21Path ?? this.java21Path,
    );
  }

  Map<String, dynamic> toJson() => {
        'java8Path': java8Path,
        'java17Path': java17Path,
        'java21Path': java21Path,
      };

  factory JavaSettings.fromJson(Map<String, dynamic> json) {
    return JavaSettings(
      java8Path: _nonEmpty(json['java8Path'] as String?) ?? '',
      java17Path: _nonEmpty(json['java17Path'] as String?) ?? '',
      java21Path: _nonEmpty(json['java21Path'] as String?) ?? '',
    );
  }
}

String? _nonEmpty(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
