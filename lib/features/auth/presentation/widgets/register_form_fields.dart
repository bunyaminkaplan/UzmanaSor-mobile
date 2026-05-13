import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/user_roles.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/academic_units/presentation/providers/academic_units_provider.dart';

/// Rol seçimi, öğrenci alanları ve fakülte/bölüm dropdown widget'ları.

// ---------------------------------------------------------------------------
// Rol Seçimi
// ---------------------------------------------------------------------------

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  static const _roles = [
    {'value': UserRoles.student, 'label': 'Öğrenci'},
    {'value': UserRoles.teacher, 'label': 'Akademisyen'},
    {'value': UserRoles.dean, 'label': 'Dekan'},
    {'value': UserRoles.rector, 'label': 'Rektör'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hesap Türü', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: _roles.map((r) {
            return ButtonSegment(
              value: r['value']!,
              label: Text(r['label']!, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          selected: {selectedRole},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Öğrenci Alanları
// ---------------------------------------------------------------------------

class StudentFields extends StatelessWidget {
  final TextEditingController studentNumberCtrl;
  final String? selectedTerm;
  final ValueChanged<String?> onTermChanged;

  const StudentFields({
    super.key,
    required this.studentNumberCtrl,
    required this.selectedTerm,
    required this.onTermChanged,
  });

  static const _terms = [
    {'value': '1', 'label': '1. Sınıf'},
    {'value': '2', 'label': '2. Sınıf'},
    {'value': '3', 'label': '3. Sınıf'},
    {'value': '4', 'label': '4. Sınıf'},
    {'value': '5', 'label': '5. Sınıf'},
    {'value': '6', 'label': '6. Sınıf'},
    {'value': 'yuksek_lisans', 'label': 'Yüksek Lisans'},
    {'value': 'doktora', 'label': 'Doktora'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: studentNumberCtrl,
          decoration: const InputDecoration(
            labelText: 'Öğrenci Numarası',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Öğrenci numarası zorunlu'
              : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Dönem/Sınıf',
            prefixIcon: Icon(Icons.calendar_today_outlined),
          ),
          initialValue: selectedTerm,
          items: _terms.map((t) {
            return DropdownMenuItem(
              value: t['value'],
              child: Text(t['label']!),
            );
          }).toList(),
          onChanged: onTermChanged,
          validator: (v) => v == null ? 'Dönem seçimi zorunlu' : null,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Fakülte & Bölüm Dropdown'ları (Backend'den dinamik)
// ---------------------------------------------------------------------------

/// Fakülte ve bölüm seçim dropdown'ları.
///
/// Backend'den `GET core/academic-units/` ile fakülte listesini çeker.
/// Fakülte seçilince bölüm dropdown'ı o fakültenin bölümlerini gösterir.
class AcademicFields extends ConsumerWidget {
  final bool showFaculty;
  final bool showDepartment;
  final int? selectedFacultyId;
  final int? selectedDepartmentId;
  final ValueChanged<int?> onFacultyChanged;
  final ValueChanged<int?> onDepartmentChanged;

  const AcademicFields({
    super.key,
    required this.showFaculty,
    required this.showDepartment,
    required this.selectedFacultyId,
    required this.selectedDepartmentId,
    required this.onFacultyChanged,
    required this.onDepartmentChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!showFaculty && !showDepartment) return const SizedBox.shrink();

    final facultiesAsync = ref.watch(facultiesProvider);

    return facultiesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Fakülte listesi yüklenemedi: $error',
          style: const TextStyle(color: AppColors.error, fontSize: 12),
        ),
      ),
      data: (faculties) {
        // Seçili fakültenin bölümlerini bul
        final selectedFaculty = selectedFacultyId != null
            ? faculties.where((f) => f.id == selectedFacultyId).firstOrNull
            : null;

        return Column(
          children: [
            if (showFaculty) ...[
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Fakülte',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                // ignore: deprecated_member_use
                value: selectedFacultyId,
                items: faculties.map((f) {
                  return DropdownMenuItem(value: f.id, child: Text(f.name));
                }).toList(),
                onChanged: (id) {
                  onFacultyChanged(id);
                  // Fakülte değişince bölümü sıfırla
                  onDepartmentChanged(null);
                },
                validator: (v) => v == null ? 'Fakülte seçimi zorunlu' : null,
              ),
              const SizedBox(height: 16),
            ],
            if (showDepartment && selectedFaculty != null) ...[
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Bölüm',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                // ignore: deprecated_member_use
                value: selectedDepartmentId,
                items: selectedFaculty.departments.map((d) {
                  return DropdownMenuItem(value: d.id, child: Text(d.name));
                }).toList(),
                onChanged: onDepartmentChanged,
                validator: (v) => v == null ? 'Bölüm seçimi zorunlu' : null,
              ),
              const SizedBox(height: 16),
            ],
          ],
        );
      },
    );
  }
}
