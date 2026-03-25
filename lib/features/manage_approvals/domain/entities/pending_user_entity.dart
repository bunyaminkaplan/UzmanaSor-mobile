/// Onay bekleyen kullanıcı entity'si.
///
/// Backend `GET auth/pending-approvals/` endpoint'inden dönen
/// kullanıcı verisini temsil eder.
class PendingUserEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String userType;
  final String? username;

  const PendingUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userType,
    this.username,
  });

  String get fullName => '$firstName $lastName';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
          .toUpperCase();

  /// Backend'den `user_type` kodu gelir (teacher, student, dean vb.),
  /// bunu UI'da gösterilecek Türkçe etikete çevirir.
  String get userTypeDisplay {
    const labels = {
      'teacher': 'Akademisyen',
      'student': 'Öğrenci',
      'r_student': 'Temsilci Öğrenci',
      'department_head': 'Bölüm Başkanı',
      'dean': 'Dekan',
      'rector': 'Rektör',
      'school_admin': 'Yönetici',
    };
    return labels[userType] ?? userType;
  }

  factory PendingUserEntity.fromJson(Map<String, dynamic> json) {
    return PendingUserEntity(
      id: json['id'] as int,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      userType: json['user_type'] as String? ?? '',
      username: json['username'] as String?,
    );
  }
}
