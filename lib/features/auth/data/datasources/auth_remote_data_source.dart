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

  /// POST auth/register/ — Kayıt + otomatik login + doğrulama kodu gönderimi.
  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String activeDashboard,
    String? phone,
    String? studentNumber,
    String? studentTerm,
    int? facultyId,
    int? departmentId,
  });

  /// POST auth/verify-code/ — E-posta doğrulama kodu gönderir.
  Future<Map<String, dynamic>> verifyCode(String code);

  /// PUT auth/verify-code/ — Kodu yeniden gönderir.
  Future<Map<String, dynamic>> resendCode();

  /// POST auth/logout/ — Session'ı invalidate eder ve cookie'leri temizler.
  Future<void> logoutUser();

  /// POST auth/switch-dashboard/ — Aktif paneli günceller
  Future<UserModel> switchDashboard(String targetRole);
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

  @override
  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String activeDashboard,
    String? phone,
    String? studentNumber,
    String? studentTerm,
    int? facultyId,
    int? departmentId,
  }) async {
    final body = <String, dynamic>{
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'active_dashboard': activeDashboard,
    };
    if (phone != null && phone.isNotEmpty) body['phone'] = phone;
    if (studentNumber != null) body['student_number'] = studentNumber;
    if (studentTerm != null) body['student_term'] = studentTerm;
    if (facultyId != null) body['faculty'] = facultyId;
    if (departmentId != null) body['department'] = departmentId;

    final response = await _apiClient.post(
      ApiEndpoints.authRegister,
      data: body,
    );
    return _parseUserFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> verifyCode(String code) async {
    final response = await _apiClient.post(
      'auth/verify-code/',
      data: {'code': code},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> resendCode() async {
    final response = await _apiClient.put('auth/verify-code/');
    return response.data as Map<String, dynamic>;
  }

  /// Response verisini güvenli şekilde UserModel'e çevirir.
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

  @override
  Future<UserModel> switchDashboard(String targetRole) async {
    final response = await _apiClient.post(
      'auth/switch-dashboard/',
      data: {'target_role': targetRole},
    );
    return _parseUserFromResponse(response.data);
  }
}
