import 'package:training_plus/common_used_models/active_challenge_model.dart';
import 'package:training_plus/common_used_models/pagination_model.dart';

class ActiveChallengeResponse {
  final String status;
  final int statusCode;
  final String message;
  final ActiveChallengeData? data;
  final List<dynamic> errors;

  ActiveChallengeResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
    required this.errors,
  });

  factory ActiveChallengeResponse.fromJson(Map<String, dynamic> json) {
    return ActiveChallengeResponse(
      status: json["status"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? ActiveChallengeData.fromJson(json["data"])
          : null,
      errors: json["errors"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "statusCode": statusCode,
      "message": message,
      "data": data?.toJson(),
      "errors": errors,
    };
  }
}

class ActiveChallengeData {
  final String type;
  final ActiveChallengeAttributes attributes;

  ActiveChallengeData({
    required this.type,
    required this.attributes,
  });

  factory ActiveChallengeData.fromJson(Map<String, dynamic> json) {
    return ActiveChallengeData(
      type: json["type"] ?? "",
      attributes: ActiveChallengeAttributes.fromJson(json["attributes"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "attributes": attributes.toJson(),
    };
  }
}

class ActiveChallengeAttributes {
  final List<ActiveChallenge> challenges;
  final Pagination pagination;

  ActiveChallengeAttributes({
    required this.challenges,
    required this.pagination,
  });

  factory ActiveChallengeAttributes.fromJson(Map<String, dynamic> json) {
    return ActiveChallengeAttributes(
      challenges: (json["challenges"] as List<dynamic>? ?? [])
          .map((e) => ActiveChallenge.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json["pagination"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "challenges": challenges.map((e) => e.toJson()).toList(),
      "pagination": pagination.toJson(),
    };
  }
}

