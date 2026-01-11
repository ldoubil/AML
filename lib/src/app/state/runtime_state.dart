import 'package:signals_flutter/signals_flutter.dart';

class RuntimeState {
  static final RuntimeState _instance = RuntimeState._internal();
  factory RuntimeState() => _instance;
  RuntimeState._internal();

  final appDataDirectory = signal<String?>(null);
}
