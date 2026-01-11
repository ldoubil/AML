import 'package:flutter/material.dart';
import 'dart:ui';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;
  final ColorScheme colorScheme;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPageChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentPage > 2) ...{
          IconButton(
            icon: Text(
              '1',
              style: TextStyle(
                color: colorScheme.tertiaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => onPageChanged?.call(1),
          ),
          Icon(Icons.remove, size: 16, color: colorScheme.tertiaryContainer),
        },

        // Display current page and a few surrounding pages
        ..._buildPageNumbers(),

        if (currentPage < totalPages - 1) ...{
          // 添加一个 - 符号
          Icon(Icons.remove, size: 16, color: colorScheme.tertiaryContainer),
          IconButton(
            icon: Text(
              '$totalPages',
              style: TextStyle(
                color: colorScheme.tertiaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => onPageChanged?.call(totalPages),
          ),
        },
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageNumbers = [];
    const int pageNumberLimit = 3; // Max number of page numbers to display

    int startPage = currentPage - (pageNumberLimit ~/ 2);
    if (startPage < 1) {
      startPage = 1;
    }
    int endPage = startPage + pageNumberLimit - 1;
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = totalPages - pageNumberLimit + 1;
      if (startPage < 1) {
        startPage = 1;
      }
    }

    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TextButton(
            onPressed: i == currentPage ? null : () => onPageChanged?.call(i),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.primaryContainer;
                }
                return null;
              }),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              minimumSize: WidgetStateProperty.all(
                const Size(40, 40),
              ), // Fixed width and height
              padding: WidgetStateProperty.all(
                EdgeInsets.zero,
              ), // Remove default padding
            ),
            child: CircleAvatar(
              backgroundColor: i == currentPage
                  ? colorScheme.onTertiary
                  : Colors.transparent,
              child: Text(
                '$i',
                style: TextStyle(
                  fontWeight:
                      i == currentPage ? FontWeight.bold : FontWeight.normal,
                  color: i == currentPage
                      ? colorScheme.onPrimaryFixed
                      : colorScheme.tertiaryContainer,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return pageNumbers;
  }
}
