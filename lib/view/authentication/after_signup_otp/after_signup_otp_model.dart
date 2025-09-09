// view/authentication/signup/signup_model.dart

class AfterSignUpOTPModel {
  final String id;
  final String fullName;
  final String email;
  final String image;
  final String role;
  final bool isBan;
  final bool isComplete;
  final int points;
  final int workoutCount;
  final int achievementCount;
  final List<String> sports;
  final String yourReferralCode;
  final String accessToken;

  AfterSignUpOTPModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.image,
    required this.role,
    required this.isBan,
    required this.isComplete,
    required this.points,
    required this.workoutCount,
    required this.achievementCount,
    required this.sports,
    required this.yourReferralCode,
    required this.accessToken,
  });

  factory AfterSignUpOTPModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['data']['attributes'];
    return AfterSignUpOTPModel(
      id: attributes['_id'] ?? '',
      fullName: attributes['fullName'] ?? '',
      email: attributes['email'] ?? '',
      image: attributes['image'] ?? '',
      role: attributes['role'] ?? '',
      isBan: attributes['isBan'] ?? false,
      isComplete: attributes['isComplete'] ?? false,
      points: attributes['points'] ?? 0,
      workoutCount: attributes['workoutCount'] ?? 0,
      achievementCount: attributes['achievementCount'] ?? 0,
      sports: List<String>.from(attributes['sports'] ?? []),
      yourReferralCode: attributes['yourRefaralCode'] ?? '',
      accessToken: json['data']['accessToken'] ?? '',
    );
  }
}
