import 'package:signals_flutter/signals_flutter.dart';
import 'package:aml/domain/models/progress_item.dart';

class ProgressStore {
  ProgressStore._internal();
  static final ProgressStore _instance = ProgressStore._internal();
  factory ProgressStore() => _instance;

  final progressList = signal<List<ProgressItem>>([]);
  final progressVisibility = signal<bool>(false);
  ProgressItem createProgressItem(String name) {
    final item = ProgressItem(
      name: name,
      onDispose: (item) {
        progressList.value = List.from(progressList.value)..remove(item);
      },
    );
    progressList.value = List.from(progressList.value)..add(item);
    return item;
  }
}
