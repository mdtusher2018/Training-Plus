import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/profile/faq/faq_controller.dart';
import 'package:training_plus/view/profile/faq/faq_model.dart';
import 'package:training_plus/view/profile/feedback/feedback_controller.dart';
import 'package:training_plus/view/profile/profile/profile_controller.dart';
import 'package:training_plus/view/profile/settings/change_password/change_password_controller.dart';

final changePasswordControllerProvider =
    StateNotifierProvider<ChangePasswordController, ChangePasswordState>(
  (ref) { 
    final IApiService apiService=ref.read(apiServiceProvider);
    return ChangePasswordController(apiService: apiService);},
);

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ProfileController(apiService: apiService);
});

final faqControllerProvider =
    StateNotifierProvider<FaqController, AsyncValue<List<FaqAttribute>>>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    
    final controller = FaqController(apiService);
    controller.fetchFaqs();
    return controller;
  },
);


final feedbackControllerProvider =
    StateNotifierProvider<FeedbackController, FeedbackState>((ref) {
  final api = ref.watch(apiServiceProvider);
  return FeedbackController(api);
});



