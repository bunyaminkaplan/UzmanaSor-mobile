import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/core/domain/entities/simple_user_entity.dart';
import 'package:mobile/features/courses/domain/entities/course_entity.dart';
import 'package:mobile/features/courses/presentation/providers/course_provider.dart';
import 'package:mobile/features/questions/data/repositories/question_repository_impl.dart';
import 'package:mobile/features/questions/presentation/providers/question_provider.dart';

/// Soru oluşturma sayfası.
///
/// Akış (web frontend ile birebir):
///   1. Ders seç → dropdown
///   2. Ders seçilince → o dersin hocaları dropdown'da görünür
///   3. Hoca seç → zorunlu
///   4. Başlık + İçerik yaz
///   5. Opsiyonel: Herkese Açık toggle
///   6. Gönder → POST core/questions/ {title, content, course, target_teacher_id, is_public}
class AskQuestionPage extends ConsumerStatefulWidget {
  const AskQuestionPage({super.key});

  @override
  ConsumerState<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends ConsumerState<AskQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  int? _selectedCourseId;
  int? _selectedTeacherId;
  List<SimpleUserEntity> _availableTeachers = [];
  bool _isPublic = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  /// Ders seçilince öğretmen listesini güncelle.
  void _onCourseChanged(int? courseId, List<CourseEntity> courses) {
    setState(() {
      _selectedCourseId = courseId;
      _selectedTeacherId = null; // Ders değişince hoca sıfırlanır

      if (courseId != null) {
        final course = courses.where((c) => c.id == courseId).firstOrNull;
        _availableTeachers = course?.teachers ?? [];
      } else {
        _availableTeachers = [];
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final repo = ref.read(questionRepositoryProvider);
    final result = await repo.createQuestion(
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      courseId: _selectedCourseId!,
      targetTeacherId: _selectedTeacherId!,
      isPublic: _isPublic,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
      (question) {
        ref.invalidate(questionsProvider(null));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Soru başarıyla gönderildi!')),
          );
          GoRouter.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Soru Sor')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ders seçimi
                coursesAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(
                    'Dersler yüklenemedi: $e',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  data: (courses) => DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Ders',
                      prefixIcon: Icon(Icons.book_outlined),
                    ),
                    // ignore: deprecated_member_use
                    value: _selectedCourseId,
                    items: courses.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text(c.displayName),
                      );
                    }).toList(),
                    onChanged: (id) => _onCourseChanged(id, courses),
                    validator: (v) => v == null ? 'Ders seçimi zorunlu' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Öğretmen seçimi (ders seçilince görünür)
                if (_availableTeachers.isNotEmpty) ...[
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Öğretmen',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    // ignore: deprecated_member_use
                    value: _selectedTeacherId,
                    items: _availableTeachers.map((t) {
                      return DropdownMenuItem(
                        value: t.id,
                        child: Text(t.fullName),
                      );
                    }).toList(),
                    onChanged: (id) => setState(() => _selectedTeacherId = id),
                    validator: (v) =>
                        v == null ? 'Öğretmen seçimi zorunlu' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // Başlık
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Soru Başlığı',
                    prefixIcon: Icon(Icons.title),
                  ),
                  textInputAction: TextInputAction.next,
                  maxLength: 255,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Başlık zorunlu';
                    if (v.trim().length < 5) return 'En az 5 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // İçerik
                TextFormField(
                  controller: _contentCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Soru İçeriği',
                    prefixIcon: Icon(Icons.description_outlined),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 6,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'İçerik zorunlu';
                    if (v.trim().length < 10) return 'En az 10 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Herkese açık toggle
                SwitchListTile(
                  title: const Text('Herkese Açık'),
                  subtitle: const Text('Diğer öğrenciler bu soruyu görebilir'),
                  value: _isPublic,
                  onChanged: (v) => setState(() => _isPublic = v),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),

                // Hata mesajı
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Gönder butonu
                FilledButton.icon(
                  onPressed: _isLoading ? null : _handleSubmit,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: const Text('Soruyu Gönder'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
