import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/personalization/subscription/my_subscription_model.dart';
import 'package:training_plus/view/personalization/subscription/subscription_model.dart';


// State class
class SubscriptionState {
  final bool isLoading;
  final String? error;
  final List<SubscriptionPlan> plans;
  final MySubscriptionAttributes? mySubscription; // ✅ Active subscription

  SubscriptionState({
    this.isLoading = false,
    this.error,
    this.plans = const [],
    this.mySubscription,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    String? error,
    List<SubscriptionPlan>? plans,
    MySubscriptionAttributes? mySubscription,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      plans: plans ?? this.plans,
      mySubscription: mySubscription ?? this.mySubscription,
    );
  }
}
// Notifier
class SubscriptionController extends StateNotifier<SubscriptionState> {
  final IApiService apiService;

  SubscriptionController(this.apiService) : super(SubscriptionState()){
    fetchSubscriptions();
  }

  /// Fetch subscription plans
  Future<void> fetchSubscriptions() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.subscriptions);

      if (response != null && response['statusCode'] == 200) {
        final subscriptionResponse = SubscriptionResponse.fromJson(response);
        state = state.copyWith(
          isLoading: false,
          plans: subscriptionResponse.data.attributes,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response?['message'] ?? "Failed to fetch subscriptions",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Error: ${e.toString()}",
      );
    }
  }

  Future<void> fetchMySubscription() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.mySubscription);

      if (response != null && response['statusCode'] == 200) {
        final mySubResponse = MySubscriptionResponse.fromJson(response);
        state = state.copyWith(
          isLoading: false,
          mySubscription: mySubResponse.data.attributes,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response?['message'] ?? "Failed to fetch my subscription",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Error: ${e.toString()}",
      );
    }
  }


}
