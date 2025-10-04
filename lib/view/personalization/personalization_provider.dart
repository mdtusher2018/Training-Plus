import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/personalization/personalication_controller.dart';
import 'package:training_plus/view/profile/subscription/subscription_controller.dart';

final personalizationControllerProvider =
    StateNotifierProvider<PersonalizationController, PersonalizationState>(
        (ref) { 
            final IApiService apiService=ref.watch(apiServiceProvider);
         return PersonalizationController(apiService: apiService);});



// Provider
final subscriptionControllerProvider =
    StateNotifierProvider<SubscriptionController, SubscriptionState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SubscriptionController(apiService);
});


