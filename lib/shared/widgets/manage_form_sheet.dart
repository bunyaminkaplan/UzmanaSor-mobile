import 'package:flutter/material.dart';

/// CRUD form'ları için standart BottomSheet sarmalayıcı.
///
/// Sabit başlık + kapatma ikonu, scrollable form body ve alt kısımda
/// sabit Kaydet/İptal butonları içerir. Keyboard-aware padding sağlar.
///
/// Kullanım:
/// ```dart
/// ManageFormSheet.show(
///   context: context,
///   title: 'Yeni Dönem Ekle',
///   onSubmit: () async { await repo.create(...); },
///   child: Column(children: [ TextField(...), ... ]),
/// );
/// ```
class ManageFormSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onSubmit;
  final String submitLabel;
  final String cancelLabel;
  final bool isLoading;

  const ManageFormSheet({
    super.key,
    required this.title,
    required this.child,
    this.onSubmit,
    this.submitLabel = 'Kaydet',
    this.cancelLabel = 'İptal',
    this.isLoading = false,
  });

  /// BottomSheet'i gösterir.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    VoidCallback? onSubmit,
    String submitLabel = 'Kaydet',
    bool isLoading = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ManageFormSheet(
        title: title,
        onSubmit: onSubmit,
        submitLabel: submitLabel,
        isLoading: isLoading,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Drag Handle ---
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // --- Başlık ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(),

          // --- Form Body (scrollable) ---
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: child,
            ),
          ),

          // --- Alt Butonlar ---
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(cancelLabel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading ? null : onSubmit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(submitLabel),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
