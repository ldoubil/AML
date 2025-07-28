import 'package:signals_flutter/signals_flutter.dart';

class AppStore {
  static final AppStore _instance = AppStore._internal();

  factory AppStore() {
    return _instance;
  }

  AppStore._internal();

  final currentPage = signal('home');
}

