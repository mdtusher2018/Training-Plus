import 'package:training_plus/common_used_models/pagination_model.dart';
import 'package:training_plus/common_used_models/recent_training_model.dart';

class WorkoutHistoryResponse {
  final String status;
  final int statusCode;
  final String message;
  final List<RecentTraining> result;
  final Pagination pagination;

  WorkoutHistoryResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.result,
    required this.pagination,
  });

  factory WorkoutHistoryResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["data"]["attributes"] ?? {};
    return WorkoutHistoryResponse(
      status: json["status"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      result: (attributes["result"] as List<dynamic>? ?? [])
          .map((e) => RecentTraining.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(attributes["pagination"] ?? {}),
    );
  }

  WorkoutHistoryResponse copyWith({
    String? status,
    int? statusCode,
    String? message,
    List<RecentTraining>? result,
    Pagination? pagination,
  }) {
    return WorkoutHistoryResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      result: result ?? this.result,
      pagination: pagination ?? this.pagination,
    );
  }
}
