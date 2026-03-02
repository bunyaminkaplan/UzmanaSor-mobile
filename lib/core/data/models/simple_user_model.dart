import 'package:mobile/core/domain/entities/simple_user_entity.dart';

/// Feature'lar arası paylaşılan basit kullanıcı modeli.
///
/// Backend: `SimpleUserSerializer` → {id, username, first_name, last_name}
class SimpleUserModel {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;

  const SimpleUserModel({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
  });

  factory SimpleUserModel.fromJson(Map<String, dynamic> json) {
    return SimpleUserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  SimpleUserEntity toEntity() => SimpleUserEntity(
    id: id,
    username: username,
    firstName: firstName,
    lastName: lastName,
  );
}
