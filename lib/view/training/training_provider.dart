import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/training/training_controller.dart';

final trainingControllerProvider =
    StateNotifierProvider<TrainingController, TrainingState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TrainingController(apiService);
});


final completedTrainingScrollControllerProvider =
    Provider.autoDispose<ScrollController>((ref) {
  final controller = ScrollController();
  controller.addListener(() {
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 100) {
      ref
          .read(trainingControllerProvider.notifier)
          .fetchCompletedTrainings(loadMore: true);
    }
  });
  return controller;
});
