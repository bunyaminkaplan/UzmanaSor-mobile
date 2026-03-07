import 'package:flutter/material.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/shared/widgets/dashboard_question_card.dart';

/// Tüm dashboard'lar (Student, Teacher, Rep vb.) için ortak,
/// kendi içinde expand/collapse state'ini yöneten soru listesi widget'ı.
class DashboardQuestionList extends StatefulWidget {
  final List<QuestionEntity> questions;
  final EdgeInsetsGeometry padding;
  final Future<void> Function()? onRefresh;

  const DashboardQuestionList({
    super.key,
    required this.questions,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 80),
    this.onRefresh,
  });

  @override
  State<DashboardQuestionList> createState() => _DashboardQuestionListState();
}

class _DashboardQuestionListState extends State<DashboardQuestionList> {
  int? _expandedId;

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      // Custom EmptyState widget'ı varsa o da kullanılabilir.
      // Şimdilik basit bir text ile bırakıyoruz.
      return const Center(child: Text('Gösterilecek soru bulunamadı.'));
    }

    Widget list = ListView.builder(
      padding: widget.padding,
      itemCount: widget.questions.length,
      itemBuilder: (context, index) {
        final q = widget.questions[index];
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
    );

    if (widget.onRefresh != null) {
      return RefreshIndicator(onRefresh: widget.onRefresh!, child: list);
    }

    return list;
  }
}
