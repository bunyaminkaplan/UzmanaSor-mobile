import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

// ---------------------------------------------------------------------------
// AuthRemoteDataSource — Auth endpoint'leriyle doğrudan konuşan katman.
//
// Sorumlulukları:
//   1. HTTP isteği yapmak (ApiClient üzerinden)
//   2. Ham JSON → UserModel dönüşümü (deserialize)
//   3. Logout sırasında cookie temizleme
//
// Sorumlulukları OLMAYAN:
//   - DioException → Failure dönüşümü (Repository'nin işi)
//   - UserModel → UserEntity dönüşümü (Repository'nin işi)
//   - İş mantığı kararları (Domain'in işi)
// ---------------------------------------------------------------------------

/// Soyut kontrat — test sırasında mock'lanabilir.
abstract class AuthRemoteDataSource {
  /// POST auth/login/ — Başarıda UserModel döner, hatada DioException fırlatır.
  Future<UserModel> loginUser({
    required String username,
    required String password,
  });

  /// GET auth/me/ — Aktif session varsa UserModel döner, yoksa DioException fırlatır.
  Future<UserModel> getCurrentUser();

  /// POST auth/logout/ — Session'ı invalidate eder ve cookie'leri temizler.
  Future<void> logoutUser();
}

/// Gerçek implementasyon.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserModel> loginUser({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.authLogin,
      data: {'username': username, 'password': password},
    );

    return _parseUserFromResponse(response.data);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.authMe);

    return _parseUserFromResponse(response.data);
  }

  /// Response verisini güvenli şekilde UserModel'e çevirir.
  ///
  /// Backend HTML veya null dönerse (ör: redirect sayfası, 302)
  /// cast hatası (TypeError) yerine açık bir FormatException fırlatır.
  /// Bu sayede Repository katmanındaki `catch (e)` bloğu tarafından
  /// yakalanır ve UI'a Failure olarak iletilir.
  UserModel _parseUserFromResponse(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Sunucudan beklenmeyen yanıt formatı: ${data.runtimeType}',
      );
    }
    return UserModel.fromJson(data);
  }

  @override
  Future<void> logoutUser() async {
    await _apiClient.post(ApiEndpoints.authLogout);

    // Backend session'ı invalidate ettikten sonra, local cookie deposunu
    // da temizliyoruz. Bu sayede aynı cihazdan tekrar auth/me çağrıldığında
    // eski (geçersiz) session cookie gönderilmez.
    await _apiClient.clearCookies();
  }
}
