class FaqAttribute {
  final String id;
  final String question;
  final String answer;

  FaqAttribute({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FaqAttribute.fromJson(Map<String, dynamic> json) => FaqAttribute(
        id: json['_id'] ?? '',
        question: json['question'] ?? '',
        answer: json['answer'] ?? '',
      );
}

class FaqResponse {
  final int status;
  final String message;
  final List<FaqAttribute> data;
  final List<dynamic>? errors;

  FaqResponse({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json['data']?['attributes']['result'];
    final faqList = <FaqAttribute>[];

    if (attributes != null && attributes is List) {
      for (var item in attributes) {
        if (item is Map<String, dynamic>) {
          faqList.add(FaqAttribute.fromJson(item));
        }
      }
    }

    return FaqResponse(
      status: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: faqList,
      errors: json['errors'] != null ? List<dynamic>.from(json['errors']) : null,
    );
  }
}
