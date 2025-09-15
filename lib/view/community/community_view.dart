import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/CommunityPostView.dart';
import 'package:training_plus/view/community/active_challenges_view.dart';
import 'package:training_plus/view/community/community_feed_view.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _activeChallengesSection(context),

            _myPostsSection(context),

            _leaderboardSection(context),

            _communityFeedSection(context),
          ],
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

  Widget _activeChallengesSection(BuildContext context) {
    final List<Map<String, dynamic>> challenges = [
      {
        'title': "7 Day Soccer Challenge",
        'status': "Joined",
        'participants': 234,
        'daysLeft': 3,
        'progress': 5 / 7,
      },
      {
        'title': "Wellness Week",
        'status': "Join",
        'participants': 189,
        'daysLeft': 3,
        'progress': null,
      },
      {
        'title': "21 Day Meditation Challenge",
        'status': "Join",
        'participants': 234,
        'daysLeft': 3,
        'progress': null,
      },
    ];

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
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: challengeCard(
                challenge['title'],
                challenge['status'],
                challenge['participants'],
                challenge['daysLeft'],
                challenge['progress'],
                onTap: () {
                  showChallengeDetailsBottomSheet(
                    context,
                    isJoined: challenge['progress'] == null,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _myPostsSection(BuildContext context) {
    final List<Map<String, dynamic>> myPosts = [
      {"user": "You", "time": "1 Day Ago"},
      {"user": "You", "time": "1 Day Ago"},
      // Add more posts here if needed
    ];

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
          itemCount: myPosts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final post = myPosts[index];
            return postCard(
              user: post['user'],
              time: post['time'],
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

  Widget _leaderboardSection(BuildContext context) {
    final leaders = [
      ["Jordan Lee", 1350],
      ["Sarah Smith", 1270],
      ["Morgan Davis", 1210],
      ["Jamie Brown", 1150],
      ["Casey Taylor", 1050],
    ];

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
        ...leaders.asMap().entries.map((entry) {
          final index = entry.key;
          final name = entry.value[0];
          final points = entry.value[1];
          return leaderboardCard(
            points: points as num,
            index: index,
            name: name as String,
          );
        }),
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
