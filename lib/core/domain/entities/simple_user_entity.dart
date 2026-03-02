/// Feature'lar arası paylaşılan basit kullanıcı entity'si.
///
/// Backend: `SimpleUserSerializer` → {id, username, first_name, last_name}
///
/// Kullanım alanları:
///   - Courses: ders hocaları
///   - Questions: soru yazarı, handler, intended_teacher
///   - Answers: cevap yazarı
///   - Transitions: from_user, to_user, performed_by
class SimpleUserEntity {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;

  const SimpleUserEntity({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
  });

  String get fullName {
    final parts = [firstName, lastName].where((s) => s != null && s.isNotEmpty);
    return parts.isNotEmpty ? parts.join(' ') : username;
  }
}
