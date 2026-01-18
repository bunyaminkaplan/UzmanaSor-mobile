import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/ui_kit/ui_kit.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Kullanıcı bilgisi bulunamadı.")),
      );
    }

    final displayName = "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
    // Use the getInitials logic or just pass displayName to UzmanAvatar which handles it.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.surfaceLight,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: AppColors.bgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  UzmanAvatar(
                    name: displayName.isNotEmpty ? displayName : user.username,
                    imageUrl: user.profileImage,
                    radius: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName.isNotEmpty ? displayName : user.username,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Role Badge
                      _Badge(
                        label: _getUserTypeLabel(user.userType),
                        color: AppColors.cyan,
                      ),
                      // Department Head Badge
                      if (user.isDepartmentHead)
                        const _Badge(
                          label: "Bölüm Başkanı",
                          color: AppColors.orange,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Info Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: user.email ?? "-",
                  ),
                  if (user.phone != null && user.phone!.isNotEmpty) ...[
                    const Divider(height: 24),
                    _InfoTile(
                      icon: Icons.phone_outlined,
                      label: "Telefon",
                      value: user.phone!,
                    ),
                  ],

                  // Role Specific Info
                  ..._buildRoleSpecificInfo(user),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Actions
            UzmanButton(
              label: 'Çıkış Yap',
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
              },
            ),
            const SizedBox(height: 12),
            Text(
              "Versiyon 1.0.0",
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  String _getUserTypeLabel(String type) {
    switch (type) {
      case 'student':
        return 'Öğrenci';
      case 'r_student':
        return 'Öğrenci Temsilcisi';
      case 'teacher':
        return 'Akademisyen';
      case 'dean':
        return 'Dekan';
      case 'rector':
        return 'Rektör';
      default:
        return 'Misafir';
    }
  }

  String _getTermLabel(String term) {
    const map = {
      'prep': 'Hazırlık',
      '1': '1. Sınıf',
      '2': '2. Sınıf',
      '3': '3. Sınıf',
      '4': '4. Sınıf',
      'extended': 'Uzatmalı',
    };
    return map[term] ?? term;
  }

  List<Widget> _buildRoleSpecificInfo(user) {
    final List<Widget> widgets = [];
    final isDean = user.userType == 'dean';
    final isTeacher = user.userType == 'teacher';
    final isStudent =
        user.userType == 'student' || user.userType == 'r_student';

    // School / Faculty (All roles usually have this context)
    if (user.facultyDetails != null) {
      widgets.add(const Divider(height: 24));
      widgets.add(
        _InfoTile(
          icon: Icons.account_balance_outlined,
          label: "Fakülte / Yüksekokul",
          value: user.facultyDetails!['name'] ?? '-',
        ),
      );
    }

    // Department (Teacher & Student)
    if ((isTeacher || isStudent) && user.departmentDetails != null) {
      widgets.add(const Divider(height: 24));
      widgets.add(
        _InfoTile(
          icon: Icons.domain_outlined,
          label: "Bölüm",
          value: user.departmentDetails!['name'] ?? '-',
        ),
      );
    }

    // Student Specifics
    if (isStudent) {
      if (user.studentNumber != null) {
        widgets.add(const Divider(height: 24));
        widgets.add(
          _InfoTile(
            icon: Icons.badge_outlined,
            label: "Öğrenci Numarası",
            value: user.studentNumber!,
          ),
        );
      }
      if (user.studentTerm != null) {
        widgets.add(const Divider(height: 24));
        widgets.add(
          _InfoTile(
            icon: Icons.school_outlined,
            label: "Sınıf / Dönem",
            value: _getTermLabel(user.studentTerm!),
          ),
        );
      }
    }

    return widgets;
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.bgLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.cyan, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
