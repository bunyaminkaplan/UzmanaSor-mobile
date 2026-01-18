// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  // Config: fieldRename maps JSON snake_case to Dart camelCase automatically
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserModel({
    required int id,
    required String username,
    String? email,
    String? firstName,
    String? lastName,

    // User Type: 'student', 'r_student', 'teacher', 'dean', 'rector', 'admin'
    // We use String here to match flexibility of backend response
    @JsonKey(name: 'user_type') required String userType,

    // Approval & Hierarchy
    @Default(false) bool isApproved,
    @Default(false) bool isDepartmentHead,

    // Details (Backend sends simplified ID/Name maps occasionally)
    Map<String, dynamic>? departmentDetails,
    Map<String, dynamic>? facultyDetails,

    // Profile
    String? profileImage,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
