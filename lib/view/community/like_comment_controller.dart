import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';

// 1️⃣ Provider for each post


class PostLikeController extends StateNotifier<bool> {
  final IApiService apiService;
  final String postId;

  // default state is false
  PostLikeController({
    required this.apiService,
    required this.postId,
    bool initial = false,
  }) : super(initial);

  // toggle like/unlike
  Future<void> toggleLike() async {
    final previous = state;
    state = !state; // optimistic update

    try {
      final response = await apiService.post(ApiEndpoints.likePost, {"post": postId});

      // optionally check API response success
      if (response == null || response["statusCode"] != 200) {
        state = previous; // revert on failure
      }
    } catch (e) {
      state = previous; // revert on exception
    }
  }
}
