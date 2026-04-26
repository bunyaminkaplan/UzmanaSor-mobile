import 'package:flutter/material.dart';

/// Öğrenci rolleri için dönem dropdown'u + öğrenci numarası TextField'ı.
///
/// Hangi alanların gösterileceği `showTerm` / `showNumber` ile kontrol edilir.
class StudentFieldsForm extends StatelessWidget {
  final bool showTerm;
  final bool showNumber;
  final String? studentTerm;
  final TextEditingController? studentNumberController;
  final ValueChanged<String?>? onTermChanged;

  const StudentFieldsForm({
    super.key,
    required this.showTerm,
    required this.showNumber,
    required this.studentTerm,
    required this.studentNumberController,
    required this.onTermChanged,
  });

  static const _termOptions = ['prep', '1', '2', '3', '4', 'extended'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTerm) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Sınıf/Dönem Seçin',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            initialValue: studentTerm,
            items: _termOptions
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: Text(
                      v.toUpperCase(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                )
                .toList(),
            onChanged: onTermChanged,
          ),
        ],
        if (showNumber) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: studentNumberController,
            decoration: const InputDecoration(
              labelText: 'Öğrenci Numarası',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ],
    );
  }
}
