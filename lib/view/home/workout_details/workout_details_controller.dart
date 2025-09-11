import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/home/workout_details/workout_details_model.dart';


// Define the states
class WorkoutState {
  final bool isLoading;
  final Workout? workout;
  final String? error;

  WorkoutState({this.isLoading = false, this.workout, this.error});

  WorkoutState copyWith({
    bool? isLoading,
    Workout? workout,
    String? error,
  }) {
    return WorkoutState(
      isLoading: isLoading ?? this.isLoading,
      workout: workout ?? this.workout,
      error: error ?? this.error,
    );
  }
}

// Controller using StateNotifier
class WorkoutController extends StateNotifier<WorkoutState> {
  WorkoutController({required this.apiService}) : super(WorkoutState());
  IApiService apiService;

  Future<void> fetchWorkout(String id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.workoutDetails(id));

      if (response['statusCode'] == 200) {
    
        final workout = WorkoutResponse.fromJson(response);
        state = state.copyWith(isLoading: false, workout: workout.data.attributes);
      } else {
        state = state.copyWith(
            isLoading: false,
            error: 'Failed to fetch workout: ${response.statusCode}');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

