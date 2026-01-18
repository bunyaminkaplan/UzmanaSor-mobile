import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/features/admin/data/models/department_model.dart';

part 'faculty_model.freezed.dart';
part 'faculty_model.g.dart';

@freezed
abstract class FacultyModel with _$FacultyModel {
  const factory FacultyModel({
    required int id,
    required String name,
    @Default([]) List<DepartmentModel> departments,
  }) = _FacultyModel;

  factory FacultyModel.fromJson(Map<String, dynamic> json) =>
      _$FacultyModelFromJson(json);
}
