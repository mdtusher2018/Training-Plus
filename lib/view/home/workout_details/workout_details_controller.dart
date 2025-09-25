import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/home/workout_details/workout_details_model.dart';

// Define the states
class WorkoutState {
  final bool isLoading;
  final Workout? workout;
  final String? error;
  final bool startWorkout;
  final bool endWorkout;

  WorkoutState({this.isLoading = false, this.workout, this.error, this.startWorkout=false,this.endWorkout=false});

  WorkoutState copyWith({bool? isLoading, Workout? workout, String? error,bool? startWorkout,bool? endWorkout}) {
    return WorkoutState(
      isLoading: isLoading ?? this.isLoading,
      workout: workout ?? this.workout,
      error: error ?? this.error,
      startWorkout: startWorkout?? this.startWorkout,
      endWorkout: endWorkout?? this.endWorkout
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
        state = state.copyWith(
          isLoading: false,
          workout: workout.data.attributes,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to fetch workout: ${response.statusCode}',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

Future<Map<String, String>> completeVideo(String videoId,num watchTime) async {
  try {
    final response = await apiService.post(ApiEndpoints.completeVideo, {
      "workout": state.workout?.id,
      "video": videoId,
      "watchTime" : watchTime
    });

    if (response != null && response['statusCode'] == 201) {
      return {
        "message": "Video marked as completed successfully",
        "title": "Success"
      };
    } else {
      final errorMsg = response != null && response['message'] != null
          ? response['message']
          : "Failed to mark video as completed";
      return {"message": errorMsg, "title": "Error"};
    }
  } catch (e) {
    return {"message": "Error: ${e.toString()}", "title": "Error"};
  }
}


Future<Map<String, String>> startWorkout() async {
  try {
    state = state.copyWith(startWorkout: true); // mark loading
    final response = await apiService.post(ApiEndpoints.startWorkout, {
      "workout": state.workout?.id,
      "watchTime": state.workout?.duration.toStringAsFixed(2),
    });

    if (response != null && response['statusCode'] == 201) {
      return {"message": "Workout Started Successfully", "title": "Success"};
    } else {
      final errorMsg = response != null && response['message'] != null
          ? response['message']
          : "Failed to start workout";
      return {"message": errorMsg, "title": "Error"};
    }
  } catch (e) {
    return {"message": "Error: ${e.toString()}", "title": "Error"};
  } finally {
    state = state.copyWith(startWorkout: false); // reset loading
  }
}

Future<Map<String, String>> finishWorkout() async {
  try {
    state = state.copyWith(endWorkout: true); // mark loading
    final response = await apiService.put(
      ApiEndpoints.finishedWorkout(state.workout?.id ?? ""),
      {"sports": state.workout?.sports},
    );

    if (response != null && response['statusCode'] == 200) {
      return {"message": "Workout Finished Successfully", "title": "Success"};
    } else {
      final errorMsg = response != null && response['message'] != null
          ? response['message']
          : "Failed to finish workout";
      return {"message": errorMsg, "title": "Error"};
    }
  } catch (e) {
    return {"message": "Error: ${e.toString()}", "title": "Error"};
  } finally {
    state = state.copyWith(endWorkout: false); // reset loading
  }
}


}
