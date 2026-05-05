import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/theme/app_colors_ext.dart';
import 'package:mobile/features/questions/presentation/providers/question_provider.dart';
import 'package:mobile/features/public_feed/presentation/widgets/feed_question_list.dart';
import 'package:mobile/shared/widgets/async_error_widget.dart';
import 'package:mobile/shared/widgets/dashboard_scaffold.dart';
import 'package:mobile/shared/widgets/filter_bar.dart';

/// Genel Akış — Herkese açık soruları listeler.
///
/// Filtreler: Arama, Ders, Sıralama (En Yeni / En Eski).
/// Mevcut `questionsProvider({'mode': 'public_feed', ...})` kullanır.
class PublicFeedPage extends ConsumerStatefulWidget {
  const PublicFeedPage({super.key});

  @override
  ConsumerState<PublicFeedPage> createState() => _PublicFeedPageState();
}

class _PublicFeedPageState extends ConsumerState<PublicFeedPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _sortOrder = 'newest'; // newest | oldest

  late Map<String, dynamic> _currentQueryParams;

  @override
  void initState() {
    super.initState();
    _currentQueryParams = _buildQueryParams();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref.read(questionsProvider(_currentQueryParams).notifier).loadMore();
    }
  }

  Map<String, dynamic> _buildQueryParams() {
    return {
      'mode': 'public_feed',
      if (_searchController.text.trim().isNotEmpty)
        'search': _searchController.text.trim(),
      'ordering': _sortOrder == 'newest' ? '-created_at' : 'created_at',
    };
  }

  void _applyFilters() {
    setState(() {
      _currentQueryParams = _buildQueryParams();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider(_currentQueryParams));

    return DashboardScaffold(
      onRefresh: () async {
        await ref
            .read(questionsProvider(_currentQueryParams).notifier)
            .refresh();
      },
      body: Column(
        children: [
          // Arama
          _buildSearchBar(),

          // Filtreler
          FilterBar(
            activeFilterCount: _sortOrder != 'newest' ? 1 : 0,
            onClearAll: () {
              setState(() => _sortOrder = 'newest');
              _applyFilters();
            },
            children: [
              FilterItem(
                label: 'Sıralama',
                child: Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('En Yeni'),
                      selected: _sortOrder == 'newest',
                      onSelected: (_) {
                        setState(() => _sortOrder = 'newest');
                        _applyFilters();
                      },
                    ),
                    ChoiceChip(
                      label: const Text('En Eski'),
                      selected: _sortOrder == 'oldest',
                      onSelected: (_) {
                        setState(() => _sortOrder = 'oldest');
                        _applyFilters();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Soru listesi
          Expanded(
            child: questionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  const AsyncErrorWidget(message: 'Sorular yüklenemedi'),
              data: (s) {
                final showFooter = s.hasMore || s.loadMoreError != null;
                return FeedQuestionList(
                  items: s.items,
                  scrollController: _scrollController,
                  footer: showFooter ? _buildFooter(s) : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(QuestionsState s) {
    if (s.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Center(
          child: TextButton.icon(
            onPressed: () => ref
                .read(questionsProvider(_currentQueryParams).notifier)
                .loadMore(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Daha fazla yüklenemedi — tekrar dene'),
          ),
        ),
      );
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: context.inputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: (_) => _applyFilters(),
          style: TextStyle(color: context.textBody, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Soru veya içerik ara...',
            hintStyle: TextStyle(color: context.textMuted, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: context.textMuted, size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _applyFilters();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

}
