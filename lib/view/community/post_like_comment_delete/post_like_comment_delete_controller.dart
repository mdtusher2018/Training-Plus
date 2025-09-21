import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/view/community/post_like_comment_delete/comment_model.dart';
import 'package:training_plus/view/home/home_providers.dart';

class PostLikeState {
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final List<PostCommentById> comments; // added list of comments
  final bool isLoadingComments; // optional: loading state for comments

  PostLikeState({
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    this.comments = const [],
    this.isLoadingComments = false,
  });

  PostLikeState copyWith({
    bool? isLiked,
    int? likeCount,
    int? commentCount,
    List<PostCommentById>? comments,
    bool? isLoadingComments,
  }) {
    return PostLikeState(
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
    );
  }
}

class PostLikeCommentDeleteController extends StateNotifier<PostLikeState> {
  final IApiService apiService;
  final String postId;

  PostLikeCommentDeleteController({
    required this.apiService,
    required this.postId,
    required bool initialLiked,
    required int initialCount,
    required int initialCommentCount,
  }) : super(
         PostLikeState(
           isLiked: initialLiked,
           likeCount: initialCount,
           commentCount: initialCommentCount,
         ),
       );

  Future<void> toggleLike() async {
    final previous = state;

    // Optimistic update
    state = state.copyWith(
      isLiked: !previous.isLiked,
      likeCount:
          previous.isLiked ? previous.likeCount - 1 : previous.likeCount + 1,
    );

    try {
      final response = await apiService.post(ApiEndpoints.likePost, {
        "post": postId,
      });

      if (response == null || response["statusCode"] != 201) {
        // revert if API fails
        state = previous;
      }
    } catch (e) {
      state = previous;
    }
  }




  Future<Map<String, String>> postComment(
    String text, {
    required WidgetRef ref,//related with bottomsheet
    required WidgetRef parentRef,//related with parent page of bottomsheet
  }) async {
    if (text.trim().isEmpty) {
      return {"title": "Error", "message": "Comment cannot be empty"};
    }
    final homePageState = ref.watch(homeControllerProvider);
    try {
      final response = await apiService.post(ApiEndpoints.commentPost, {
        "post": postId,
        "text": text,
      });

      if (response != null && response["statusCode"] == 201) {
        final newComment = PostCommentById(
          id: response['data']['attributes']['_id'] ?? '',

          user: CommentUser(
            fullName: homePageState.response?.user?.fullName ?? "You",
            image: homePageState.response?.user?.image ?? "",
          ),
          text: text,
          createdAt:
              response['data']['attributes']['createdAt'] ??
              DateTime.now().toIso8601String(),
        );

        final updatedComments = [newComment, ...state.comments];

        state = state.copyWith(comments: updatedComments);


       parentRef.read(
          myPostControllerProvider.notifier,
          ).incrementCommentCount(postId: postId, count:state.commentCount);
          

       parentRef.read(
          communityControllerProvider.notifier,
          ).incrementCommentCount(postId: postId, count:state.commentCount);





        return {
          "title": "Success",
          "message": response["message"] ?? "Comment posted successfully",
        };
      } else {
        return {
          "title": "Error",
          "message": response?["message"] ?? "Failed to post comment",
        };
      }
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    }
  }

  Future<Map<String, String>> deletePost({
    required String postId,
    required WidgetRef parentRef,
  }) async {
    try {
      final response = await apiService.delete(ApiEndpoints.deletePost(postId));

      if (response != null && response["statusCode"] == 200) {
        parentRef
            .read(myPostControllerProvider.notifier)
            .deletePost(postId: postId);
        parentRef
            .read(communityControllerProvider.notifier)
            .deletePost(postId: postId);
        return {
          "title": "Success",
          "message": response["message"] ?? "Post deleted successfully",
        };
      } else {
        return {
          "title": "Error",
          "message": response?["message"] ?? "Failed to delete post",
        };
      }
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    }
  }

  Future<void> fetchCommentsByPostId() async {
    try {
      final response = await apiService.get(
        ApiEndpoints.getCommentByPostId(postId),
      );
      if (response != null && response["statusCode"] == 200) {
        final parsed = CommentsByPostIdResponse.fromJson(response);
        state = state.copyWith(comments: parsed.comments); // Update the state
      }
    } catch (e) {
      log("Failed to fetch comments: $e");
    }
  }
}
