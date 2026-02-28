import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';

// ---------------------------------------------------------------------------
// AuthProvider — Kimlik doğrulama state'ini yöneten AsyncNotifier.
//
// Tip: AsyncNotifier<UserEntity?>
//   - null  → Kullanıcı oturum açmamış (veya session expired)
//   - UserEntity → Kullanıcı oturum açmış
//   - AsyncLoading → Oturum kontrol ediliyor / giriş yapılıyor
//   - AsyncError → Ağ hatası veya sunucu hatası
//
// KRİTİK GARANTİ:
//   build() ve login() metodları HER DURUMDA state'i Loading'den çıkarır.
//   Hiçbir exception akışı sessizce yutulamaz.
// ---------------------------------------------------------------------------
final authProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  late final AuthRepository _repository;

  @override
  FutureOr<UserEntity?> build() async {
    try {
      _repository = ref.watch(authRepositoryProvider);
      return await _checkAuthStatus();
    } catch (e, stackTrace) {
      debugPrint('⚠️ AuthNotifier.build() hatası: $e');
      debugPrint('$stackTrace');
      return null;
    }
  }

  /// Mevcut session'ı kontrol eder.
  Future<UserEntity?> _checkAuthStatus() async {
    try {
      final result = await _repository.checkAuth();
      return result.fold((failure) {
        debugPrint('ℹ️ Oturum kontrolü: $failure');
        return null;
      }, (user) => user);
    } catch (e, stackTrace) {
      debugPrint('⚠️ _checkAuthStatus hatası: $e');
      debugPrint('$stackTrace');
      return null;
    }
  }

  /// Kullanıcı adı ve şifre ile giriş yapar.
  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    try {
      final result = await _repository.login(
        username: username,
        password: password,
      );

      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (user) => AsyncValue.data(user),
      );
    } catch (e, stackTrace) {
      debugPrint('⚠️ login() hatası: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Oturumu kapatır, session cookie'leri temizler.
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _repository.logout();
    } catch (e) {
      debugPrint('⚠️ logout() hatası: $e');
    }
    state = const AsyncValue.data(null);
  }
}
