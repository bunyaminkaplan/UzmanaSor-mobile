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
  userType: json['user_type'] as String,
  isApproved: json['is_approved'] as bool? ?? false,
  isDepartmentHead: json['is_department_head'] as bool? ?? false,
  departmentDetails: json['department_details'] as Map<String, dynamic>?,
  facultyDetails: json['faculty_details'] as Map<String, dynamic>?,
  phone: json['phone'] as String?,
  studentNumber: json['student_number'] as String?,
  studentTerm: json['student_term'] as String?,
  dateJoined: json['date_joined'] == null
      ? null
      : DateTime.parse(json['date_joined'] as String),
  profileImage: json['profile_image'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'user_type': instance.userType,
      'is_approved': instance.isApproved,
      'is_department_head': instance.isDepartmentHead,
      'department_details': instance.departmentDetails,
      'faculty_details': instance.facultyDetails,
      'phone': instance.phone,
      'student_number': instance.studentNumber,
      'student_term': instance.studentTerm,
      'date_joined': instance.dateJoined?.toIso8601String(),
      'profile_image': instance.profileImage,
    };
