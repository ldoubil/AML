import 'dart:async';

import 'package:aml/data/repositories/settings/ui_settings_repository.dart';
import 'package:aml/domain/models/ui_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:signals_flutter/signals_flutter.dart';

class UiSettingsState {
  static final UiSettingsState _instance = UiSettingsState._internal();
  factory UiSettingsState() => _instance;
  UiSettingsState._internal();

  final showDebugConsole = signal<bool>(true);

  late final UiSettingsRepository _repository;
  bool _initialized = false;
  bool _hydrating = false;
  Timer? _saveDebounce;
  VoidCallback? _disposeEffect;

  Future<void> initialize({required String baseDir}) async {
    if (_initialized) return;
    _hydrating = true;
    _repository = UiSettingsRepository(baseDir: baseDir);

    final settings = await _repository.load();
    _applySettings(settings);

    _hydrating = false;
    _initialized = true;

    _disposeEffect = effect(() {
      if (_hydrating) return;
      _scheduleSave(_snapshotSettings());
    });
  }

  void _applySettings(UiSettings settings) {
    showDebugConsole.value = settings.showDebugConsole;
  }

  UiSettings _snapshotSettings() {
    return UiSettings(showDebugConsole: showDebugConsole.value);
  }

  void _scheduleSave(UiSettings settings) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        await _repository.save(settings);
      } catch (e) {
        debugPrint('保存 UI 设置失败: $e');
      }
    });
  }

  Future<void> dispose() async {
    _disposeEffect?.call();
    _saveDebounce?.cancel();
  }
}
