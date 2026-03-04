import 'package:flutter/material.dart';

/// PaginationBar — sayfa navigasyonu widget'ı.
///
/// Web: Pagination.jsx → önceki/sonraki butonları + sayfa numaraları.
class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Önceki
          IconButton(
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: currentPage > 1
                  ? theme.colorScheme.surfaceContainerHighest
                  : null,
            ),
          ),

          const SizedBox(width: 8),

          // Sayfa numaraları
          ..._buildPageNumbers(theme),

          const SizedBox(width: 8),

          // Sonraki
          IconButton(
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: currentPage < totalPages
                  ? theme.colorScheme.surfaceContainerHighest
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(ThemeData theme) {
    final pages = <Widget>[];
    final start = (currentPage - 2).clamp(1, totalPages);
    final end = (currentPage + 2).clamp(1, totalPages);

    if (start > 1) {
      pages.add(
        _PageButton(
          page: 1,
          isActive: currentPage == 1,
          onTap: onPageChanged,
          theme: theme,
        ),
      );
      if (start > 2) {
        pages.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '...',
              style: TextStyle(color: theme.colorScheme.outline),
            ),
          ),
        );
      }
    }

    for (int i = start; i <= end; i++) {
      pages.add(
        _PageButton(
          page: i,
          isActive: currentPage == i,
          onTap: onPageChanged,
          theme: theme,
        ),
      );
    }

    if (end < totalPages) {
      if (end < totalPages - 1) {
        pages.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '...',
              style: TextStyle(color: theme.colorScheme.outline),
            ),
          ),
        );
      }
      pages.add(
        _PageButton(
          page: totalPages,
          isActive: currentPage == totalPages,
          onTap: onPageChanged,
          theme: theme,
        ),
      );
    }

    return pages;
  }
}

class _PageButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final ValueChanged<int> onTap;
  final ThemeData theme;

  const _PageButton({
    required this.page,
    required this.isActive,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 36,
        height: 36,
        child: MaterialButton(
          onPressed: isActive ? null : () => onTap(page),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: isActive ? theme.colorScheme.primary : null,
          elevation: 0,
          padding: EdgeInsets.zero,
          child: Text(
            '$page',
            style: TextStyle(
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
