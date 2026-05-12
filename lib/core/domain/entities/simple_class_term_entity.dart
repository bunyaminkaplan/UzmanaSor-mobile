class SimpleClassTermEntity {
  final int id;
  final String term;
  final String termDisplay;

  const SimpleClassTermEntity({
    required this.id,
    required this.term,
    required this.termDisplay,
  });

  factory SimpleClassTermEntity.fromJson(Map<String, dynamic> json) {
    return SimpleClassTermEntity(
      id: json['id'] as int,
      term: json['term'] as String,
      termDisplay: json['term_display'] as String,
    );
  }
}
