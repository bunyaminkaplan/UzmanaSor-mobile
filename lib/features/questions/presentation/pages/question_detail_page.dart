import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/questions/presentation/widgets/widgets.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';
import 'package:mobile/features/questions/data/repositories/question_repository.dart';

class QuestionDetailPage extends ConsumerStatefulWidget {
  final QuestionModel question;

  const QuestionDetailPage({super.key, required this.question});

  @override
  ConsumerState<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends ConsumerState<QuestionDetailPage> {
  final _answerController = TextEditingController();
  bool _isSubmitting = false;
  late QuestionModel _currentQuestion;

  @override
  void initState() {
    super.initState();
    _currentQuestion = widget.question;
    _refreshQuestion(); // Fetch latest data including answers
  }

  Future<void> _refreshQuestion() async {
    final result = await ref
        .read(questionRepositoryProvider)
        .getQuestion(_currentQuestion.id);

    if (mounted) {
      result.fold(
        (failure) => null, // Silent fail on refresh
        (updatedQuestion) {
          setState(() {
            _currentQuestion = updatedQuestion;
          });
        },
      );
    }
  }

  Future<void> _submitAnswer() async {
    final content = _answerController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSubmitting = true);

    final result = await ref
        .read(questionRepositoryProvider)
        .postAnswer(questionId: _currentQuestion.id, content: content);

    if (mounted) {
      setState(() => _isSubmitting = false);

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (_) async {
          _answerController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cevabınız gönderildi!'),
              backgroundColor: AppColors.success,
            ),
          );
          await _refreshQuestion(); // Re-fetch to show new answer
        },
      );
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soru Detayı'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.navy,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: AppColors.bgLight,
      body: Column(
        children: [
          // Scrollable Content (Question + Answers)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuestionHeaderCard(question: _currentQuestion),
                  const SizedBox(height: 24),
                  const Text(
                    "Cevaplar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAnswersList(),
                ],
              ),
            ),
          ),

          // Answer Input Area
          AnswerInputArea(
            controller: _answerController,
            onSubmit:
                _submitAnswer, // _isSubmitting check handled inside? No, passed as isLoading
            isLoading: _isSubmitting,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersList() {
    final answers = _currentQuestion.answers;

    if (answers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            "Henüz cevap yok. İlk cevabı sen yaz!",
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(), // Scroll managed by parent
      shrinkWrap: true,
      itemCount: answers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return AnswerListItem(answer: answers[index]);
      },
    );
  }
}
