import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class BadgeShelfView extends StatelessWidget {
  const BadgeShelfView({super.key});

  final List<Map<String, String>> badges = const [
    {
      "icon": "assest/images/profile/badge_self/streak_beast.png",
      "title": "Streak Beast",
      "subtitle": "Run 7 days in a row"
    },
    {
      "icon": "assest/images/profile/badge_self/weekend_warrior.png",
      "title": "Weekend Warrior",
      "subtitle": "10 weekend runs"
    },
    {
      "icon": "assest/images/profile/badge_self/5k_finisher.png",
      "title": "5K Finisher",
      "subtitle": "Complete a 5K"
    },
    {
      "icon": "assest/images/profile/badge_self/social_starter.png",
      "title": "Social Starter",
      "subtitle": "Share 5 workouts"
    },
    {
      "icon": "assest/images/profile/badge_self/clip_king.png",
      "title": "Clip King/Queen",
      "subtitle": "Share 10 highlight videos"
    },
    {
      "icon": "assest/images/profile/badge_self/pace_breaker.png",
      "title": "Pace Breaker",
      "subtitle": "Beat 8:00/mile pace\nfor 2+ miles"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("Badge Shelf", size: 21, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDEE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CommonImage(
                        imagePath: badge["icon"]!,
                        isAsset: true,
                        height: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  commonText(badge["title"]!,
                      size: 14, isBold: true, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  commonText(badge["subtitle"]!,
                      size: 12,
                      color: Colors.grey.shade800,
                      textAlign: TextAlign.center),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
