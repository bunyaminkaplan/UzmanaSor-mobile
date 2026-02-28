// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:mobile/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// [UserModel] — Django UserSerializer yanıtının 1:1 Dart karşılığı.
///
/// @JsonSerializable(fieldRename: FieldRename.snake) ile tüm camelCase alanlar
/// otomatik olarak snake_case JSON key'lerine eşlenir.
/// ANCAK bileşik edge-case'lerde (örn: user_type vs userType) açık @JsonKey kullanıyoruz.
///
/// Kurallar:
///   - Backend'de null gelebilecek HER alan nullable (?) olmalıdır.
///   - Backend'de her zaman gelen alanlar dahi nullable yapılmıştır (defensive).
///     Çünkü tek bir beklenmeyen null, tüm deserialization'ı çökertir.
@freezed
abstract class UserModel with _$UserModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserModel({
    required int id,
    required String username,
    String? email,
    String? firstName,
    String? lastName,

    // Django: "primary_role" alanı (student, teacher, dean, rector, guest)
    String? primaryRole,

    // Django: SerializerMethodField "user_type" — primary_role'dan türetilir
    @JsonKey(name: 'user_type') String? userType,

    // Django: ManyToManyField "roles" — PrimaryKeyRelatedField ile [6, 3] gibi
    // int dizisi gönderiyor. Nested serializer kullanılırsa [{name: "student"}, ...]
    // gelir. Her iki formata da uyum sağlamak için List<dynamic> kullanıyoruz.
    @JsonKey(defaultValue: []) List<dynamic>? roles,

    // Durum alanları
    @Default(false) bool isApproved,
    @Default(false) bool isActive,
    @Default(false) bool isDepartmentHead,
    @Default(false) bool isAdvisor,

    // Fakülte/Bölüm ID'leri (SerializerMethodField — null gelebilir)
    int? faculty,
    int? department,

    // Detay nesneleri (SerializerMethodField — null gelebilir)
    Map<String, dynamic>? departmentDetails,
    Map<String, dynamic>? facultyDetails,

    // Profil nesneleri (nested serializer — null gelebilir)
    Map<String, dynamic>? studentProfile,
    Map<String, dynamic>? teacherProfile,
    Map<String, dynamic>? deanProfile,
    Map<String, dynamic>? rectorProfile,

    // Danışman bilgisi (SerializerMethodField — null gelebilir)
    Map<String, dynamic>? advisor,

    // Kişisel bilgiler
    String? phone,
    String? studentNumber,
    String? studentTerm,
    DateTime? dateJoined,
    String? profileImage,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// ---------------------------------------------------------------------------
// Mapper: Data → Domain
// ---------------------------------------------------------------------------

/// UserModel'den UserEntity'ye dönüşüm.
///
/// Neden extension?
///   freezed sınıflarına doğrudan method eklenemez (const factory kısıtı).
///   Extension method, Data katmanı sınırında kalmayı garanti eder.
///
/// userType null gelirse primaryRole'dan türetilir (fallback zinciri).
extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      // userType öncelikli, yoksa primaryRole, yoksa 'unknown'
      userType: userType ?? primaryRole ?? 'unknown',
      isApproved: isApproved,
      isDepartmentHead: isDepartmentHead,
      departmentDetails: departmentDetails,
      facultyDetails: facultyDetails,
      phone: phone,
      studentNumber: studentNumber,
      studentTerm: studentTerm,
      dateJoined: dateJoined,
      profileImage: profileImage,
    );
  }
}
