import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mobile/core/constants/api_endpoints.dart';

// ---------------------------------------------------------------------------
// ApiClient — Uygulamanın tüm HTTP trafiğini yöneten tek merkezi sınıf.
//
// Sorumlulukları:
//   1. Dio instance oluşturma ve konfigürasyon (timeout, baseUrl, header)
//   2. PersistCookieJar ile session çerezlerini diske yazma / okuma
//   3. CsrfInterceptor ile güvenli olmayan HTTP metodlarına CSRF token ekleme
//
// Neden static factory?
//   PersistCookieJar oluşturmak için path_provider'dan async dizin bilgisi
//   gerekiyor. Dart constructor'ları async olamaz; bu yüzden
//   `ApiClient.create()` factory method'u kullanılıyor.
// ---------------------------------------------------------------------------
class ApiClient {
  final Dio dio;
  final PersistCookieJar cookieJar;

  ApiClient._(this.dio, this.cookieJar);

  /// Asenkron factory — uygulama başlatılırken (main.dart) bir kez çağrılır.
  static Future<ApiClient> create() async {
    // 1. Cookie deposunu hazırla
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(
      storage: FileStorage('${appDocDir.path}/.cookies/'),
    );

    // 2. Dio konfigürasyonu
    //    Timeout 10 saniye: Fiziksel cihazda sunucuya ulaşılamazsa
    //    30 saniye beklemek yerine 10 saniyede hata döner → Loading kilitlenemez.
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 3. Interceptor zinciri (sıra önemli)
    //    CookieManager önce: gelen Set-Cookie'leri yakalar, giden Cookie'leri ekler
    //    CsrfInterceptor sonra: CookieJar'dan okunan csrftoken'ı header'a yazar
    //    LogInterceptor en son: debug modda tüm trafiği konsola yazar
    dio.interceptors.addAll([
      CookieManager(cookieJar),
      _CsrfInterceptor(cookieJar),
      if (kDebugMode)
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
    ]);

    return ApiClient._(dio, cookieJar);
  }

  // --------------- Convenience HTTP Metotları ---------------
  // Repository katmanı bu metotları çağırır.
  // Ham Response döner; Failure dönüşümü Repository'nin sorumluluğudur.

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.patch(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.delete(path, data: data, queryParameters: queryParameters);
  }

  // --------------- Cookie Yönetimi ---------------

  /// Tüm çerezleri temizler (logout sonrası çağrılır).
  Future<void> clearCookies() async {
    await cookieJar.deleteAll();
  }
}

// ---------------------------------------------------------------------------
// _CsrfInterceptor — Django Session Auth güvenliği için kritik.
//
// Mantık:
//   1. Sadece güvenli olmayan metodlar için (POST, PUT, DELETE, PATCH)
//   2. CookieJar'dan `csrftoken` isimli cookie okunur
//   3. Request header'ına `X-CSRFToken` olarak eklenir
//
// Neden private?
//   Bu interceptor sadece ApiClient tarafından kullanılır.
//   Dışarıya sızdırmanın anlamı yoktur (Information Hiding).
// ---------------------------------------------------------------------------
class _CsrfInterceptor extends Interceptor {
  final CookieJar _cookieJar;

  _CsrfInterceptor(this._cookieJar);

  static const _safeMethods = {'GET', 'HEAD', 'OPTIONS'};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Güvenli metotlar için CSRF token gerekmez.
    if (_safeMethods.contains(options.method)) {
      return handler.next(options);
    }

    try {
      final uri = options.uri;
      final cookies = await _cookieJar.loadForRequest(uri);

      final csrfCookie = cookies.cast<Cookie?>().firstWhere(
        (c) => c?.name == 'csrftoken',
        orElse: () => null,
      );

      if (csrfCookie != null && csrfCookie.value.isNotEmpty) {
        options.headers['X-CSRFToken'] = csrfCookie.value;
      }
    } catch (_) {
      // CSRF token enjeksiyonu başarısız olsa bile isteği engellemiyoruz.
      // Server tarafı CSRF zorunluluğu varsa 403 dönecektir;
      // bu durumu Repository katmanında ele alıyoruz.
    }

    return handler.next(options);
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

/// Uygulama genelinde kullanılan tekil ApiClient instance'ı.
///
/// `main.dart` içinde `container.read(apiClientProvider)` ile
/// uygulama başlatılmadan önce override edilir.
final apiClientProvider = Provider<ApiClient>((ref) {
  throw UnimplementedError(
    'apiClientProvider main.dart içinde override edilmedi',
  );
});
