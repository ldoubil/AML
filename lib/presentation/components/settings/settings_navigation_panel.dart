import 'dart:io';

import 'package:aml/presentation/config/settings_registry.dart';
import 'package:aml/presentation/components/navigation/nav_rect_button.dart';
import 'package:flutter/material.dart';

class SettingsNavigationPanel extends StatelessWidget {
  final String selectedPageId;
  final ValueChanged<String> onPageSelected;

  const SettingsNavigationPanel({
    super.key,
    required this.selectedPageId,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: SettingsRegistry.pages
                .map(
                  (config) => Padding(
                    padding: const EdgeInsets.only(
                        left: 25, top: 2, right: 0, bottom: 1),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: NavRectButton(
                        icon: config.icon,
                        text: config.title,
                        label: config.title,
                        isSelected: selectedPageId == config.id,
                        width: 245,
                        onTap: () => onPageSelected(config.id),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        const AppInfoCard(),
        const SizedBox(height: 12),
      ],
    );
  }
}

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        width: 235,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.rocket_launch,
                size: 20,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'AstralMC App 0.10.3',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
                    style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
