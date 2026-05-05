import 'package:flutter/material.dart';

import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/public_feed/presentation/widgets/feed_question_card.dart';
import 'package:mobile/shared/widgets/empty_state_widget.dart';

/// Public Feed soru listesi.
///
/// Expand/collapse state'i yönetir — aynı anda yalnızca bir kart açık kalır.
/// Empty state, scroll controller ve opsiyonel footer (infinite scroll) dışarıdan gelir.
class FeedQuestionList extends StatefulWidget {
  final List<QuestionEntity> items;
  final Widget? footer;
  final VoidCallback? onNearEnd;

  const FeedQuestionList({
    super.key,
    required this.items,
    this.footer,
    this.onNearEnd,
  });

  @override
  State<FeedQuestionList> createState() => _FeedQuestionListState();
}

class _FeedQuestionListState extends State<FeedQuestionList> {
  int? _expandedId;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.public_off_rounded,
        title: 'Henüz herkese açık soru bulunmuyor',
        description: 'Sorular herkese açık yapıldığında burada görünecek',
      );
    }

    final hasFooter = widget.footer != null;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (widget.onNearEnd != null &&
            notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
          widget.onNearEnd!();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: widget.items.length + (hasFooter ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= widget.items.length) {
          return widget.footer!;
        }
        final q = widget.items[index];
        final isExpanded = _expandedId == q.id;
        return FeedQuestionCard(
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
  }
}
