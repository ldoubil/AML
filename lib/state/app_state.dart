import 'package:aml/model/app_base_state.dart';
import 'package:aml/database/persistent_signal_extension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AppState {

  static final AppState _instance = AppState._internal();
  factory AppState() {
    return _instance;
  }

  final currentPage = signal('home');
  final showDebugConsole = signal<bool>(true);
  final appDataDirectory = signal<String?>(null);

  AppState._internal() {
    _initializeAppDataDirectory();
  }

  void _initializeAppDataDirectory() async {
    final directory = await getApplicationSupportDirectory();
    appDataDirectory.value = directory.path;
  }
  final java8Directory = signal("")..persistWith('app_settings', 'java8Directory');
  final java17Directory = signal("")..persistWith('app_settings', 'java17Directory');
  final java21Directory = signal("")..persistWith('app_settings', 'java21Directory');
}
