import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/common_used_models/workout_preview_model.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/home/my_workouts/my_workouts_model.dart';

/// State class for MyWorkout
class MyWorkoutState {
  final bool isLoading;
  final bool isFetchingMore;
  final MyWorkoutResponse? data;
  final String? error;
  final bool hasMore;
  final int currentPage;

  MyWorkoutState({
    this.isLoading = false,
    this.isFetchingMore = false,
    this.data,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  MyWorkoutState copyWith({
    bool? isLoading,
    bool? isFetchingMore,
    MyWorkoutResponse? data,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return MyWorkoutState(
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      data: data ?? this.data,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
/// Controller for MyWorkout
class MyWorkoutController extends StateNotifier<MyWorkoutState> {
  final IApiService apiService;

  MyWorkoutController({required this.apiService})
      : super(MyWorkoutState()) {
    fetchWorkouts(); // load immediately
  }

  /// Fetch workouts (with pagination support)
  Future<void> fetchWorkouts({int? page, int limit = 10, bool loadMore = false}) async {
    final targetPage = page ?? (loadMore ? state.currentPage + 1 : 1);

    if (loadMore) {
      if (!state.hasMore || state.isFetchingMore) return;
      state = state.copyWith(isFetchingMore: true, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null, data: null);
    }

    try {
      final response = await apiService.get(
        ApiEndpoints.myWorkout(page: targetPage, limit: limit),
      );

      if (response != null && response["statusCode"] == 200) {
        final newData = MyWorkoutResponse.fromJson(response);

        final List<WorkoutPreviewModel> newWorkouts = newData.suggestions;
        final oldWorkouts = loadMore ? (state.data?.suggestions ?? []) : [];

        final List<WorkoutPreviewModel>  allWorkouts = [...oldWorkouts, ...newWorkouts];

        // Merge into a new MyWorkoutResponse
        final mergedData = newData.copyWith(suggestions: allWorkouts);

        state = state.copyWith(
          isLoading: false,
          isFetchingMore: false,
          data: mergedData,
          currentPage: targetPage,
          hasMore: newWorkouts.length == limit, // ✅ stop when less than limit
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isFetchingMore: false,
          error: response?["message"] ?? "Failed to fetch workouts",
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
