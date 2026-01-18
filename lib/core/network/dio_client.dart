import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile/core/constants/api_endpoints.dart';

/// [dioProvider] - Uygulama genelinde kullanılan tekil Dio instance'ı.
/// Cookie yönetimi ve CSRF koruması burada konfigüre edilir.
final dioProvider = Provider<Dio>((ref) {
  // 1. Temel Konfigürasyon
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  // 2. Cookie Management (Session Auth için ZORUNLU)
  // PersistedCookieJar: Uygulama kapansa bile session'ı saklar.
  // Bu işlem asenkron olduğu için Provider initialization sırasında
  // cookie jar'ın hazır olmasını beklemek gerekir. Ancak Dio senkron oluşturulur.
  // Bu yüzden CookieJar'ı singleton veya ayrı bir provider olarak yönetmek daha doğrudur.
  // *Geçici Çözüm:* CookiePath'i alıp sync (senkron) başlatılamayacağı için
  // FutureProvider kullanımı önerilir ama burada basitlik adına init
  // işlemini interceptor içinde veya main'de yapmak gerekebilir.
  // Clean Architecture gereği, burada "hazır" bir Dio dönmeliyiz.

  // NOT: CookieJar'ın path'ini almak için platform kanalı gerekir (await).
  // Bu yüzden burada interceptor eklenemez.
  // DOĞRU YÖNTEM: UI katmanında değil, main.dart içinde
  // prepareDio() gibi bir fonksiyonla hazırlanmalı veya
  // Dio'yu FutureProvider ile vermeliyiz.
  // Ancak kullanıcı "dioProvider" istediği için, interceptor'ı sonradan ekleyeceğiz.

  return dio;
});

/// [cookieJarProvider] - Cookie deposuna erişim sağlar.
final cookieJarProvider = FutureProvider<PersistCookieJar>((ref) async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final cj = PersistCookieJar(
    storage: FileStorage("${appDocDir.path}/.cookies/"),
  );
  return cj;
});

/// [setupDio] - Main fonksiyonunda çağrılacak asenkron kurulum yardımcısı.
/// Dio ve CookieJar arasındaki asenkron durumu çözer.
Future<void> setupDio(Dio dio, PersistCookieJar cookieJar) async {
  dio.interceptors.add(CookieManager(cookieJar));
  dio.interceptors.add(CsrfInterceptor(cookieJar));

  // Log Interceptor (Dev Only)
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true, // Crucial for debugging Cookie
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
  );
}

/// [CsrfInterceptor] - Django Session Auth güvenliği için kritik.
///
/// Mantık:
/// 1. İstek (Request) atılmadan önce CookieJar'a bak.
/// 2. `csrftoken` isimli bir cookie varsa değerini al.
/// 3. Request Header'ına `X-CSRFToken` olarak ekle.
class CsrfInterceptor extends Interceptor {
  final CookieJar cookieJar;

  CsrfInterceptor(this.cookieJar);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Sadece güvenli olmayan metodlar (POST, PUT, DELETE, PATCH) için CSRF gerekir.
    // GET, HEAD, OPTIONS güvenlidir.
    if (options.method == 'GET' ||
        options.method == 'HEAD' ||
        options.method == 'OPTIONS') {
      return handler.next(options);
    }

    try {
      final uri = Uri.parse(options.baseUrl); // Veya options.uri
      // CookieJar'dan host'a ait tüm cookieleri çek
      List<Cookie> cookies = await cookieJar.loadForRequest(uri);

      // 'csrftoken' cookie'sini bul
      final csrfCookie = cookies.firstWhere(
        (c) => c.name == 'csrftoken',
        orElse: () => Cookie('csrftoken', ''),
      );

      // Header'a ekle
      if (csrfCookie.value.isNotEmpty) {
        options.headers['X-CSRFToken'] = csrfCookie.value;
      }
    } catch (e) {
      // Hata olsa bile akışı bozma, belki server CSRF istemiyordur (düşük ihtimal)
      print('CSRF Token injection failed: $e');
    }

    return handler.next(options);
  }
}
