// import 'package:equatable/equatable.dart';

// class SubscriptionResponse extends Equatable {
//   final String status;
//   final int statusCode;
//   final String message;
//   final SubscriptionData data;
//   final List<dynamic> errors;

//   const SubscriptionResponse({
//     required this.status,
//     required this.statusCode,
//     required this.message,
//     required this.data,
//     required this.errors,
//   });

//   factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
//     return SubscriptionResponse(
//       status: json['status'] ?? '',
//       statusCode: json['statusCode'] ?? 0,
//       message: json['message'] ?? '',
//       data: SubscriptionData.fromJson(json['data']),
//       errors: json['errors'] ?? [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "status": status,
//       "statusCode": statusCode,
//       "message": message,
//       "data": data.toJson(),
//       "errors": errors,
//     };
//   }

//   @override
//   List<Object?> get props => [status, statusCode, message, data, errors];
// }

// class SubscriptionData extends Equatable {
//   final String type;
//   final List<SubscriptionPlan> attributes;

//   const SubscriptionData({
//     required this.type,
//     required this.attributes,
//   });

//   factory SubscriptionData.fromJson(Map<String, dynamic> json) {
//     return SubscriptionData(
//       type: json['type'] ?? '',
//       attributes: (json['attributes'] as List<dynamic>? ?? [])
//           .map((e) => SubscriptionPlan.fromJson(e))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "type": type,
//       "attributes": attributes.map((e) => e.toJson()).toList(),
//     };
//   }

//   @override
//   List<Object?> get props => [type, attributes];
// }

// class SubscriptionPlan extends Equatable {
//   final String id;
//   final String planName;
//   final bool nutritionTracker;
//   final bool runningTracker;
//   final double price;
//   final String stripePriceId;
//   final String createdAt;
//   final String updatedAt;
//   final int v;

//   const SubscriptionPlan({
//     required this.id,
//     required this.planName,
//     required this.nutritionTracker,
//     required this.runningTracker,
//     required this.price,
//     required this.stripePriceId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });

//   factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
//     return SubscriptionPlan(
//       id: json['_id'] ?? '',
//       planName: json['planName'] ?? '',
//       nutritionTracker: json['nutritionTracker'] ?? false,
//       runningTracker: json['runningTracker'] ?? false,
//       price: (json['price'] is int)
//           ? (json['price'] as int).toDouble()
//           : (json['price'] as num).toDouble(),
//       stripePriceId: json['stripePriceId'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       v: json['__v'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "planName": planName,
//       "nutritionTracker": nutritionTracker,
//       "runningTracker": runningTracker,
//       "price": price,
//       "stripePriceId": stripePriceId,
//       "createdAt": createdAt,
//       "updatedAt": updatedAt,
//       "__v": v,
//     };
//   }

//   @override
//   List<Object?> get props => [
//         id,
//         planName,
//         nutritionTracker,
//         runningTracker,
//         price,
//         stripePriceId,
//         createdAt,
//         updatedAt,
//         v,
//       ];
// }


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

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
      'errors': errors,
    };
  }
}

class SubscriptionData {
  final String type;
  final List<SubscriptionPlan> attributes;

  SubscriptionData({
    required this.type,
    required this.attributes,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      type: json['type'] ?? '',
      attributes: (json['attributes'] as List<dynamic>?)
              ?.map((e) => SubscriptionPlan.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'attributes': attributes.map((e) => e.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'planName': planName,
      'nutritionTracker': nutritionTracker,
      'runningTracker': runningTracker,
      'price': price,
      'stripePriceId': stripePriceId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}







