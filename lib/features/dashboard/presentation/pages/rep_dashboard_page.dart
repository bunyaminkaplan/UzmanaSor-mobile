import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';

import 'package:mobile/features/questions/presentation/providers/question_provider.dart';
import 'package:mobile/shared/widgets/dashboard_page_header.dart';
import 'package:mobile/shared/widgets/dashboard_question_list.dart';
import 'package:mobile/shared/widgets/async_error_widget.dart';
import 'package:mobile/shared/widgets/dashboard_scaffold.dart';
import 'package:mobile/shared/widgets/filter_bar.dart';

/// Temsilci Paneli — Onay Bekleyen Sorular
///
/// Temsilciler (rep) sadece bekleyen soruları yönetir. Bu sayfada paylaşımlı
/// UI bileşenleri (DashboardScaffold, FilterBar, DashboardQuestionList) kullanılır.
class RepDashboardPage extends ConsumerStatefulWidget {
  const RepDashboardPage({super.key});

  @override
  ConsumerState<RepDashboardPage> createState() => _RepDashboardPageState();
}

class _RepDashboardPageState extends ConsumerState<RepDashboardPage> {
  final TextEditingController _searchController = TextEditingController();

  // Temsilci panelinde "durum" varsayılan olarak bekleyenlerdir.
  String _selectedStatus = 'pending';

  // Riverpod family provider'ları parametreleri referans bazlı karşılaştırır.
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

  void _updateFilter(VoidCallback updateAction) {
    setState(() {
      updateAction();
      _cachedParams = _buildParams();
    });
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider(_cachedParams));

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(questionsProvider(_cachedParams)),
      pageTitle: 'Sınıfına Gelen Sorular',
      header: const DashboardPageHeader(
        title: 'Sınıfına Gelen Sorular',
        description:
            'Onaylaman veya reddetmen gereken soruları buradan yönetebilirsin.',
        borderColor: AppColors.accentNavy,
      ),
      body: Column(
        children: [

          // 2. Filtre Çubuğu
          FilterBar(
            activeFilterCount:
                (_selectedStatus != 'pending' ? 1 : 0) +
                (_searchController.text.isNotEmpty ? 1 : 0),
            onClearAll: () {
              _updateFilter(() {
                _selectedStatus = 'pending';
                _searchController.clear();
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
                    border: Border.all(color: AppColors.textMuted),
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
            error: (err, stack) => const Expanded(
              child: AsyncErrorWidget(message: 'Bir hata oluştu'),
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
