import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/progress/widget/recent_session_card.dart';

class RecentSessionsView extends StatelessWidget {
  RecentSessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBG,
      appBar: AppBar(leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios_new)),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(height: 16,),
          itemBuilder: (context, index) {
          return RecentSessionCard(
          title: "Master Ball Control",
          subtitle: "Today | 20 Min",
          tag: "Soccer",
          tagImageUrl: "https://www.pikpng.com/pngl/b/52-520496_png-soccer-ball-soccer-ball-logo-png-clipart.png", // replace with your image
          onTap: () {
            // Handle tap
          },
        );
        },),
      )
    );
  }
}
