import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.boxBG,
        elevation: 0,
        title: commonText("Community", size: 20, isBold: true),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _activeChallengesSection(),
            const SizedBox(height: 24),
            _myPostsSection(),
            const SizedBox(height: 24),
            _leaderboardSection(),
            const SizedBox(height: 24),
            _communityFeedSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _activeChallengesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader("Active Challenges"),
        const SizedBox(height: 12),
        challengeCard("7 Day Soccer Challenge", "Joined", 234, 3, 5 / 7),
        const SizedBox(height: 12),
        challengeCard("Wellness Week", "Join", 189, 3, null),
        const SizedBox(height: 12),
        challengeCard("21 Day Meditation Challenge", "Join", 234, 3, null),
      ],
    );
  }


  Widget _myPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader("My Posts"),
        const SizedBox(height: 12),
        _postCard(user: "You", time: "1 Day Ago",myPost: true),
        const SizedBox(height: 12),
        _postCard(user: "You", time: "1 Day Ago",myPost: true),
      ],
    );
  }

  Widget _leaderboardSection() {
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
        sectionHeader("This Week Leaderboard"),
        const SizedBox(height: 12),
        ...leaders.asMap().entries.map((entry) {
          final index = entry.key;
          final name = entry.value[0];
          final points = entry.value[1];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                commonText("${index + 1}", size: 14, isBold: true),
                const SizedBox(width: 8),
                CircleAvatar(radius: 16,backgroundImage: NetworkImage("https://plus.unsplash.com/premium_photo-1664297814064-661d433c03d9?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")),
                const SizedBox(width: 12),
                Expanded(child: commonText(name.toString(), size: 14)),
                commonText("$points\nPoints", size: 14, fontWeight: FontWeight.w600,textAlign: TextAlign.left),
              ],
            ),
          );
        })
      ],
    );
  }

  Widget _communityFeedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader("Community Feed"),
        const SizedBox(height: 12),
        _postCard(user: "Michael Carter", time: "1hr Ago", tag: "Soccer"),
        const SizedBox(height: 12),
        _postCard(user: "Emily Rivera", time: "1hr Ago", tag: "Yoga"),
      ],
    );
  }

  Widget _postCard({required String user, required String time, String? tag,bool myPost=false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20,backgroundImage: NetworkImage("https://plus.unsplash.com/premium_photo-1664297814064-661d433c03d9?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonText(user, size: 14, isBold: true),
                    commonText(time, size: 12, color: AppColors.textSecondary),
                  ],
                ),
              ),

              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: commonText(tag, size: 12),
                ),
              if(myPost)...[Icon(Icons.edit),SizedBox(width: 4,),
              Icon(Icons.delete_outline_rounded)]
            ],
          ),
          const SizedBox(height: 12),
          commonText(
            "Just completed my first 5K run today! 🏃‍♂️ The feeling of crossing that finish line was incredible. Started training just 2 months ago and couldn’t even run for 5 minutes straight. Now look at me!",
            size: 13,maxline: 4
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite_border, size: 16),
              const SizedBox(width: 4),
              commonText("15", size: 12),
              const SizedBox(width: 16),
              const Icon(Icons.mode_comment_outlined, size: 16),
              const SizedBox(width: 4),
              commonText("6", size: 12),
            ],
          )
        ],
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Row(
      
      children: [
        Expanded(child: commonText(title, size: 16, isBold: true,maxline: 1)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            commonText("See all "),
            const Icon(Icons.arrow_forward, size: 14,color: AppColors.primary,),
          ],
        ),
      ],
    );
  }
}
