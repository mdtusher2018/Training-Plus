import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/profile/Badge%20Shelf/badge_shelf_controller.dart';
import 'package:training_plus/view/profile/Trems%20of%20service%20And%20Privacy%20policy/static_content_controller.dart';
import 'package:training_plus/view/profile/faq/faq_controller.dart';
import 'package:training_plus/view/profile/faq/faq_model.dart';
import 'package:training_plus/view/profile/feedback/feedback_controller.dart';
import 'package:training_plus/view/profile/profile/profile_controller.dart';
import 'package:training_plus/view/profile/running_history/running_history_controller.dart';
import 'package:training_plus/view/profile/settings/change_password/change_password_controller.dart';

final changePasswordControllerProvider =
    StateNotifierProvider<ChangePasswordController, ChangePasswordState>((ref) {
      final IApiService apiService = ref.read(apiServiceProvider);
      return ChangePasswordController(apiService: apiService);
    });

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
      final apiService = ref.read(apiServiceProvider);
      return ProfileController(apiService: apiService);
    });

final faqControllerProvider =
    StateNotifierProvider<FaqController, AsyncValue<List<FaqAttribute>>>((ref) {
      final apiService = ref.watch(apiServiceProvider);

      final controller = FaqController(apiService);
      controller.fetchFaqs();
      return controller;
    });

final feedbackControllerProvider =
    StateNotifierProvider<FeedbackController, FeedbackState>((ref) {
      final api = ref.watch(apiServiceProvider);
      return FeedbackController(api);
    });

final staticContentControllerProvider =
    StateNotifierProvider.family<StaticContentController, StaticContentState,String>((ref,contentType) {
      final apiService = ref.watch(apiServiceProvider);
      return StaticContentController(apiService: apiService,contentType: contentType);
    });

/// Provider
final badgeShelfProvider =
    StateNotifierProvider<BadgeShelfController, BadgeShelfState>((ref) {
      final apiService = ref.watch(apiServiceProvider);
      final controller=BadgeShelfController(apiService: apiService);
      controller.fetchBadges();
      return controller;
    });


/// Running History Provider
final runningHistoryControllerProvider =
    StateNotifierProvider<RunningHistoryController, RunningHistoryState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final controller = RunningHistoryController(apiService: apiService);
  controller.fetchHistory();
  return controller;
});

/// Scroll controller for running history pagination
final runningHistoryScrollControllerProvider =
    Provider.autoDispose<ScrollController>((ref) {
  final controller = ScrollController();
  controller.addListener(() {
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 100) {
      final notifier = ref.read(runningHistoryControllerProvider.notifier);
      notifier.fetchHistory(loadMore: true);
    }
  });

  return controller;
});