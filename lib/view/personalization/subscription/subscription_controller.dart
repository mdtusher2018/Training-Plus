import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/personalization/subscription/my_subscription_model.dart';
import 'package:training_plus/view/personalization/subscription/subscription_model.dart';
import 'package:training_plus/view/personalization/subscription/webview_payment.dart';
import 'package:training_plus/widgets/common_widgets.dart';

// State class
class SubscriptionState {
  final bool isLoading;
  final int currentIndex;
  final String? error;
  final List<SubscriptionPlan> plans;
  final MySubscriptionAttributes? mySubscription;

  /// Track button-level loading
  final Map<String, bool> buttonLoading;

  SubscriptionState({
    this.isLoading = false,
    this.currentIndex = 0,
    this.error,
    this.plans = const [],
    this.mySubscription,
    this.buttonLoading = const {},
  });

  SubscriptionState copyWith({
    bool? isLoading,
    int? currentIndex,
    String? error,
    List<SubscriptionPlan>? plans,
    MySubscriptionAttributes? mySubscription,
    Map<String, bool>? buttonLoading,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      currentIndex: currentIndex ?? this.currentIndex,
      error: error,
      plans: plans ?? this.plans,
      mySubscription: mySubscription ?? this.mySubscription,
      buttonLoading: buttonLoading ?? this.buttonLoading,
    );
  }
}

// Notifier
class SubscriptionController extends StateNotifier<SubscriptionState> {
  final IApiService apiService;

  SubscriptionController(this.apiService) : super(SubscriptionState()) {
    fetchSubscriptions();
    fetchMySubscription();
  }

  void switchTabs(int index) {
    state = state.copyWith(currentIndex: index);
  }

  Future<void> refreshAll() async {
    state = state.copyWith(isLoading: true);
    await fetchSubscriptions();
    await fetchMySubscription();
    state = state.copyWith(isLoading: false);
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
      state = state.copyWith(isLoading: false, error: "Error: ${e.toString()}");
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
      state = state.copyWith(isLoading: false, error: "Error: ${e.toString()}");
    }
  }

  /// Punch subscription (create Stripe checkout session)
  Future<void> purchaseSubscription({
    required String subscriptionId,
    required String stripePriceId,
    required BuildContext context,
  }) async {
    try {
      // Set loading for this button only
      state = state.copyWith(
        buttonLoading: {...state.buttonLoading, subscriptionId: true},
        error: null,
      );

      final body = {
        "subscription": subscriptionId,
        "stripePriceId": stripePriceId,
      };

      final response = await apiService.post(
        ApiEndpoints.punchSubscription,
        body,
      );

      if (response != null && response['statusCode'] == 200) {
        final sessionUrl = response['data']['attributes']['url'] as String;

        // Clear button loading
        state = state.copyWith(
          buttonLoading: {...state.buttonLoading, subscriptionId: false},
        );

        navigateToPage(PaymentWebViewScreen(url: sessionUrl), context: context);
      } else {
        state = state.copyWith(
          buttonLoading: {...state.buttonLoading, subscriptionId: false},
          error:
              response?['message'] ?? "Failed to create subscription session",
        );
      }
    } catch (e) {
      state = state.copyWith(
        buttonLoading: {...state.buttonLoading, subscriptionId: false},
        error: "Error: ${e.toString()}",
      );
    }
  }
}
