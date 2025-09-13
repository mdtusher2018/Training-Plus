class BadgeShelfResponse {
  final String status;
  final int statusCode;
  final String message;
  final BadgeShelfData data;
  final List<dynamic> errors;

  BadgeShelfResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory BadgeShelfResponse.fromJson(Map<String, dynamic> json) {
    return BadgeShelfResponse(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: BadgeShelfData.fromJson(json['data']),
      errors: json['errors'] ?? [],
    );
  }
}

class BadgeShelfData {
  final String type;
  final List<BadgeShelf> attributes;

  BadgeShelfData({
    required this.type,
    required this.attributes,
  });

  factory BadgeShelfData.fromJson(Map<String, dynamic> json) {
    return BadgeShelfData(
      type: json['type'] ?? '',
      attributes: (json['attributes'] as List<dynamic>)
          .map((attr) => BadgeShelf.fromJson(attr))
          .toList(),
    );
  }
}

class BadgeShelf {
  final String badgeName;
  final String badgeImage;
  final String description;

  BadgeShelf({
    required this.badgeName,
    required this.badgeImage,
    required this.description,
  });

  factory BadgeShelf.fromJson(Map<String, dynamic> json) {
    return BadgeShelf(
      badgeName: json['badgeName'] ?? '',
      badgeImage: json['badgeImage'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
