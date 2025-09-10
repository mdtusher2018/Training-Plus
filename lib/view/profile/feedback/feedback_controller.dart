import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'feedback_model.dart';

class FeedbackState {
  final double rating;
  final bool isLoading;
  final String? error;
  final FeedbackResponse? response;

  FeedbackState({
    this.rating = 0.0,
    this.isLoading = false,
    this.error,
    this.response,
  });

  FeedbackState copyWith({
    double? rating,
    bool? isLoading,
    String? error,
    FeedbackResponse? response,
  }) {
    return FeedbackState(
      rating: rating ?? this.rating,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      response: response ?? this.response,
    );
  }
}

class FeedbackController extends StateNotifier<FeedbackState> {
  final IApiService apiService;

  FeedbackController(this.apiService) : super(FeedbackState());

  void updateRating(double value) {
    state = state.copyWith(rating: value);
  }

  Future<void> submitFeedback(String text) async {
    if (state.rating == 0.0 || text.isEmpty) {
      state = state.copyWith(error: "Please provide a rating and feedback.");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final responseData = await apiService.post(ApiEndpoints.addFeedback, {
        'rating': state.rating,
        'text': text,
      });

      final feedbackResponse = FeedbackResponse.fromJson(responseData);

      state = state.copyWith(
        isLoading: false,
        response: feedbackResponse,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

