import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_colors_ext.dart';
import 'package:mobile/features/content_moderation/data/report_data_source.dart';
import 'package:mobile/shared/widgets/async_error_widget.dart';
import 'package:mobile/shared/widgets/confirm_dialog.dart';
import 'package:mobile/shared/widgets/dashboard_scaffold.dart';
import 'package:mobile/shared/widgets/empty_state_widget.dart';

class ContentModerationPage extends ConsumerStatefulWidget {
  const ContentModerationPage({super.key});

  @override
  ConsumerState<ContentModerationPage> createState() =>
      _ContentModerationPageState();
}

class _ContentModerationPageState extends ConsumerState<ContentModerationPage> {
  int? _processingId;

  Future<void> _handleAction(int reportId, String action) async {
    // İçerik silme için onay dialogu
    if (action == 'delete_content') {
      final confirmed = await ConfirmDialog.show(
        context: context,
        title: 'İçeriği Sil',
        message: 'Bu içeriği kalıcı olarak silmek istediğinize emin misiniz?',
        confirmLabel: 'Sil',
        confirmColor: AppColors.error,
      );
      if (!confirmed) return;
    }

    setState(() => _processingId = reportId);
    try {
      final ds = ref.read(reportDataSourceProvider);
      if (action == 'dismiss') {
        await ds.dismissReport(reportId);
      } else if (action == 'delete_content') {
        await ds.deleteContent(reportId);
      }
      ref.invalidate(reportsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('İşlem başarılı'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İşlem başarısız: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _processingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(reportsProvider);

    return DashboardScaffold(
      onRefresh: () async {
        ref.invalidate(reportsProvider);
      },
      body: reportsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const AsyncErrorWidget(message: 'Raporlar yüklenemedi'),
        data: (reports) {
          if (reports.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.verified_user_rounded,
              title: 'İncelenecek rapor bulunmuyor',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final report = reports[index];
              return _buildReportCard(report);
            },
          );
        },
      ),
    );
  }

  Widget _buildReportCard(ReportEntity report) {
    final isProcessing = _processingId == report.id;

    // Tarih formatlama
    String formattedDate = '';
    if (report.createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(report.createdAt);
        formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(date);
      } catch (_) {
        formattedDate = report.createdAt;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: report.isPending
            ? Border.all(color: AppColors.warning.withValues(alpha: 0.3))
            : null,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst satır: raporlayan + durum badge + tarih
          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: AppColors.accentCyan),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  report.reporterUsername,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textHeading,
                  ),
                ),
              ),
              _buildStatusBadge(report.status),
            ],
          ),
          const SizedBox(height: 12),

          // Şikayet sebebi
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.flag_rounded, size: 16, color: AppColors.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    report.reason,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // İçerik özeti
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.inputBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '"${report.contentSummary.length > 80 ? '${report.contentSummary.substring(0, 80)}...' : report.contentSummary}"',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: context.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Alt satır: tarih + aksiyon butonları
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: context.textMuted),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 11,
                  color: context.textMuted,
                ),
              ),
              const Spacer(),

              // Aksiyon butonları (sadece pending)
              if (report.isPending && !isProcessing) ...[
                _buildActionButton(
                  label: 'Yoksay',
                  icon: Icons.close_rounded,
                  color: Colors.grey,
                  onTap: () => _handleAction(report.id, 'dismiss'),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  label: 'İçeriği Sil',
                  icon: Icons.delete_forever_rounded,
                  color: Colors.red,
                  onTap: () => _handleAction(report.id, 'delete_content'),
                ),
              ],
              if (isProcessing)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              if (!report.isPending && !isProcessing)
                Text(
                  'İşlem yapıldı',
                  style: TextStyle(
                    fontSize: 11,
                    color: context.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final (String label, Color color) = switch (status) {
      'pending' => ('Beklemede', AppColors.warning),
      'reviewed' => ('İncelendi', AppColors.accentCyan),
      'resolved' => ('Çözüldü', AppColors.success),
      'dismissed' => ('Reddedildi', AppColors.textMuted),
      _ => (status, AppColors.textMuted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
