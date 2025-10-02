class ActiveChallenge {
  final String id;
  final String challengeName;
  final int count;
  final int days;
  final int point;
  final bool isJoined;
  final num progress;
  final String createdAt;
  final String expiredAt;

  ActiveChallenge({
    required this.id,
    required this.challengeName,
    required this.count,
    required this.days,
    required this.point,
    required this.isJoined,
    required this.progress,
    required this.createdAt,
    required this.expiredAt,
  });

  factory ActiveChallenge.fromJson(Map<String, dynamic> json) {
    return ActiveChallenge(
      id: json["_id"] ?? "",
      challengeName: json["challengeName"] ?? "",
      count: json["count"] ?? 0,
      days: json["days"] ?? 0,
      point: json["point"] ?? 0,
      isJoined: json["isJoined"] ?? false,
      progress: json["progress"] ?? 0.0,
      createdAt: json["createdAt"] ?? "",
      expiredAt: json["expiredAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "challengeName": challengeName,
      "count": count,
      "days": days,
      "point": point,
      "isJoined": isJoined,
      "progress": progress,
      "createdAt": createdAt,
      "expiredAt": expiredAt,
    };
  }
}
