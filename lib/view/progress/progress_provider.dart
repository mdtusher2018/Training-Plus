import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/progress/all_recent_sessions/all_recent_sessions_controller.dart';
import 'package:training_plus/view/progress/progress/progress_controller.dart';

final progressControllerProvider =
    StateNotifierProvider<ProgressController, ProgressState>((ref) {
      final apiService = ref.watch(apiServiceProvider);

      final controller = ProgressController(apiService: apiService);
      controller.fetchProgress();
      controller.fetchCategories();
      return controller;
    });

/// --- Provider ---
final recentSessionsProvider =
    StateNotifierProvider<RecentSessionsController, RecentSessionsState>((ref) {
      final apiService = ref.read(apiServiceProvider);
      final controller = RecentSessionsController(apiService: apiService);
      controller.fetchRecentSessions();
      return controller;
    });
