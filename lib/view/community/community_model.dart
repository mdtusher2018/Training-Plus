class CommunityResponse {
  final String status;
  final int statusCode;
  final String message;
  final CommunityData data;

  CommunityResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CommunityResponse.fromJson(Map<String, dynamic> json) {
    return CommunityResponse(
      status: json["status"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      data: CommunityData.fromJson(json["data"]["attributes"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "statusCode": statusCode,
      "message": message,
      "data": {"attributes": data.toJson()},
    };
  }
}

class CommunityData {
  final List<ActiveChallenge> activeChallenge;
  final List<MyPost> mypost;
  final Leaderboard leaderboard;
  final List<Feed> feed;

  CommunityData({
    required this.activeChallenge,
    required this.mypost,
    required this.leaderboard,
    required this.feed,
  });

  factory CommunityData.fromJson(Map<String, dynamic> json) {
    return CommunityData(
      activeChallenge: (json["activeChallenge"] as List<dynamic>)
          .map((e) => ActiveChallenge.fromJson(e))
          .toList(),
      mypost: (json["mypost"] as List<dynamic>)
          .map((e) => MyPost.fromJson(e))
          .toList(),
      leaderboard: Leaderboard.fromJson(json["leaderboard"]),
      feed: (json["feed"] as List<dynamic>)
          .map((e) => Feed.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "activeChallenge": activeChallenge.map((e) => e.toJson()).toList(),
      "mypost": mypost.map((e) => e.toJson()).toList(),
      "leaderboard": leaderboard.toJson(),
      "feed": feed.map((e) => e.toJson()).toList(),
    };
  }
}

class ActiveChallenge {
  final String id;
  final String challengeName;
  final int count;
  final int days;
  final int point;
  final bool isJoined;
  final int progress;
  final String? createdAt;
  final String? expiredAt;

  ActiveChallenge({
    required this.id,
    required this.challengeName,
    required this.count,
    required this.days,
    required this.point,
    required this.isJoined,
    required this.progress,
    this.createdAt,
    this.expiredAt,
  });

  factory ActiveChallenge.fromJson(Map<String, dynamic> json) {
    return ActiveChallenge(
      id: json["_id"] ?? "",
      challengeName: json["challengeName"] ?? "",
      count: json["count"] ?? 0,
      days: json["days"] ?? 0,
      point: json["point"] ?? 0,
      isJoined: json["isJoined"] ?? false,
      progress: json["progress"] ?? 0,
      createdAt: json["createdAt"],
      expiredAt: json["expiredAt"],
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

class MyPost {
  final String id;
  final Author author;
  final String caption;
  final String category;
  final int likeCount;
  final int commentCount;
  final String createdAt;
  final bool isLiked;

  MyPost({
    required this.id,
    required this.author,
    required this.caption,
    required this.category,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.isLiked,
  });

  factory MyPost.fromJson(Map<String, dynamic> json) {
    return MyPost(
      id: json["_id"] ?? "",
      author: Author.fromJson(json["author"]),
      caption: json["caption"] ?? "",
      category: json["category"] ?? "",
      likeCount: json["likeCount"] ?? 0,
      commentCount: json["commentCount"] ?? 0,
      createdAt: json["createdAt"] ?? "",
      isLiked: json["isLiked"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "author": author.toJson(),
      "caption": caption,
      "category": category,
      "likeCount": likeCount,
      "commentCount": commentCount,
      "createdAt": createdAt,
      "isLiked": isLiked,
    };
  }
}

class Author {
  final String fullName;
  final String image;

  Author({
    required this.fullName,
    required this.image,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      fullName: json["fullName"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "image": image,
    };
  }
}

class Leaderboard {
  final String id;
  final String weekStart;
  final String weekEnd;
  final List<dynamic> topUsers;
  final String createdAt;
  final String updatedAt;

  Leaderboard({
    required this.id,
    required this.weekStart,
    required this.weekEnd,
    required this.topUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      id: json["_id"] ?? "",
      weekStart: json["weekStart"] ?? "",
      weekEnd: json["weekEnd"] ?? "",
      topUsers: json["topUsers"] ?? [],
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "weekStart": weekStart,
      "weekEnd": weekEnd,
      "topUsers": topUsers,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}

class Feed {
  final String id;
  final String caption;
  final String category;
  final int likeCount;
  final int commentCount;
  final String createdAt;
  final bool isLiked;
  final String authorName;
  final String authorImage;

  Feed({
    required this.id,
    required this.caption,
    required this.category,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.isLiked,
    required this.authorName,
    required this.authorImage,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json["_id"] ?? "",
      caption: json["caption"] ?? "",
      category: json["category"] ?? "",
      likeCount: json["likeCount"] ?? 0,
      commentCount: json["commentCount"] ?? 0,
      createdAt: json["createdAt"] ?? "",
      isLiked: json["isLiked"] ?? false,
      authorName: json["authorName"] ?? "",
      authorImage: json["authorImage"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "caption": caption,
      "category": category,
      "likeCount": likeCount,
      "commentCount": commentCount,
      "createdAt": createdAt,
      "isLiked": isLiked,
      "authorName": authorName,
      "authorImage": authorImage,
    };
  }
}
