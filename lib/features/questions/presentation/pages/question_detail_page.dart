import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/questions/presentation/providers/question_provider.dart';
import 'package:mobile/features/questions/domain/entities/question_status.dart';
import 'package:mobile/features/questions/presentation/widgets/answer_list.dart';
import 'package:mobile/features/questions/presentation/widgets/question_header.dart';
import 'package:mobile/features/questions/presentation/widgets/question_info_panel.dart';
import 'package:mobile/features/questions/presentation/widgets/rep_action_buttons.dart';
import 'package:mobile/features/questions/presentation/widgets/student_resubmit_form.dart';
import 'package:mobile/features/questions/presentation/widgets/teacher_answer_form.dart';
import 'package:mobile/features/questions/presentation/widgets/teacher_forward_form.dart';
import 'package:mobile/features/questions/presentation/widgets/transition_timeline.dart';

/// Soru detay sayfası — orkestratör.
///
/// Web: QuestionDetail.jsx → rol bazlı delegasyon.
/// Rol-koşullu widget gösterimi:
///   - Teacher: Cevap yaz + Yönlendirme
///   - Rep (Student): Onay / Red
///   - Student (owner + rejected): Resubmit
class QuestionDetailPage extends ConsumerWidget {
  final int questionId;

  const QuestionDetailPage({super.key, required this.questionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionAsync = ref.watch(questionDetailProvider(questionId));
    final user = ref.watch(authProvider).value;
    final userType = user?.userType;
    final isTeacher = userType == 'teacher';
    final isStudent = userType == 'student' || userType == 'r_student';
    final isRep = userType == 'r_student';

    return Scaffold(
      appBar: AppBar(title: const Text('Soru Detay')),
      body: questionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Soru yüklenemedi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.invalidate(questionDetailProvider(questionId)),
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
        data: (question) => RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(questionDetailProvider(questionId)),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionHeader(question: question),
                const SizedBox(height: 16),
                QuestionInfoPanel(question: question),
                const SizedBox(height: 16),
                AnswerListWidget(answers: question.answers),

                // --------- HOCA AKSİYONLARI ---------
                if (isTeacher && question.status != QuestionStatus.closed) ...[
                  const SizedBox(height: 24),
                  TeacherAnswerForm(questionId: question.id),
                  const SizedBox(height: 16),
                  TeacherForwardForm(questionId: question.id),
                ],

                // --------- TEMSİLCİ AKSİYONLARI ---------
                if (isRep && question.repStatus == RepStatus.pending) ...[
                  const SizedBox(height: 24),
                  RepActionButtons(questionId: question.id),
                ],

                // --------- ÖĞRENCİ RESUBMIT ---------
                if (isStudent && question.canEdit) ...[
                  const SizedBox(height: 24),
                  StudentResubmitForm(question: question),
                ],

                // --------- GEÇİŞ TARİHÇESİ ---------
                if (question.transitions.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  TransitionTimeline(transitions: question.transitions),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
