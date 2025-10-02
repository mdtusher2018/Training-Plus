import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/post_create_edit/CommunityPostCreateView.dart';
import 'package:training_plus/view/community/active_challenges/active_challenges_view.dart';
import 'package:training_plus/view/community/community/community_controller.dart';
import 'package:training_plus/view/community/comunity_feed/community_feed_view.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/view/community/leaderboard/leaderboard_view.dart';
import 'package:training_plus/view/community/my_all_post/my_posts_view.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class CommunityView extends ConsumerWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityControllerProvider);
    final controller = ref.read(communityControllerProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.boxBG,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: commonText("Community", size: 20, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchCommunity();
        },
        child: Builder(
          builder: (context) {
            if (state.data == null && state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return commonErrorMassage(
                context: context,
                massage: state.error!,
              );
            } else if (state.data != null) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // if (state.data!.activeChallenge.isNotEmpty)
                  _activeChallengesSection(context, state, ref),

                  // if (state.data!.mypost.isNotEmpty)
                  _myPostsSection(context, state, ref),

                  // if (state.data!.leaderboard.topUsers.isNotEmpty)
                  _leaderboardSection(context, state),

                  // if (state.data!.feed.isNotEmpty)
                  _communityFeedSection(context, state, ref),
                  SizedBox(height: 24),
                ],
              );
            } else {
              return commonSizedBox();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          navigateToPage(context: context, CommunityPostView());
        },
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _activeChallengesSection(
    BuildContext context,
    CommunityState state,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          "Active Challenges",
          onTap: () {
            navigateToPage(context: context, ActiveChallengesView());
          },
        ),
        commonSizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.data!.activeChallenge.length,
          itemBuilder: (context, index) {
            final challenge = state.data!.activeChallenge[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: challengeCard(
                title: challenge.challengeName,
                isJoined: challenge.isJoined,
                points: challenge.point,
                count: challenge.count,
                days: challenge.days,
                onTap: () {
                  showChallengeDetailsBottomSheet(
                    context,
                    isJoined: !challenge.isJoined,
                    ref: ref,
                    challengeId: challenge.id,
                    days: challenge.days,
                    condition: challenge.challengeName,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _myPostsSection(
    BuildContext context,
    CommunityState state,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          "My Posts",
          onTap: () {
            navigateToPage(context: context, MyPostsView());
          },
        ),
        commonSizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.data!.mypost.length,
          separatorBuilder: (_, __) => commonSizedBox(height: 12),
          itemBuilder: (context, index) {
            final post = state.data!.mypost[index];
            return PostCard(
              id: post.id,
              user: post.author.fullName,
              time: post.createdAt,
              caption: post.caption,
              likeCount: post.likeCount,
              commentCount: post.commentCount,
              isLikedByMe: post.isLiked,
              userImage: post.author.image,
              catagory: post.category,
              myPost: true,
              parentRef: ref,
            );
          },
        ),
      ],
    );
  }

  Widget _leaderboardSection(BuildContext context, CommunityState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        sectionHeader(
          "This Week Leaderboard",
          onTap: () {
            navigateToPage(context: context, LeaderboardView());
          },
        ),
        commonSizedBox(height: 12),
        ListView.separated(
          itemCount: state.data!.leaderboard.topUsers.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => commonSizedBox(height: 12),
          itemBuilder: (context, index) {
            final user = state.data!.leaderboard.topUsers[index];
            return leaderboardCard(
              index: index,
              name: user.fullName,
              points: user.points,
              image: user.image,
            );
          },
        ),
      ],
    );
  }

  Widget _communityFeedSection(
    BuildContext context,
    CommunityState state,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        sectionHeader(
          "Community Feed",
          onTap: () {
            navigateToPage(context: context, CommunityFeedView());
          },
        ),
        commonSizedBox(height: 12),
        ListView.separated(
          itemCount: state.data!.feed.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => commonSizedBox(height: 12),
          itemBuilder: (context, index) {
            final post = state.data!.feed[index];
            return PostCard(
              id: post.id,
              user: post.authorName,
              userImage: post.authorImage,
              time: post.createdAt,
              isLikedByMe: post.isLiked,

              commentCount: post.commentCount,
              likeCount: post.likeCount,
              caption: post.caption,
              catagory: post.category,
              parentRef: ref,
            );
          },
        ),
      ],
    );
  }
}
