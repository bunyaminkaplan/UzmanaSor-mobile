// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_stats_entity.dart';

part 'dashboard_stats_model.freezed.dart';
part 'dashboard_stats_model.g.dart';

@freezed
abstract class ChartDistributionModel with _$ChartDistributionModel {
  const ChartDistributionModel._(); // Custom methodlar için private constructor

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ChartDistributionModel({
    @Default([]) List<String> labels,
    @Default([]) List<int> data,
  }) = _ChartDistributionModel;

  factory ChartDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$ChartDistributionModelFromJson(json);

  ChartDistributionEntity toEntity() =>
      ChartDistributionEntity(labels: labels, data: data);
}

@freezed
abstract class DepartmentPerformanceModel with _$DepartmentPerformanceModel {
  const DepartmentPerformanceModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DepartmentPerformanceModel({
    @Default('') String name,
    @Default(0) int total,
    @Default(0) int answered,
    @Default(0) int rate,
  }) = _DepartmentPerformanceModel;

  factory DepartmentPerformanceModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentPerformanceModelFromJson(json);

  DepartmentPerformanceEntity toEntity() => DepartmentPerformanceEntity(
    name: name,
    total: total,
    answered: answered,
    rate: rate,
  );
}

@freezed
abstract class DashboardStatsModel with _$DashboardStatsModel {
  const DashboardStatsModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DashboardStatsModel({
    @Default(0) int totalQuestions,
    @Default(0) int answeredQuestions,
    @Default(0) int pendingQuestions,
    @Default(0) int forwardedQuestions,
    required ChartDistributionModel departmentDistribution,
    required ChartDistributionModel statusDistribution,
    @Default([]) List<DepartmentPerformanceModel> departmentPerformance,
  }) = _DashboardStatsModel;

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);

  DashboardStatsEntity toEntity() => DashboardStatsEntity(
    totalQuestions: totalQuestions,
    answeredQuestions: answeredQuestions,
    pendingQuestions: pendingQuestions,
    forwardedQuestions: forwardedQuestions,
    departmentDistribution: departmentDistribution.toEntity(),
    statusDistribution: statusDistribution.toEntity(),
    departmentPerformance: departmentPerformance
        .map((e) => e.toEntity())
        .toList(),
  );
}
