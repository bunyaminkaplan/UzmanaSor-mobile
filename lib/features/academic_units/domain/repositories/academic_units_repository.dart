import 'package:fpdart/fpdart.dart';

import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/academic_units/domain/entities/academic_unit_entities.dart';

/// Academic Units repository kontratı (Domain katmanı).
///
/// Tek metod: fakülte listesini getirir (her fakülte kendi bölümlerini içerir).
abstract class AcademicUnitsRepository {
  /// Backend: GET core/academic-units/
  /// Fakülte listesini getirir, her fakülte nested departments içerir.
  Future<Either<Failure, List<FacultyEntity>>> getFaculties();
}
