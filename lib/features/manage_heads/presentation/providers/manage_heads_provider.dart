import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/domain/entities/simple_user_entity.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/manage_heads/data/datasources/manage_heads_remote_data_source.dart';

/// Data source provider.
final _manageHeadsDataSourceProvider = Provider<ManageHeadsRemoteDataSource>((
  ref,
) {
  return ManageHeadsRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

/// Bölüme göre hoca listesi provider'ı (departmentId parametreli).
final departmentTeachersProvider = FutureProvider.autoDispose
    .family<List<SimpleUserEntity>, int>((ref, departmentId) async {
      final ds = ref.watch(_manageHeadsDataSourceProvider);
      return ds.getTeachersByDepartment(departmentId);
    });

/// Toggle department head provider (tek seferlik aksiyon).
final toggleHeadProvider = Provider<ManageHeadsRemoteDataSource>((ref) {
  return ManageHeadsRemoteDataSourceImpl(ref.watch(apiClientProvider));
});
