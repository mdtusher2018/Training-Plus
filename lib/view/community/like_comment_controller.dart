import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';


class PostLikeState {
  final bool isLiked;
  final int likeCount;

  PostLikeState({required this.isLiked, required this.likeCount});

  PostLikeState copyWith({bool? isLiked, int? likeCount}) {
    return PostLikeState(
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}




class PostLikeController extends StateNotifier<PostLikeState> {
  final IApiService apiService;
  final String postId;

  PostLikeController({
    required this.apiService,
    required this.postId,
    required bool initialLiked,
    required int initialCount,
  }) : super(PostLikeState(isLiked: initialLiked, likeCount: initialCount));

  Future<void> toggleLike() async {
    final previous = state;

    // Optimistic update
    state = state.copyWith(
      isLiked: !previous.isLiked,
      likeCount: previous.isLiked
          ? previous.likeCount - 1
          : previous.likeCount + 1,
    );

    try {
      final response =
          await apiService.post(ApiEndpoints.likePost, {"post": postId});

      if (response == null || response["statusCode"] != 201) {
        // revert if API fails
        state = previous;
      }
    } catch (e) {
      state = previous;
    }
  }
}
