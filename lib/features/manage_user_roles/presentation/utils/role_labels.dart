import 'package:mobile/core/constants/user_roles.dart';

/// Rol string'lerini TR etiketlerine çeviren ortak yardımcı.
String mapRoleToTR(String role) {
  switch (role) {
    case UserRoles.student:
      return 'Öğrenci';
    case UserRoles.teacher:
      return 'Öğretmen';
    case UserRoles.dean:
      return 'Dekan';
    case UserRoles.rector:
      return 'Rektör';
    case UserRoles.schoolAdmin:
      return 'Sistem Yöneticisi';
    case UserRoles.studentRep:
      return 'Temsilci';
    default:
      return role;
  }
}

/// Tüm atanabilir roller (selector chip sırası).
const kAllAssignableRoles = [
  UserRoles.student,
  UserRoles.studentRep,
  UserRoles.teacher,
  UserRoles.dean,
  UserRoles.schoolAdmin,
  UserRoles.rector,
];

/// Rol başına zorunlu form bağımlılıkları (form sihirbazında açılan alanlar).
const kRoleDependencies = <String, List<String>>{
  UserRoles.student: ['faculty', 'department', 'student_number', 'student_term'],
  UserRoles.studentRep: [
    'faculty',
    'department',
    'student_number',
    'student_term',
  ],
  UserRoles.teacher: ['faculty', 'department'],
  UserRoles.dean: ['faculty'],
  UserRoles.schoolAdmin: [],
  UserRoles.rector: [],
};
