import 'package:training_plus/core/common_used_models/pagination_model.dart';
import 'package:training_plus/core/common_used_models/workout_preview_model.dart';

class MyWorkoutResponse {
  final String status;
  final int statusCode;
  final String message;
  final List<WorkoutPreviewModel> suggestions;
  final Pagination pagination;

  MyWorkoutResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.suggestions,
    required this.pagination,
  });

  factory MyWorkoutResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["data"]["attributes"] ?? {};

    return MyWorkoutResponse(
      status: json["status"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      suggestions: (attributes["suggestions"] as List<dynamic>? ?? [])
          .map((e) => WorkoutPreviewModel.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(attributes["pagination"] ?? {}),
    );
  }
  
}
extension MyWorkoutResponseCopy on MyWorkoutResponse {
  MyWorkoutResponse copyWith({
    String? status,
    int? statusCode,
    String? message,
    List<WorkoutPreviewModel>? suggestions,
    Pagination? pagination,
  }) {
    return MyWorkoutResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      suggestions: suggestions ?? this.suggestions,
      pagination: pagination ?? this.pagination,
    );
  }
}

