import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/common_used_models/pagination_model.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/common_used_models/feed_model.dart';
import 'package:training_plus/view/community/comunity_feed/community_feed_model.dart'; // Your Feed & Pagination models


// Controller State
class FeedState {
  final bool isLoading;
  final bool isFetchingMore;
  final String? error;
  final List<Feed> feed;
  final Pagination? pagination;
  final bool hasMore;
  final int currentPage;

  FeedState({
    this.isLoading = false,
    this.isFetchingMore = false,
    this.error,
    this.feed = const [],
    this.pagination,
    this.hasMore = true,
    this.currentPage = 1,
  });

  FeedState copyWith({
    bool? isLoading,
    bool? isFetchingMore,
    String? error,
    List<Feed>? feed,
    Pagination? pagination,
    bool? hasMore,
    int? currentPage,
  }) {
    return FeedState(
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      error: error,
      feed: feed ?? this.feed,
      pagination: pagination ?? this.pagination,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// Controller
class FeedController extends StateNotifier<FeedState> {
  final IApiService apiService;

  FeedController(this.apiService) : super(FeedState());

  // Fetch feed (initial or refresh)
  Future<void> fetchFeed({int page = 1, int limit = 10, bool loadMore = false}) async {
    if (loadMore) {
      if (!state.hasMore || state.isFetchingMore) return;
      state = state.copyWith(isFetchingMore: true);
    } else {
      state = state.copyWith(isLoading: true, error: null, feed: []);
    }

    try {
      final response = await apiService.get(ApiEndpoints.feed(page: page, limit: limit));

      if (response != null && response["statusCode"] == 200) {
        final parsed = FeedResponseModel.fromJson(response);
        final newFeed = parsed.data?.attributes?.feed ?? [];
        final pagination = parsed.data?.attributes?.pagination;

        state = state.copyWith(
          feed: loadMore ? [...state.feed, ...newFeed] : newFeed,
          pagination: pagination,
          isLoading: false,
          isFetchingMore: false,
          hasMore: pagination != null ? pagination.currentPage < pagination.totalPages : false,
          currentPage: page,
        );
      } else {
        state = state.copyWith(
          error: response?["message"] ?? "Failed to fetch feed",
          isLoading: false,
          isFetchingMore: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isFetchingMore: false,
      );
    }
  }

  // Fetch next page
  Future<void> fetchMoreFeed({int limit = 10}) async {
    if (!state.hasMore || state.isFetchingMore) return;

    final nextPage = state.currentPage + 1;
    await fetchFeed(page: nextPage, limit: limit, loadMore: true);
  }
}
