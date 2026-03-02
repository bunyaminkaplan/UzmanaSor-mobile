import 'package:mobile/features/academic_units/domain/entities/academic_unit_entities.dart';

/// Backend JSON → Domain Entity mapper'ları.
///
/// Freezed kullanmıyoruz çünkü yapı basit ve stabil.
/// Manuel fromJson + toEntity tek dosyada kalıyor.

class DepartmentModel {
  final int id;
  final String name;

  const DepartmentModel({required this.id, required this.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(id: json['id'] as int, name: json['name'] as String);
  }

  DepartmentEntity toEntity() => DepartmentEntity(id: id, name: name);
}

class FacultyModel {
  final int id;
  final String name;
  final List<DepartmentModel> departments;

  const FacultyModel({
    required this.id,
    required this.name,
    this.departments = const [],
  });

  factory FacultyModel.fromJson(Map<String, dynamic> json) {
    return FacultyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      departments:
          (json['departments'] as List<dynamic>?)
              ?.map((d) => DepartmentModel.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  FacultyEntity toEntity() => FacultyEntity(
    id: id,
    name: name,
    departments: departments.map((d) => d.toEntity()).toList(),
  );
}
