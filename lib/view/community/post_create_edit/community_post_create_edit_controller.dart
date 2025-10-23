import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/common_used_models/my_post_model.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/personalization/spots_catagory_model.dart';

// ------------------- State -------------------
class CommunityPostCreateEditState {
  final bool isLoading;
  final String? error;
  final String? sport;
  final List<CategoryItem> categories;

  CommunityPostCreateEditState({
    this.isLoading = false,
    this.error,
    this.sport,
    this.categories = const [],
  });

  CommunityPostCreateEditState copyWith({
    bool? isLoading,
    String? error,
    String? sport,
    List<CategoryItem>? categories,
  }) {
    return CommunityPostCreateEditState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sport: sport ?? this.sport,
      categories: categories ?? this.categories,
    );
  }
}

// ------------------- Controller -------------------
class CommunityPostCreateEditController extends StateNotifier<CommunityPostCreateEditState> {
  final IApiService apiService;

  CommunityPostCreateEditController(this.apiService) : super(CommunityPostCreateEditState()) {
    fetchCategories(); // fetch once at init
  }

  /// Select a single sport (stores both ID & name)
  void selectSport(String selectedSport) {
        log("Selected sport: $selectedSport)");
    if (state.sport == selectedSport) {

      state = state.copyWith(sport: null);
    } else {
      state = state.copyWith(sport: selectedSport);
    }

  }

  void clearSport() {
    state = state.copyWith(sport: "");
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
Future<(Map<String, dynamic>, MyPost?)> createPost({
  required String caption,
  required String category,
}) async {
  log(category);
  state = state.copyWith(isLoading: true, error: null);

  try {
    final response = await apiService.post(ApiEndpoints.createPost, {
      "caption": caption,
      "category": category,
    });

    if (response != null && response["statusCode"] == 201) {
      final myPost = MyPost.fromJson(response['data']);
      return (
        {
          "title": "Success",
          "message": response["message"] ?? "Post created successfully",
        },
        myPost
      );
    } else {
      return (
        {
          "title": "Error",
          "message": response?["message"] ?? "Failed to create post",
        },
        null
      );
    }
  } catch (e) {
    return (
      {
        "title": "Error",
        "message": e.toString(),
      },
      null
    );
  } finally {
    state = state.copyWith(isLoading: false);
  }
}



Future<Map<String, String>> updatePost({
  required String postId,
  required String caption,
  required String category,
}) async {
  log("Updating post: $postId with category: $category");
  state = state.copyWith(isLoading: true, error: null);

  try {
    final response = await apiService.put(
      ApiEndpoints.updatePost(postId), 
      {
        "caption": caption,
        "category": category,
      },
    );

    if (response != null && response["statusCode"] == 200) {
      return {
        "title": "Success",
        "message": response["message"] ?? "Post updated successfully",
      };
    } else {
      return {
        "title": "Error",
        "message": response?["message"] ?? "Failed to update post",
      };
    }
  } catch (e) {
    return {"title": "Error", "message": e.toString()};
  } finally {
    state = state.copyWith(isLoading: false);
  }
}





}
