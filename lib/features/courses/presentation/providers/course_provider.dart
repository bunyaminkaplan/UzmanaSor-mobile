import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/courses/data/repositories/course_repository_impl.dart';
import 'package:mobile/features/courses/domain/entities/course_entity.dart';

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
