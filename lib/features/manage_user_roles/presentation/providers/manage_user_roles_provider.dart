import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/manage_user_roles/data/datasources/manage_user_roles_remote_datasource.dart';
import 'package:mobile/features/manage_user_roles/data/repositories/manage_user_roles_repository_impl.dart';
import 'package:mobile/features/manage_user_roles/domain/repositories/manage_user_roles_repository.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';

// --- SEARCH QUERY PROVIDER ---
/// Arama kelimesini (search query) tutar. Değiştiğinde `usersListProvider` otomatik tetiklenir.
final userSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

// --- CORE PROVIDERS ---
final _manageUserRolesDataSourceProvider =
    Provider<ManageUserRolesRemoteDataSource>((ref) {
      // apiClientProvider projedeki mevcut Dio kopyasını verir.
      return ManageUserRolesRemoteDataSourceImpl(
        dio: ref.watch(apiClientProvider).dio,
      );
    });

final manageUserRolesRepositoryProvider = Provider<ManageUserRolesRepository>((
  ref,
) {
  return ManageUserRolesRepositoryImpl(
    remoteDataSource: ref.watch(_manageUserRolesDataSourceProvider),
  );
});

// --- LIST PROVIDER ---
/// Onaylı tüm kullanıcıların listesini (veya arama sonuçlarını) döner.
final usersListProvider = FutureProvider.autoDispose<List<UserEntity>>((
  ref,
) async {
  final repo = ref.watch(manageUserRolesRepositoryProvider);
  final query = ref.watch(userSearchQueryProvider);

  // Şimdilik page 1 ile listeliyoruz (Sayfalama - pagination ileride InfiniteScroll ile eklenebilir)
  return repo.getUsers(page: 1, search: query);
});
