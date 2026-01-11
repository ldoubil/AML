import 'dart:async';

import 'package:aml/src/features/settings/data/repositories/java_settings_repository.dart';
import 'package:aml/src/features/settings/domain/models/java_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:signals_flutter/signals_flutter.dart';

class JavaSettingsState {
  static final JavaSettingsState _instance = JavaSettingsState._internal();
  factory JavaSettingsState() => _instance;
  JavaSettingsState._internal();

  final java8Directory = signal('');
  final java17Directory = signal('');
  final java21Directory = signal('');

  late final JavaSettingsRepository _repository;
  bool _initialized = false;
  bool _hydrating = false;
  Timer? _saveDebounce;
  VoidCallback? _disposeEffect;

  Future<void> initialize({required String baseDir}) async {
    if (_initialized) return;
    _hydrating = true;
    _repository = JavaSettingsRepository(baseDir: baseDir);

    final settings = await _repository.load();
    _applySettings(settings);

    _hydrating = false;
    _initialized = true;

    _disposeEffect = effect(() {
      if (_hydrating) return;
      _scheduleSave(_snapshotSettings());
    });
  }

  void _applySettings(JavaSettings settings) {
    java8Directory.value = settings.java8Path;
    java17Directory.value = settings.java17Path;
    java21Directory.value = settings.java21Path;
  }

  JavaSettings _snapshotSettings() {
    return JavaSettings(
      java8Path: java8Directory.value,
      java17Path: java17Directory.value,
      java21Path: java21Directory.value,
    );
  }

  void _scheduleSave(JavaSettings settings) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        await _repository.save(settings);
      } catch (e) {
        debugPrint('保存 Java 设置失败: $e');
      }
    });
  }

  Future<void> dispose() async {
    _disposeEffect?.call();
    _saveDebounce?.cancel();
  }
}
