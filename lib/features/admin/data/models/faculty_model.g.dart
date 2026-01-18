// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faculty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FacultyModel _$FacultyModelFromJson(Map<String, dynamic> json) =>
    _FacultyModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      departments:
          (json['departments'] as List<dynamic>?)
              ?.map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FacultyModelToJson(_FacultyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'departments': instance.departments,
    };
