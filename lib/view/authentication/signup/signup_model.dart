
class SignUpModel {
  final String type;
  final String signUpToken;

  SignUpModel({
    required this.type,
    required this.signUpToken,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return SignUpModel(
      type: data['type'],
      signUpToken: data['signUpToken'],
    );
  }
}
