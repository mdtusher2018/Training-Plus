import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/home/home_providers.dart';
import 'post_details_model.dart';

// ------------------- State -------------------
class PostDetailsState {
  final bool isLoading;
  final String? error;
  final PostDetails? postDetails;

  PostDetailsState({
    this.isLoading = false,
    this.error,
    this.postDetails,
  });

  PostDetailsState copyWith({
    bool? isLoading,
    String? error,
    PostDetails? postDetails,
  }) {
    return PostDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      postDetails: postDetails ?? this.postDetails,
    );
  }
}

// ------------------- Controller -------------------
class PostDetailsController extends StateNotifier<PostDetailsState> {
  final IApiService apiService;

  PostDetailsController(this.apiService) : super(PostDetailsState());

  /// Fetch post details by ID
  Future<void> fetchPostDetails(String postId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiService.get(ApiEndpoints.postDetails(postId));

      if (response != null && response["statusCode"] == 200) {
        final postData = response['data'];
        final postDetails = PostDetails.fromJson(postData);
        state = state.copyWith(postDetails: postDetails);
      } else {
        state = state.copyWith(error: response?["message"] ?? "Failed to fetch post details");
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Add a comment to the post
  Future<Map<String, String>> addComment(String postId, String text,{required WidgetRef ref}) async {
    try {
        final homePageState = ref.watch(homeControllerProvider);
      final response = await apiService.post(ApiEndpoints.commentPost, {
        "post": postId,
        "text": text,
      });

      if (response != null && response["statusCode"] == 201) {
        // Optionally, update local state with new comment
      final newComment = PostComment(
        id: response['data']['attributes']['_id'] ?? '',
        userId: response['data']['attributes']['user'] ?? '',
        postId: postId,
        text: text,
        createdAt: response['data']['attributes']['createdAt'] ?? DateTime.now().toIso8601String(),
        updatedAt: response['data']['attributes']['updatedAt'] ?? DateTime.now().toIso8601String(),
        userFullName: homePageState.response?.user?.fullName??"You",
        userImage: homePageState.response?.user?.image??"", 
      );

        final updatedComments = [
          newComment,
          ...?state.postDetails?.comments,
        ];
        

final commentCount=(state.postDetails?.commentCount??0)+1;

        final updatedPost = state.postDetails?.copyWith(comments: updatedComments,commentCount: commentCount);

log(updatedPost!.commentCount.toString());

        state = state.copyWith(postDetails: updatedPost);

        return {"title": "Success", "message": "Comment added"};
      } else {
        return {"title": "Error", "message": response?["message"] ?? "Failed to add comment"};
      }
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    }
  }
}
