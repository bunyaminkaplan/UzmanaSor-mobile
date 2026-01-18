import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_app_bar.dart';
import 'package:mobile/features/admin/presentation/providers/approval_provider.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

class ApprovalPage extends ConsumerStatefulWidget {
  const ApprovalPage({super.key});

  @override
  ConsumerState<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends ConsumerState<ApprovalPage> {
  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında bekleyen listeyi çek
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(approvalProvider.notifier).loadPendingUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Kullanıcı rolüne göre başlık belirle (Rector vs Dean)
    final user = ref.watch(authProvider).value;
    String title = "Onay Bekleyenler";
    String subtitle = "";

    if (user != null) {
      if (user.userType == 'rector') {
        title = "Onay Bekleyen Dekanlar";
        subtitle = "Üniversitenize başvuran Dekan adayları";
      } else if (user.userType == 'dean') {
        title = "Fakülte Onayları";
        subtitle = "Fakültenizdeki Hocalar ve Öğrenciler";
      }
    }

    final state = ref.watch(approvalProvider);

    return Scaffold(
      appBar: UzmanAppBar(title: title),
      backgroundColor: AppColors.bgLight,
      body: Column(
        children: [
          // Subtitle Banner
          if (subtitle.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surfaceLight,
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          Expanded(
            child: Builder(
              builder: (context) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(state.errorMessage!),
                        TextButton(
                          onPressed: () => ref
                              .read(approvalProvider.notifier)
                              .loadPendingUsers(),
                          child: const Text("Tekrar Dene"),
                        ),
                      ],
                    ),
                  );
                }

                if (state.pendingUsers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: AppColors.cyan,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Bekleyen Başvuru Yok",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Tüm onay işlemleri tamamlandı.",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                // List
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.pendingUsers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final pendingUser = state.pendingUsers[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.orange.withValues(
                                    alpha: 0.1,
                                  ),
                                  child: Text(
                                    pendingUser.firstName?[0] ?? '?',
                                    style: const TextStyle(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${pendingUser.firstName} ${pendingUser.lastName}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                      Text(
                                        pendingUser.email ?? '',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgLight,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Text(
                                    pendingUser.userType.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      ref
                                          .read(approvalProvider.notifier)
                                          .rejectUser(pendingUser.id);
                                    },
                                    icon: const Icon(Icons.close, size: 18),
                                    label: const Text("Reddet"),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.error,
                                      side: const BorderSide(
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      ref
                                          .read(approvalProvider.notifier)
                                          .approveUser(pendingUser.id);
                                    },
                                    icon: const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    label: const Text("Onayla"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .green, // Specific success color
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
