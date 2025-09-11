import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/home/workout_details/workout_details_controller.dart';

import 'home/home_page_controller.dart';

/// Provider
final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return HomeController(apiService);
});

final workoutControllerProvider =
    StateNotifierProvider<WorkoutController, WorkoutState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return WorkoutController(apiService: apiService);
});

