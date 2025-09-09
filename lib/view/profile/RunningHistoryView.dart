import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class RunningHistoryView extends StatelessWidget {
  const RunningHistoryView({super.key});

  final List<Map<String, String>> runs = const [
    {
      "title": "Marine Bay Park",
      "distance": "8.4 Km",
      "timeAgo": "2 hrs",
      "duration": "35:08",
      "pace": "4:11 min/km",
    },
    {
      "title": "Central Park",
      "distance": "6.2 Km",
      "timeAgo": "1 hr",
      "duration": "28:55",
      "pace": "4:39 min/km",
    },
    {
      "title": "Golden Gate Park",
      "distance": "9.3 Km",
      "timeAgo": "3 hrs",
      "duration": "42:10",
      "pace": "4:32 min/km",
    },
    {
      "title": "Hyde Park",
      "distance": "7.5 Km",
      "timeAgo": "5 hrs",
      "duration": "32:25",
      "pace": "4:19 min/km",
    },
    {
      "title": "Balboa Park",
      "distance": "4.8 Km",
      "timeAgo": "20 mins",
      "duration": "20:50",
      "pace": "4:20 min/km",
    },
    {
      "title": "Lincoln Park",
      "distance": "5.5 Km",
      "timeAgo": "30 mins",
      "duration": "26:40",
      "pace": "4:50 min/km",
    },
    {
      "title": "Stanley Park",
      "distance": "10.1 Km",
      "timeAgo": "4 hrs",
      "duration": "45:15",
      "pace": "4:29 min/km",
    },
    {
      "title": "City Park",
      "distance": "3.9 Km",
      "timeAgo": "15 mins",
      "duration": "18:25",
      "pace": "4:43 min/km",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.boxBG,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("Running History", size: 21, isBold: true),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: runs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final run = runs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CommonImage(
                    imagePath: "assest/images/profile/runing_map.png",
                    isAsset: true,
                    height: 60,
                    width: 60,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: commonText(run["title"]!, size: 16, isBold: true,maxline: 1)),
                          commonText(run["distance"]!,
                              size: 16, isBold: true),
                        ],
                      ),
                      const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        commonText(run["duration"]!,
                          size: 12, color: AppColors.textSecondary
                        ),
                      ],
                    ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                     
                                Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: AppColors.textPrimary),
                          const SizedBox(width: 4),
                          commonText("${run["timeAgo"]!} Ago",
                              size: 12, color: AppColors.textSecondary),
                        ],
                      ),
                          commonText(run["pace"]!,
                              size: 12, color: AppColors.textSecondary),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
