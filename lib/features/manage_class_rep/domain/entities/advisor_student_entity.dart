/// Danışman hoca tarafından görüntülenen öğrenci varlığı.
///
/// Backend: `UserSerializer` ile dönen veriden parse edilir.
/// API: GET core/advisor/students/
class AdvisorStudentEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String? studentNumber;
  final String? departmentName;

  /// `user_type == 'r_student'` ise mevcut temsilci.
  final bool isRepresentative;

  const AdvisorStudentEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.studentNumber,
    this.departmentName,
    this.isRepresentative = false,
  });

  /// Backend UserSerializer JSON → Entity.
  factory AdvisorStudentEntity.fromJson(Map<String, dynamic> json) {
    // department_details nested: {id, name}
    final deptDetails = json['department_details'] as Map<String, dynamic>?;

    return AdvisorStudentEntity(
      id: json['id'] as int,
      firstName: (json['first_name'] as String?) ?? '',
      lastName: (json['last_name'] as String?) ?? '',
      studentNumber: json['student_number'] as String?,
      departmentName: deptDetails?['name'] as String?,
      isRepresentative: (json['user_type'] as String?) == 'r_student',
    );
  }

  /// Gösterim adı
  String get fullName => '$firstName $lastName'.trim();

  /// İnisyaller (avatar için)
  String get initials {
    final parts = [
      firstName,
      lastName,
    ].where((s) => s.isNotEmpty).take(2).map((s) => s[0].toUpperCase());
    return parts.join();
  }
}
