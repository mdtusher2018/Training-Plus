import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/training/training_controller.dart';

final trainingControllerProvider =
    StateNotifierProvider<TrainingController, TrainingState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TrainingController(apiService);
});
