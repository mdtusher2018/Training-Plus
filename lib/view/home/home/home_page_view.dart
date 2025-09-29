import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/home/home/home_page_controller.dart';
import 'package:training_plus/view/home/home/widget/home_page_banner.dart';
import 'package:training_plus/view/home/home_providers.dart';
import 'package:training_plus/view/home/my_workouts/my_workouts_view.dart';
import 'package:training_plus/view/home/nutrition_tracker/nutrition_tracker_view.dart';
import 'package:training_plus/view/home/running_gps/running_gps_view.dart';
import 'package:training_plus/view/home/widgets/workoutCard.dart';
import 'package:training_plus/view/home/workout_details/workout_details.dart';
import 'package:training_plus/view/notification/notification_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageView extends ConsumerWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.mainBG,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (state.response == null && state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return RefreshIndicator(
                onRefresh: () async => await controller.fetchHomeData(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: commonText(
                          state.error!,
                          size: 16.sp,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.response == null || state.response!.data == null) {
              return RefreshIndicator(
                onRefresh: () async => await controller.fetchHomeData(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(
                      height: 400,
                      child: Center(child: Text("No data found")),
                    ),
                  ],
                ),
              );
            }

            // ✅ Actual Data Loaded
            return RefreshIndicator(
              onRefresh: () async => await controller.fetchHomeData(),
              child: _buildContent(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    final response = state.response!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// ===== Top Bar =====
        Row(
          children: [
            ClipOval(
              child: CommonImage(
                imagePath: response.data!.attributes.user.image,
                fit: BoxFit.cover,
                width: 32.r,
              ),
            ),
            commonSizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText(
                    "Welcome , ${response.data!.attributes.user.fullName}",
                    size: 14,
                  ),
                  commonText("Ready to train?", size: 18, isBold: true),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                navigateToPage(context: context, NotificationsView());
              },
              child: Container(
                padding: EdgeInsets.all(8.r), // responsive padding
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 20.sp, // responsive icon size
                ),
              ),
            ),
          ],
        ),

        commonSizedBox(height: 20),

        /// ===== Motivational Banner (from API Quotes) =====
        QuoteBanner(quotes: response.quotes),

        commonSizedBox(height: 20),

        /// ===== Stats Grid =====
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "assest/images/home/days.png",
                "${response.streakCount} Days",
                "Streak",
              ),
            ),
            Expanded(
              child: _buildStatCard(
                "assest/images/home/workout.png",
                "${response.data!.attributes.user.workoutCount}",
                "Workouts",
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "assest/images/home/goals.png",
                "${response.data!.attributes.goal.progress}/${response.data!.attributes.goal.target}",
                "Goals",
              ),
            ),
            Expanded(
              child: _buildStatCard(
                "assest/images/home/achivment.png",
                "${response.achievementCount}",
                "Achievement",
              ),
            ),
          ],
        ),

        commonSizedBox(height: 20),

        /// ===== Quick Actions =====
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  navigateToPage(context: context, RunningTrackerPage());
                },
                child: _buildQuickAction(
                  label: "Running\nTracker",
                  imagePath: "assest/images/home/running_track.png",
                ),
              ),
            ),
            commonSizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  navigateToPage(context: context, NutritionTrackerPage());
                },
                child: _buildQuickAction(
                  label: "Nutrition\nTracker",
                  imagePath: "assest/images/home/nutrition_track.png",
                  color1: const Color(0xFF724C21),
                  color2: const Color(0xFFE0CC64),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ),

        commonSizedBox(height: 20),

        /// ===== My Workouts =====
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            commonText("My Workouts", size: 18, isBold: true),
            GestureDetector(
              onTap: () {
                navigateToPage(context: context, MyWorkoutsView());
              },
              child: Row(
                children: [
                  commonText(
                    "See all ",
                    color: AppColors.textSecondary,
                    size: 14,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        commonSizedBox(height: 12),

        SizedBox(
          height: 280,
          child: ListView.separated(
            itemCount: response.workouts.length,
            separatorBuilder: (context, index) => commonSizedBox(width: 10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final workout = response.workouts[index];
              return GestureDetector(
                onTap: () {
                  navigateToPage(
                    context: context,
                    WorkoutDetailPage(id: workout.id),
                  );
                },
                child: buildWorkoutCard(
                  workout.skillLevel,
                  workout.title,
                  workout.watchTime.toStringAsFixed(2),
                  workout.thumbnail,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// ===== Helper Widgets =====
  Widget _buildStatCard(String icon, String value, String label) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(icon),
            ),
            commonSizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText(value, size: 16, isBold: true, maxline: 1),
                  commonText(
                    label,
                    size: 12,
                    color: AppColors.textSecondary,
                    maxline: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required String imagePath,
    required String label,
    Color color1 = const Color(0xFF44330E),
    Color color2 = const Color(0xFFAA7F24),
    Alignment begin = Alignment.bottomCenter,
    Alignment end = Alignment.topCenter,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: begin,
          end: end,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 32, width: 32),
          commonSizedBox(width: 6),
          Expanded(
            child: commonText(
              label,
              size: 14,
              color: Colors.white,
              isBold: true,
              maxline: 2,
            ),
          ),
        ],
      ),
    );
  }
}
