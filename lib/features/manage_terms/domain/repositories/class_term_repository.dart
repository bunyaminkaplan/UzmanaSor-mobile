import 'package:mobile/features/manage_terms/domain/entities/class_term_entity.dart';

/// ClassTerm yönetimi repository kontratı.
abstract class ClassTermRepository {
  /// Tüm dönemleri getirir.
  Future<List<ClassTermEntity>> getAll();

  /// Yeni dönem oluşturur.
  Future<ClassTermEntity> create({
    required int departmentId,
    required int term,
    int? advisorId,
  });

  /// Mevcut dönemi günceller.
  Future<ClassTermEntity> update({
    required int id,
    required int departmentId,
    required int term,
    int? advisorId,
  });

  /// Dönemi siler.
  Future<void> delete(int id);
}
