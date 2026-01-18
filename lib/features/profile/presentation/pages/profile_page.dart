import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_shadows.dart';
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

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.scaffoldBackground,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // MAIN IDENTITY CARD
            Container(
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.medium,
              ),
              child: Column(
                children: [
                  // 1. AVATAR with Border
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryCyan.withValues(alpha: 0.3),
                        width: 4,
                      ),
                    ),
                    child: UzmanAvatar(
                      name: displayName.isNotEmpty
                          ? displayName
                          : user.username,
                      imageUrl: user.profileImage,
                      radius: 50,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. NAME
                  Text(
                    displayName.isNotEmpty ? displayName : user.username,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeading,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // 3. BADGES
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      UzmanBadge(
                        text: _getUserTypeLabel(user.userType),
                        baseColor: _getRoleColor(user.userType),
                      ),
                      if (user.isDepartmentHead)
                        const UzmanBadge(
                          text: "Bölüm Başkanı",
                          baseColor: AppColors.primaryOrange,
                          icon: Icons.star,
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // 4. INFO LIST
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

                  // Role Specific Info (Preserved Logic)
                  ..._buildRoleSpecificInfo(user),
                ],
              ),
            ),

            // LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton.icon(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text(
                  "Çıkış Yap",
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Versiyon 1.0.0",
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 40),
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

  Color _getRoleColor(String type) {
    switch (type) {
      case 'student':
      case 'r_student':
        return AppColors.primaryCyan;
      case 'teacher':
        return AppColors.primaryOrange;
      case 'dean':
      case 'rector':
        return AppColors.primaryNavy;
      default:
        return AppColors.textMuted;
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
    final isStudent =
        user.userType == 'student' || user.userType == 'r_student';
    final isTeacher = user.userType == 'teacher';

    // School / Faculty
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

    // Department
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryCyan, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textBody,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
