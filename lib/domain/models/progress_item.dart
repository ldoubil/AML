import 'package:signals_flutter/signals_flutter.dart';

class ProgressItem {
  final name = signal<String>('');
  final progress = signal<double>(0.0);
  final progressText = signal<String>('');

  // 用于自动移除
  final void Function(ProgressItem) onDispose;

  ProgressItem({
    required String name,
    required this.onDispose,
  }) {
    this.name.value = name;
  }

  void setProgress(double value, [String? text]) {
    progress.value = value;
    if (text != null) progressText.value = text;
  }

  void setName(String value) => name.value = value;
  void setProgressText(String value) => progressText.value = value;

  void dispose() {
    onDispose(this);
  }
}
