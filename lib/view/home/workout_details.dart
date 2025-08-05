import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/view/home/chapters.dart';
import 'package:training_plus/view/home/widgets/common_videoplayer.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:training_plus/utils/colors.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Column(
        children: [
          // HEADER IMAGE + PLAY BUTTON
        SizedBox(child: commonVideoPlayer(videoUrl: "http://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),height: 280,),
          // DETAILS
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Share
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: commonText(
                          "Ball Control Mastery",
                          size: 20,
                          isBold: true,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // share action
                        },
                        child: const Icon(
                          Icons.share,
                          size: 24,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                

                  // Level
                  commonText(
                    "Intermediate",
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
             

                  // Duration Row
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      commonText("30 min", size: 14, color: AppColors.textSecondary),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // About Header
                  commonText(
                    "About this training",
                    size: 16,
                    isBold: true,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  commonText(
                    "Sharpen your touch and elevate your game with drills focused on improving close control, footwork, and reaction speed. This session includes cone work, toe taps, turns, and small-space ball handling to help you maintain possession under pressure and play with confidence on the field.",
                    size: 14,
                    color: AppColors.textSecondary,
                    softwarp: true,
                    maxline: 10,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // START WORKOUT BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: commonButton(
              "Start Workout",
    
              width: double.infinity,
              onTap: () {
                Get.to(ChaptersPage());
              },
            ),
          ),
        ],
      ),
    );
  }
}
