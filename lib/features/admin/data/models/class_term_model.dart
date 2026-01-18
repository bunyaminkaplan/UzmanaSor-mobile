class ClassTermModel {
  final int id;
  final String name;
  final int? advisorId; // ID of the teacher assigned as advisor

  ClassTermModel({required this.id, required this.name, this.advisorId});

  factory ClassTermModel.fromJson(Map<String, dynamic> json) {
    return ClassTermModel(
      id: json['id'] as int,
      name: json['name'] as String,
      advisorId:
          json['advisor'] as int?, // Assuming backend returns just ID or object
    );
  }
}
