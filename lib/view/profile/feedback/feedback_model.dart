class FeedbackResponse {
  final String status;
  final int statusCode;
  final String message;
  final List<dynamic>? errors;

  FeedbackResponse({
    required this.status,
    required this.message,
    required this.statusCode,
    this.errors,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      errors: json['errors']??[],
      statusCode: json['statusCode']??0
    );
  }

  /// Convenience getter
  bool get isSuccess => statusCode == 201;
}
