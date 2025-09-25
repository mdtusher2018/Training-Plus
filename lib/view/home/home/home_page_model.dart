
import 'package:training_plus/common_used_models/workout_preview_model.dart';

class HomeResponse {
  final String status;
  final int statusCode;
  final String message;
  final _Data? data;

  HomeResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? _Data.fromJson(json['data']) : null,
    );
  }

  /// Expose nested models instead of only flat fields
  _User? get user => data?.attributes.user;
  _Goal? get goal => data?.attributes.goal;
  List<WorkoutPreviewModel> get workouts => data?.attributes.workout ?? [];//was not nessasary but makes access easy for developers
  List<Quote> get quotes => data?.attributes.quotes ?? [];
  num get achievementCount => data?.attributes.achievementCount ?? 0;
  num get streakCount => data?.attributes.streak ?? 0;
}

/// Private models
class _Data {
  final String type;
  final _Attributes attributes;

  _Data({required this.type, required this.attributes});

  factory _Data.fromJson(Map<String, dynamic> json) {
    return _Data(
      type: json['type'] ?? '',
      attributes: _Attributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class _Attributes {
  final _User user;
  final _Goal goal;
  final List<WorkoutPreviewModel> workout;
  final num achievementCount;
  final num streak;
  final List<Quote> quotes;

  _Attributes({
    required this.user,
    required this.goal,
    required this.workout,
    required this.streak,
    required this.achievementCount,
    required this.quotes,
  });

  factory _Attributes.fromJson(Map<String, dynamic> json) {
    return _Attributes(
      user: _User.fromJson(json['user'] ?? {}),
      goal: _Goal.fromJson(json['goal'] ?? {}),
      workout: (json['workout'] as List<dynamic>? ?? [])
          .map((e) => WorkoutPreviewModel.fromJson(e))
          .toList(),
      achievementCount: json['achievementCount'] ?? 0,
      streak: json['streak']??0,
      quotes: (json['quots'] as List<dynamic>? ?? [])
          .map((e) => Quote.fromJson(e))
          .toList(),
    );
  }
}

class _User {
  final String id;
  final String fullName;
  final String image;
  final int workoutCount;

  _User({
    required this.id,
    required this.fullName,
    required this.image,
    required this.workoutCount,
  });

  factory _User.fromJson(Map<String, dynamic> json) {
    return _User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      image: json['image'] ?? '',
      workoutCount: json['workoutCount'] ?? 0,
    );
  }
}

class _Goal {
  final String id;
  final int target;
  final int progress;

  _Goal({required this.id, required this.target, required this.progress});

  factory _Goal.fromJson(Map<String, dynamic> json) {
    return _Goal(
      id: json['_id'] ?? '',
      target: json['target'] ?? 0,
      progress: json['progress'] ?? 0,
    );
  }
}


class Quote {
  final String id;
  final String image;
  final String text;

  Quote({
    required this.id,
    required this.image,
    required this.text,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      text: json['text'] ?? 'N/A',
    );
  }
}
