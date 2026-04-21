import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

class ProfileHeader extends ConsumerWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  String get _initials {
    if ((user.firstName?.isNotEmpty ?? false) &&
        (user.lastName?.isNotEmpty ?? false)) {
      return '${user.firstName![0]}${user.lastName![0]}'.toUpperCase();
    }
    return user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U';
  }

  String get _userTypeLabel {
    return _roleToLabel(user.activeDashboard);
  }

  String _roleToLabel(String r) {
    switch (r) {
      case 'student':
        return 'Öğrenci';
      case 'student_rep':
        return 'Öğrenci Temsilcisi';
      case 'teacher':
        return 'Akademisyen';
      case 'dean':
        return 'Dekan';
      case 'rector':
        return 'Rektör';
      case 'school_admin':
        return 'Okul Yöneticisi';
      default:
        return r;
    }
  }

  String get _termLabel {
    final t = user.studentTerm;
    if (t == null) return '';
    switch (t) {
      case 'prep':
        return 'Hazırlık';
      case '1':
      case '2':
      case '3':
      case '4':
        return '$t. Sınıf';
      case 'extended':
        return 'Uzatmalı';
      default:
        return t;
    }
  }

  bool get _isStudent =>
      user.activeDashboard == 'student' ||
      user.activeDashboard == 'student_rep';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentNavy, AppColors.accentNavyDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentNavy.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accentOrange, Color(0xFFD66A0F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 4,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (user.firstName?.isNotEmpty ?? false) &&
                          (user.lastName?.isNotEmpty ?? false)
                      ? '${user.firstName} ${user.lastName}'
                      : user.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),

                // Badges
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Rol Etiketi / Değiştirici
                    if (user.roles.length > 1) ...[
                      PopupMenuButton<String>(
                        initialValue: user.activeDashboard,
                        onSelected: (String role) async {
                          if (role == user.activeDashboard) return;

                          // Show loading inside UI somehow wait for the operation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dashboard değiştiriliyor...'),
                            ),
                          );

                          final res = await ref
                              .read(authProvider.notifier)
                              .switchDashboard(role);
                          if (!context.mounted) return;

                          if (res['success'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Dashboard başarıyla değiştirildi.',
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Hata: ${res['error']}')),
                            );
                          }
                        },
                        itemBuilder: (context) => user.roles
                            .map(
                              (r) => PopupMenuItem(
                                value: r,
                                child: Text(_roleToLabel(r)),
                              ),
                            )
                            .toList(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _userTypeLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _userTypeLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],

                    // Bölüm Başkanı Etiketi
                    if (user.isDepartmentHead)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Bölüm Başkanı',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // Danışman Etiketi
                    if (user.isAdvisor)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Danışman',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // Dönem Etiketi
                    if (_isStudent && user.studentTerm != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _termLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
