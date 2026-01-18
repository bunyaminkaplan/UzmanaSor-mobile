import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/ui_kit/ui_kit.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';
import 'package:mobile/features/questions/data/repositories/question_repository.dart';
import 'package:mobile/features/questions/presentation/providers/question_feed_provider.dart';

class AskQuestionPage extends ConsumerStatefulWidget {
  const AskQuestionPage({super.key});

  @override
  ConsumerState<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends ConsumerState<AskQuestionPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // State
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<CourseDetails> _courses = [];
  List<UserModel> _availableTeachers = [];

  CourseDetails? _selectedCourse;
  UserModel? _selectedTeacher;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    final repo = ref.read(questionRepositoryProvider);
    final result = await repo.getCourses();

    if (mounted) {
      result.fold(
        (failure) {
          setState(() {
            _errorMessage = failure.message;
            _isLoading = false;
          });
        },
        (courses) {
          setState(() {
            _courses = courses;
            _isLoading = false;
          });
        },
      );
    }
  }

  void _onCourseChanged(CourseDetails? course) {
    setState(() {
      _selectedCourse = course;
      // Reset teacher selection when course changes
      _selectedTeacher = null;
      _availableTeachers = course?.teachers ?? [];
    });
  }

  Future<void> _submitQuestion() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCourse == null || _selectedTeacher == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen ders ve öğretmen seçiniz.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final repo = ref.read(questionRepositoryProvider);
    final result = await repo.createQuestion(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      courseId: _selectedCourse!.id,
      teacherId: _selectedTeacher!.id,
    );

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
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sorunuz başarıyla gönderildi!'),
              backgroundColor: AppColors.success,
            ),
          );
          // Refresh the feed
          ref.refresh(questionFeedProvider);
          context.pop(); // Go back to dashboard
        },
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soru Sor'),
        backgroundColor: AppColors.surfaceLight,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.navy,
      ),
      backgroundColor: AppColors.bgLight,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.error),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Input
                    UzmanTextField(
                      controller: _titleController,
                      label: 'Başlık',
                      hint: 'Sorunuzun başlığı',
                      validator: (v) =>
                          v?.isEmpty == true ? 'Başlık zorunludur' : null,
                    ),
                    const SizedBox(height: 20),

                    // Content Input
                    UzmanTextField(
                      controller: _contentController,
                      label: 'İçerik',
                      hint: 'Sorunuzu detaylıca açıklayın...',
                      maxLines: 5,
                      validator: (v) =>
                          v?.isEmpty == true ? 'İçerik zorunludur' : null,
                    ),
                    const SizedBox(height: 20),

                    // Course Dropdown
                    UzmanDropdown<CourseDetails>(
                      value: _selectedCourse,
                      items: _courses.map((course) {
                        return DropdownMenuItem(
                          value: course,
                          child: Text(course.title),
                        );
                      }).toList(),
                      hint: 'Ders Seçiniz',
                      onChanged: _onCourseChanged,
                    ),
                    const SizedBox(height: 20),

                    // Teacher Dropdown
                    if (_selectedCourse != null) ...[
                      UzmanDropdown<UserModel>(
                        value: _selectedTeacher,
                        items: _availableTeachers.map((teacher) {
                          return DropdownMenuItem(
                            value: teacher,
                            child: Text(
                              "${teacher.firstName} ${teacher.lastName}",
                            ),
                          );
                        }).toList(),
                        hint: 'Öğretmen Seçiniz',
                        onChanged: (val) =>
                            setState(() => _selectedTeacher = val),
                        errorText: _availableTeachers.isEmpty
                            ? 'Bu dersi veren öğretmen bulunamadı.'
                            : null,
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Submit Button
                    UzmanButton(
                      label: 'Soruyu Gönder',
                      isLoading: _isSubmitting,
                      onPressed: _submitQuestion,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
