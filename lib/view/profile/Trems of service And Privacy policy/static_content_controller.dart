import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/profile/Trems%20of%20service%20And%20Privacy%20policy/static_content_model.dart';

class StaticContentState {
  final bool isLoading;
  final StaticContentModel? content;
  final String? error;

  StaticContentState({
    this.isLoading = false,
    this.content,
    this.error,
  });

  StaticContentState copyWith({
    bool? isLoading,
    StaticContentModel? content,
    String? error,
  }) {
    return StaticContentState(
      isLoading: isLoading ?? this.isLoading,
      content: content ?? this.content,
      error: error,
    );
  }
}


class StaticContentController extends StateNotifier<StaticContentState> {
  final IApiService apiService;
  String contentType;

  StaticContentController({required this.apiService,required this.contentType}) : super(StaticContentState());

  /// Fetch static content
  Future<void> fetchStaticContent(String type) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.staticContent(type));

      if (response != null && response['statusCode'] == 200) {
        final contentModel = StaticContentModel.fromJson(response['data']);
        state = state.copyWith(content: contentModel, isLoading: false);
      } else {
        state = state.copyWith(
          error: response?['message'] ?? 'Failed to fetch content',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}
