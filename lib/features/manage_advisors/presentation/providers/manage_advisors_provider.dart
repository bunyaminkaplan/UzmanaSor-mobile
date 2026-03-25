import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/domain/entities/simple_user_entity.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/manage_advisors/data/datasources/manage_advisors_remote_data_source.dart';
import 'package:mobile/features/manage_terms/domain/entities/class_term_entity.dart';

/// Data source provider.
final manageAdvisorsDataSourceProvider =
    Provider<ManageAdvisorsRemoteDataSource>((ref) {
      return ManageAdvisorsRemoteDataSourceImpl(ref.watch(apiClientProvider));
    });

/// Bölüm başkanının bölümüne ait sınıf/dönem listesi provider'ı.
final deptHeadClassTermsProvider =
    FutureProvider.autoDispose<List<ClassTermEntity>>((ref) {
      final ds = ref.watch(manageAdvisorsDataSourceProvider);
      return ds.getDeptClassTerms();
    });

/// Bölüm başkanının bölümüne ait hoca listesi provider'ı.
final deptHeadTeachersProvider =
    FutureProvider.autoDispose<List<SimpleUserEntity>>((ref) {
      final ds = ref.watch(manageAdvisorsDataSourceProvider);
      return ds.getDeptTeachers();
    });
