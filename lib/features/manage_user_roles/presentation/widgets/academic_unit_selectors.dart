import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../academic_units/presentation/providers/academic_units_provider.dart';

/// Fakülte + (opsiyonel) cascade Bölüm dropdown'u.
///
/// `showDepartment` false ise sadece fakülte alanı render edilir.
class AcademicUnitSelectors extends ConsumerWidget {
  final int? facultyId;
  final int? departmentId;
  final bool showDepartment;
  final ValueChanged<int?> onFacultyChanged;
  final ValueChanged<int?> onDepartmentChanged;

  const AcademicUnitSelectors({
    super.key,
    required this.facultyId,
    required this.departmentId,
    required this.showDepartment,
    required this.onFacultyChanged,
    required this.onDepartmentChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facultiesAsync = ref.watch(facultiesProvider);

    return facultiesAsync.when(
      data: (faculties) {
        final selectedFaculty = faculties
            .where((f) => f.id == facultyId)
            .firstOrNull;
        final departments = selectedFaculty?.departments ?? [];

        return Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Fakülte Seçin',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              initialValue: facultyId,
              items: faculties
                  .map(
                    (f) => DropdownMenuItem(
                      value: f.id,
                      child: Text(f.name, style: const TextStyle(fontSize: 12)),
                    ),
                  )
                  .toList(),
              onChanged: onFacultyChanged,
            ),
            if (showDepartment) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Bölüm Seçin',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                initialValue: departmentId,
                items: departments
                    .map(
                      (d) => DropdownMenuItem(
                        value: d.id,
                        child: Text(
                          d.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: facultyId == null ? null : onDepartmentChanged,
              ),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Fakülteler yüklenemedi: $e'),
    );
  }
}
