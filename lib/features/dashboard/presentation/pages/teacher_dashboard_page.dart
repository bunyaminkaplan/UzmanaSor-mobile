import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/questions/presentation/providers/question_provider.dart';
import 'package:mobile/shared/widgets/dashboard_page_header.dart';
import 'package:mobile/shared/widgets/dashboard_question_list.dart';
import 'package:mobile/shared/widgets/async_error_widget.dart';
import 'package:mobile/shared/widgets/dashboard_scaffold.dart';
import 'package:mobile/shared/widgets/filter_bar.dart';

/// Teacher Dashboard — öğretmen ana paneli.
///
/// Hocalara (ve bölüm başkanlarına) atanan soruları listeler.
/// Gelen soruları öncelik/tarih gibi filtrelerle gösterir.
class TeacherDashboardPage extends ConsumerStatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  ConsumerState<TeacherDashboardPage> createState() =>
      _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends ConsumerState<TeacherDashboardPage> {
  // --- Filtre State ---
  String _search = '';
  String _statusFilter = '';
  String _sortBy = 'priority';

  Map<String, dynamic> _cachedParams = const {'ordering': '-question_priority'};

  void _rebuildParams() {
    final params = <String, dynamic>{};
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

    return DashboardScaffold(
      onRefresh: () =>
          ref.read(questionsProvider(_cachedParams).notifier).refresh(),
      pageTitle: 'Öğretmen Paneli',
      header: DashboardPageHeader(
        title: 'Öğretmen Paneli',
        description: 'Öğrencilerden gelen soruları cevapla ve yönet.',
        borderColor: Theme.of(context).colorScheme.primary,
        userName: user?.username ?? '',
        userNameColor: Theme.of(context).colorScheme.primary,
        roleName: 'Öğretmen Hesabı',
      ),
      body: Column(
        children: [

          // Filter Bar
          FilterBar(
            activeFilterCount: _activeFilterCount,
            onClearAll: _clearFilters,
            children: [
              // Arama
              FilterItem(
                label: 'Arama',
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Soru ara...',
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (val) {
                    _search = val;
                    _rebuildParams();
                  },
                ),
              ),
              // Durum
              FilterItem(
                label: 'Durum',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _statusFilter.isEmpty ? null : _statusFilter,
                    hint: const Text('Durum'),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    items: const [
                      DropdownMenuItem(value: '', child: Text('Tümü')),
                      DropdownMenuItem(
                        value: 'reviewing',
                        child: Text('İnceleniyor'),
                      ),
                      DropdownMenuItem(
                        value: 'answered',
                        child: Text('Cevaplandı'),
                      ),
                      DropdownMenuItem(
                        value: 'forwarded',
                        child: Text('Yönlendirildi'),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _statusFilter = val ?? '';
                        _rebuildParams();
                      });
                    },
                  ),
                ),
              ),
              // Sıralama
              FilterItem(
                label: 'Sıralama',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    isExpanded: true,
                    icon: const Icon(Icons.sort, size: 20),
                    items: const [
                      DropdownMenuItem(
                        value: 'priority',
                        child: Text('Öncelikli'),
                      ),
                      DropdownMenuItem(value: 'newest', child: Text('En Yeni')),
                      DropdownMenuItem(value: 'oldest', child: Text('En Eski')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _sortBy = val;
                          _rebuildParams();
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          // Soru Listesi (Scrollable)
          questionsAsync.when(
            loading: () => const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => const Expanded(
              child: AsyncErrorWidget(message: 'Bir hata oluştu'),
            ),
            data: (s) {
              return Expanded(
                child: DashboardQuestionList(
                  questions: s.items,
                  onRefresh: () async {
                    await ref
                        .read(questionsProvider(_cachedParams).notifier)
                        .refresh();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
