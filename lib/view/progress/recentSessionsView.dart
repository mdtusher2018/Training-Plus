import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/progress/widget/recent_session_card.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class RecentSessionsView extends StatelessWidget {
  RecentSessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBG,
     appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("Recent Sessions", size: 21, isBold: true),
      ),
        
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
