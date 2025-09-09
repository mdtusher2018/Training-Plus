import 'package:flutter/material.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class MyPostsView extends StatefulWidget {
  const MyPostsView({super.key});

  @override
  State<MyPostsView> createState() => _MyPostsViewState();
}

class _MyPostsViewState extends State<MyPostsView> {
  final List<Map<String, dynamic>> myPosts = [
    {"user": "You", "time": "1 Day Ago"},
    {"user": "You", "time": "1 Day Ago"},
    {"user": "You", "time": "1 Day Ago"},
    {"user": "You", "time": "1 Day Ago"},
    {"user": "You", "time": "1 Day Ago"},
    {"user": "You", "time": "1 Day Ago"},
    {"user": "You", "time": "1 Day Ago"},
    {"user": "You", "time": "1 Day Ago"},
    // Add more posts here if needed
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
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: commonText("Active Community", size: 20, isBold: true),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,

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
    );
  }
}
