import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/home/home_providers.dart';

import 'package:training_plus/view/home/video_play_view.dart';
import 'package:training_plus/view/home/workout_details/workout_details_model.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_close_button.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_image.dart';
import 'package:training_plus/core/utils/colors.dart';

class ChaptersPage extends ConsumerStatefulWidget {
  const ChaptersPage({super.key, required this.chapters});
  final List<Chapter> chapters;
  @override
  ConsumerState<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends ConsumerState<ChaptersPage> {
  bool get allDone =>
      widget.chapters.every((ch) => ch.videos.every((v) => v.watched));

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(workoutControllerProvider.notifier);
    final state = ref.read(workoutControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: widget.chapters.length,
              itemBuilder: (context, ci) {
                final chap = widget.chapters[ci];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(chap.name, size: 18, isBold: true),
                    CommonSizedBox(height: 8),
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
                              final response = await controller.completeVideo(
                                video.id,video.duration
                              );

                              if (response['title'] == "Success") {
                                setState(() {
                                  video.watched = true;
                                });

                                context.showCommonSnackbar(
                                  title: response['title']!,
                                  message: response['message']!,
                                  backgroundColor: response['title']=="Success"?AppColors.success:AppColors.error
                                );
                              } else {
                                context.showCommonSnackbar(
                                  title: response['title']!,
                                  message: response['message']!,
                                  backgroundColor: response['title']=="Success"?AppColors.success:AppColors.error
                                );
                              }
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          video.title,
                                          size: 14,
                                          isBold: true,
                                          color: AppColors.textPrimary,
                                        ),
                                        CommonSizedBox(height: 4),
                                        CommonText(
                                          video.duration.toStringAsFixed(2),
                                          size: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Completed check (only show if completed)
                                if (video.watched)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.boxBG,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    CommonSizedBox(height: 16),
                  ],
                );
              },
            ),
          ),

          // Finish Workout button
          Padding(
            padding: const EdgeInsets.all(12),
            child: CommonButton(
              "Finish Workout",
              isLoading: state.endWorkout,
              color:
                  allDone
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.5),
              width: double.infinity,
              onTap: allDone ? ()async{
                     final response =
                                await controller.finishWorkout();
                            if (response['title'] == "Success") {
                                    _showWorkoutCompleteSheet();
                              context.showCommonSnackbar(
                                title: response['title']!,
                                message: response['message']!,
                                backgroundColor:
                                    response['title'] == "Success"
                                        ? AppColors.success
                                        : AppColors.error,
                              );
                            } else {
                              context.showCommonSnackbar(
                                title: response['title']!,
                                message: response['message']!,
                                backgroundColor:
                                    response['title'] == "Success"
                                        ? AppColors.success
                                        : AppColors.error,
                              );
                            }
          
              } : null,
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
                children: [CommonCloseButton(context)],
              ),
              Image.asset("assest/images/home/tophy.png", width: 70),
              CommonSizedBox(height: 16),
              CommonText(
                "Workout\nComplete",
                size: 20,
                isBold: true,
                textAlign: TextAlign.center,
              ),
              CommonSizedBox(height: 24),

              CommonButton(
                "Return Home",

                width: double.infinity,
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              CommonSizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
