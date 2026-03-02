/// Fakülte domain entity'si.
///
/// Backend: `core.models.Faculty` — `id`, `name`, `departments` (related).
class FacultyEntity {
  final int id;
  final String name;
  final List<DepartmentEntity> departments;

  const FacultyEntity({
    required this.id,
    required this.name,
    this.departments = const [],
  });
}

/// Bölüm domain entity'si.
///
/// Backend: `core.models.Department` — `id`, `name`, `faculty` (FK).
class DepartmentEntity {
  final int id;
  final String name;

  const DepartmentEntity({required this.id, required this.name});
}
