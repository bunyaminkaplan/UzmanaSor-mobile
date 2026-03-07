import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/questions/presentation/providers/question_provider.dart';
import 'package:mobile/shared/widgets/dashboard_page_header.dart';
import 'package:mobile/shared/widgets/dashboard_question_list.dart';
import 'package:mobile/shared/widgets/filter_bar.dart';
import 'package:mobile/shared/widgets/dashboard_drawer.dart';

/// Temsilci Paneli — Onay Bekleyen Sorular
///
/// Temsilciler (rep) sadece bekleyen soruları yönetir. Bu sayfada paylaşımlı
/// UI bileşenleri (DashboardDrawer, FilterBar, DashboardQuestionList) kullanılır.
class RepDashboardPage extends ConsumerStatefulWidget {
  const RepDashboardPage({super.key});

  @override
  ConsumerState<RepDashboardPage> createState() => _RepDashboardPageState();
}

class _RepDashboardPageState extends ConsumerState<RepDashboardPage> {
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  // Temsilci panelinde "durum" varsayılan olarak bekleyenlerdir.
  String _selectedStatus = 'pending';

  // Riverpod family provider'ları parametreleri referans bazlı karşılaştırır.
  // Her build'de yeni Map oluşturulmasını engellemek için parametreleri cache'liyoruz.
  late Map<String, dynamic> _cachedParams = _buildParams();

  Map<String, dynamic> _buildParams() {
    final params = <String, dynamic>{
      'rep_status': _selectedStatus,
      'rep_handler': 'me',
      'has_answers': 'false',
    };
    if (_searchController.text.isNotEmpty) {
      params['search'] = _searchController.text;
    }
    return params;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtrelerin değişmesi durumunda listeyi güncelleyen genel metot.
  void _updateFilter(VoidCallback updateAction) {
    setState(() {
      updateAction();
      _cachedParams = _buildParams();
    });
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider(_cachedParams));
    return Scaffold(
      drawer: const DashboardDrawer(),
      appBar: AppBar(
        title: const Text('Temsilci Paneli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(questionsProvider(_cachedParams)),
            tooltip: 'Yenile',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Dashboard Başlığı
          const DashboardPageHeader(
            title: 'Sınıfına Gelen Sorular',
            description:
                'Onaylaman veya reddetmen gereken soruları buradan yönetebilirsin.',
            borderColor: Colors.purple,
          ),

          // 2. Filtre Çubuğu
          FilterBar(
            activeFilterCount:
                (_selectedStatus != 'pending' ? 1 : 0) +
                (_searchController.text.isNotEmpty ? 1 : 0),
            onClearAll: () {
              _updateFilter(() {
                _selectedStatus = 'pending';
                _searchController.clear();
                _isSearchExpanded = false;
              });
            },
            children: [
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
                  onChanged: (v) => _updateFilter(() {}),
                  controller:
                      TextEditingController(text: _searchController.text)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: _searchController.text.length),
                        ),
                ),
              ),
              FilterItem(
                label: 'Durum',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _updateFilter(() => _selectedStatus = newValue);
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text('Onay Bekleyenler'),
                        ),
                        DropdownMenuItem(
                          value: 'approved',
                          child: Text('Onaylananlar'),
                        ),
                        DropdownMenuItem(
                          value: 'rejected',
                          child: Text('Reddedilenler'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 3. Ortak Soru Listesi Bileşeni
          questionsAsync.when(
            loading: () => const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => Expanded(
              child: Center(
                child: Text(
                  'Bir hata oluştu:\n$err',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (questions) {
              return Expanded(
                child: DashboardQuestionList(
                  questions: questions,
                  onRefresh: () async {
                    ref.invalidate(questionsProvider(_cachedParams));
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
