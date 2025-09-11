import 'package:flutter/material.dart';

import 'package:training_plus/view/home/video_play_view.dart';
import 'package:training_plus/view/home/workout_details/workout_details_model.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:training_plus/core/utils/colors.dart';

class ChaptersPage extends StatefulWidget {
  const ChaptersPage({super.key,required this.chapters});
final List<Chapter> chapters;
  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {

  bool get allDone =>
      widget. chapters.every((ch) => ch.videos.every((v) => v.completed));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount:widget. chapters.length,
              itemBuilder: (context, ci) {
                final chap = widget.chapters[ci];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonText(chap.name, size: 18, isBold: true),
                    const SizedBox(height: 8),
                    ...chap.videos.asMap().entries.map((entry) {
                      
                      final video = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                         onTap: () async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const VideoPlayerView(),
      ),
    );

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
                                        commonText(video.duration.toStringAsFixed(2),
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
                children: [commonCloseButton(context)],),
              Image.asset("assest/images/home/tophy.png",width: 70,),
              const SizedBox(height: 16),
              commonText("Workout\nComplete", size: 20, isBold: true, textAlign: TextAlign.center),
              const SizedBox(height: 24),
           
              commonButton(
                "Return Home",
              
                width: double.infinity,
                onTap: () {
                   Navigator.of(context).popUntil((route) => route.isFirst);
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

