// view/authentication/forget_password/reset_password_model.dart

class CreateNewPasswordModel {
  final String type;
  final String status;
  final int statusCode;
  final String message;

  CreateNewPasswordModel({
    required this.type,
    required this.status,
    required this.statusCode,
    required this.message,
  });

  factory CreateNewPasswordModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return CreateNewPasswordModel(
      type: data['type'] ?? '',
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
      },
    };
  }
}
