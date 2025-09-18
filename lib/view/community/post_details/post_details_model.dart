class PostDetails {
  final String id;
  final String caption;
  final String category;
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final String createdAt;
  final String updatedAt;
  final PostAuthor postAuthor;
  final List<PostComment> comments;

  PostDetails({
    required this.id,
    required this.caption,
    required this.category,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    required this.postAuthor,
    required this.comments,
  });

  factory PostDetails.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    return PostDetails(
      id: attributes['_id'] ?? '',
      caption: attributes['caption'] ?? '',
      category: attributes['category'] ?? '',
      isLiked: attributes['isLiked'] ?? false,
      likeCount: attributes['likeCount'] ?? 0,
      commentCount: attributes['commentCount'] ?? 0,
      createdAt: attributes['createdAt'] ?? '',
      updatedAt: attributes['updatedAt'] ?? '',
      postAuthor: PostAuthor.fromJson(attributes['postAuthor']),
      comments:
          (attributes['comments'] as List<dynamic>? ?? [])
              .map((e) => PostComment.fromJson(e))
              .toList(),
    );
  }
  PostDetails copyWith({
    String? id,
    String? caption,
    String? category,
    bool? isLiked,
    int? likeCount,
    int? commentCount,
    String? createdAt,
    String? updatedAt,
    PostAuthor? postAuthor,
    List<PostComment>? comments,
  }) {
    return PostDetails(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      category: category ?? this.category,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      postAuthor: postAuthor ?? this.postAuthor,
      comments: comments ?? this.comments,
    );
  }
}

class PostAuthor {
  final String fullName;
  final String image;

  PostAuthor({required this.fullName, required this.image});

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      fullName: json['fullName'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class PostComment {
  final String id;
  final String userId;
  final String postId;
  final String text;
  final String createdAt;
  final String updatedAt;
  final String userFullName;
  final String userImage;

  PostComment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.userFullName,
    required this.userImage,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      postId: json['post'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      userFullName: json['userFullName'] ?? '',
      userImage: json['userImage'] ?? '',
    );
  }
}
