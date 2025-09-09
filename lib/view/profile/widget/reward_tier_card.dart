import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

Widget rewardTierCard(int points) {
  final tiers = [
    {
      'title': 'Starter',
      'points': 100,
      'next': 400,
      'colors': [Color(0xFFFCE38A), Color(0xFFF38181)],
      'desc': '400 Points to next tier',
    },
    {
      'title': 'Grinder',
      'points': 500,
      'next': 200,
      'colors': [Color(0xFF43CEA2), Color(0xFF185A9D)],
      'desc': '200 Points to next tier',
    },
    {
      'title': 'Pacer',
      'points': 1000,
      'next': 750,
      'colors': [Color(0xFFF7971E), Color(0xFFFFD200)],
      'desc': '750 Points to next tier',
    },
    {
      'title': 'Strider',
      'points': 2000,
      'next': 750,
      'colors': [Color(0xFF00C9FF), Color(0xFF92FE9D)],
      'desc': '750 Points to next tier',
    },
    {
      'title': 'Finisher',
      'points': 3500,
      'next': 750,
      'colors': [Color(0xFFFC466B), Color(0xFF3F5EFB)],
      'desc': '750 Points to next tier',
    },
    {
      'title': 'Plus Champ',
      'points': 5200,
      'next': 0,
      'colors': [Color(0xFFDA22FF), Color(0xFF9733EE)],
      'desc': 'You\'ve hit the peak!',
    },
  ];

  // Find current tier
  Map<String, dynamic> currentTier = tiers.first;
  for (final tier in tiers) {
    if (points >= (tier['points'] as num)) currentTier = tier;
  }

  final int basePoints = currentTier['points'];
  // final int nextPoints = (basePoints + currentTier['next']).toInt();
  final double progress = currentTier['next'] == 0
      ? 1.0
      : (points - basePoints) / currentTier['next'];
  final List<Color> gradientColors = currentTier['colors'];

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: gradientColors,end: Alignment.centerLeft,begin: Alignment.centerRight
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: commonText(
                currentTier['title'],
                
                size: 18,
                color: AppColors.white,
                isBold: true
                
              ),
            ),
            CommonImage(imagePath: "assest/images/profile/points.png",width: 24,isAsset: true,),
            const SizedBox(width: 4),
            commonText(
              "$points POINTS",
              color: Colors.white,size: 14,
              isBold: true
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: commonText(
            currentTier['desc'],
            size: 12,
            color: AppColors.white
          ),
        ),
      ],
    ),
  );
}
