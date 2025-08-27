import 'package:aml/model/app_base_state.dart';
import 'package:aml/database/persistent_signal_extension.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AppStore {
  AppStore._internal();
  static final AppStore _instance = AppStore._internal();
  factory AppStore() {
    return _instance;
  }

  final currentPage = signal('home');
  final showDebugConsole = signal<bool>(true);

  final appBaseState = signal(AppBaseState())
    ..persistWith('app_settings', 'app_base_state');
}
