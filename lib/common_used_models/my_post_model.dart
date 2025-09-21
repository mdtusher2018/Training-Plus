class MyPost {
  final String id;
  final Author author;
  final String caption;
  final String category;
  final int likeCount;
  final int commentCount;
  final String createdAt;
  final bool isLiked;

  MyPost({
    required this.id,
    required this.author,
    required this.caption,
    required this.category,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.isLiked,
  });

  factory MyPost.fromJson(Map<String, dynamic> json) {
    return MyPost(
      id: json["_id"] ?? "",
      author: Author.fromJson(json["author"]??{}),
      caption: json["caption"] ?? "",
      category: json["category"] ?? "",
      likeCount: json["likeCount"] ?? 0,
      commentCount: json["commentCount"] ?? 0,
      createdAt: json["createdAt"] ?? "2025-09-16T01:47:16.889Z",
      isLiked: json["isLiked"] ?? false,
    );
  }
  MyPost copyWith({
    String? id,
    Author? author,
    String? caption,
    String? category,
    int? likeCount,
    int? commentCount,
    String? createdAt,
    bool? isLiked,
  }) {
    return MyPost(
      id: id ?? this.id,
      author: author ?? this.author,
      caption: caption ?? this.caption,
      category: category ?? this.category,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

}
class Author {
  final String fullName;
  final String image;

  Author({
    required this.fullName,
    required this.image,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      fullName: json["fullName"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "image": image,
    };
  }
}