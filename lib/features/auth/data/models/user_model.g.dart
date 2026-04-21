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
  activeDashboard: json['active_dashboard'] as String?,
  userType: json['user_type'] as String?,
  roles: json['roles'] as List<dynamic>? ?? [],
  isApproved: json['is_approved'] as bool? ?? false,
  isActive: json['is_active'] as bool? ?? false,
  isDepartmentHead: json['is_department_head'] as bool? ?? false,
  isAdvisor: json['is_advisor'] as bool? ?? false,
  faculty: (json['faculty'] as num?)?.toInt(),
  department: (json['department'] as num?)?.toInt(),
  departmentDetails: json['department_details'] as Map<String, dynamic>?,
  facultyDetails: json['faculty_details'] as Map<String, dynamic>?,
  studentProfile: json['student_profile'] as Map<String, dynamic>?,
  teacherProfile: json['teacher_profile'] as Map<String, dynamic>?,
  deanProfile: json['dean_profile'] as Map<String, dynamic>?,
  rectorProfile: json['rector_profile'] as Map<String, dynamic>?,
  advisor: json['advisor'] as Map<String, dynamic>?,
  phone: json['phone'] as String?,
  studentNumber: json['student_number'] as String?,
  studentTerm: json['student_term'] as String?,
  dateJoined: json['date_joined'] == null
      ? null
      : DateTime.parse(json['date_joined'] as String),
  profileImage: json['profile_image'] as String?,
  isEmailVerified: json['is_email_verified'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'active_dashboard': instance.activeDashboard,
      'user_type': instance.userType,
      'roles': instance.roles,
      'is_approved': instance.isApproved,
      'is_active': instance.isActive,
      'is_department_head': instance.isDepartmentHead,
      'is_advisor': instance.isAdvisor,
      'faculty': instance.faculty,
      'department': instance.department,
      'department_details': instance.departmentDetails,
      'faculty_details': instance.facultyDetails,
      'student_profile': instance.studentProfile,
      'teacher_profile': instance.teacherProfile,
      'dean_profile': instance.deanProfile,
      'rector_profile': instance.rectorProfile,
      'advisor': instance.advisor,
      'phone': instance.phone,
      'student_number': instance.studentNumber,
      'student_term': instance.studentTerm,
      'date_joined': instance.dateJoined?.toIso8601String(),
      'profile_image': instance.profileImage,
      'is_email_verified': instance.isEmailVerified,
    };
