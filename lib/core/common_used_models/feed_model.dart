
class Feed {
  final String id;
  final String caption;
  final String category;
  final int likeCount;
  final int commentCount;
  final String createdAt;
  final bool isLiked;
  final String authorName;
  final String authorImage;

  Feed({
    required this.id,
    required this.caption,
    required this.category,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.isLiked,
    required this.authorName,
    required this.authorImage,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json["_id"] ?? "",
      caption: json["caption"] ?? "",
      category: json["category"] ?? "",
      likeCount: json["likeCount"] ?? 0,
      commentCount: json["commentCount"] ?? 0,
      createdAt: json["createdAt"] ?? "",
      isLiked: json["isLiked"] ?? false,
      authorName: json["authorName"] ?? "",
      authorImage: json["authorImage"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "caption": caption,
      "category": category,
      "likeCount": likeCount,
      "commentCount": commentCount,
      "createdAt": createdAt,
      "isLiked": isLiked,
      "authorName": authorName,
      "authorImage": authorImage,
    };
  }
}
