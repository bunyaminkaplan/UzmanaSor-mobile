import 'package:flutter/material.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/public_feed/presentation/widgets/feed_answer_card.dart';

/// Soruya ait tüm cevapların incelenebildiği %70 ekran kapasiteli Modal Panel
class AnswersBottomSheet extends StatelessWidget {
  final List<AnswerEntity> answers;

  const AnswersBottomSheet({super.key, required this.answers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () =>
          Navigator.of(context).pop(), // Boşluğa (üst %30) tıklanınca kapat
      child: GestureDetector(
        onTap:
            () {}, // Sheet content içindeki tıklamaların propagate olmasını engelle
        child: DraggableScrollableSheet(
          initialChildSize: 0.7, // Ekranın %70'i
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Sürükleme Çizgisi (Handle)
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Cevaplar (${answers.length})',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Liste içindeki cevaplar
                  Expanded(
                    child: answers.isEmpty
                        ? const Center(
                            child: Text(
                              'Henüz cevaplanmamış.',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: answers.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return FeedAnswerCard(
                                answer: answers[index],
                                isSnippet: false,
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
