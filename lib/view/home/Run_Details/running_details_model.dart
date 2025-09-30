class RunningHistoryResponse {
  final String status;
  final int statusCode;
  final String message;
  final RunningHistoryData data;
  final List<dynamic> errors;

  RunningHistoryResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory RunningHistoryResponse.fromJson(Map<String, dynamic> json) {
    return RunningHistoryResponse(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: RunningHistoryData.fromJson(json['data']),
      errors: json['errors'] ?? [],
    );
  }
}

class RunningHistoryData {
  final String type;
  final RunningHistoryAttributes attributes;

  RunningHistoryData({
    required this.type,
    required this.attributes,
  });

  factory RunningHistoryData.fromJson(Map<String, dynamic> json) {
    return RunningHistoryData(
      type: json['type'] ?? '',
      attributes: RunningHistoryAttributes.fromJson(json['attributes']),
    );
  }
}

class RunningHistoryAttributes {
  final String id;
  final List<String> deviceId;
  final MongooId mongooId;
  final User user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  RunningHistoryAttributes({
    required this.id,
    required this.deviceId,
    required this.mongooId,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory RunningHistoryAttributes.fromJson(Map<String, dynamic> json) {
    return RunningHistoryAttributes(
      id: json['_id'] ?? '',
      deviceId: List<String>.from(json['deviceId'] ?? []),
      mongooId: MongooId.fromJson(json['mongooId']),
      user: User.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }
}

class MongooId {
  final String id;
  final String image;
  final String place;
  final double distance;
  final int time;
  final String pace;
  final String createdAt;

  MongooId({
    required this.id,
    required this.image,
    required this.place,
    required this.distance,
    required this.time,
    required this.pace,
    required this.createdAt,
  });

  factory MongooId.fromJson(Map<String, dynamic> json) {
    return MongooId(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      place: json['place'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      time: json['time'] ?? 0,
      pace: json['pace'] ?? '',
      createdAt: json['createdAt']??"",
    );
  }
}

class User {
  final String id;
  final String email;

  User({
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
