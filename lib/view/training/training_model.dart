import 'package:training_plus/common_used_models/recent_training_model.dart';

class TrainingResponse {
  final String status;
  final int statusCode;
  final String message;
  final TrainingAttributes data;
  final List<dynamic> errors;

  TrainingResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory TrainingResponse.fromJson(Map<String, dynamic> json) {
    return TrainingResponse(
      status: json['status'] ?? "",
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? "",
      data: TrainingAttributes.fromJson(json['data']['attributes']),
      errors: json['errors'] ?? [],
    );
  }
}

class TrainingAttributes {
  final List<RecentTraining> myTrainings;
  final List<Wellness> wellness;
  final String currentTrainning;

  TrainingAttributes({
    required this.myTrainings,
    required this.wellness,
    required this.currentTrainning,
  });

  factory TrainingAttributes.fromJson(Map<String, dynamic> json) {
    return TrainingAttributes(
      myTrainings:
          (json['myTrainings'] as List<dynamic>? ?? [])
              .map((t) => RecentTraining.fromJson(t))
              .toList(),
      wellness:
          (json['wellness'] as List<dynamic>? ?? [])
              .map((w) => Wellness.fromJson(w))
              .toList(),
      currentTrainning: json['currentTrainning']?['currentTrainning'] ?? "N/A",
    );
  }
  TrainingAttributes copyWith({
    List<RecentTraining>? myTrainings,
    List<Wellness>? wellness,
    String? currentTrainning,
  }) {
    return TrainingAttributes(
      myTrainings: myTrainings ?? this.myTrainings,
      wellness: wellness ?? this.wellness,
      currentTrainning: currentTrainning ?? this.currentTrainning,
    );
  }
}

class Wellness {
  final String id;
  final String title;
  final int duration;

  Wellness({required this.id, required this.title, required this.duration});

  factory Wellness.fromJson(Map<String, dynamic> json) {
    return Wellness(
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      duration: json['duration'] ?? 0,
    );
  }
}
