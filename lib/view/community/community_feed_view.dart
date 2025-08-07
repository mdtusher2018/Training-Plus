import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class CommunityFeedView extends StatefulWidget {
  const CommunityFeedView({super.key});

  @override
  State<CommunityFeedView> createState() => _CommunityFeedViewState();
}

class _CommunityFeedViewState extends State<CommunityFeedView> {





 final List<Map<String, String>> communityPosts = [
      {"user": "Michael Carter", "time": "1hr Ago", "tag": "Soccer"},
      {"user": "Emily Rivera", "time": "1hr Ago", "tag": "Yoga"},
      {"user": "Michael Carter", "time": "1hr Ago", "tag": "Soccer"},
      {"user": "Emily Rivera", "time": "1hr Ago", "tag": "Yoga"},
      {"user": "Michael Carter", "time": "1hr Ago", "tag": "Soccer"},
      {"user": "Emily Rivera", "time": "1hr Ago", "tag": "Yoga"},
      {"user": "Michael Carter", "time": "1hr Ago", "tag": "Soccer"},
      {"user": "Emily Rivera", "time": "1hr Ago", "tag": "Yoga"},
      {"user": "Michael Carter", "time": "1hr Ago", "tag": "Soccer"},
      {"user": "Emily Rivera", "time": "1hr Ago", "tag": "Yoga"},
      {"user": "Michael Carter", "time": "1hr Ago", "tag": "Soccer"},
      {"user": "Emily Rivera", "time": "1hr Ago", "tag": "Yoga"},
      {"user": "Michael Carter", "time": "1hr Ago", "tag": "Soccer"},
      {"user": "Emily Rivera", "time": "1hr Ago", "tag": "Yoga"},

      // Add more posts if needed
    ];

    


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.boxBG,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new)),
        title: commonText("Community Feed", size: 20, isBold: true),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: communityPosts.length,
        shrinkWrap: true,
        
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final post = communityPosts[index];
          return postCard(
            user: post["user"]!,
            time: post["time"]!,
            tag: post["tag"],
            ontap: () {
            showCommentsBottomSheet(context);                
          },
          );
        },
      )
    );
  }
}