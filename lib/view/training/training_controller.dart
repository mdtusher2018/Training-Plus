import 'dart:developer';

import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/personalization/spots_catagory_model.dart';
import 'package:training_plus/view/training/training_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingState {
  final bool isLoading;
  final TrainingAttributes? attributes;
  final List<CategoryItem> categories;
    final String? sport; // Single sport
  final String? sportId; // Single sport
  final String? error;

  TrainingState({
    this.isLoading = false,

    this.attributes,
    this.categories = const [],
        this.sport,
    this.sportId,
    this.error,
  });

  TrainingState copyWith({
    bool? isLoading,
    TrainingAttributes? attributes,
    List<CategoryItem>? categories,
        String? sport,
    String? sportId,
    String? error,
  }) {
    return TrainingState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
            sport: sport ?? this.sport,
      sportId: sportId??this.sportId,
      attributes: attributes ?? this.attributes,
      error: error,
    );
  }
}

class TrainingController extends StateNotifier<TrainingState> {
  final IApiService apiService;

  TrainingController(this.apiService) : super(TrainingState());

  /// Fetch trainings from API
  Future<void> fetchTrainings() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.training);

      if (response != null && response['statusCode'] == 200) {
        final trainingResponse = TrainingResponse.fromJson(response);
        state = state.copyWith(
          isLoading: false,
          attributes: trainingResponse.data,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response?['message'] ?? "Failed to fetch trainings",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Error: ${e.toString()}");
    }
  }


void updateSport({
  String? sport,   
  String? sportId,
}) {
  state = state.copyWith(
    sport:  sport ?? state.sport,  // store as single-item list
    sportId: sportId??state.sportId,
  );
}



  Future<void> fetchCategories() async {
    log("Fetching categories...");
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiService.get(ApiEndpoints.sportsCategory);
      if (response != null) {
        final categoryResponse = SportsCategoryResponse.fromJson(response);
        final List<CategoryItem> categories =
            categoryResponse.data?.attributes.category ?? [];

        state = state.copyWith(categories: categories);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }




Future<Map<String, String>> changeCategory() async {
  if (state.sportId == null) {
    return {
      "message": "No sport selected",
      "title": "Error",
    };
  }

  state = state.copyWith(isLoading: true, error: null);

  try {
    final response = await apiService.post(
      ApiEndpoints.changeCurrentTraining,
      {"currentTrainning": state.sportId},
    );

    if (response != null && response['statusCode'] == 200) {
      return {
        "message": response['message'] ?? "Category changed successfully",
        "title": "Success",
      };
    } else {
      final errorMsg = response != null && response['message'] != null
          ? response['message']
          : "Failed to change category";
      return {"message": errorMsg, "title": "Error"};
    }
  } catch (e) {
    return {"message": "Error: ${e.toString()}", "title": "Error"};
  } finally {
    state = state.copyWith(isLoading: false);
  }
}






}
