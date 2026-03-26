import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';

class AcademicInfoCard extends StatelessWidget {
  final UserEntity user;

  const AcademicInfoCard({super.key, required this.user});

  bool get _hideDepartment => ['dean', 'rector'].contains(user.userType);

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
              const Icon(
                Icons.account_balance_rounded,
                color: AppColors.accentCyan,
              ),
              const SizedBox(width: 8),
              Text(
                'Akademik Bilgiler',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeadingDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.domain_rounded,
            label: 'Fakülte',
            value: user.facultyDetails?['name'] as String? ?? '-',
          ),
          if (!_hideDepartment) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.school_rounded,
              label: 'Bölüm',
              value: user.departmentDetails?['name'] as String? ?? '-',
            ),
          ],
          const SizedBox(height: 12),
          _buildApprovalStatusRow(),
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
          Icon(icon, color: AppColors.accentNavy, size: 20),
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

  Widget _buildApprovalStatusRow() {
    final isApproved = user.isApproved;
    final color = isApproved ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBgDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isApproved
                ? Icons.check_circle_rounded
                : Icons.pending_actions_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hesap Durumu',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMutedDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isApproved ? 'Onaylandı' : 'Onay Bekliyor',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
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
