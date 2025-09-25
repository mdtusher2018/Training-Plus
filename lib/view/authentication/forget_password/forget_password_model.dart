// view/authentication/forget_password/forget_password_otp_model.dart

class ForgetPasswordModel {
  final String status;
  final int statusCode;
  final String message;
  final String type; // from data.type
  final String attributes;

  ForgetPasswordModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.type,
    required this.attributes
  });

  factory ForgetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordModel(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      type: json['data']?['type'] ?? '',
      attributes: json['data']?['attributes']??''
    );
  }
}
