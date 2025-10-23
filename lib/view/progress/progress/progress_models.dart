

import 'package:training_plus/core/common_used_models/recent_training_model.dart';

class ProgressResponse {
  final String status;
  final int statusCode;
  final String message;
  final ProgressData data;
  final List<dynamic> errors;

  ProgressResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory ProgressResponse.fromJson(Map<String, dynamic> json) {
    return ProgressResponse(
      status: json['status'] ?? "",
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? ProgressData.fromJson(json['data'])
          : ProgressData.empty(),
      errors: json['errors'] ?? [],
    );
  }
}

class ProgressData {
  final String type;
  final ProgressAttributes attributes;

  ProgressData({required this.type, required this.attributes});

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      type: json['type'] ?? "",
      attributes: json['attributes'] != null
          ? ProgressAttributes.fromJson(json['attributes'])
          : ProgressAttributes.empty(),
    );
  }

  factory ProgressData.empty() => ProgressData(
        type: "",
        attributes: ProgressAttributes.empty(),
      );
}

class ProgressAttributes {
  final ProgressChart progressChart;
  final PieChartResponse pieChart;
  final List<MyGoal> mygoal;
  final List<Achievement> achievements;
  final List<RecentTraining> recentTraining;

  ProgressAttributes({
    required this.progressChart,
    required this.pieChart,
    required this.mygoal,
    required this.achievements,
    required this.recentTraining,
  });

  factory ProgressAttributes.fromJson(Map<String, dynamic> json) {
    return ProgressAttributes(
      progressChart: json['progressChart'] != null
          ? ProgressChart.fromJson(json['progressChart'])
          : ProgressChart.empty(),
      pieChart: json['pieChart'] != null
          ? PieChartResponse.fromJson(json['pieChart'])
          : PieChartResponse.empty(),
      mygoal: (json['mygoal'] as List<dynamic>? ?? [])
          .map((e) => MyGoal.fromJson(e))
          .toList(),
      achievements: (json['achievements'] as List<dynamic>? ?? [])
          .map((e) => Achievement.fromJson(e))
          .toList(),
      recentTraining: (json['recentTraining'] as List<dynamic>? ?? [])
          .map((e) => RecentTraining.fromJson(e))
          .toList(),
    );
  }

  factory ProgressAttributes.empty() => ProgressAttributes(
        progressChart: ProgressChart.empty(),
        pieChart: PieChartResponse.empty(),
        mygoal: [],
        achievements: [],
        recentTraining: [],
      );
}

class ProgressChart {
  final List<ChartItem> weekly;
  final List<ChartItem> monthly;

  ProgressChart({required this.weekly, required this.monthly});

  factory ProgressChart.fromJson(Map<String, dynamic> json) {
    return ProgressChart(
      weekly: (json['weekly'] as List<dynamic>? ?? [])
          .map((e) => ChartItem.fromJson(e))
          .toList(),
      monthly: (json['monthly'] as List<dynamic>? ?? [])
          .map((e) => ChartItem.fromJson(e))
          .toList(),
    );
  }

  factory ProgressChart.empty() => ProgressChart(weekly: [], monthly: []);
}

class ChartItem {
  final String label;
  final int totalCompleted;

  ChartItem({required this.label, required this.totalCompleted});

  factory ChartItem.fromJson(Map<String, dynamic> json) {
    return ChartItem(
      label: json['label'] ?? "",
      totalCompleted: json['totalCompleted'] ?? 0,
    );
  }
}

class PieChartResponse {
  final int totalCount;
  final List<ChartItem> data;

  PieChartResponse({required this.totalCount, required this.data});

  factory PieChartResponse.fromJson(Map<String, dynamic> json) {
    return PieChartResponse(
      totalCount: json['totalCount'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ChartItem.fromJson(e))
          .toList(),
    );
  }

  factory PieChartResponse.empty() => PieChartResponse(totalCount: 0, data: []);
}

class MyGoal {
  final String id;
  final int target;
  final int progress;
  final String timeFrame;
  final String sports;

  MyGoal({
    required this.id,
    required this.target,
    required this.progress,
    required this.timeFrame,
    required this.sports,
  });

  factory MyGoal.fromJson(Map<String, dynamic> json) {
    return MyGoal(
      id: json['_id'] ?? "",
      target: json['target'] ?? 0,
      progress: json['progress'] ?? 0,
      timeFrame: json['timeFrame'] ?? "",
      sports: json['sports'] ?? "",
    );
  }
}

class Achievement {
  final String badgeName;
  final String badgeImage;
  final String description;

  Achievement({
    required this.badgeName,
    required this.badgeImage,
    required this.description,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      badgeName: json['badgeName'] ?? "",
      badgeImage: json['badgeImage'] ?? "",
      description: json['description'] ?? "",
    );
  }
}

