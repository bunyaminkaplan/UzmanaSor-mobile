import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/questions/presentation/providers/question_provider.dart';
import 'package:mobile/features/public_feed/presentation/widgets/feed_question_card.dart';
import 'package:mobile/shared/widgets/dashboard_scaffold.dart';

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
  String _sortOrder = 'newest'; // newest | oldest
  bool _showFilters = false;

  late Map<String, dynamic> _currentQueryParams;

  @override
  void initState() {
    super.initState();
    _currentQueryParams = _buildQueryParams();
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider(_currentQueryParams));

    return DashboardScaffold(
      title: 'Genel Akış',
      onRefresh: () async {
        ref.invalidate(questionsProvider(_currentQueryParams));
      },
      onLogout: () {
        ref.read(authProvider.notifier).logout();
      },
      body: Column(
        children: [
          // Arama + filtre toggle
          _buildSearchBar(),

          // Filtreler (gizlenebilir)
          if (_showFilters) _buildFilterChips(),

          // Soru listesi
          Expanded(
            child: questionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Sorular yüklenemedi',
                        style: TextStyle(
                          color: AppColors.textMutedDark,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              data: (questions) {
                if (questions.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    return FeedQuestionCard(question: q);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.inputBgDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (_) => _applyFilters(),
                style: const TextStyle(
                  color: AppColors.textBodyDark,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Soru veya içerik ara...',
                  hintStyle: TextStyle(
                    color: AppColors.textMutedDark,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textMutedDark,
                    size: 20,
                  ),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Filtre toggle
          Material(
            color: _showFilters
                ? AppColors.accentCyan.withValues(alpha: 0.15)
                : AppColors.inputBgDark,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _showFilters = !_showFilters),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: _showFilters
                      ? AppColors.accentCyan
                      : AppColors.textMutedDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBgDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sıralama',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMutedDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChip('En Yeni', 'newest'),
                const SizedBox(width: 8),
                _buildChip('En Eski', 'oldest'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    final isActive = _sortOrder == value;
    return GestureDetector(
      onTap: () {
        setState(() => _sortOrder = value);
        _applyFilters();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.accentCyan.withValues(alpha: 0.15)
              : AppColors.inputBgDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.accentCyan.withValues(alpha: 0.4)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.accentCyan : AppColors.textMutedDark,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.public_off_rounded,
            size: 64,
            color: AppColors.accentCyan.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz herkese açık soru bulunmuyor',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textMutedDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sorular herkese açık yapıldığında burada görünecek',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMutedDark.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
