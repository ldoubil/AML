import 'package:flutter/material.dart';

class DiscoverBox extends StatelessWidget {
  const DiscoverBox({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '整合包',
          style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 16),
        ),
      ),
    );
  }
}
