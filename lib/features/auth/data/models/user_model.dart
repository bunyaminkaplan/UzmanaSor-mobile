// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  @JsonValue('student')
  student,
  @JsonValue('teacher')
  teacher,
  @JsonValue('admin')
  admin,
  @JsonValue('rector')
  rector,
  @JsonValue('dean')
  dean,
  @JsonValue('department_head')
  departmentHead,
  unknown,
}

@freezed
abstract class UserModel with _$UserModel {
  // fieldRename: FieldRename.snake -> JSON'dan gelen snake_case'i otomatik camelCase'e çevirir.
  const factory UserModel({
    required int id,
    // Since we removed fieldRename: FieldRename.snake, we must be explicit
    required String username,
    String? email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,

    // Role alanı React'te 'user_type' olarak geçiyor (AuthContext.jsx satır 25)
    // Eğer backend'den gelen field ismi 'user_type' ise bunu belirtmeliyiz.
    // Varsayılan olarak snake_case olduğu için 'user_type' -> 'userType' eşleşmesi otomatik olur
    // ama @JsonKey ile force etmek daha güvenlidir.
    @JsonKey(name: 'user_type', unknownEnumValue: UserRole.unknown)
    UserRole? role,

    // Profil resmi vb.
    String? profileImage,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
