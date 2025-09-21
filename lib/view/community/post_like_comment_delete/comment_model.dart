class CommentsByPostIdResponse {
  final String status;
  final int statusCode;
  final String message;
  final List<PostCommentById> comments;

  CommentsByPostIdResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.comments,
  });

  factory CommentsByPostIdResponse.fromJson(Map<String, dynamic> json) {
    return CommentsByPostIdResponse(
      status: json["status"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      comments: (json["data"]?["attributes"] as List<dynamic>? ?? [])
          .map((e) => PostCommentById.fromJson(e))
          .toList(),
    );
  }

}

class PostCommentById {
  final String id;
  final CommentUser user;
  final String text;
  final String createdAt;

  PostCommentById({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
  });

  factory PostCommentById.fromJson(Map<String, dynamic> json) {
    return PostCommentById(
      id: json["_id"] ?? "",
      user: CommentUser.fromJson(json["user"] ?? {}),
      text: json["text"] ?? "",
      createdAt: (json["createdAt"] ?? ""),
    );
  }


}

class CommentUser {
  final String fullName;
  final String image;

  CommentUser({
    required this.fullName,
    required this.image,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      fullName: json["fullName"] ?? "",
      image: json["image"] ?? "",
    );
  }

}
