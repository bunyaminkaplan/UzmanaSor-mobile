import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';

/// Backend BusyTerm response: {id, teacher, class_term, class_term_display, is_busy}
class BusyTermEntity {
  final int id;
  final int classTermId;
  final String classTermDisplay;
  final bool isBusy;

  const BusyTermEntity({
    required this.id,
    required this.classTermId,
    required this.classTermDisplay,
    required this.isBusy,
  });

  factory BusyTermEntity.fromJson(Map<String, dynamic> json) {
    return BusyTermEntity(
      id: json['id'] as int,
      classTermId: json['class_term'] as int,
      classTermDisplay: (json['class_term_display'] as String?) ?? '',
      isBusy: (json['is_busy'] as bool?) ?? true,
    );
  }
}

/// Backend ClassTerm response: {id, department_name, term, term_display, ...}
class ClassTermSimple {
  final int id;
  final String departmentName;
  final String term;
  final String termDisplay;

  const ClassTermSimple({
    required this.id,
    required this.departmentName,
    required this.term,
    required this.termDisplay,
  });

  factory ClassTermSimple.fromJson(Map<String, dynamic> json) {
    return ClassTermSimple(
      id: json['id'] as int,
      departmentName: (json['department_name'] as String?) ?? '',
      term: (json['term'] as String?) ?? '',
      termDisplay: (json['term_display'] as String?) ?? '',
    );
  }
}

/// Busy term remote data source.
class BusyTermRemoteDataSource {
  final ApiClient _api;

  BusyTermRemoteDataSource(this._api);

  /// Hocaya ait tüm busy kayıtları
  Future<List<BusyTermEntity>> getBusyTerms() async {
    final res = await _api.get(ApiEndpoints.teacherBusyTerms);
    final data = res.data;
    final list = data is List
        ? data
        : (data is Map<String, dynamic> && data['results'] is List)
        ? data['results'] as List
        : [];
    return list
        .map((j) => BusyTermEntity.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Tüm class term'ler (toggle listesi için)
  Future<List<ClassTermSimple>> getClassTerms() async {
    final res = await _api.get(ApiEndpoints.classTerms);
    final data = res.data;
    final list = data is List
        ? data
        : (data is Map<String, dynamic> && data['results'] is List)
        ? data['results'] as List
        : [];
    return list
        .map((j) => ClassTermSimple.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Meşgul modu aç (yeni kayıt oluştur)
  Future<BusyTermEntity> createBusyTerm(int classTermId) async {
    final res = await _api.post(
      ApiEndpoints.teacherBusyTerms,
      data: {'class_term': classTermId, 'is_busy': true},
    );
    return BusyTermEntity.fromJson(res.data as Map<String, dynamic>);
  }

  /// Meşgul modu kapat (kaydı sil)
  Future<void> deleteBusyTerm(int busyTermId) async {
    await _api.delete(ApiEndpoints.teacherBusyTermDetail(busyTermId));
  }
}

/// Providers
final busyTermDataSourceProvider = Provider<BusyTermRemoteDataSource>((ref) {
  return BusyTermRemoteDataSource(ref.watch(apiClientProvider));
});

final busyTermsProvider = FutureProvider.autoDispose<List<BusyTermEntity>>((
  ref,
) async {
  return ref.watch(busyTermDataSourceProvider).getBusyTerms();
});

final classTermsProvider = FutureProvider.autoDispose<List<ClassTermSimple>>((
  ref,
) async {
  return ref.watch(busyTermDataSourceProvider).getClassTerms();
});
