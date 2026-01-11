import 'package:signals_flutter/signals_flutter.dart';

class NavigationState {
  static final NavigationState _instance = NavigationState._internal();
  factory NavigationState() => _instance;
  NavigationState._internal();

  final currentPage = signal('home');
}
