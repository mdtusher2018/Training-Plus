import 'package:training_plus/core/common_used_models/my_post_model.dart';
import 'package:training_plus/core/common_used_models/pagination_model.dart';

class MyPostResponseModel {
  final List<MyPost> posts;
  final Pagination pagination;

  MyPostResponseModel({
    required this.posts,
    required this.pagination,
  });

  factory MyPostResponseModel.fromJson(Map<String, dynamic> json) {
    final attributes = json["data"]?["attributes"] ?? {};
    final resultList = attributes["result"] as List<dynamic>? ?? [];
    final paginationJson = attributes["pagination"] ?? {};

    return MyPostResponseModel(
      posts: resultList.map((e) => MyPost.fromJson(e)).toList(),
      pagination: Pagination.fromJson(paginationJson),
    );
  }


}
