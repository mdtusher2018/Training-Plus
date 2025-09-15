import 'package:training_plus/common_used_models/recent_training_model.dart';

class AllRecentSessionResponse {
  final String status;
  final int statusCode;
  final String message;
  final RecentSessionData data;
  final List<dynamic> errors;

  AllRecentSessionResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory AllRecentSessionResponse.fromJson(Map<String, dynamic> json) {
    return AllRecentSessionResponse(
      status: json['status'] ?? "",
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? "",
      data: RecentSessionData.fromJson(json['data']),
      errors: json['errors'] ?? [],
    );
  }
}

class RecentSessionData {
  final String type;
  final RecentSessionAttributes attributes;

  RecentSessionData({
    required this.type,
    required this.attributes,
  });

  factory RecentSessionData.fromJson(Map<String, dynamic> json) {
    return RecentSessionData(
      type: json['type'] ?? "",
      attributes: RecentSessionAttributes.fromJson(json['attributes']),
    );
  }
}

class RecentSessionAttributes {
  final List<RecentTraining> result;
  final Pagination pagination;

  RecentSessionAttributes({
    required this.result,
    required this.pagination,
  });

  factory RecentSessionAttributes.fromJson(Map<String, dynamic> json) {
    return RecentSessionAttributes(
      result: (json['result'] as List<dynamic>)
          .map((e) => RecentTraining.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Pagination {
  final int totalResults;
  final int totalPages;
  final int currentPage;
  final int limit;

  Pagination({
    required this.totalResults,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalResults: json['totalResults'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}

