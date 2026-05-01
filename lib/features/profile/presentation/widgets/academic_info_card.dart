import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_colors_ext.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';

class AcademicInfoCard extends StatelessWidget {
  final UserEntity user;

  const AcademicInfoCard({super.key, required this.user});

  bool get _hideDepartment => ['dean', 'rector'].contains(user.userType);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
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
                  color: context.textHeading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.domain_rounded,
            label: 'Fakülte',
            value: user.facultyDetails?['name'] as String? ?? '-',
          ),
          if (!_hideDepartment) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.school_rounded,
              label: 'Bölüm',
              value: user.departmentDetails?['name'] as String? ?? '-',
            ),
          ],
          const SizedBox(height: 12),
          _buildApprovalStatusRow(context),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.inputBg,
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
                  style: TextStyle(fontSize: 12, color: context.textMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.textHeading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalStatusRow(BuildContext context) {
    final isApproved = user.isApproved;
    final color = isApproved ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.inputBg,
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
                Text(
                  'Hesap Durumu',
                  style: TextStyle(fontSize: 12, color: context.textMuted),
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
