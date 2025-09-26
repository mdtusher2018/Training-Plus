import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/personalization/spots_catagory_model.dart';
import 'package:training_plus/view/progress/progress/progress_models.dart';

// Define the states
class ProgressState {
  final bool isLoading;
  final ProgressAttributes? progress;
  final List<CategoryItem> categories; // dynamic fetched sports categories
  final String? error;
  final bool isMonthly;

  ProgressState({
    this.isLoading = false,
    this.progress,
    this.error,
    this.isMonthly = false,
    this.categories = const [],
  });

  ProgressState copyWith({
    bool? isLoading,
    ProgressAttributes? progress,
    List<CategoryItem>? categories,
    String? error,
    bool? isMonthly,
  }) {
    return ProgressState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      categories: categories ?? this.categories,
      error: error ,
      isMonthly: isMonthly ?? this.isMonthly,
    );
  }
}

// Controller using StateNotifier
class ProgressController extends StateNotifier<ProgressState> {
  final IApiService apiService;

  ProgressController({required this.apiService}) : super(ProgressState());

  void switchMonthly() {
    state = state.copyWith(isMonthly: !state.isMonthly);
  }

  Future<void> fetchProgress() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.progress);

      if (response['statusCode'] == 200) {
        final progressResponse = ProgressResponse.fromJson(response);
        state = state.copyWith(
          isLoading: false,
          progress: progressResponse.data.attributes,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to fetch progress: ${response['statusCode']}',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

 Future<void> fetchCategories() async {
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

Future<Map<String,String>> setGoal({
  required BuildContext context,
  required String sportId,
  required int target,
  required String timeFrame, // e.g., "weekly", "monthly"
}) async {
  try {
    final body = {
      "sports": sportId,
      "target": target,
      "timeFrame": timeFrame.toLowerCase(),
    };

    final response = await apiService.post(
      ApiEndpoints.addGoal,
      body,
    );

    if (response != null && response['status'] == 'success') {
      return {"massage":"Goal added successfully","title":"Successful"};
   
    } else {
      final errorMsg = response != null && response['message'] != null
          ? response['message']
          : "Something went wrong";
              return {"massage":errorMsg,"title":"Error"};
    }
  } catch (e) {
        return {"massage":"Error: ${e.toString()}","title":"Error"};
   
  }
}


}
