import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/home/workout_details/chapters.dart';
import 'package:training_plus/view/home/home_providers.dart';
import 'package:training_plus/view/home/widgets/common_videoplayer.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:training_plus/core/utils/colors.dart';

class WorkoutDetailPage extends ConsumerStatefulWidget {
  final String id;
  const WorkoutDetailPage({super.key, required this.id});

  @override
  ConsumerState<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends ConsumerState<WorkoutDetailPage> {
  @override
  void initState() {
    super.initState();
    // Fetch workout once when the page loads
    Future.microtask(() {
      ref.read(workoutControllerProvider.notifier).fetchWorkout(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutControllerProvider);
    final workoutController = ref.watch(workoutControllerProvider.notifier);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await workoutController.fetchWorkout(widget.id);
        },
        child:
            (workoutState.workout == null && workoutState.isLoading)
                ? const Center(child: CircularProgressIndicator())
                : workoutState.error != null
                ? commonErrorMassage(
                  context: context,
                  massage: workoutState.error!,
                )
                : workoutState.workout == null
                ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: commonText(
                          "No workout data",
                          size: 16,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          ListView(
                            children: [
                              // HEADER VIDEO
                              SizedBox(
                                height: 280,
                                child: commonVideoPlayer(
                                  videoUrl: workoutState.workout!.previewVideo,
                                ),
                              ),

                              // DETAILS
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Title & Share
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: commonText(
                                            workoutState.workout!.title,
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
                                                              
                                    commonSizedBox(height: 8),
                                                              
                                    // Level
                                    commonText(
                                      workoutState.workout!.skillLevel,
                                      size: 16,
                                      color: AppColors.textPrimary,
                                    ),
                                                              
                                    commonSizedBox(height: 8),
                                                              
                                    // Duration Row
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                        commonSizedBox(width: 4),
                                        commonText(
                                          workoutState.workout!.duration
                                              .formatDuration(),
                                          size: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                    commonSizedBox(height: 12),
                                                              
                                    // About Header
                                    commonText(
                                      "About this training",
                                      size: 16,
                                      isBold: true,
                                      color: AppColors.textPrimary,
                                    ),
                                    commonSizedBox(height: 8),
                                                              
                                    // Description
                                    commonText(
                                      workoutState.workout!.description,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                      softwarp: true,
                                      maxline: 10,
                                    ),
                                                              
                                    commonSizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Positioned(
                            top: 80,
                            left: 24,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // START WORKOUT BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: commonButton(
                        "Start Workout",
                        isLoading: workoutState.startWorkout,
                        width: double.infinity,
                        onTap: () async {
                          final response =
                              await workoutController.startWorkout();
                          if (response['title'] == "Success") {
                            navigateToPage(
                              context: context,
                              ChaptersPage(
                                chapters: workoutState.workout!.chapters,
                              ),
                            );
                            commonSnackbar(
                              context: context,
                              title: response['title']!,
                              message: response['message']!,
                              backgroundColor:
                                  response['title'] == "Success"
                                      ? AppColors.success
                                      : AppColors.error,
                            );
                          } else {
                            commonSnackbar(
                              context: context,
                              title: response['title']!,
                              message: response['message']!,
                              backgroundColor:
                                  response['title'] == "Success"
                                      ? AppColors.success
                                      : AppColors.error,
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
      ),
    );
  }
}
