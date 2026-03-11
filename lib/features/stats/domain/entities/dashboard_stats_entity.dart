class ChartDistributionEntity {
  final List<String> labels;
  final List<int> data;

  const ChartDistributionEntity({required this.labels, required this.data});
}

class DepartmentPerformanceEntity {
  final String name;
  final int total;
  final int answered;
  final int rate;

  const DepartmentPerformanceEntity({
    required this.name,
    required this.total,
    required this.answered,
    required this.rate,
  });
}

class DashboardStatsEntity {
  final int totalQuestions;
  final int answeredQuestions;
  final int pendingQuestions;
  final int forwardedQuestions;
  final ChartDistributionEntity departmentDistribution;
  final ChartDistributionEntity statusDistribution;
  final List<DepartmentPerformanceEntity> departmentPerformance;

  const DashboardStatsEntity({
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.pendingQuestions,
    required this.forwardedQuestions,
    required this.departmentDistribution,
    required this.statusDistribution,
    required this.departmentPerformance,
  });
}
