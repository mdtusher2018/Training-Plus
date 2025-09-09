// view/authentication/forget_password/forget_password_otp_model.dart

class ForgetPasswordOtpModel {
  final String type;
  final String forgetPasswordToken;
  final String status;
  final int statusCode;
  final String message;

  ForgetPasswordOtpModel({
    required this.type,
    required this.forgetPasswordToken,
    required this.status,
    required this.statusCode,
    required this.message,
  });

  factory ForgetPasswordOtpModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return ForgetPasswordOtpModel(
      type: data['type'] ?? '',
      forgetPasswordToken: data['forgetPasswordToken'] ?? '',
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'data': {
        'type': type,
        'forgetPasswordToken': forgetPasswordToken,
      },
    };
  }
}
