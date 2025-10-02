class ProfileModel {
  final String status;
  final int statusCode;
  final String message;
  final UserAttributes attributes; // non-null now
  final List<dynamic> errors;

  ProfileModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.attributes,
    required this.errors,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      attributes: json['data'] != null && json['data']['attributes'] != null
          ? UserAttributes.fromJson(json['data']['attributes'])
          : UserAttributes.empty(), // fallback to empty
      errors: json['errors'] ?? [],
    );
  }
}

class UserAttributes {
  final String id;
  final String fullName;
  final String email;
  final String image;
  final String skillLevel;
  final String ageGroup;
  final int points;
  final String userType;
  final String goal;
  final String referralCode;

  UserAttributes({
    required this.id,
    required this.fullName,
    required this.email,
    required this.image,
    required this.skillLevel,
    required this.ageGroup,
    required this.points,
    required this.userType,
    required this.goal,
    required this.referralCode
  });

  // Factory for creating from JSON
  factory UserAttributes.fromJson(Map<String, dynamic> json) {
    return UserAttributes(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      skillLevel: json['skillLevel'] ?? '',
      ageGroup: json['ageGroup'] ?? '',
      points: json['points'] ?? 0,
      userType: json['userType'] ?? '',
      goal: json['goal'] ?? '',
      referralCode: json['yourRefaralCode']??'N/A'
    );
  }

  // Empty/default values
  factory UserAttributes.empty() {
    return UserAttributes(
      id: '',
      fullName: '',
      email: '',
      image: '',
      skillLevel: '',
      ageGroup: '',
      points: 0,
      userType: '',
      goal: '',
      referralCode: ''
    );
  }
}
