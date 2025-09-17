import 'package:training_plus/common_used_models/feed_model.dart';
import 'package:training_plus/common_used_models/pagination_model.dart';

class FeedResponseModel {
  final String status;
  final int statusCode;
  final String message;
  final FeedData? data;
  final List<dynamic> errors;

  FeedResponseModel({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
    this.errors = const [],
  });

  factory FeedResponseModel.fromJson(Map<String, dynamic> json) {
    return FeedResponseModel(
      status: json["status"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      data: json["data"] != null ? FeedData.fromJson(json["data"]) : null,
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

class FeedData {
  final String? type;
  final FeedAttributes? attributes;

  FeedData({this.type, this.attributes});

  factory FeedData.fromJson(Map<String, dynamic> json) {
    return FeedData(
      type: json["type"],
      attributes: json["attributes"] != null
          ? FeedAttributes.fromJson(json["attributes"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "attributes": attributes?.toJson(),
    };
  }
}

class FeedAttributes {
  final List<Feed> feed;
  final Pagination? pagination;

  FeedAttributes({this.feed = const [], this.pagination});

  factory FeedAttributes.fromJson(Map<String, dynamic> json) {
    return FeedAttributes(
      feed: (json["feed"] as List<dynamic>?)
              ?.map((e) => Feed.fromJson(e))
              .toList() ??
          [],
      pagination: json["pagination"] != null
          ? Pagination.fromJson(json["pagination"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "feed": feed.map((e) => e.toJson()).toList(),
      "pagination": pagination?.toJson(),
    };
  }
}
