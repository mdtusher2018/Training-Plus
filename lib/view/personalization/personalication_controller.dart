import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/enums.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/personalization/spots_catagory_model.dart';
import 'package:training_plus/view/root_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class PersonalizationState {
  final String userType;
  final String skillLevel;
  final String ageGroup;
  final String? sport; // Single sport
  final String? sportId; // Single sport
  final String? goal; // Single goal
  final List<CategoryItem> categories; // dynamic fetched sports categories
  final bool isLoading;
  final String? error;

  PersonalizationState({
    this.userType = '',
    this.skillLevel = '',
    this.ageGroup = '',
    this.sport,
    this.sportId,
    this.goal,
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  PersonalizationState copyWith({
    String? userType,
    String? skillLevel,
    String? ageGroup,
    String? sport,
    String? goal,
    String? sportId,
    List<CategoryItem>? categories,
    bool? isLoading,
    String? error,
  }) {
    return PersonalizationState(
      userType: userType ?? this.userType,
      skillLevel: skillLevel ?? this.skillLevel,
      ageGroup: ageGroup ?? this.ageGroup,
      sport: sport ?? this.sport,
      sportId: sportId ?? this.sportId,
      goal: goal ?? this.goal,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PersonalizationController extends StateNotifier<PersonalizationState> {
  final IApiService apiService;
  PersonalizationController({required this.apiService})
    : super(PersonalizationState()) {
    fetchCategories(); // Fetch categories on initialization
  }

  /// Fetch categories from API
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

  /// Select a single sport (replaces previous selection)
  void selectSport(String sportId) {
    if (state.sport == sportId) {
      // If the same sport is tapped again, unselect it
      state = state.copyWith(sport: null);
    } else {
      state = state.copyWith(sport: sportId);
    }
    log("Selected sport: ${state.sport}");
  }

  /// Unified method to update any personalization field (single sport & goal)
  void updatePersonalization({
    String? userType,
    String? skillLevel,
    String? ageGroup,
    String? sport, // single sport
    String? sportId,
    String? goal, // single goal
  }) {
    state = state.copyWith(
      userType: userType ?? state.userType,
      skillLevel: skillLevel ?? state.skillLevel,
      ageGroup: ageGroup ?? state.ageGroup,

      sport: sport ?? state.sport, // store as single-item list
      sportId: sportId ?? state.sportId,
      goal: goal ?? state.goal, // store as single-item set
    );
  }

  /// Complete the user's profile by sending data to the API
  Future<void> completeProfile(BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Build the payload
      final payload = {
        "userType": roleMap[state.userType] ?? "",
        "sports": state.sportId,
        "skillLevel": skillLevelMap[state.skillLevel] ?? "",
        "ageGroup": ageGroupMap[state.ageGroup] ?? "",
        "goal": goalMap[state.goal] ?? "",
      };

      // Call the API (replace with your endpoint)
      final response = await apiService.put(
        ApiEndpoints.completeProfile,
        payload,
      );

      if (response != null && response['statusCode'] == 200) {
        // Success → Navigate to RootView
        context.navigateTo(
RootView(),  clearStack: true);

        // Optional: Show success snackbar
        commonSnackbar(
          context: context,
          title: "Success",
          message: "Profile completed successfully",
          backgroundColor: AppColors.success,
        );
      } else {
        // API returned an error → Show snackbar
        final errorMessage =
            response?['message'] ?? 'Failed to complete profile';
        commonSnackbar(
          context: context,
          title: "Error",
          message: errorMessage,
          backgroundColor: AppColors.error,
        );

        state = state.copyWith(error: errorMessage);
      }
    } catch (e) {
      // Exception → Show snackbar
      final errorMessage = e.toString().replaceAll("Exception: ", "");
      commonSnackbar(
        context: context,
        title: "Error",
        message: errorMessage,
        backgroundColor: AppColors.error,
      );

      state = state.copyWith(error: errorMessage);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

/// Provider
