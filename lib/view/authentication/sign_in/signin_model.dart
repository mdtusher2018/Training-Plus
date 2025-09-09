// view/authentication/sign_in/signin_model.dart

class SignInModel {
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

  SignInModel({
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

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['data']['attributes'];
    return SignInModel(
      id: attributes['_id'],
      fullName: attributes['fullName'],
      email: attributes['email'],
      image: attributes['image'],
      role: attributes['role'],
      isBan: attributes['isBan'],
      isComplete: attributes['isComplete'],
      points: attributes['points'],
      workoutCount: attributes['workoutCount'],
      achievementCount: attributes['achievementCount'],
      sports: List<String>.from(attributes['sports'] ?? []),
      yourReferralCode: attributes['yourRefaralCode'],
      accessToken: json['data']['accessToken'],
    );
  }
}
