import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/home/my_workouts/my_workout_controller.dart';
import 'package:training_plus/view/home/nutrition_tracker/nutrition_tracker_controller.dart';
import 'package:training_plus/view/home/running_gps/running_gps_controller.dart';
import 'package:training_plus/view/home/workout_details/workout_details_controller.dart';

import 'home/home_page_controller.dart';

/// Provider
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    return HomeController(apiService);
  },
);

final workoutControllerProvider =
    StateNotifierProvider<WorkoutController, WorkoutState>((ref) {
      final apiService = ref.watch(apiServiceProvider);
      return WorkoutController(apiService: apiService);
    });

/// Riverpod provider
final nutritionTrackerControllerProvider =
    StateNotifierProvider<NutritionTrackerController, NutritionTrackerState>((
      ref,
    ) {
      final apiService = ref.watch(apiServiceProvider);
      return NutritionTrackerController(apiService: apiService);
    });

/// Riverpod provider
final myWorkoutControllerProvider =
    StateNotifierProvider<MyWorkoutController, MyWorkoutState>((ref) {
      final apiService = ref.read(apiServiceProvider);
      return MyWorkoutController(apiService: apiService);
    });

final myWorkoutScrollControllerProvider =
    Provider.autoDispose<ScrollController>((ref) {
      final controller = ScrollController();

      controller.addListener(() {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent - 100) {
          ref
              .read(myWorkoutControllerProvider.notifier)
              .fetchWorkouts(loadMore: true);
        }
      });

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });




final runningGpsControllerProvider =
    StateNotifierProvider<RunningGpsController, RunningGpsState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return RunningGpsController(apiService: apiService);
});


