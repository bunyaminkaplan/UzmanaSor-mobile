import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/academic_units/data/repositories/academic_units_repository_impl.dart';
import 'package:mobile/features/academic_units/domain/entities/academic_unit_entities.dart';

/// Fakülte listesi provider'ı (AutoDispose — ekrandan ayrılınca temizlenir).
///
/// Kullanım:
///   ref.watch(facultiesProvider)
///   Döner: `AsyncValue<List<FacultyEntity>>`
final facultiesProvider = FutureProvider.autoDispose<List<FacultyEntity>>((
  ref,
) async {
  final repository = ref.watch(academicUnitsRepositoryProvider);
  final result = await repository.getFaculties();
  return result.fold((failure) => throw failure, (faculties) => faculties);
});
