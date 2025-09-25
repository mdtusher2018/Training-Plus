// ---- STATE ----
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/common_used_models/active_challenge_model.dart';
import 'package:training_plus/common_used_models/pagination_model.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/community/active_challenges/active_challenges_model.dart';
import 'package:training_plus/view/community/comunity_provider.dart';

class ActiveChallengeState {
  final bool isLoading;
  final bool isFetchingMore;
  final String? error;
  final List<ActiveChallenge> challenges;
  final Pagination? pagination;
  final bool hasMore;
  final int currentPage;

  ActiveChallengeState({
    this.isLoading = false,
    this.isFetchingMore = false,
    this.error,
    this.challenges = const [],
    this.pagination,
    this.hasMore = true,
    this.currentPage=1,
  });

  ActiveChallengeState copyWith({
    bool? isLoading,
    bool? isFetchingMore,
    String? error,
    List<ActiveChallenge>? challenges,
    Pagination? pagination,
    bool? hasMore,
    int? currentPage,
  }) {
    return ActiveChallengeState(
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      error: error,
      challenges: challenges ?? this.challenges,
      pagination: pagination ?? this.pagination,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage??this.currentPage
    );
  }
}

class ActiveChallengeController extends StateNotifier<ActiveChallengeState> {
  final IApiService apiService;

  ActiveChallengeController(this.apiService) : super(ActiveChallengeState());

  Future<void> fetchActiveChallenges({
    int? page,
    int limit = 10,
    bool loadMore = false,
  }) async {
    final targetPage = page ?? (loadMore ? state.currentPage + 1 : 1);

    if (loadMore) {
      if (!state.hasMore || state.isFetchingMore) return;
      state = state.copyWith(isFetchingMore: true, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null, challenges: []);
    }

    try {
      final response = await apiService.get(
        ApiEndpoints.activeChallenges(page: targetPage, limit: limit),
      );

      if (response != null && response["statusCode"] == 200) {
        final parsed = ActiveChallengeResponse.fromJson(response);

        final newChallenges = parsed.data?.attributes.challenges ?? [];
        final pagination = parsed.data?.attributes.pagination;

        state = state.copyWith(
          isLoading: false,
          isFetchingMore: false,
          challenges: loadMore
              ? [...state.challenges, ...newChallenges]
              : newChallenges,
          pagination: pagination,
          hasMore: pagination != null
              ? pagination.currentPage < pagination.totalPages
              : newChallenges.isNotEmpty,
          currentPage: pagination?.currentPage ?? targetPage,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isFetchingMore: false,
          error: response?["message"] ?? "Failed to fetch challenges",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFetchingMore: false,
        error: e.toString(),
      );
    }
  }


  void markChallengeJoined(String challengeId) {
    final updatedChallenges = state.challenges.map((challenge) {
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

    state = state.copyWith(challenges: updatedChallenges);
  }



  /// Join a challenge (example)
  Future<Map<String, String>> joinChallenge({
    required String challengeId,
    required num day,
    required condition,
    required WidgetRef ref
  }) async {
    try {
      final response = await apiService.post(ApiEndpoints.joinChallenge, {
        "challenge": challengeId,
        "days": day,
        "condition" : "run"
      });

      if (response != null && response["statusCode"] == 201) {
        markChallengeJoined(challengeId);
        
          ref.read(communityControllerProvider.notifier).markChallengeJoined(challengeId);
        
        return {
          "title": "Success",
          "message": response["message"] ?? "Challenge joined successfully",

        };
      } else {
        return {
          "title": "Error",
          "message": response?["message"] ?? "Failed to join challenge",
        };
      }
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    }
  }


}
