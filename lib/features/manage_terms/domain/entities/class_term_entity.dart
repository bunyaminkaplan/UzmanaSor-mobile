/// ClassTerm (Sınıf/Dönem) entity'si.
///
/// Backend `GET/POST/PUT/DELETE core/class-terms/` endpoint'inden
/// dönen veriyi temsil eder.
class ClassTermEntity {
  final int id;
  final int departmentId;
  final String departmentName;
  final int term;
  final String termDisplay;
  final int? advisorId;
  final String advisorName;

  const ClassTermEntity({
    required this.id,
    required this.departmentId,
    required this.departmentName,
    required this.term,
    required this.termDisplay,
    this.advisorId,
    this.advisorName = 'Atanmamış',
  });

  bool get hasAdvisor => advisorId != null;

  factory ClassTermEntity.fromJson(Map<String, dynamic> json) {
    return ClassTermEntity(
      id: _parseInt(json['id']) ?? 0,
      departmentId: _parseInt(json['department']) ?? 0,
      departmentName: json['department_name']?.toString() ?? '',
      term: _parseInt(json['term']) ?? 1,
      termDisplay: json['term_display']?.toString() ?? '',
      advisorId: _parseInt(json['advisor']),
      advisorName: json['advisor_name']?.toString() ?? 'Atanmamış',
    );
  }

  /// Güvenli int parse — int, String veya null değerleri handle eder.
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
