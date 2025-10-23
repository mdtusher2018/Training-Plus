import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/common_used_models/leader_board_model.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'leaderboard_model.dart';

class LeaderboardState {
  final bool isLoading;
  final String? error;
  final Leaderboard? leaderboard;

  LeaderboardState({
    this.isLoading = false,
    this.error,
    this.leaderboard,
  });

  LeaderboardState copyWith({
    bool? isLoading,
    String? error,
    Leaderboard? leaderboard,
  }) {
    return LeaderboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      leaderboard: leaderboard ?? this.leaderboard,
    );
  }
}

class LeaderboardController extends StateNotifier<LeaderboardState> {
  final IApiService apiService;

  LeaderboardController(this.apiService) : super(LeaderboardState());

  Future<void> fetchLeaderboard() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiService.get(ApiEndpoints.leaderboard);
      if (response != null && response['statusCode'] == 200) {
        final parsed = LeaderboardFullResponse.fromJson(response);
        state = state.copyWith(
          isLoading: false,
          leaderboard: parsed.data,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response?['message'] ?? 'Failed to fetch leaderboard',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

