import 'package:flutter/material.dart';

enum UzmanStatusVariant {
  forwarded,
  solved, // CEVAPLANDI
  pending, // İNCELENİYOR (React: reviewing)
}

class UzmanStatusBadge extends StatelessWidget {
  final UzmanStatusVariant variant;
  final String? customLabel; // Optional override

  const UzmanStatusBadge({super.key, required this.variant, this.customLabel});

  @override
  Widget build(BuildContext context) {
    // 1. Determine Style based on Variant (EXACT REACT HEX CODES)
    // Source: web/.../frontend/src/components/QuestionBadge.jsx

    final Color backgroundColor;
    final Color foregroundColor;
    final IconData icon;
    final String label;

    switch (variant) {
      case UzmanStatusVariant.forwarded:
        // React: bg-[#cff4fc] text-[#055160]
        backgroundColor = const Color(0xFFCFF4FC);
        foregroundColor = const Color(0xFF055160);
        icon = Icons.forward; // or Icons.share/reply
        label = "YÖNLENDİRİLDİ";
        break;

      case UzmanStatusVariant.solved:
        // React: bg-[#d1e7dd] text-[#0f5132]
        backgroundColor = const Color(0xFFD1E7DD);
        foregroundColor = const Color(0xFF0F5132);
        icon = Icons.check_circle;
        label = "CEVAPLANDI";
        break;

      case UzmanStatusVariant.pending:
        // React: "reviewing" -> bg-[#fff3cd] text-[#664d03]
        // Note: React uses 'pending' (Gray) for "Beklemede", but 'reviewing' (Yellow) for "İnceleniyor".
        // Our default fallback in app is "İNCELENİYOR", so we use the Yellow/Gold palette.
        backgroundColor = const Color(0xFFFFF3CD);
        foregroundColor = const Color(0xFF664D03);
        icon = Icons.hourglass_empty; // or Icons.remove_red_eye
        label = "İNCELENİYOR";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20), // React uses rounded-[20px]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: foregroundColor,
            size: 14, // React text is 0.75rem (12px), icons slightly bigger
          ),
          const SizedBox(width: 5), // React gap-[5px]
          Text(
            customLabel ?? label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 12, // React 0.75rem ~ 12px
              fontWeight: FontWeight.bold, // React font-bold
              // React uppercase is default
            ),
          ),
        ],
      ),
    );
  }
}
