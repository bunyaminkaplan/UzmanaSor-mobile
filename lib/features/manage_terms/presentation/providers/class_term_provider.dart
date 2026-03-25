import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/manage_terms/data/datasources/class_term_remote_data_source.dart';
import 'package:mobile/features/manage_terms/data/repositories/class_term_repository_impl.dart';
import 'package:mobile/features/manage_terms/domain/entities/class_term_entity.dart';
import 'package:mobile/features/manage_terms/domain/repositories/class_term_repository.dart';

// Bağımlılıklar
import 'package:mobile/features/academic_units/presentation/providers/academic_units_provider.dart';
import 'package:mobile/features/teachers/presentation/providers/teachers_provider.dart';

/// Data source provider.
final _classTermDataSourceProvider = Provider<ClassTermRemoteDataSource>((ref) {
  return ClassTermRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

/// Repository provider.
final classTermRepositoryProvider = Provider<ClassTermRepository>((ref) {
  return ClassTermRepositoryImpl(ref.watch(_classTermDataSourceProvider));
});

/// Dönem listesi provider'ı.
final classTermsProvider = FutureProvider.autoDispose<List<ClassTermEntity>>((
  ref,
) async {
  final repo = ref.watch(classTermRepositoryProvider);
  return repo.getAll();
});

/// Form için bölüm listesini academic_units'tan flatten eder.
/// [{id, name}, ...] formatında döner.
final flatDepartmentsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final faculties = await ref.watch(facultiesProvider.future);
      final departments = <Map<String, dynamic>>[];
      for (final faculty in faculties) {
        for (final dept in faculty.departments) {
          departments.add({'id': dept.id, 'name': dept.name});
        }
      }
      return departments;
    });

/// Form için hoca listesi — tüm hocalar (departmentId=null).
final allTeachersProvider = teachersProvider(null);
