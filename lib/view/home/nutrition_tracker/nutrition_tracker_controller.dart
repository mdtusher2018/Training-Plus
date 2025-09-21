import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/home/nutrition_tracker/nutrition_traker_model.dart';

/// State for Nutrition Tracker
class NutritionTrackerState {
  final bool isLoading;
  final NutritionData? data;
  final String? error;

  NutritionTrackerState({required this.isLoading, this.data, this.error});

  NutritionTrackerState copyWith({
    bool? isLoading,
    NutritionData? data,
    String? error,
  }) {
    return NutritionTrackerState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

/// StateNotifier for Nutrition Tracker
class NutritionTrackerController extends StateNotifier<NutritionTrackerState> {
  final IApiService apiService;

  NutritionTrackerController({required this.apiService})
    : super(NutritionTrackerState(isLoading: false)) {
    fetchNutritionTracker();
  }

  /// Fetch the nutrition tracker data
  Future<void> fetchNutritionTracker() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.nutritionTracker);

      if (response != null && response["statusCode"] == 201) {
        final data = NutritionData.fromJson(
          response["data"]["attributes"] ?? {},
        );
        state = state.copyWith(isLoading: false, data: data);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response?["message"] ?? "Failed to fetch nutrition data",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  /// Set food goals
Future<Map<String, String>> setFoodGoal({
  required int calories,
  required int proteins,
  required int carbs,
  required int fats,
}) async {
  state=state.copyWith(isLoading: true);
  try {
    final body = {
      "calories": calories,
      "proteins": proteins,
      "carbs": carbs,
      "fats": fats,
    };

    final response = await apiService.post(ApiEndpoints.setFoodGoal, body);

    if (response != null && response["statusCode"] == 201) {

      return {
        "title": "Success",
        "message": response["message"] ?? "Food goal set successfully",
      };
    } else {
      return {
        "title": "Error",
        "message": response?["message"] ?? "Failed to set food goal",
      };
    }
  } catch (e) {
    return {"title": "Error", "message": e.toString()};
  }finally{
    state=state.copyWith(isLoading: false);
  }
}

}
