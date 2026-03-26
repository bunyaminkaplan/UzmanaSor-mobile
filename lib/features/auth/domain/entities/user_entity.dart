import 'package:mobile/features/auth/domain/entities/simple_user_entity.dart';

/// [UserEntity] — Domain katmanının kullanıcı temsili.
///
/// Bu sınıf %100 saf Dart'tır. Hiçbir framework (Flutter, freezed,
/// json_annotation) bağımlılığı taşımaz. İş mantığı kuralları
/// bu entity üzerinden uygulanır.
///
/// Neden ayrı bir Entity?
///   Data katmanındaki UserModel, JSON serileştirme ve 3rd party
///   annotation'lara bağımlıdır. Domain katmanının bu detaylardan
///   habersiz olması gerekir (Dependency Inversion Principle).
class UserEntity {
  final int id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String userType;
  final bool isApproved;
  final bool isDepartmentHead;
  final Map<String, dynamic>? departmentDetails;
  final Map<String, dynamic>? facultyDetails;
  final String? phone;
  final String? studentNumber;
  final String? studentTerm;
  final DateTime? dateJoined;
  final String? profileImage;
  final bool isEmailVerified;
  final SimpleUserEntity? advisor;

  const UserEntity({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    required this.userType,
    this.isApproved = false,
    this.isDepartmentHead = false,
    this.departmentDetails,
    this.facultyDetails,
    this.phone,
    this.studentNumber,
    this.studentTerm,
    this.dateJoined,
    this.profileImage,
    this.isEmailVerified = false,
    this.advisor,
  });

  // --------------- Derived Getters (İş Mantığı) ---------------

  /// Kullanıcının tam adını döner. Ad veya soyad yoksa username kullanılır.
  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final combined = '$first $last'.trim();
    return combined.isNotEmpty ? combined : username;
  }

  /// Kullanıcının yetkili bir rol sahibi olup olmadığını kontrol eder.
  bool get isPrivilegedRole {
    const privileged = {'dean', 'rector', 'school_admin'};
    return privileged.contains(userType);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'UserEntity(id: $id, username: $username, userType: $userType)';
}
