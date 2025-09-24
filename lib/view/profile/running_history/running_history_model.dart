import 'package:training_plus/common_used_models/pagination_model.dart';

class RunningHistoryResponse {
  final String status;
  final int statusCode;
  final String message;
  final List<RunningResult> results;
  final Pagination pagination;

  RunningHistoryResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.results,
    required this.pagination,
  });

  factory RunningHistoryResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["data"]["attributes"] ?? {};

    return RunningHistoryResponse(
      status: json["status"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      results: (attributes["results"] as List<dynamic>? ?? [])
          .map((e) => RunningResult.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(attributes),
    );
  }

  /// ✅ CopyWith
  RunningHistoryResponse copyWith({
    String? status,
    int? statusCode,
    String? message,
    List<RunningResult>? results,
    Pagination? pagination,
  }) {
    return RunningHistoryResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      results: results ?? this.results,
      pagination: pagination ?? this.pagination,
    );
  }
}

class RunningResult {
  final String id;
  final String image;
  final String place;
  final double distance;
  final int time; // in seconds
  final String pace; // stored as string in API
  final String createdAt;

  RunningResult({
    required this.id,
    required this.image,
    required this.place,
    required this.distance,
    required this.time,
    required this.pace,
    required this.createdAt,
  });

  factory RunningResult.fromJson(Map<String, dynamic> json) {
    return RunningResult(
      id: json["_id"] ?? "",
      image: json["image"] ?? "",
      place: json["place"] ?? "Unknown",
      distance: (json["distance"] ?? 0).toDouble(),
      time: json["time"] ?? 0,
      pace: json["pace"] ?? "--",
      createdAt: json["createdAt"] ?? "",
    );
  }
  /// ✅ CopyWith
  RunningResult copyWith({
    String? id,
    String? image,
    String? place,
    double? distance,
    int? time,
    String? pace,
    String? createdAt,
  }) {
    return RunningResult(
      id: id ?? this.id,
      image: image ?? this.image,
      place: place ?? this.place,
      distance: distance ?? this.distance,
      time: time ?? this.time,
      pace: pace ?? this.pace,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
