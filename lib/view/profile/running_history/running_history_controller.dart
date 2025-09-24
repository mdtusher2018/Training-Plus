import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/profile/running_history/running_history_model.dart';

/// STATE
class RunningHistoryState {
  final bool isLoading;
  final bool isFetchingMore;
  final RunningHistoryResponse? data;
  final String? error;
  final bool hasMore;
  final int currentPage;

  RunningHistoryState({
    this.isLoading = false,
    this.isFetchingMore = false,
    this.data,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  RunningHistoryState copyWith({
    bool? isLoading,
    bool? isFetchingMore,
    RunningHistoryResponse? data,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return RunningHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      data: data ?? this.data,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// CONTROLLER
class RunningHistoryController extends StateNotifier<RunningHistoryState> {
  final IApiService apiService;

  RunningHistoryController({required this.apiService})
      : super(RunningHistoryState()) {
    fetchHistory(); // auto load
  }

  /// Fetch Running History (with pagination support)
  Future<void> fetchHistory({
    int? page,
    int limit = 10,
    bool loadMore = false,
  }) async {
    final targetPage = page ?? (loadMore ? state.currentPage + 1 : 1);

    if (loadMore) {
      if (!state.hasMore || state.isFetchingMore) return;
      state = state.copyWith(isFetchingMore: true, error: null);
    } else {
      state = state.copyWith(
        isLoading: true,
        error: null,
        data: loadMore ? state.data : null,
      );
    }

    try {
      final response = await apiService.get(
        ApiEndpoints.runningHistory(page: targetPage, limit: limit),
      );

      if (response != null && response["statusCode"] == 201) {
        final newData = RunningHistoryResponse.fromJson(response);

        // merge old + new results if loading more
        final mergedResults = [
          if (loadMore && state.data != null) ...state.data!.results,
          ...newData.results,
        ];

        state = state.copyWith(
          isLoading: false,
          isFetchingMore: false,
          data: newData.copyWith(results: mergedResults),
          currentPage: targetPage,
          hasMore: targetPage < newData.pagination.totalPages,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isFetchingMore: false,
          error: response?["message"] ?? "Failed to fetch running history",
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
}
