import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/progress/progress_controller.dart';

final progressControllerProvider =
    StateNotifierProvider<ProgressController, ProgressState>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);

    final controller = ProgressController(apiService: apiService);
    controller.fetchProgress(); 
    return controller;
  },
);
