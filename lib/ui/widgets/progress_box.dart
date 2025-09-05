import 'package:flutter/material.dart';
import 'package:aml/state/progress_state.dart';
import 'package:aml/model/progress_item.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ProgressBox extends StatefulWidget {
  const ProgressBox({super.key});

  @override
  State<ProgressBox> createState() => _ProgressBoxState();
}

class _ProgressBoxState extends State<ProgressBox> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progressList = ProgressStore().progressList.watch(context);
    return Stack(
      children: [
        Positioned(
          top: 10,
          right: 80,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 320,
              constraints: const BoxConstraints(minHeight: 50),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: progressList.isEmpty
                  ? const Center(
                      child:
                          Text('暂无进度', style: TextStyle(color: Colors.white70)))
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: progressList
                            .map((item) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  child: ProgressItemWidget(item: item),
                                ))
                            .toList(),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressItemWidget extends StatelessWidget {
  final ProgressItem item;
  const ProgressItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final name = item.name.watch(context);
    final progress = item.progress.watch(context);
    final progressText = item.progressText.watch(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onTertiary),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          progressText.isEmpty ? '进度描述' : progressText,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }
}
