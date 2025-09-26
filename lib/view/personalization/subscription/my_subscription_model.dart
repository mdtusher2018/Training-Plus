import 'package:training_plus/view/personalization/subscription/subscription_model.dart';

class MySubscriptionResponse {
  final String status;
  final int statusCode;
  final String message;
  final MySubscriptionData data;
  final List<dynamic> errors;

  MySubscriptionResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory MySubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return MySubscriptionResponse(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: MySubscriptionData.fromJson(json['data']),
      errors: json['errors'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'statusCode': statusCode,
        'message': message,
        'data': data.toJson(),
        'errors': errors,
      };
}

class MySubscriptionData {
  final String type;
  final MySubscriptionAttributes attributes;

  MySubscriptionData({
    required this.type,
    required this.attributes,
  });

  factory MySubscriptionData.fromJson(Map<String, dynamic> json) {
    return MySubscriptionData(
      type: json['type'] ?? '',
      attributes: MySubscriptionAttributes.fromJson(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'attributes': attributes.toJson(),
      };
}

class MySubscriptionAttributes {
  final String id;
  final String user;
  final SubscriptionPlan subscription;
  final String planName;
  final DateTime expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  MySubscriptionAttributes({
    required this.id,
    required this.user,
    required this.subscription,
    required this.planName,
    required this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory MySubscriptionAttributes.fromJson(Map<String, dynamic> json) {
    return MySubscriptionAttributes(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      subscription: SubscriptionPlan.fromJson(json['subscription']),
      planName: json['planName'] ?? '',
      expiryDate: DateTime.parse(json['expiryDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user,
        'subscription': subscription.toJson(),
        'planName': planName,
        'expiryDate': expiryDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };
}


