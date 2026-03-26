class SimpleUserEntity {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;

  const SimpleUserEntity({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
  });

  factory SimpleUserEntity.fromMap(Map<String, dynamic> map) {
    return SimpleUserEntity(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
    );
  }
}
