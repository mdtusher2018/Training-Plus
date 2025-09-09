import 'package:flutter/material.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/home/workout_details.dart';
import 'package:training_plus/view/training/chooseYourSportChange.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({super.key});

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: commonText("Training", size: 21, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: AppColors.mainBG,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentTrainingCard(),

            const SizedBox(height: 16),
            _buildTabs(),

            const SizedBox(height: 16),
            if (selectedTab == 0)
              _buildTrainingList(
                sessions: [
                  {
                    "image":
                        "https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg", // Image for Soccer
                    "title": "Ball Control Mastery",
                    "level": "Intermediate",
                    "duration": "25 min",
                  },
                  {
                    "image":
                        "https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg", // Same image
                    "title": "Passing Precision",
                    "level": "Advanced",
                    "duration": "30 min",
                  },
                  {
                    "image":
                        "https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg", // Same image
                    "title": "Dribbling Drills",
                    "level": "Advanced",
                    "duration": "45 min",
                  },
                  {
                    "image":
                        "https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg", // Same image
                    "title": "Shooting Accuracy",
                    "level": "Beginner",
                    "duration": "20 min",
                  },
                ],
              ),

            if (selectedTab == 1)
              _buildTrainingList(
                sessions: [
                  {
                    "image":
                        "https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg", // Same image for Basketball
                    "title": "Dribble Mastery",
                    "level": "Advanced",
                    "duration": "35 min",
                  },
                  {
                    "image":
                        "https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg", // Same image
                    "title": "Passing Precision",
                    "level": "Intermediate",
                    "duration": "25 min",
                  },
                  {
                    "image":
                        "https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg", // Same image
                    "title": "Shooting Accuracy",
                    "level": "Advanced",
                    "duration": "30 min",
                  },
                  {
                    "image":
                        "https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg", // Same image
                    "title": "Defensive Drills",
                    "level": "Intermediate",
                    "duration": "40 min",
                  },
                ],
              ),

            const SizedBox(height: 24),
            _buildWellnessToolkit(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTrainingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText("Current Training", size: 18),
                commonText("Soccer", size: 14, isBold: true),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
navigateToPage(context: context, ChooseYourSportChangeView());
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
              ),
              child: commonText(
                "Change",
                size: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedTab = 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selectedTab == 0 ? AppColors.primary : AppColors.boxBG,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: commonText(
                  "My Trainings",

                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedTab = 1),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selectedTab == 1 ? AppColors.primary : AppColors.boxBG,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: commonText(
                  "Completed",

                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingList({required List<Map<String, String>> sessions}) {
    return Column(
      children: sessions.map((session) => _buildTrainingCard(session)).toList(),
    );
  }

  Widget _buildTrainingCard(Map<String, String> session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Image.network(
              session["image"]!,
              width: 100,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText(
                    session["title"]!,
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  commonText(
                    session["level"]!,
                    size: 14,
                    color: AppColors.green,
                  ),
                  const SizedBox(height: 4),
                  commonText(
                    session["duration"]!,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessToolkit() {
    final tools = [
      {"title": "Breathing", "subtitle": "5 min"},
      {"title": "Meditation", "subtitle": "5 min"},
      {"title": "Journaling", "subtitle": "5 min"},
      {"title": "Mobility", "subtitle": "5 min"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonText("Wellness Toolkit", size: 18, fontWeight: FontWeight.w600),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children:
                tools.map((tool) {
                  return GestureDetector(
                    onTap: () {
                      navigateToPage(context: context,WorkoutDetailPage());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.boxBG,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonText(
                            tool["title"]!,
                            size: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          commonText(
                            "${tool["subtitle"]!} exercises",
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
