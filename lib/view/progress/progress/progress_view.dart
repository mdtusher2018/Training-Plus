// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/profile/Badge%20Shelf/BadgeShelfView.dart';
import 'package:training_plus/view/progress/common_used_models/recent_training_model.dart';
import 'package:training_plus/view/progress/progress/progress_controller.dart';
import 'package:training_plus/view/progress/progress/progress_models.dart';
import 'package:training_plus/view/progress/progress_provider.dart';
import 'package:training_plus/view/progress/all_recent_sessions/recentSessionsView.dart';
import 'package:training_plus/view/progress/widget/recent_session_card.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressView extends ConsumerWidget {
  ProgressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressControllerProvider);
    final controller = ref.read(progressControllerProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.boxBG,
        title: commonText("Progress", size: 20, fontWeight: FontWeight.bold),
      ),
      body:
          RefreshIndicator(
            onRefresh: () async{
              await controller.fetchProgress();
            },
            child:(state.progress==null)?const Center(child: CircularProgressIndicator()) : (state.progress == null && state.isLoading)
      // Full-screen loader for first load
      ? const Center(child: CircularProgressIndicator())
      : state.error != null
          // Show error in a scrollable ListView so RefreshIndicator works
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: commonText(
                      state.error!,
                      size: 16,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            )
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
                      const SizedBox(height: 16),
                      _buildSportsActivityChart(
                        state: state,
                        controller: controller,
                      ),
                      const SizedBox(height: 16),
                      _buildGoalsSection(goals: state.progress!.mygoal),
                      const SizedBox(height: 16),
                      _buildRecentSessions(
                        context: context,
                        sessions: state.progress!.recentTraining,
                      ),
                      const SizedBox(height: 16),
                      _buildAchievements(
                        context: context,
                        achievements: state.progress!.achievements,
                      ),
                      const SizedBox(height: 20),
                      _buildSetGoalsButton(
                        context,
                        state: state,
                        controller: controller,
                      ),
                      const SizedBox(height: 20),
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
              commonText(
                "Training Activity",
                size: 14,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.switchMonthly(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      commonText(
                        state.isMonthly ? "Monthly" : "Weekly",
                        size: 12,
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final list = state.isMonthly ? monthlyData : weeklyData;

                        if (value.toInt() < list.length) {
                          String label = list[value.toInt()].label;
                          // Take only the first 3 characters
                          if (label.length > 3) {
                            label = label.substring(0, 3);
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              label,
                              style: const TextStyle(fontSize: 8),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                barGroups: List.generate(
                  state.isMonthly ? monthlyData.length : weeklyData.length,
                  (index) {
                    final list = state.isMonthly ? monthlyData : weeklyData;
                    final item = list[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item.totalCompleted.toDouble(),
                          width: state.isMonthly ? 16 : 24,
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.primary,
                        ),
                      ],
                    );
                  },
                ),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state.progress!.pieChart.data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text("No sports activity data")),
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
              commonText(
                "Sports Activity",
                size: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 12),
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        commonText(label, size: 11),
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
        child: commonText("No goals found", size: 14),
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
          commonText("Goals", size: 14, fontWeight: FontWeight.w600),
          const SizedBox(height: 12),
          ...goals.map((goal) {
            
           double percent = (goal.target == 0) 
    ? 1.0 
    : goal.progress / goal.target;

            String title =
                "${goal.timeFrame[0].toUpperCase()}${goal.timeFrame.substring(1)} ${goal.sports} Goals";

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText(title, size: 12),
                      commonText(
                        "${goal.progress}/${goal.target} Sessions",
                        size: 12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: percent,
                    backgroundColor: AppColors.boxBG,
                    color: AppColors.primary,
                    minHeight: 16,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ],
              ),
            );
          }).toList(),
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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
        ),
        child: commonText("No recent sessions found", size: 14),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.mainBG,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              commonText(
                "Recent Sessions",
                size: 14,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  navigateToPage(context: context, RecentSessionsView());
                },
                child: Row(
                  children: [
                    commonText("See all", size: 12),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
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
          }).toList(),
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
        child: commonText("No achievements yet", size: 14),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.mainBG,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              commonText("Achievements", size: 14, fontWeight: FontWeight.w600),
              const Spacer(),
              TextButton(
                onPressed: () {
                  navigateToPage(context: context, BadgeShelfView());
                },
                child: Row(
                  children: [
                    commonText("See all", size: 12),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    achievement.badgeImage.isNotEmpty
                        ? Image.network(
                          getFullImagePath(achievement.badgeImage),
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        )
                        : Image.asset(
                          "assest/images/progress/achivment.png",
                          width: 60,
                          height: 60,
                        ),
                    const SizedBox(height: 8),
                    commonText(
                      achievement.badgeName,
                      size: 13,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    commonText(
                      achievement.description,
                      size: 11,
                      color: AppColors.textSecondary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
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
            const SizedBox(width: 6),
            Expanded(
              child: commonText(
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
 bool isLoading=false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                        const SizedBox(height: 16),
                        Center(
                          child: commonText("Set Goal", size: 20, isBold: true),
                        ),
                        const SizedBox(height: 24),

                        /// Sports Dropdown
                        commonText(
                          "Select Sports",
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        commonDropdown<String>(
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

                        const SizedBox(height: 24),

                        /// Target TextField
                        commonTextfieldWithTitle(
                          "Target",
                          targetController,
                          hintText: "Type Target",
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 24),

                        /// Time Frame Dropdown
                        commonText(
                          "Select Time Frame",
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        commonDropdown<String>(
                          items: timeFrameList,
                          value: selectedTimeFrame,
                          hint: "Select Time Frame",
                          onChanged: (value) {
                            setState(() => selectedTimeFrame = value);
                          },
                        ),

                        const SizedBox(height: 32),

                        /// Set Goal Button
                        commonButton(
                          "Set Goal",
                          isLoading: isLoading,
                          onTap: () async {
                          
                            if (selectedSportId != null &&
                                targetController.text.isNotEmpty) {
                                    setState((){
                              isLoading=true;
                            });
                              final response = await controller.setGoal(
                                context: context,
                                sportId: selectedSportId!,
                                target:
                                    int.tryParse(targetController.text) ?? 0,
                                timeFrame: selectedTimeFrame!,
                              );
                              Navigator.pop(context);
                              commonSnackbar(
                                context: context,
                                title: response["title"].toString(),
                                message: response["massage"].toString(),
                                backgroundColor: response['title']=="Successful"?AppColors.success:AppColors.error
                              );
                         setState((){
                              isLoading=false;
                            });
                            }else{
                                    commonSnackbar(
                                context: context,
                                title: "Empty",
                                message: "Please Enter Target",
                                backgroundColor: AppColors.error
                              );
                         
                            }
                          },
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: commonCloseButton(context),
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
