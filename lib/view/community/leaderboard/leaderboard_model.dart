import 'package:training_plus/common_used_models/leader_board_model.dart';

class LeaderboardFullResponse {
  final String status;
  final int statusCode;
  final String type;
  final String message;
  final Leaderboard data;

  LeaderboardFullResponse({
    required this.status,
    required this.statusCode,
    required this.type,
    required this.message,
    required this.data,
  });

  factory LeaderboardFullResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardFullResponse(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      data: Leaderboard.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'type': type,
      'message': message,
      'data': data.toJson(),
    };
  }
}

