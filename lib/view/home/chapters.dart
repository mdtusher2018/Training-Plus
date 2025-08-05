import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/view/home/video_play_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:training_plus/utils/colors.dart';

class ChaptersPage extends StatefulWidget {
  const ChaptersPage({super.key});

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  final List<Chapter> chapters = [
    Chapter(
      title: 'Chapter 1',
      videos: [
        Video('Basic Touch Drills', '6 min',
            'https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg', false),
        Video('Close Control with Movement', '4 min',
            'https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg', false),
        Video('Basic Touch Drills', '5 min',
            'https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg', false),
      ],
    ),
    Chapter(
      title: 'Chapter 2',
      videos: [
        Video('Ball Mastery Under Pressure', '10 min',
            'https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg', false),
        Video('First Touch Perfection', '7 min',
            'https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg', false),
        Video('Dribble & Turn Combos', '8 min',
            'https://www.nbc.com/sites/nbcblog/files/styles/scale_862/public/2024/07/paris-2024-olympics-soccer.jpg', false),
      ],
    ),
  ];

  bool get allDone =>
      chapters.every((ch) => ch.videos.every((v) => v.completed));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: chapters.length,
              itemBuilder: (context, ci) {
                final chap = chapters[ci];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonText(chap.title, size: 18, isBold: true),
                    const SizedBox(height: 8),
                    ...chap.videos.asMap().entries.map((entry) {
                      
                      final video = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () async {
                            final result = await Get.to(() => const VideoPlayerView());
                            if (result == true) {
                              setState(() {
                                video.completed = true;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Thumbnail
                                CommonImage(
                                  imagePath: video.thumbnail,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),

                                // Title & duration
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        commonText(video.title,
                                            size: 14,
                                            isBold: true,
                                            color: AppColors.textPrimary),
                                        const SizedBox(height: 4),
                                        commonText(video.duration,
                                            size: 12,
                                            color: AppColors.textSecondary),
                                      ],
                                    ),
                                  ),
                                ),

                                // Completed check (only show if completed)
                                if (video.completed)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.boxBG,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.done, color: Colors.green),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),

          // Finish Workout button
          Padding(
            padding: const EdgeInsets.all(12),
            child: commonButton(
              "Finish Workout",
              color: allDone ? AppColors.primary : AppColors.primary.withOpacity(0.5),
              width: double.infinity,
              onTap: allDone ? _showWorkoutCompleteSheet : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showWorkoutCompleteSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppColors.white,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [commonCloseButton()],),
              Image.asset("assest/images/home/tophy.png",width: 70,),
              const SizedBox(height: 16),
              commonText("Workout\nComplete", size: 20, isBold: true, textAlign: TextAlign.center),
              const SizedBox(height: 24),
           
              commonButton(
                "Return Home",
              
                width: double.infinity,
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

// Models
class Chapter {
  final String title;
  final List<Video> videos;
  Chapter({required this.title, required this.videos});
}

class Video {
  final String title;
  final String duration;
  final String thumbnail;
  bool completed;
  Video(this.title, this.duration, this.thumbnail, this.completed);
}
