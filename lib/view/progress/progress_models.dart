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
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: ProgressData.fromJson(json['data']),
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
      type: json['type'],
      attributes: ProgressAttributes.fromJson(json['attributes']),
    );
  }
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
      progressChart: ProgressChart.fromJson(json['progressChart']),
      pieChart: PieChartResponse.fromJson(json['pieChart']),
      mygoal: (json['mygoal'] as List)
          .map((e) => MyGoal.fromJson(e))
          .toList(),
      achievements: (json['achievements'] as List)
          .map((e) => Achievement.fromJson(e))
          .toList(),
      recentTraining: (json['recentTraining'] as List)
          .map((e) => RecentTraining.fromJson(e))
          .toList(),
    );
  }
}

class ProgressChart {
  final List<ChartItem> weekly;
  final List<ChartItem> monthly;

  ProgressChart({required this.weekly, required this.monthly});

  factory ProgressChart.fromJson(Map<String, dynamic> json) {
    return ProgressChart(
      weekly: (json['weekly'] as List)
          .map((e) => ChartItem.fromJson(e))
          .toList(),
      monthly: (json['monthly'] as List)
          .map((e) => ChartItem.fromJson(e))
          .toList(),
    );
  }
}

class ChartItem {
  final String label;
  final int totalCompleted;

  ChartItem({required this.label, required this.totalCompleted});

  factory ChartItem.fromJson(Map<String, dynamic> json) {
    return ChartItem(
      label: json['label'],
      totalCompleted: json['totalCompleted'],
    );
  }
}

class PieChartResponse {
  final int totalCount;
  final List<ChartItem> data;

  PieChartResponse({required this.totalCount, required this.data});

  factory PieChartResponse.fromJson(Map<String, dynamic> json) {
    return PieChartResponse(
      totalCount: json['totalCount'],
      data: (json['data'] as List)
          .map((e) => ChartItem.fromJson(e))
          .toList(),
    );
  }
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
      id: json['_id'],
      target: json['target'],
      progress: json['progress'],
      timeFrame: json['timeFrame'],
      sports: json['sports'],
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
      badgeName: json['badgeName'],
      badgeImage: json['badgeImage'],
      description: json['description'],
    );
  }
}

class RecentTraining {
  final String id;
  final String watchTime;
  final bool isCompleted;
  final DateTime updatedAt;
  final String workoutName;
  final String? thumbnail;
  final String skillLevel;
  final String workoutId;
  final String sportsname;

  RecentTraining({
    required this.id,
    required this.watchTime,
    required this.isCompleted,
    required this.updatedAt,
    required this.workoutName,
    this.thumbnail,
    required this.skillLevel,
    required this.workoutId,
    required this.sportsname,
  });

  factory RecentTraining.fromJson(Map<String, dynamic> json) {
    return RecentTraining(
      id: json['_id'],
      watchTime: json['watchTime'],
      isCompleted: json['isCompleted'],
      updatedAt: DateTime.parse(json['updatedAt']),
      workoutName: json['workoutName'],
      thumbnail: json['thumbnail'],
      skillLevel: json['skillLevel'],
      workoutId: json['workoutId'],
      sportsname: json['sportsname'],
    );
  }
}
