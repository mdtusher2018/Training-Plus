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

  CommunityData copyWith({
    List<ActiveChallenge>? activeChallenge,
    List<MyPost>? mypost,
    Leaderboard? leaderboard,
    List<Feed>? feed,
  }) {
    return CommunityData(
      activeChallenge: activeChallenge ?? this.activeChallenge,
      mypost: mypost ?? this.mypost,
      leaderboard: leaderboard ?? this.leaderboard,
      feed: feed ?? this.feed,
    );
  }



}
