class Leaderboard {
  final String id;
  final String weekStart;
  final String weekEnd;
  final List<LeaderboardUser> topUsers;
  // final String createdAt;
  // final String updatedAt;

  Leaderboard({
    required this.id,
    required this.weekStart,
    required this.weekEnd,
    required this.topUsers,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      id: json["_id"] ?? "",
      weekStart: json["weekStart"] ?? "",
      weekEnd: json["weekEnd"] ?? "",
      topUsers: (json["topUsers"] as List<dynamic>?)
              ?.map((e) => LeaderboardUser.fromJson(e))
              .toList() ??
          [],
      // createdAt: json["createdAt"] ?? "",
      // updatedAt: json["updatedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "weekStart": weekStart,
      "weekEnd": weekEnd,
      "topUsers": topUsers.map((e) => e.toJson()).toList(),
      // "createdAt": createdAt,
      // "updatedAt": updatedAt,
    };
  }
}

class LeaderboardUser {
  final String id;
  final String fullName;
  final String image;
  final int points;

  LeaderboardUser({
    required this.id,
    required this.fullName,
    required this.image,
    required this.points,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json["_id"] ?? "",
      fullName: json["fullName"] ?? "",
      image: json["image"] ?? "",
      points: json["points"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "fullName": fullName,
      "image": image,
      "points": points,
    };
  }
}
