import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/progress/progress_models.dart';

// Define the states
class ProgressState {
  final bool isLoading;
  final ProgressAttributes? progress;
  final String? error;
  final bool isMonthly;

  ProgressState({this.isLoading = false, this.progress, this.error,this.isMonthly=false});

  ProgressState copyWith({
    bool? isLoading,
    ProgressAttributes? progress,
    String? error,
    bool? isMonthly,
  }) {
    return ProgressState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      isMonthly: isMonthly?? this.isMonthly
    );
  }
}

// Controller using StateNotifier
class ProgressController extends StateNotifier<ProgressState> {
  final IApiService apiService;

  ProgressController({required this.apiService}) : super(ProgressState());

void switchMonthly(){
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
}
