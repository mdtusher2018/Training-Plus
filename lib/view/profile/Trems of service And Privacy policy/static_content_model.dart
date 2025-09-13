class StaticContentModel {
  final String id;
  final String content;

  StaticContentModel({
    required this.id,
    required this.content,
  });

  factory StaticContentModel.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] ?? {};
    return StaticContentModel(
      id: attrs['_id'] ?? '',
      content: attrs['content'] ?? '',
    );
  }
}