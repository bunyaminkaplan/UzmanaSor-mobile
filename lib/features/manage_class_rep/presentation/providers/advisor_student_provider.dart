import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/manage_class_rep/data/datasources/advisor_student_remote_data_source.dart';
import 'package:mobile/features/manage_class_rep/domain/entities/advisor_student_entity.dart';

/// Danışman öğrenci listesi provider'ı.
final advisorStudentsProvider =
    FutureProvider.autoDispose<List<AdvisorStudentEntity>>((ref) async {
      final ds = ref.watch(advisorStudentDataSourceProvider);
      return ds.getStudents();
    });
