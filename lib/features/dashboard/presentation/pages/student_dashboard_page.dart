import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/questions/presentation/providers/question_provider.dart';
import 'package:mobile/shared/widgets/dashboard_page_header.dart';
import 'package:mobile/shared/widgets/dashboard_question_card.dart';
import 'package:mobile/shared/widgets/empty_state_widget.dart';
import 'package:mobile/shared/widgets/filter_bar.dart';

/// Student Dashboard — öğrenci ana paneli.
///
/// Web: StudentDashboard.jsx → author=me filtreli soru listesi,
/// FilterBar (search, status, course, sort), Pagination,
/// sağ panelde CreateQuestionForm (mobilde FAB ile).
class StudentDashboardPage extends ConsumerStatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  ConsumerState<StudentDashboardPage> createState() =>
      _StudentDashboardPageState();
}

class _StudentDashboardPageState extends ConsumerState<StudentDashboardPage> {
  // --- Filtre State ---
  String _search = '';
  String _statusFilter = '';
  String _sortBy = 'priority';
  int? _expandedId;

  // Riverpod family parametresi referans karşılaştırması kullandığı için
  // her build'de yeni Map oluşturmak sonsuz rebuild döngüsüne yol açar.
  // Bu yüzden Map'i cache'liyoruz ve sadece filtre değişimlerinde güncelliyoruz.
  Map<String, dynamic> _cachedParams = const {
    'author': 'me',
    'ordering': '-question_priority',
  };

  /// Filtre değişikliklerinde cache'i güncelle.
  void _rebuildParams() {
    final params = <String, dynamic>{'author': 'me'};
    if (_search.isNotEmpty) params['search'] = _search;
    if (_statusFilter.isNotEmpty) params['status'] = _statusFilter;

    switch (_sortBy) {
      case 'newest':
        params['ordering'] = '-created_at';
        break;
      case 'oldest':
        params['ordering'] = 'created_at';
        break;
      case 'priority':
        params['ordering'] = '-question_priority';
        break;
    }
    setState(() {
      _cachedParams = params;
    });
  }

  int get _activeFilterCount {
    int count = 0;
    if (_search.isNotEmpty) count++;
    if (_statusFilter.isNotEmpty) count++;
    return count;
  }

  void _clearFilters() {
    _search = '';
    _statusFilter = '';
    _sortBy = 'priority';
    _rebuildParams();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final questionsAsync = ref.watch(questionsProvider(_cachedParams));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci Paneli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(questionsProvider(_cachedParams)),
            tooltip: 'Yenile',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
            tooltip: 'Çıkış',
          ),
        ],
      ),
      // Soru Sor FAB (web'deki sidebar yerine)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => GoRouter.of(context).push('/ask'),
        icon: const Icon(Icons.add),
        label: const Text('Soru Sor'),
      ),
      body: Column(
        children: [
          // Page Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: DashboardPageHeader(
              title: 'Öğrenci Paneli',
              description: 'Sorularını yönet, cevaplarını takip et.',
              borderColor: Colors.cyan,
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user?.username ?? '',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    'Öğrenci Hesabı',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilterBar(
              activeFilterCount: _activeFilterCount,
              onClearAll: _clearFilters,
              children: [
                // Arama
                FilterItem(
                  label: 'Ara',
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Başlık veya içerik...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (v) => setState(() => _search = v),
                    controller: TextEditingController(text: _search)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: _search.length),
                      ),
                  ),
                ),

                // Durum Filtresi
                FilterItem(
                  label: 'Durum',
                  child: Wrap(
                    spacing: 6,
                    children: [
                      _StatusChip(
                        label: 'Bekliyor',
                        value: 'reviewing',
                        selected: _statusFilter == 'reviewing',
                        onTap: () => setState(
                          () => _statusFilter = _statusFilter == 'reviewing'
                              ? ''
                              : 'reviewing',
                        ),
                      ),
                      _StatusChip(
                        label: 'Cevaplanmış',
                        value: 'answered',
                        selected: _statusFilter == 'answered',
                        onTap: () => setState(
                          () => _statusFilter = _statusFilter == 'answered'
                              ? ''
                              : 'answered',
                        ),
                      ),
                      _StatusChip(
                        label: 'Yönlendirildi',
                        value: 'forwarded',
                        selected: _statusFilter == 'forwarded',
                        onTap: () => setState(
                          () => _statusFilter = _statusFilter == 'forwarded'
                              ? ''
                              : 'forwarded',
                        ),
                      ),
                    ],
                  ),
                ),

                // Sıralama
                FilterItem(
                  label: 'Sıralama',
                  child: DropdownButtonFormField<String>(
                    initialValue: _sortBy,
                    isDense: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'priority',
                        child: Text('Öncelik'),
                      ),
                      DropdownMenuItem(value: 'newest', child: Text('En Yeni')),
                      DropdownMenuItem(value: 'oldest', child: Text('En Eski')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _sortBy = v);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Soru Listesi (Scrollable)
          Expanded(
            child: questionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sorular yüklenemedi',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () =>
                          ref.invalidate(questionsProvider(_cachedParams)),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
              data: (questions) {
                if (questions.isEmpty) {
                  return EmptyStateWidget(
                    icon: _activeFilterCount > 0
                        ? Icons.filter_list_off
                        : Icons.inbox_outlined,
                    title: _activeFilterCount > 0
                        ? 'Sonuç Bulunamadı'
                        : 'Henüz soru sormadınız',
                    description: _activeFilterCount > 0
                        ? 'Filtre kriterlerinize uygun soru yok.'
                        : 'Sağ alttaki butonu kullanarak ilk sorunuzu oluşturun.',
                    action: _activeFilterCount > 0
                        ? TextButton(
                            onPressed: _clearFilters,
                            child: const Text('Filtreleri Temizle'),
                          )
                        : null,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(questionsProvider(_cachedParams));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final q = questions[index];
                      final isExpanded = _expandedId == q.id;
                      return DashboardQuestionCard(
                        key: ValueKey(q.id),
                        question: q,
                        isExpanded: isExpanded,
                        onToggle: () => setState(() {
                          _expandedId = isExpanded ? null : q.id;
                        }),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Durum filtresi chip butonu.
class _StatusChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.cyan.withValues(alpha: 0.2),
      checkmarkColor: Colors.cyan,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        color: selected ? Colors.cyan : null,
      ),
    );
  }
}
