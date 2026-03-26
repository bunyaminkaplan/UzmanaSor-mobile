import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';

class PersonalInfoCard extends StatelessWidget {
  final UserEntity user;

  const PersonalInfoCard({super.key, required this.user});

  bool get _isStudent =>
      user.userType == 'student' || user.userType == 'r_student';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBgDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge_rounded, color: AppColors.accentCyan),
              const SizedBox(width: 8),
              Text(
                'Kişisel Bilgiler',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeadingDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.email_rounded,
            label: 'E-posta',
            value: (user.email?.isNotEmpty ?? false) ? user.email! : '-',
          ),
          if (user.phone?.isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.phone_rounded,
              label: 'Telefon',
              value: user.phone!,
            ),
          ],
          if (_isStudent) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.numbers_rounded,
              label: 'Öğrenci Numarası',
              value: user.studentNumber ?? '-',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBgDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentOrange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMutedDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHeadingDark,
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
