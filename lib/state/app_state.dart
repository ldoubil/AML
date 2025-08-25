import 'package:signals_flutter/signals_flutter.dart';

class AppStore {
  AppStore._internal();
  static final AppStore _instance = AppStore._internal();
  factory AppStore() {
    return _instance;
  }

  final currentPage = signal('home');
  final showDebugConsole = signal<bool>(true);
}
