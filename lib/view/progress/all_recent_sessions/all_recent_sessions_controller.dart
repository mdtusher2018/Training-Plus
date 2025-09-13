import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/progress/all_recent_sessions/all_recent_sessions_model.dart';
import 'package:training_plus/view/progress/common_used_models/recent_training_model.dart';

/// --- State ---
class RecentSessionsState {
  final bool isLoading;
  final List<RecentTraining> sessions;
  final String? error;

  RecentSessionsState({
    this.isLoading = false,
    this.sessions = const [],
    this.error,
  });

  RecentSessionsState copyWith({
    bool? isLoading,
    List<RecentTraining>? sessions,
    String? error,
  }) {
    return RecentSessionsState(
      isLoading: isLoading ?? this.isLoading,
      sessions: sessions ?? this.sessions,
      error: error ?? this.error,
    );
  }
}

/// --- Controller ---
class RecentSessionsController extends StateNotifier<RecentSessionsState> {
  final IApiService apiService;

  RecentSessionsController({required this.apiService})
    : super(RecentSessionsState());

  Future<void> fetchRecentSessions() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.recentSessions);
      if (response != null && response['statusCode'] == 200) {
        final parsed = AllRecentSessionResponse.fromJson(response);

        if (parsed.data.attributes.result.isEmpty) {
          state = state.copyWith(
            error: "No recent sessions found",
            isLoading: false,
          );
        } else {
          state = state.copyWith(
            sessions: parsed.data.attributes.result,
            isLoading: false,
          );
        }
      } else {
        state = state.copyWith(
          error: response?['message'] ?? "Failed to fetch recent sessions",
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
