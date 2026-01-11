import 'dart:async';
import 'dart:io';

import 'package:aml/model/app_settings.dart';
import 'package:aml/storage/app_settings_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  final currentPage = signal('home');
  final showDebugConsole = signal<bool>(true);
  final appDataDirectory = signal<String?>(null);
  final resourceDirectory = signal('');
  final java8Directory = signal('');
  final java17Directory = signal('');
  final java21Directory = signal('');

  late final AppSettingsRepository _repository;
  late final String _baseDir;
  bool _initialized = false;
  bool _hydrating = false;
  Timer? _saveDebounce;
  VoidCallback? _disposeSettingsEffect;

  Future<void> initialize() async {
    if (_initialized) return;
    _hydrating = true;

    final directory = await getApplicationSupportDirectory();
    _baseDir = directory.path;
    appDataDirectory.value = _baseDir;
    _repository = AppSettingsRepository(baseDir: _baseDir);

    final settings = await _repository.load();
    await _applySettings(settings);

    _hydrating = false;
    _initialized = true;

    _disposeSettingsEffect = effect(() {
      if (_hydrating) return;
      final snapshot = _snapshotSettings();
      _scheduleSave(snapshot);
    });
  }

  Future<void> _applySettings(AppSettings settings) async {
    final resolvedResourceDir = settings.resourceDirectory.isEmpty
        ? p.join(_baseDir, 'resourceDirectory')
        : settings.resourceDirectory;

    resourceDirectory.value = resolvedResourceDir;
    showDebugConsole.value = settings.showDebugConsole;
    java8Directory.value = settings.java8Path;
    java17Directory.value = settings.java17Path;
    java21Directory.value = settings.java21Path;

    final directory = Directory(resolvedResourceDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  AppSettings _snapshotSettings() {
    final resolvedResourceDir = resourceDirectory.value.isEmpty
        ? p.join(_baseDir, 'resourceDirectory')
        : resourceDirectory.value;

    return AppSettings(
      resourceDirectory: resolvedResourceDir,
      java8Path: java8Directory.value,
      java17Path: java17Directory.value,
      java21Path: java21Directory.value,
      showDebugConsole: showDebugConsole.value,
    );
  }

  void _scheduleSave(AppSettings settings) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 250), () async {
      try {
        await _repository.save(settings);
      } catch (e) {
        debugPrint('保存应用设置失败: $e');
      }
    });
  }

  Future<void> dispose() async {
    _disposeSettingsEffect?.call();
    _saveDebounce?.cancel();
  }
}
