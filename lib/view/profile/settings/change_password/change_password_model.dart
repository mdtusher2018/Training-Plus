// view/authentication/change_password/change_password_model.dart

class ChangePasswordModel {
  final String status;
  final int statusCode;
  final String message;
  final String type; // from data.type

  ChangePasswordModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.type,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      type: json['data']?['type'] ?? '',
    );
  }

  bool get isSuccess => statusCode == 200;
}
