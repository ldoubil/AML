class UiSettings {
  final bool showDebugConsole;

  const UiSettings({required this.showDebugConsole});

  factory UiSettings.defaults() => const UiSettings(showDebugConsole: true);

  UiSettings copyWith({bool? showDebugConsole}) {
    return UiSettings(
      showDebugConsole: showDebugConsole ?? this.showDebugConsole,
    );
  }

  Map<String, dynamic> toJson() => {
        'showDebugConsole': showDebugConsole,
      };

  factory UiSettings.fromJson(Map<String, dynamic> json) {
    return UiSettings(
      showDebugConsole: json['showDebugConsole'] as bool? ?? true,
    );
  }
}
