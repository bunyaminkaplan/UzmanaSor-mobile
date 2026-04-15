import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';

/// Backend Report response DTO
class ReportEntity {
  final int id;
  final String reporterUsername;
  final String reason;
  final String contentSummary;
  final String status; // pending | reviewed | resolved | dismissed
  final String createdAt;
  final String? resolvedAt;

  const ReportEntity({
    required this.id,
    required this.reporterUsername,
    required this.reason,
    required this.contentSummary,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
  });

  factory ReportEntity.fromJson(Map<String, dynamic> json) {
    return ReportEntity(
      id: json['id'] as int,
      reporterUsername: (json['reporter_username'] as String?) ?? 'Anonim',
      reason: (json['reason'] as String?) ?? '',
      contentSummary: (json['content_summary'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'pending',
      createdAt: (json['created_at'] as String?) ?? '',
      resolvedAt: json['resolved_at'] as String?,
    );
  }

  bool get isPending => status == 'pending';
}

/// Report remote data source.
class ReportRemoteDataSource {
  final ApiClient _api;

  ReportRemoteDataSource(this._api);

  /// Tüm raporları getir
  Future<List<ReportEntity>> getReports() async {
    final res = await _api.get(ApiEndpoints.reports);
    final data = res.data;
    final list = data is List
        ? data
        : (data is Map<String, dynamic> && data['results'] is List)
        ? data['results'] as List
        : [];
    return list
        .map((j) => ReportEntity.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Raporu yoksay (dismiss)
  Future<void> dismissReport(int reportId) async {
    await _api.post(ApiEndpoints.reportAction(reportId, 'dismiss'));
  }

  /// İçeriği sil ve raporu çözüldü yap
  Future<void> deleteContent(int reportId) async {
    await _api.post(ApiEndpoints.reportAction(reportId, 'delete_content'));
  }
}

/// Providers
final reportDataSourceProvider = Provider<ReportRemoteDataSource>((ref) {
  return ReportRemoteDataSource(ref.watch(apiClientProvider));
});

final reportsProvider = FutureProvider.autoDispose<List<ReportEntity>>((
  ref,
) async {
  return ref.watch(reportDataSourceProvider).getReports();
});
