// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/profile/Badge%20Shelf/BadgeShelfView.dart';
import 'package:training_plus/common_used_models/recent_training_model.dart';
import 'package:training_plus/view/progress/progress/progress_controller.dart';
import 'package:training_plus/view/progress/progress/progress_models.dart';
import 'package:training_plus/view/progress/progress_provider.dart';
import 'package:training_plus/view/progress/all_recent_sessions/recentSessionsView.dart';
import 'package:training_plus/view/progress/widget/recent_session_card.dart';
import 'package:training_plus/widgets/common_error_message.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text_field_with_title.dart';
import 'package:training_plus/widgets/common_close_button.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_dropdown.dart';
import 'package:training_plus/widgets/common_image.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressView extends ConsumerWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressControllerProvider);
    final controller = ref.read(progressControllerProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 50.h,
        backgroundColor: AppColors.boxBG,
        title: CommonText("Progress", size: 20, fontWeight: FontWeight.bold),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchProgress();
        },
        child:
            (state.progress == null)
                ? const Center(child: CircularProgressIndicator())
                : (state.progress == null && state.isLoading)
                // Full-screen loader for first load
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                // Show error in a scrollable ListView so RefreshIndicator works
                ? CommonErrorMassage(context: context, massage: state.error!)
                // Normal loaded state
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTrainingActivityChart(
                        state: state,
                        controller: controller,
                      ),
                      CommonSizedBox(height: 16),
                      _buildSportsActivityChart(
                        state: state,
                        controller: controller,
                      ),
                      CommonSizedBox(height: 16),
                      _buildGoalsSection(goals: state.progress!.mygoal),
                      CommonSizedBox(height: 16),
                      _buildRecentSessions(
                        context: context,
                        sessions: state.progress!.recentTraining,
                      ),
                      CommonSizedBox(height: 16),
                      _buildAchievements(
                        context: context,
                        achievements: state.progress!.achievements,
                      ),
                      CommonSizedBox(height: 20),
                      _buildSetGoalsButton(
                        context,
                        state: state,
                        controller: controller,
                      ),
                      CommonSizedBox(height: 20),
                    ],
                  ),
                ),
      ),
    );
  }

  // Widget _buildTrainingActivityChart() {
  Widget _buildTrainingActivityChart({
    required ProgressState state,
    required ProgressController controller,
  }) {
    final monthlyData = state.progress?.progressChart.monthly ?? [];
    final weeklyData = state.progress?.progressChart.weekly ?? [];

    final list = state.isMonthly ? monthlyData : weeklyData;

    // Calculate height dynamically based on number of bars and device height
    final chartHeight = (list.length <= 7 ? 180 : 200).h;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CommonText(
                "Training Activity",
                size: 14,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.switchMonthly(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    children: [
                      CommonText(
                        state.isMonthly ? "Monthly" : "Weekly",
                        size: 12,
                      ),
                      Icon(Icons.arrow_drop_down, size: 20.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),
          CommonSizedBox(height: 16.h),
          SizedBox(
            height: chartHeight,

            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      getTitlesWidget: (value, meta) {
                        return CommonText(value.toStringAsFixed(1), size: 8);
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30.h, // 🔑 reserve space for labels
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < list.length) {
                          String label = list[value.toInt()].label;
                          if (label.length > 3) label = label.substring(0, 3);
                          return CommonText(label, size: 7);
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                barGroups: List.generate(list.length, (index) {
                  final item = list[index];
                  return BarChartGroupData(
                    x: index,
                    barsSpace: 8.w, // responsive spacing between bars
                    barRods: [
                      BarChartRodData(
                        toY: item.totalCompleted.toDouble(),
                        width: state.isMonthly ? 16.w : 24.w,
                        borderRadius: BorderRadius.circular(4.r),
                        color: AppColors.primary,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportsActivityChart({
    required ProgressState state,
    required ProgressController controller,
  }) {
    if (state.progress?.pieChart == null) {
      return Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state.progress!.pieChart.data.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(child: CommonText("No sports activity data")),
      );
    }

    final pieChart = state.progress!.pieChart;
    final total = pieChart.data.fold<int>(
      0,
      (sum, item) => sum + item.totalCompleted,
    );

    // Define colors dynamically (or keep a fixed palette)
    final colors = [
      Colors.amber.shade200,
      Colors.amber.shade400,
      Colors.amber.shade600,
      Colors.brown.shade400,
      Colors.yellow.shade300,
      Colors.yellow.shade600,
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CommonText(
                "Sports Activity",
                size: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          CommonSizedBox(height: 12),
          SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: List.generate(pieChart.data.length, (index) {
                  final item = pieChart.data[index];
                  final color = colors[index % colors.length];
                  final value =
                      total == 0 ? 0 : (item.totalCompleted / total) * 100;

                  return PieChartSectionData(
                    color: color,
                    value: value as double,
                    title: '',
                  );
                }),
              ),
            ),
          ),
          CommonSizedBox(height: 12),
          Wrap(
            spacing: 12,
            alignment: WrapAlignment.center,
            runSpacing: 6,
            children: List.generate(pieChart.data.length, (index) {
              final item = pieChart.data[index];
              final color = colors[index % colors.length];
              return _buildDot(item.label, color);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.sp,
          height: 10.sp,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        CommonSizedBox(width: 6),
        CommonText(label, size: 11),
      ],
    );
  }

  Widget _buildGoalsSection({required List<MyGoal> goals}) {
    if (goals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CommonText("No goals found", size: 14),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText("Goals", size: 14, fontWeight: FontWeight.w600),
          CommonSizedBox(height: 12),
          ...goals.map((goal) {
            double percent =
                (goal.target == 0) ? 1.0 : goal.progress / goal.target;

            String title =
                "${goal.timeFrame[0].toUpperCase()}${goal.timeFrame.substring(1)} ${goal.sports} Goals";

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8.w,
                    children: [
                      Flexible(child: CommonText(title, size: 12)),
                      Flexible(
                        child: CommonText(
                          "${goal.progress}/${goal.target} Sessions",
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                  CommonSizedBox(height: 6),
                  LinearProgressIndicator(
                    value: percent,
                    backgroundColor: AppColors.boxBG,
                    color: AppColors.primary,
                    minHeight: 16.h,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentSessions({
    required BuildContext context,
    required List<RecentTraining> sessions,
  }) {
    if (sessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.mainBG,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(width: 1.w, color: Colors.grey.withOpacity(0.5)),
        ),
        child: CommonText("No recent sessions found", size: 14),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.mainBG,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1.w, color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.h,
        children: [
          Row(
            children: [
              CommonText(
                "Recent Sessions",
                size: 14,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.navigateTo(
 RecentSessionsView());
                },
                child: Row(
                  children: [
                    CommonText("See all", size: 12),
                    CommonSizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 20.sp),
                  ],
                ),
              ),
            ],
          ),

          ...sessions.map((session) {
            // Format updatedAt to something like "Today | 20 Min"
            final now = DateTime.now();
            final difference = now.difference(session.updatedAt);
            String timeLabel;
            if (difference.inDays == 0) {
              timeLabel = "Today | ${session.watchTime}";
            } else if (difference.inDays == 1) {
              timeLabel = "Yesterday | ${session.watchTime}";
            } else {
              timeLabel =
                  "${difference.inDays} days ago | ${session.watchTime}";
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RecentSessionCard(
                title: session.workoutName,
                subtitle: timeLabel,
                tag: session.sportsname,
                tagImageUrl: session.thumbnail ?? '', // fallback if null
                onTap: () {
                  // Handle tap, e.g., navigate to workout details
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAchievements({
    required BuildContext context,
    required List<Achievement> achievements,
  }) {
    if (achievements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.mainBG,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
        ),
        child: CommonText("No achievements yet", size: 14),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.mainBG,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1.w, color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonText("Achievements", size: 14, fontWeight: FontWeight.w600),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.navigateTo(
 BadgeShelfView());
                },
                child: Row(
                  children: [
                    CommonText("See all", size: 12),
                    CommonSizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 20.sp),
                  ],
                ),
              ),
            ],
          ),
          CommonSizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, i) {
              final achievement = achievements[i];
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDEE),
                  borderRadius: BorderRadius.circular(12.sp),
                  border: Border.all(color: AppColors.primary, width: 1.w),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FittedBox(
                        child: CommonImage(
                          imagePath: achievement.badgeImage,
                          isAsset: false,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    CommonText(
                      achievement.badgeName,
                      size: 14,
                      isBold: true,
                      textAlign: TextAlign.center,
                    ),
                    CommonSizedBox(height: 4),
                    CommonText(
                      achievement.description,
                      size: 12,
                      color: Colors.grey.shade800,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          CommonSizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSetGoalsButton(
    BuildContext context, {
    required ProgressState state,
    required ProgressController controller,
  }) {
    return GestureDetector(
      onTap: () {
        if (state.categories.isEmpty) {
          controller.fetchCategories().then((value) {
            showSetGoalBottomSheet(
              context,
              state: state,
              controller: controller,
            );
          });
        } else {
          showSetGoalBottomSheet(context, state: state, controller: controller);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF724C21), Color(0xFFE0CC64)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assest/images/home/goals.png", height: 32, width: 32),
            CommonSizedBox(width: 6),
            Expanded(
              child: CommonText(
                "Set Goals",
                size: 16,
                color: Colors.white,
                isBold: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSetGoalBottomSheet(
    BuildContext context, {
    required ProgressState state,
    required ProgressController controller,
  }) {
    final TextEditingController targetController = TextEditingController();

    final List<String> timeFrameList = ["Weekly", "Monthly"];

    // Initial selected values
    String? selectedSportId =
        state.categories.isNotEmpty ? state.categories.first.id : null;
    String? selectedTimeFrame = timeFrameList.first;
    bool isLoading = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 10,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonSizedBox(height: 16),
                        Center(
                          child: CommonText("Set Goal", size: 20, isBold: true),
                        ),
                        CommonSizedBox(height: 24),

                        /// Sports Dropdown
                        CommonText(
                          "Select Sports",
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        CommonSizedBox(height: 8),
                        CommonDropdown<String>(
                          items:
                              state.categories
                                  .map((c) => c.name)
                                  .toList(), // map names
                          value:
                              selectedSportId != null
                                  ? state.categories
                                      .firstWhere(
                                        (c) => c.id == selectedSportId,
                                      )
                                      .name
                                  : null,
                          hint: "Select Sports",
                          onChanged: (value) {
                            final category = state.categories.firstWhere(
                              (c) => c.name == value,
                            );
                            setState(() {
                              selectedSportId = category.id;
                            });
                          },
                        ),

                        CommonSizedBox(height: 24),

                        /// Target TextField
                        CommonTextfieldWithTitle(
                          "Target",
                          targetController,
                          hintText: "Type Target",
                          keyboardType: TextInputType.number,
                        ),

                        CommonSizedBox(height: 24),

                        /// Time Frame Dropdown
                        CommonText(
                          "Select Time Frame",
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        CommonSizedBox(height: 8),
                        CommonDropdown<String>(
                          items: timeFrameList,
                          value: selectedTimeFrame,
                          hint: "Select Time Frame",
                          onChanged: (value) {
                            setState(() => selectedTimeFrame = value);
                          },
                        ),

                        CommonSizedBox(height: 32),

                        /// Set Goal Button
                        CommonButton(
                          "Set Goal",
                          isLoading: isLoading,
                          onTap: () async {
                            double? target = double.tryParse(
                              targetController.text.trim(),
                            );
                            if (selectedSportId != null && target != null) {
                              setState(() {
                                isLoading = true;
                              });
                              final response = await controller.setGoal(
                                context: context,
                                sportId: selectedSportId!,
                                target:
                                    int.tryParse(targetController.text) ?? 0,
                                timeFrame: selectedTimeFrame!,
                              );
                              Navigator.pop(context);
                              context.showCommonSnackbar(
                                title: response["title"].toString(),
                                message: response["massage"].toString(),
                                backgroundColor:
                                    response['title'] == "Successful"
                                        ? AppColors.success
                                        : AppColors.error,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              context.showCommonSnackbar(
                                
                                title: "Empty",
                                message: "Please Enter Valid Number as Target",
                                backgroundColor: AppColors.error,
                              );
                            }
                          },
                        ),

                        CommonSizedBox(height: 32),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CommonCloseButton(context),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
