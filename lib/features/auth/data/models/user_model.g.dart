// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  role: $enumDecodeNullable(
    _$UserRoleEnumMap,
    json['user_type'],
    unknownValue: UserRole.unknown,
  ),
  profileImage: json['profileImage'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'user_type': _$UserRoleEnumMap[instance.role],
      'profileImage': instance.profileImage,
    };

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.teacher: 'teacher',
  UserRole.admin: 'admin',
  UserRole.rector: 'rector',
  UserRole.dean: 'dean',
  UserRole.departmentHead: 'department_head',
  UserRole.unknown: 'unknown',
};
