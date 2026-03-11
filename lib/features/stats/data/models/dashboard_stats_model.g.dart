// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChartDistributionModel _$ChartDistributionModelFromJson(
  Map<String, dynamic> json,
) => _ChartDistributionModel(
  labels:
      (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$ChartDistributionModelToJson(
  _ChartDistributionModel instance,
) => <String, dynamic>{'labels': instance.labels, 'data': instance.data};

_DepartmentPerformanceModel _$DepartmentPerformanceModelFromJson(
  Map<String, dynamic> json,
) => _DepartmentPerformanceModel(
  name: json['name'] as String? ?? '',
  total: (json['total'] as num?)?.toInt() ?? 0,
  answered: (json['answered'] as num?)?.toInt() ?? 0,
  rate: (json['rate'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DepartmentPerformanceModelToJson(
  _DepartmentPerformanceModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'total': instance.total,
  'answered': instance.answered,
  'rate': instance.rate,
};

_DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    _DashboardStatsModel(
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
      answeredQuestions: (json['answered_questions'] as num?)?.toInt() ?? 0,
      pendingQuestions: (json['pending_questions'] as num?)?.toInt() ?? 0,
      forwardedQuestions: (json['forwarded_questions'] as num?)?.toInt() ?? 0,
      departmentDistribution: ChartDistributionModel.fromJson(
        json['department_distribution'] as Map<String, dynamic>,
      ),
      statusDistribution: ChartDistributionModel.fromJson(
        json['status_distribution'] as Map<String, dynamic>,
      ),
      departmentPerformance:
          (json['department_performance'] as List<dynamic>?)
              ?.map(
                (e) => DepartmentPerformanceModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
  _DashboardStatsModel instance,
) => <String, dynamic>{
  'total_questions': instance.totalQuestions,
  'answered_questions': instance.answeredQuestions,
  'pending_questions': instance.pendingQuestions,
  'forwarded_questions': instance.forwardedQuestions,
  'department_distribution': instance.departmentDistribution,
  'status_distribution': instance.statusDistribution,
  'department_performance': instance.departmentPerformance,
};
