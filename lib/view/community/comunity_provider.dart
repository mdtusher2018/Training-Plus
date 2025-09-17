import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/community/active_challenges/active_challenges_controller.dart';
import 'package:training_plus/view/community/community/community_controller.dart';
import 'package:training_plus/view/community/comunity_feed/community_feed_controller.dart';
import 'package:training_plus/view/community/leaderboard/leaderboard_controller.dart';
import 'package:training_plus/view/community/like_comment_controller.dart';
import 'package:training_plus/view/community/my_all_post/community_my_post_controller.dart';
import 'package:training_plus/view/community/post_create/community_post_create_controller.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, CommunityState>((ref) {
      final apiService = ref.read(
        apiServiceProvider,
      ); 
      final controller = CommunityController(apiService);
      controller.fetchCommunity();
      return controller;
    });

final activeChallengeControllerProvider =
    StateNotifierProvider<ActiveChallengeController, ActiveChallengeState>((
      ref,
    ) {
      final apiService = ref.read(apiServiceProvider);
      final controller = ActiveChallengeController(apiService);
      controller.fetchActiveChallenges();

      return controller;
    });


final activeChallengeScrollControllerProvider = Provider.autoDispose<ScrollController>((ref) {
  final controller = ScrollController();

  controller.addListener(() {
    if (controller.position.pixels >= controller.position.maxScrollExtent - 100) {
      ref.read(activeChallengeControllerProvider.notifier).fetchActiveChallenges(loadMore:true);
    }
  });

  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});


final leaderboardControllerProvider =
    StateNotifierProvider<LeaderboardController, LeaderboardState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final controller= LeaderboardController(apiService);
  controller.fetchLeaderboard();
  return controller;
});



// Providers
final feedControllerProvider = StateNotifierProvider<FeedController, FeedState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final controller = FeedController(apiService);
  controller.fetchFeed(); // Fetch initial feed
  return controller;
});

final feedScrollControllerProvider = Provider.autoDispose((ref) {
  final scrollController = ScrollController();

  scrollController.addListener(() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      ref.read(feedControllerProvider.notifier).fetchMoreFeed();
    }
  });

  ref.onDispose(() {
    scrollController.dispose();
  });

  return scrollController;
});



// --------------------- PROVIDERS ---------------------
final myPostControllerProvider = StateNotifierProvider<MyPostController, MyPostState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return MyPostController(apiService);
});

final myPostScrollControllerProvider = Provider.autoDispose<ScrollController>((ref) {
  final scrollController = ScrollController();

  scrollController.addListener(() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      ref.read(myPostControllerProvider.notifier).fetchMorePosts();
    }
  });

  ref.onDispose(() {
    scrollController.dispose();
  });

  return scrollController;
});


// ------------------- Provider -------------------
final communityPostCreateProvider =
    StateNotifierProvider<CategoriesController, CategoriesState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return CategoriesController(apiService);
});



final postLikeControllerProvider =
    StateNotifierProvider.family.autoDispose<PostLikeController, bool, String>(
  (ref, postId) {
    final apiService = ref.read(apiServiceProvider); // assuming you have this
    return PostLikeController(apiService: apiService, postId: postId);
  },
);
