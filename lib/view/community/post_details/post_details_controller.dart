import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/home/home_providers.dart';
import 'post_details_model.dart';

// ------------------- State -------------------
class PostDetailsState {
  final bool isLoading;
  final bool userBlockLoading;
  final bool userReportLoading;
  final bool isSending;
  final String? error;
  final PostDetails? postDetails;

  PostDetailsState({
    this.isLoading = false,
    this.isSending = false,
    this.userBlockLoading = false,
    this.userReportLoading = false,
    this.error,
    this.postDetails,
  });

  PostDetailsState copyWith({
    bool? isLoading,
    bool? userBlockLoading,
    bool? userReportLoading,
    bool? isSending,
    String? error,
    PostDetails? postDetails,
  }) {
    return PostDetailsState(
      isLoading: isLoading ?? this.isLoading,
      userBlockLoading: userBlockLoading ?? this.userBlockLoading,
      userReportLoading: userReportLoading ?? this.userReportLoading,
      isSending: isSending ?? this.isSending,
      error: error,
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
        state = state.copyWith(
          error: response?["message"] ?? "Failed to fetch post details",
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Add a comment to the post
  Future<Map<String, String>> addComment(
    String postId,
    String text, {
    required WidgetRef ref,
  }) async {
    try {
      state = state.copyWith(isSending: true);
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
          createdAt:
              response['data']['attributes']['createdAt'] ??
              DateTime.now().toIso8601String(),
          updatedAt:
              response['data']['attributes']['updatedAt'] ??
              DateTime.now().toIso8601String(),
          userFullName: homePageState.response?.user?.fullName ?? "You",
          userImage: homePageState.response?.user?.image ?? "",
        );

        final updatedComments = [newComment, ...?state.postDetails?.comments];

        final commentCount = (state.postDetails?.commentCount ?? 0) + 1;

        final updatedPost = state.postDetails?.copyWith(
          comments: updatedComments,
          commentCount: commentCount,
        );

        log(updatedPost!.commentCount.toString());

        state = state.copyWith(postDetails: updatedPost);

        return {"title": "Success", "message": "Comment added"};
      } else {
        return {
          "title": "Error",
          "message": response?["message"] ?? "Failed to add comment",
        };
      }
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    } finally {
      state = state.copyWith(isSending: false);
    }
  }

  /// Block user by ID
  Future<Map<String, String>> blockUser(String userId) async {
    try {
      state = state.copyWith(userBlockLoading: true);

      final response = await apiService.put(ApiEndpoints.blockUser(userId), {});

      if (response != null && response["statusCode"] == 200) {
        return {"title": "Success", "message": "User blocked sucessfully"};
      } else {
        return {
          "title": "Error",
          "message": response?["message"] ?? "Failed to block this user",
        };
      }
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    } finally {
      state = state.copyWith(userBlockLoading: false);
    }
  }

  Future<Map<String, String>> reportPost(String postId, String reason) async {
    try {
      state = state.copyWith(userReportLoading: true);

      final response = await apiService.post(ApiEndpoints.reportAPost, {
        "post": postId,
        "reason": reason,
      });

      if (response != null && response["statusCode"] == 201) {
        return {"title": "Success", "message": "Post reported successfully"};
      } else {
        return {
          "title": "Error",
          "message": response?["message"] ?? "Failed to report this post",
        };
      }
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    } finally {
      state = state.copyWith(userReportLoading: false);
    }
  }
}
