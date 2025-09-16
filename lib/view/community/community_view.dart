import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/CommunityPostView.dart';
import 'package:training_plus/view/community/active_challenges_view.dart';
import 'package:training_plus/view/community/community_controller.dart';
import 'package:training_plus/view/community/community_feed_view.dart';
import 'package:training_plus/view/community/community_model.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/view/community/leaderboard_view.dart';
import 'package:training_plus/view/community/my_posts_view.dart';
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
            }else
            if (state.error != null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: commonText(
                        state.error!,
                        size: 16,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              );
            }
else if(state.data!=null){
       
            
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _activeChallengesSection(context, state),

                _myPostsSection(context,state),

                _leaderboardSection(context,state),

                _communityFeedSection(context),
              ],
            );
            
            
            }else{
              return const SizedBox.shrink();
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

  Widget _activeChallengesSection(BuildContext context, CommunityState state) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          "Active Challenges",
          onTap: () {
            navigateToPage(context: context, ActiveChallengesView());
          },
        ),
        const SizedBox(height: 12),
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
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _myPostsSection(BuildContext context, CommunityState state) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          "My Posts",
          onTap: () {
            navigateToPage(context: context, MyPostsView());
          },
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.data!.mypost.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            MyPost post = state.data!.mypost[index];
            return postCard(
              user: post.author.fullName,
              time: post.createdAt,
              caption: post.caption,
              likeCount: post.likeCount,
              commentCount: post.commentCount,
              isLikedByMe: post.isLiked,
              userImage: post.author.image,              
              context: context,
              myPost: true,
              ontap: () {
                showCommentsBottomSheet(context);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _leaderboardSection(BuildContext context,CommunityState state) {


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
        const SizedBox(height: 12),
        ListView.separated(
          itemCount: state.data!.leaderboard.topUsers.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final user = state.data!.leaderboard.topUsers[index];
            return leaderboardCard(
              index:  index + 1,
              name: user.fullName,
              points: user.points,
              image: user.image,
              
            );
          },
        ),


      ],
    );
  }

  Widget _communityFeedSection(BuildContext context) {
    final List<Map<String, String>> communityPosts = [
      {"user": "Michael Carter", "time": "1hr Ago", "tag": "Soccer"},
      {"user": "Emily Rivera", "time": "1hr Ago", "tag": "Yoga"},
      // Add more posts if needed
    ];

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
        const SizedBox(height: 12),
        ListView.separated(
          itemCount: communityPosts.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final post = communityPosts[index];
            return postCard(
              user: post["user"]!,
              time: post["time"]!,
              isLikedByMe: false,
              userImage: "",

              commentCount: 0,
              likeCount: 0,
              caption: "",
              tag: post["tag"],
              context: context,
              ontap: () {
                showCommentsBottomSheet(context);
              },
            );
          },
        ),
      ],
    );
  }
}
