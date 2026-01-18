import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/questions/presentation/widgets/widgets.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';
import 'package:mobile/features/questions/data/repositories/question_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/questions/presentation/providers/question_feed_provider.dart';

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

  void _showForwardModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ForwardTeacherSheet(
        currentHandlerId: _currentQuestion.currentHandler?.id,
        onTeacherSelected: (teacher) {
          Navigator.pop(context); // Close modal
          _confirmForward(teacher);
        },
      ),
    );
  }

  void _confirmForward(UserModel newHandler) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Emin misiniz?"),
        content: Text(
          "Soruyu ${newHandler.firstName} ${newHandler.lastName} kişisine yönlendirmek üzeresiniz.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _executeForward(newHandler.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text("Yönlendir"),
          ),
        ],
      ),
    );
  }

  Future<void> _executeForward(int newHandlerId) async {
    final result = await ref
        .read(questionRepositoryProvider)
        .forwardQuestion(
          questionId: _currentQuestion.id,
          newHandlerId: newHandlerId,
        );

    if (mounted) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Soru başarıyla yönlendirildi ve listenizden kaldırıldı.',
              ),
              backgroundColor: AppColors.success,
            ),
          );

          // Invalidate feed and exit
          ref.invalidate(questionFeedProvider);
          if (mounted) Navigator.of(context).pop();
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
    final user = ref.watch(authProvider).value;
    // Show forward button only for Teachers, Deans, etc.
    final canForward =
        user != null &&
        (user.userType == 'teacher' ||
            user.userType == 'dean' ||
            user.userType == 'department_head' ||
            user.isDepartmentHead);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soru Detayı'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.navy,
        scrolledUnderElevation: 0,
        actions: [
          if (canForward)
            IconButton(
              icon: const Icon(Icons.forward_to_inbox, color: AppColors.orange),
              tooltip: "Soruyu Yönlendir",
              onPressed: _showForwardModal,
            ),
        ],
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
