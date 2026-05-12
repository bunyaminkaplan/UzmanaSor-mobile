import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/courses/data/repositories/course_repository_impl.dart';
import 'package:mobile/features/courses/domain/entities/course_entity.dart';
import 'package:mobile/features/teachers/presentation/providers/teachers_provider.dart';

// Re-export: sayfa katmanından kolayca erişilebilmesi için.
export 'package:mobile/features/courses/data/repositories/course_repository_impl.dart'
    show courseRepositoryProvider;

/// Tüm dersler
final coursesProvider = FutureProvider.autoDispose<List<CourseEntity>>((
  ref,
) async {
  final repo = ref.watch(courseRepositoryProvider);
  final result = await repo.getCourses();
  return result.fold((f) => throw f, (courses) => courses);
});

/// Kullanıcının dersleri
final myCoursesProvider = FutureProvider.autoDispose<List<CourseEntity>>((
  ref,
) async {
  final repo = ref.watch(courseRepositoryProvider);
  final result = await repo.getMyCourses();
  return result.fold((f) => throw f, (courses) => courses);
});

/// Bölüm başkanının bölümündeki dersler (Ders Yönetimi sayfası)
final departmentCoursesProvider =
    FutureProvider.autoDispose<List<CourseEntity>>((
  ref,
) async {
  final repo = ref.watch(courseRepositoryProvider);
  final result = await repo.getMyDepartmentCourses();
  return result.fold((f) => throw f, (courses) => courses);
});

/// Form'daki öğretmen multi-select için — tüm hocalar (department filtresi yok).
final allTeachersForCoursesProvider = teachersProvider(null);
