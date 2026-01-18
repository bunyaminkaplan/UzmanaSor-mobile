import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class UzmanAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final VoidCallback? onTap;

  const UzmanAvatar({
    super.key,
    this.imageUrl,
    this.name = '?',
    this.radius = 24.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate initials: "Bunyamin Kaplan" -> "BK"
    String initials = "?";
    if (name.isNotEmpty) {
      final nameParts = name.trim().split(' ');
      if (nameParts.length > 1) {
        initials = "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase();
      } else {
        initials = nameParts[0][0].toUpperCase();
      }
    }

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.cyan.withValues(alpha: 0.1),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              initials,
              style: TextStyle(
                color: AppColors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.8,
              ),
            )
          : null,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: avatar,
      );
    }

    return avatar;
  }
}
