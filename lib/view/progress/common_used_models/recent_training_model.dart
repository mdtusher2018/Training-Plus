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
      id: json['_id'] ?? "",
      watchTime: json['watchTime'] ?? "",
      isCompleted: json['isCompleted'] ?? false,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      workoutName: json['workoutName'] ?? "",
      thumbnail: json['thumbnail'],
      skillLevel: json['skillLevel'] ?? "",
      workoutId: json['workoutId'] ?? "",
      sportsname: json['sportsname'] ?? "",
    );
  }
}
