import 'package:training_plus/common_used_models/active_challenge_model.dart';
import 'package:training_plus/common_used_models/feed_model.dart';
import 'package:training_plus/common_used_models/leader_board_model.dart';
import 'package:training_plus/common_used_models/my_post_model.dart';

class CommunityResponseModel {
  final String status;
  final int statusCode;
  final String message;
  final CommunityData data;

  CommunityResponseModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CommunityResponseModel.fromJson(Map<String, dynamic> json) {
    return CommunityResponseModel(
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
      activeChallenge:
          (json["activeChallenge"] as List<dynamic>)
              .map((e) => ActiveChallenge.fromJson(e))
              .toList(),
      mypost:
          (json["mypost"] as List<dynamic>)
              .map((e) => MyPost.fromJson(e))
              .toList(),
      leaderboard: Leaderboard.fromJson(json["leaderboard"]),
      feed:
          (json["feed"] as List<dynamic>).map((e) => Feed.fromJson(e)).toList(),
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
