/// Rol string'lerini TR etiketlerine çeviren ortak yardımcı.
String mapRoleToTR(String role) {
  switch (role) {
    case 'student':
      return 'Öğrenci';
    case 'teacher':
      return 'Öğretmen';
    case 'department_head':
      return 'Bölüm Başkanı';
    case 'dean':
      return 'Dekan';
    case 'rector':
      return 'Rektör';
    case 'school_admin':
      return 'Sistem Yöneticisi';
    case 'student_rep':
      return 'Temsilci';
    default:
      return role;
  }
}

/// Tüm atanabilir roller (selector chip sırası).
const kAllAssignableRoles = [
  'student',
  'student_rep',
  'teacher',
  'department_head',
  'dean',
  'school_admin',
  'rector',
];

/// Rol başına zorunlu form bağımlılıkları (form sihirbazında açılan alanlar).
const kRoleDependencies = <String, List<String>>{
  'student': ['faculty', 'department', 'student_number', 'student_term'],
  'student_rep': ['faculty', 'department', 'student_number', 'student_term'],
  'teacher': ['faculty', 'department'],
  'department_head': ['faculty', 'department'],
  'dean': ['faculty'],
  'school_admin': [],
  'rector': [],
};
