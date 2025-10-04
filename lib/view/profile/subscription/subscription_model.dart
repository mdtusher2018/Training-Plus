class SubscriptionResponse {
  final String status;
  final int statusCode;
  final String message;
  final SubscriptionData data;
  final List<dynamic> errors;

  SubscriptionResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: SubscriptionData.fromJson(json['data'] ?? {}),
      errors: json['errors'] ?? [],
    );
  }
}

class SubscriptionData {
  final String type;
  final List<SubscriptionPlan> attributes;

  SubscriptionData({required this.type, required this.attributes});

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      type: json['type'] ?? '',
      attributes:
          (json['attributes']??[] as List<dynamic>?)
              ?.map((e) => SubscriptionPlan.fromJson(e??{}))
              .toList() ??
          [],
    );
  }
}

class SubscriptionPlan {
  final String id;
  final String planName;
  final bool nutritionTracker;
  final bool runningTracker;
  final double price;
  final String stripePriceId;
  final String createdAt;
  final String updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.planName,
    required this.nutritionTracker,
    required this.runningTracker,
    required this.price,
    required this.stripePriceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['_id'] ?? '',
      planName: json['planName'] ?? '',
      nutritionTracker: json['nutritionTracker'] ?? false,
      runningTracker: json['runningTracker'] ?? false,
      price: (json['price'] ?? 0).toDouble(),
      stripePriceId: json['stripePriceId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
