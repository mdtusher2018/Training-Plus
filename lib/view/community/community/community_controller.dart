import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/common_used_models/active_challenge_model.dart';
import 'package:training_plus/common_used_models/my_post_model.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'community_model.dart'; // <- your model file

// ---------------- STATE ----------------
class CommunityState {
  final bool isLoading;
  final String? error;
  final CommunityData? data;

  CommunityState({this.isLoading = false, this.error, this.data});

  CommunityState copyWith({
    bool? isLoading,
    String? error,
    CommunityData? data,
  }) {
    return CommunityState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

// ---------------- CONTROLLER ----------------
class CommunityController extends StateNotifier<CommunityState> {
  final IApiService apiService;

  CommunityController(this.apiService) : super(CommunityState());

  Future<void> fetchCommunity() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.get(ApiEndpoints.community);

      if (response != null && response['statusCode'] == 200) {
        final community = CommunityResponseModel.fromJson(
          response,
        ); // parse JSON to model
        state = state.copyWith(isLoading: false, data: community.data);
      } else {
        final errorMsg =
            response != null && response['message'] != null
                ? response['message']
                : "Failed to fetch community";
        state = state.copyWith(isLoading: false, error: errorMsg);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void deletePost({required String postId}) {
    final updatedPosts =
        state.data!.mypost.where((p) => p.id != postId).toList();
    state = state.copyWith(data: state.data!.copyWith(mypost: updatedPosts));
  }

  void incrementCommentCount({required String postId, required int count}) {
    final updatedPosts =
        state.data!.mypost.map((p) {
          if (p.id == postId) {
            return p.copyWith(commentCount: p.commentCount + 1);
          }
          return p;
        }).toList();

    state = state.copyWith(data: state.data!.copyWith(mypost: updatedPosts));
  }

  void markChallengeJoined(String challengeId) {
    final updatedChallenges =
        state.data!.activeChallenge.map((challenge) {
          if (challenge.id == challengeId) {
            return ActiveChallenge(
              id: challenge.id,
              challengeName: challenge.challengeName,
              count: challenge.count,
              days: challenge.days,
              point: challenge.point,
              isJoined: true, // ✅ Update flag here
              progress: challenge.progress,
              createdAt: challenge.createdAt,
              expiredAt: challenge.expiredAt,
            );
          }
          return challenge;
        }).toList();

    state = state.copyWith(
      data: state.data!.copyWith(activeChallenge: updatedChallenges),
    );
  }

  void addMyPostManually(MyPost? myPost) {
    if (myPost != null) {
      final updatedMyPosts = [myPost, ...?state.data?.mypost];
      final updatedData = state.data?.copyWith(mypost: updatedMyPosts);

      state = state.copyWith(data: updatedData);
    }
  }
}
