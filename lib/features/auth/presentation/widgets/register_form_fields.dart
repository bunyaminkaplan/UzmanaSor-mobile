import 'package:flutter/material.dart';

import 'package:mobile/core/theme/app_colors.dart';

/// Rol seçimi, öğrenci alanları ve fakülte/bölüm girişi widget'ları.
/// RegisterPage'den çıkarılmıştır (SRP — form section'ları ayrı widget).

// ---------------------------------------------------------------------------
// Rol Seçimi
// ---------------------------------------------------------------------------

/// Rol bazlı SegmentedButton widget'ı.
class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  static const _roles = [
    {'value': 'student', 'label': 'Öğrenci'},
    {'value': 'teacher', 'label': 'Akademisyen'},
    {'value': 'dean', 'label': 'Dekan'},
    {'value': 'rector', 'label': 'Rektör'},
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

/// Öğrenci numarası ve dönem/sınıf seçimi.
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
// Fakülte/Bölüm Alanları (Geçici — Faz 2'de dropdown olacak)
// ---------------------------------------------------------------------------

/// Fakülte ve bölüm ID girişi.
/// TODO: Faz 2'de AcademicUnits feature'ından dinamik dropdown'a dönüşecek.
class AcademicFieldsTemp extends StatelessWidget {
  final bool showFaculty;
  final bool showDepartment;
  final ValueChanged<int?> onFacultyChanged;
  final ValueChanged<int?> onDepartmentChanged;

  const AcademicFieldsTemp({
    super.key,
    required this.showFaculty,
    required this.showDepartment,
    required this.onFacultyChanged,
    required this.onDepartmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showFaculty) ...[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Fakülte ID (opsiyonel)',
              prefixIcon: Icon(Icons.school_outlined),
              helperText: 'Faz 2\'de zorunlu dropdown olacak',
              helperStyle: TextStyle(color: AppColors.textLight),
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => onFacultyChanged(int.tryParse(v)),
          ),
          const SizedBox(height: 16),
        ],
        if (showDepartment) ...[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Bölüm ID (opsiyonel)',
              prefixIcon: Icon(Icons.business_outlined),
              helperText: 'Faz 2\'de zorunlu dropdown olacak',
              helperStyle: TextStyle(color: AppColors.textLight),
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => onDepartmentChanged(int.tryParse(v)),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
