import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class UzmanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onProfileTap;

  const UzmanAppBar({super.key, required this.title, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surfaceLight,
      elevation: 1,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            "MALATYA TURGUT ÖZAL ÜNİVERSİTESİ",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            "DİNAMİK SORU PLATFORMU",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.orange,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 10,
            ),
          ),
        ],
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      actions: [
        if (onProfileTap != null)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(20),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.navy,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
