import 'dart:convert';

import 'package:training_plus/common_used_models/pagination_model.dart';

class NotificationResponse {
  final String status;
  final int statusCode;
  final String message;
  final NotificationData? data;
  final List<dynamic>? errors;

  NotificationResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? NotificationData.fromJson(json['data']) : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
        "errors": errors,
      };
}

/// Data wrapper
class NotificationData {
  final String type;
  final NotificationAttributes? attributes;

  NotificationData({
    required this.type,
    this.attributes,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      type: json['type'] ?? '',
      attributes: json['attributes'] != null
          ? NotificationAttributes.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "attributes": attributes?.toJson(),
      };
}

/// Attributes
class NotificationAttributes {
  final List<NotificationItem> notification;
  final Pagination pagination;

  NotificationAttributes({
    required this.notification,
    required this.pagination,
  });

  factory NotificationAttributes.fromJson(Map<String, dynamic> json) {
    return NotificationAttributes(
      notification: (json['notification'] as List<dynamic>)
          .map((e) => NotificationItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']??{}),
    );
  }

  Map<String, dynamic> toJson() => {
        "notification": notification.map((e) => e.toJson()).toList(),
        "pagination": pagination.toJson(),
      };
}

/// Single notification item
class NotificationItem {
  final String id;
  final String targetUser;
  final String postId;
  final String message;
  final bool isRead;
  final bool forAdmin;
  final String createdAt;
  final String updatedAt;
  final int v;

  NotificationItem({
    required this.id,
    required this.targetUser,
    required this.postId,
    required this.message,
    required this.isRead,
    required this.forAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'] ?? '',
      targetUser: json['targetUser'] ?? '',
      postId: json['postId'] ?? '',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      forAdmin: json['forAdmin'] ?? false,
      createdAt: json['createdAt']??"",
      updatedAt: json['updatedAt']??"",
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "targetUser": targetUser,
        "postId": postId,
        "message": message,
        "isRead": isRead,
        "forAdmin": forAdmin,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}


/// Helpers to parse from raw JSON string
NotificationResponse notificationResponseFromJson(String str) =>
    NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());
