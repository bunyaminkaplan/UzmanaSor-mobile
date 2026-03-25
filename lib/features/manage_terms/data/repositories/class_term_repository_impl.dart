import 'package:mobile/features/manage_terms/data/datasources/class_term_remote_data_source.dart';
import 'package:mobile/features/manage_terms/domain/entities/class_term_entity.dart';
import 'package:mobile/features/manage_terms/domain/repositories/class_term_repository.dart';

class ClassTermRepositoryImpl implements ClassTermRepository {
  final ClassTermRemoteDataSource _dataSource;

  ClassTermRepositoryImpl(this._dataSource);

  @override
  Future<List<ClassTermEntity>> getAll() => _dataSource.getAll();

  @override
  Future<ClassTermEntity> create({
    required int departmentId,
    required int term,
    int? advisorId,
  }) {
    final body = <String, dynamic>{'department': departmentId, 'term': term};
    if (advisorId != null) body['advisor'] = advisorId;
    return _dataSource.create(body);
  }

  @override
  Future<ClassTermEntity> update({
    required int id,
    required int departmentId,
    required int term,
    int? advisorId,
  }) {
    final body = <String, dynamic>{
      'department': departmentId,
      'term': term,
      'advisor': advisorId,
    };
    return _dataSource.update(id, body);
  }

  @override
  Future<void> delete(int id) => _dataSource.delete(id);
}
