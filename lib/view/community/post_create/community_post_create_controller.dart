import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/personalization/spots_catagory_model.dart';

// ------------------- State -------------------
class CategoriesState {
  final bool isLoading;
  final String? error;
  final String? sport; // Selected sport name
  final String? sportId; // Selected sport ID
  final List<CategoryItem> categories;

  CategoriesState({
    this.isLoading = false,
    this.error,
    this.sport,
    this.sportId,
    this.categories = const [],
  });

  CategoriesState copyWith({
    bool? isLoading,
    String? error,
    String? sport,
    String? sportId,
    List<CategoryItem>? categories,
  }) {
    return CategoriesState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sport: sport ?? this.sport,
      sportId: sportId ?? this.sportId,
      categories: categories ?? this.categories,
    );
  }
}

// ------------------- Controller -------------------
class CategoriesController extends StateNotifier<CategoriesState> {
  final IApiService apiService;

  CategoriesController(this.apiService) : super(CategoriesState()) {
    fetchCategories(); // fetch once at init
  }

  /// Select a single sport (stores both ID & name)
  void selectSport(CategoryItem category) {
    if (state.sportId == category.id) {
      // Unselect if the same category is tapped
      state = state.copyWith(sport: null, sportId: null);
    } else {
      state = state.copyWith(sport: category.name, sportId: category.id);
    }
    log("Selected sport: ${state.sport} (ID: ${state.sportId})");
  }

  void clearSport() {
    state = state.copyWith(sport: "", sportId: "");
  }

  /// Fetch categories from API
  Future<void> fetchCategories() async {
    log("Fetching categories...");
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.get(ApiEndpoints.sportsCategory);

      if (response != null && response["statusCode"] == 201) {
        final categoryResponse = SportsCategoryResponse.fromJson(response);
        final List<CategoryItem> categories =
            categoryResponse.data?.attributes.category ?? [];

        log("Fetched ${categories.length} categories.");

        state = state.copyWith(categories: categories);
      } else {
        state = state.copyWith(
          error: response?["message"] ?? "Failed to fetch categories",
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Create a new post
  Future<Map<String, String>> createPost({
    required String caption,
    required String categoryId,
  }) async {
    log(categoryId);
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiService.post(ApiEndpoints.createPost, {
        "caption": caption,
        "category": categoryId,
      });

      if (response != null && response["statusCode"] == 201) {
        return {
          "title": "Success",
          "message": response["message"] ?? "Post created successfully",
        };
      } else {
        return {
          "title": "Error",
          "message": response?["message"] ?? "Failed to create post",
        };
      }
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
