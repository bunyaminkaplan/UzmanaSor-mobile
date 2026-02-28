# 📱 Login Mimarisi: Tam Rehber
**Yolda Okumak İçin Hazırlandı**

---

# BÖLÜM 1: Katmanlar Nedir?

## Restoran Analojisi ile Anla

### 🎨 Presentation (Garson)
Müşteriyle konuşur. Yemeğin nasıl piştiğini BİLMEZ.
- Widget'lar, Provider'lar burada.
- Login örneği: "Kullanıcı Adı" ve "Şifre" alır.

### 🧠 Domain (Müdür)
Kuralları koyar. Tedarikçiden bağımsızdır.
- Entity'ler, UseCase'ler burada.
- Login örneği: "Şifre 6 haneden kısa olamaz" kuralı.

### 📦 Data (Mutfak)
Pis işleri yapar. API, JSON, veritabanı burada.
- Model'ler, Repository Impl, DataSource burada.
- Login örneği: Django'ya istek atar, JSON'ı parse eder.

---

# BÖLÜM 2: Mevcut Akış (Pragmatik)

```
👤 KULLANICI
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 login_page.dart                     │
│ ⚙️ _onLogin()                          │
│                                        │
│ 📥 GİREN: "ahmet", "123456" (String)   │
│ 🧠 Form validasyonu, Provider tetikle  │
│ 📤 ÇIKAN: String'ler Provider'a        │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_provider.dart                  │
│ ⚙️ login()                             │
│                                        │
│ 📥 GİREN: "ahmet", "123456"            │
│ 🧠 Loading state set et, Repo çağır    │
│ 📤 ÇIKAN: Parametreler Repository'ye   │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_repository_impl.dart           │
│ ⚙️ login()                             │
│                                        │
│ 📥 GİREN: "ahmet", "123456"            │
│ 🧠 Map yap, Dio çağır, JSON parse et   │
│ 📤 ÇIKAN: Map (Dio'ya)                 │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 dio_client.dart                     │
│ ⚙️ CsrfInterceptor.onRequest()         │
│                                        │
│ 📥 GİREN: Request (URL, Method, Data)  │
│ 🧠 Cookie'den CSRF Token'ı bul, ekle   │
│ 📤 ÇIKAN: Header'a X-CSRFToken eklendi │
└────────────────────────────────────────┘
     │
     ▼ ☁️ İNTERNET
     │
┌────────────────────────────────────────┐
│ ☁️ Django Backend                      │
│                                        │
│ 📥 GİREN: JSON credentials             │
│ 🧠 DB'de ara, şifre kontrol           │
│ 📤 ÇIKAN: JSON user bilgisi            │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_repository_impl.dart (devam)   │
│ ⚙️ UserModel.fromJson()                │
│                                        │
│ 📥 GİREN: Map (JSON)                   │
│ 🧠 JSON'ı Dart objesine çevir          │
│ 📤 ÇIKAN: Right(UserModel)             │
│ ⚠️ PROBLEM: UserModel yukarı sızıyor!  │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_provider.dart (devam)          │
│ ⚙️ result.fold()                       │
│                                        │
│ 📥 GİREN: Right(UserModel)             │
│ 🧠 State güncelle                      │
│ 📤 ÇIKAN: AsyncValue.data(UserModel)   │
│ ⚠️ UI artık Data objesini tutuyor!     │
└────────────────────────────────────────┘
     │
     ▼
✅ SnackBar: "Giriş Başarılı"
```

---

# BÖLÜM 3: Problem Ne?

## UserModel Sızıntısı

```
Domain Layer (auth_repository.dart):
import 'package:mobile/.../user_model.dart';  ❌ YANLIŞ!

Future<Either<Failure, UserModel>> login();   ❌ YANLIŞ!
```

**Sonuç:** API formatı değişirse:
- UserModel değişir
- Repository değişir
- Provider değişir
- UI patlar

---

# BÖLÜM 4: İdeal Akış (Clean)

Yeni katmanlar 🆕 ile işaretli.

```
👤 KULLANICI
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 login_page.dart                     │
│ (Aynı)                                 │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_provider.dart                  │
│ ⚙️ login()                             │
│                                        │
│ ⚠️ DEĞİŞİKLİK: UseCase'i çağırır!      │
│ 📤 ÇIKAN: _loginUseCase.execute(...)   │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 🆕 📄 login_usecase.dart               │
│ ⚙️ execute()                           │
│                                        │
│ 📥 GİREN: username, password           │
│ 🧠 İş kuralları (validasyon, logging)  │
│ 📤 ÇIKAN: Repository'yi çağır          │
│ Dönüş: Either<Failure, User> (Entity!) │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_repository.dart (Interface)    │
│ SADECE KONTRAT!                        │
│                                        │
│ Dönüş tipi: Future<Either<Failure,     │
│             User>>  ✅ ENTITY!          │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_repository_impl.dart           │
│ ⚙️ login()                             │
│                                        │
│ 🧠 DataSource'u çağır, Mapping yap     │
│ 📤 ÇIKAN: DataSource'a delege          │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 🆕 📄 auth_remote_data_source.dart     │
│ ⚙️ login()                             │
│                                        │
│ 🧠 SADECE network işi, Dio çağır       │
│ 📤 ÇIKAN: UserModel (burada kalır!)    │
└────────────────────────────────────────┘
     │
     ▼ ☁️ İNTERNET (Django)
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_remote_data_source.dart        │
│ ⚙️ UserModel.fromJson()                │
│                                        │
│ 📤 ÇIKAN: UserModel → Repository'ye    │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_repository_impl.dart           │
│ 🆕 ⚙️ Mapper (DÖNÜŞÜM)                 │
│                                        │
│ 📥 GİREN: UserModel (Data objesi)      │
│ 🧠 KRİTİK: userModel.toEntity()        │
│ 📤 ÇIKAN: User (Domain Entity - SAF!)  │
│                                        │
│ ⚠️ UserModel BURADA ÖLÜR!              │
│ ⚠️ Yukarıya User (Entity) çıkar!       │
└────────────────────────────────────────┘
     │
     ▼
┌────────────────────────────────────────┐
│ 📄 auth_provider.dart                  │
│                                        │
│ 📥 GİREN: Right(User) - ENTITY!        │
│ 🧠 state = AsyncValue.data(User)       │
│                                        │
│ ✅ UI artık SAF Entity tutuyor!        │
└────────────────────────────────────────┘
     │
     ▼
✅ BİTİŞ
```

---

# BÖLÜM 5: Fark Tablosu

| Katman | Mevcut | İdeal |
|--------|--------|-------|
| Provider State | `AsyncValue<UserModel?>` | `AsyncValue<User?>` |
| UseCase | YOK | `LoginUseCase` |
| Repository Dönüşü | `Either<Failure, UserModel>` | `Either<Failure, User>` |
| DataSource | Repo içinde gömülü | Ayrı sınıf |
| Mapper | YOK | `toEntity()` |

---

# BÖLÜM 6: Kod Detayları

## _onLogin (login_page.dart)
```dart
void _onLogin() {
  if (_formKey.currentState?.validate() ?? false) {
    ref.read(authProvider.notifier)
       .login(_usernameController.text.trim(), 
              _passwordController.text);
  }
}
```
- `ref.read`: Aksiyon için kullan (tek seferlik).
- `ref.watch`: Dinlemek için kullan (sürekli).
- `.notifier`: State değil, yönetici sınıfa eriş.

## login (auth_provider.dart)
```dart
Future<void> login(String username, String password) async {
  state = const AsyncValue.loading();
  
  final result = await _repository.login(...);
  
  state = result.fold(
    (failure) => AsyncValue.error(failure, StackTrace.current),
    (user) => AsyncValue.data(user),
  );
}
```
- `state = loading`: UI'a spinner göster.
- `await`: Kod burada durur, yanıt bekler.
- `fold`: Either kutusunu aç (Sol=Hata, Sağ=Başarı).

## CsrfInterceptor (dio_client.dart)
```dart
void onRequest(RequestOptions options, ...) async {
  List<Cookie> cookies = await cookieJar.loadForRequest(uri);
  final csrfCookie = cookies.firstWhere((c) => c.name == 'csrftoken');
  options.headers['X-CSRFToken'] = csrfCookie.value;
}
```
- Django POST için CSRF Token şart koşar.
- Interceptor: Her istek öncesi araya girer.
- Cookie'den token alır, Header'a koyar.

---

# BÖLÜM 7: Generated Code (.g.dart, .freezed.dart)

## Ne yapar?
- `copyWith`: Immutable obje kopyalama.
- `fromJson/toJson`: JSON ↔ Dart dönüşümü.
- `==` operatörü: Obje karşılaştırma.

## Neden kullanıyoruz?
Elle yazsak:
- 50+ satır boilerplate kod.
- Hata riski yüksek.
- Bir alan unutulur.

Generated ile:
- Derleme zamanı güvenliği.
- Otomatik güncelleme.
- Sıfır hata.

---

**İyi yolculuklar! 🚀**
