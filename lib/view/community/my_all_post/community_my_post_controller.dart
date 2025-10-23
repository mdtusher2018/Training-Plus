
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/common_used_models/my_post_model.dart';
import 'package:training_plus/core/common_used_models/pagination_model.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/community/my_all_post/community_my_post_model.dart';

// --------------------- STATE ---------------------
class MyPostState {
  final bool isLoading;
  final bool isFetchingMore;
  final String? error;
  final List<MyPost> posts;
  final Pagination? pagination;
  final bool hasMore;
  final int currentPage;

  MyPostState({
    this.isLoading = false,
    this.isFetchingMore = false,
    this.error,
    this.posts = const [],
    this.pagination,
    this.hasMore = true,
    this.currentPage = 1,
  });

  MyPostState copyWith({
    bool? isLoading,
    bool? isFetchingMore,
    String? error,
    List<MyPost>? posts,
    Pagination? pagination,
    bool? hasMore,
    int? currentPage,
  }) {
    return MyPostState(
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      error: error,
      posts: posts ?? this.posts,
      pagination: pagination ?? this.pagination,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// --------------------- CONTROLLER ---------------------
class MyPostController extends StateNotifier<MyPostState> {
  final IApiService apiService;

  MyPostController(this.apiService) : super(MyPostState()) {
    fetchPosts(); // fetch first page by default
  }

  Future<void> fetchPosts({int page = 1, int limit = 10, bool loadMore = false}) async {
    if (loadMore) {
      if (!state.hasMore || state.isFetchingMore) return;
      state = state.copyWith(isFetchingMore: true);
    } else {
      state = state.copyWith(isLoading: true, error: null, posts: []);
    }

    try {
      final response = await apiService.get("${ApiEndpoints.myPosts}?page=$page&limit=$limit");

      if (response != null && response["statusCode"] == 201) {
        final parsed = MyPostResponseModel.fromJson(response);
        final newPosts = parsed.posts;
        final pagination = parsed.pagination;

        state = state.copyWith(
          isLoading: false,
          isFetchingMore: false,
          posts: loadMore ? [...state.posts, ...newPosts] : newPosts,
          pagination: pagination,
          hasMore: pagination.currentPage < pagination.totalPages,
          currentPage: pagination.currentPage,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isFetchingMore: false,
          error: response?["message"] ?? "Failed to fetch posts",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFetchingMore: false,
        error: e.toString(),
      );
    }
  }




void deletePost({
  required String postId,
})  {
      final updatedPosts = state.posts.where((p) => p.id != postId).toList();
      state = state.copyWith(posts: updatedPosts);
}



void incrementCommentCount({required String postId, required int count}) {
  final updatedPosts = state.posts.map((p) {
    if (p.id == postId) {
      
      return p.copyWith(commentCount: p.commentCount+1);
    }
    return p;
  }).toList();

  state = state.copyWith(posts: updatedPosts);
}







  Future<void> fetchMorePosts() async {
    if (!state.hasMore || state.isFetchingMore) return;
    final nextPage = state.currentPage + 1;
    await fetchPosts(page: nextPage, loadMore: true);
  }

  Future<void> refreshPosts() async {
    await fetchPosts(page: 1, loadMore: false);
  }
}

