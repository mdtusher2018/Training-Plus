import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/home/barcode_scanner_page.dart';
import 'package:training_plus/view/home/home_providers.dart';
import 'package:training_plus/view/home/nutrition_tracker/nutrition_tracker_controller.dart';
import 'package:training_plus/view/home/nutrition_tracker/nutrition_traker_model.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class NutritionTrackerPage extends ConsumerWidget {
  NutritionTrackerPage({super.key});

  final Color caloriesColor = Color(0xFFFF5733);
  final Color protienColor = Color(0xFF34C759);
  final Color carbsColor = Color(0xFFFFD60A);
  final Color fatColor = Color(0xFFFF9500);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutritionTrackerControllerProvider);
    final controller = ref.read(nutritionTrackerControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CommonText("Nutrition Tracker", size: 21, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchNutritionTracker();
        },
        child: Builder(
          builder: (context) {
            return state.data == null && state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? CommonErrorMassage(context: context, massage: state.error!)
                : ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.calendar_month_outlined),

                            CommonText(
                              DateFormat('EEEE, MMM d').format(DateTime.now()),
                              size: 14,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showSetGoalsBottomSheet(context, controller);
                          },
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assest/images/home/gole_black.png",
                                    width: 20,
                                  ),
                                  CommonText("Set Goals", size: 14),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Today's Progress
                    _buildOverallProgress(
                      state.data!.overallPercent >= 100
                          ? 100
                          : state.data!.overallPercent,
                    ),

                    CommonSizedBox(height: 16),

                    // Quick Stat (quickTodayGain)
                    _buildQuickStats(state.data!.quickTodayGain),

                    CommonSizedBox(height: 16),

                    // Detailed Stats
                    _buildDetailedStats(state.data!.detailedProgress),

                    CommonSizedBox(height: 16),

                    // Today's Meals
                    _buildMealsList(state.data!.todayMeals),
                  ],
                );
          },
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          context.navigateTo(
 BarcodeDemoPage());
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.fullscreen, size: 40),
        ),
      ),
    );
  }

  Widget _buildOverallProgress(num overallPercent) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.primary, size: 30),
              CommonSizedBox(width: 6),
              CommonText(
                "Today's Progress",
                size: 16,
                isBold: true,
                color: Colors.black,
              ),
            ],
          ),
          CommonSizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                "Overall Goal Achievement",
                size: 12,
                color: AppColors.textSecondary,
              ),
              CommonText(
                overallPercent.toString(),
                size: 12,
                isBold: true,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          CommonSizedBox(height: 6),
          LinearProgressIndicator(
            value: overallPercent / 100.0,
            color: Colors.yellow.shade700,
            backgroundColor: Colors.grey.shade200,
            minHeight: 12,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(QuickTodayGain stats) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText("Quick Stat", size: 16, isBold: true),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: GridView.count(
                padding: EdgeInsets.all(0),
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.75,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildQuickStatCard(
                    "${stats.calories}",
                    "Calories",
                    caloriesColor,
                  ),
                  _buildQuickStatCard(
                    "${stats.proteins}",
                    "Proteins",
                    protienColor,
                  ),
                  _buildQuickStatCard("${stats.carbs}", "Carbs", carbsColor),
                  _buildQuickStatCard("${stats.fats}", "Fat", fatColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats(DetailedProgress detailed) {
    String getProgressStatus(num percentage) {
      if (percentage < 30) {
        return "Getting Started";
      } else if (percentage >= 30 && percentage < 100) {
        return "Good Progress";
      } else {
        return "Complete";
      }
    }

    return Column(
      children: [
        _buildDetailedStatCard(
          label: "Calories",
          valueText: "${detailed.calories.gain}/${detailed.calories.goal} cal",
          progress: detailed.calories.percentage / 100,
          remainingText: "${detailed.calories.remaining} cal remaining",
          imagePath: "assest/images/home/calories.png",
          statusColor: caloriesColor,
          statusText: getProgressStatus(detailed.calories.percentage),
        ),
        _buildDetailedStatCard(
          label: "Proteins",
          valueText: "${detailed.proteins.gain}/${detailed.proteins.goal} g",
          progress: detailed.proteins.percentage / 100,
          remainingText: "${detailed.proteins.remaining} g remaining",
          imagePath: "assest/images/home/protein.png",
          statusColor: protienColor,
          statusText: getProgressStatus(detailed.proteins.percentage),
        ),
        _buildDetailedStatCard(
          label: "Carbs",
          valueText: "${detailed.carbs.gain}/${detailed.carbs.goal} g",
          progress: detailed.carbs.percentage / 100,
          remainingText: "${detailed.carbs.remaining} g remaining",
          imagePath: "assest/images/home/crabs.png",
          statusColor: carbsColor,
          statusText: getProgressStatus(detailed.carbs.percentage),
        ),
        _buildDetailedStatCard(
          label: "Fats",
          valueText: "${detailed.fats.gain}/${detailed.fats.goal} g",
          progress: detailed.fats.percentage / 100,
          remainingText: "${detailed.fats.remaining} g remaining",
          imagePath: "assest/images/home/fat.png",
          statusColor: fatColor,
          statusText: getProgressStatus(detailed.fats.percentage),
        ),
      ],
    );
  }

  Widget _buildMealsList(List<TodayMeal> meals) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText("Today’s Meals", size: 16, isBold: true),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  meals.map((meal) {
                    return _buildMealItem(
                      title: meal.mealName,
                      time: DateFormat.jm().format(
                        DateTime.parse(meal.createdAt.toString()),
                      ),
                      stats: [
                        _mealStat(
                          "Calories",
                          "${meal.calories}c",
                          Color(0xFFFF5733),
                        ),
                        _mealStat(
                          "Proteins",
                          "${meal.proteins}g",
                          Color(0xFF34C759),
                        ),
                        _mealStat("Carbs", "${meal.carbs}g", Color(0xFFFFD60A)),
                        _mealStat("Fat", "${meal.fats}g", Color(0xFFFF9500)),
                      ],
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.boxBG,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonText(
            value,
            size: 18,
            color: color,
            fontWeight: FontWeight.w800,
          ),
          CommonSizedBox(height: 2),
          CommonText(label, size: 14, color: color),
        ],
      ),
    );
  }

  Widget _buildDetailedStatCard({
    required String imagePath,
    required String label,
    required String valueText,
    required String statusText,
    required Color statusColor,
    required double progress,
    required String remainingText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0),
            minVerticalPadding: 0,
            title: CommonText(label, size: 16, isBold: true),
            subtitle: CommonText(valueText, size: 12, isBold: false),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(imagePath),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    (statusText == "Getting Started")
                        ? Color(0xFFFFD60A)
                        : (statusText == "Complete")
                        ? Color(0xFF00C566)
                        : Color(0xFF5AC8FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CommonText(
                statusText,
                size: 10,
                color: AppColors.white,
                isBold: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText("${(progress * 100).toStringAsFixed(0)}%", size: 12),
              CommonText(
                (statusText == "Complete") ? "Goal Reached" : remainingText,
                size: 12,
                isBold: true,
              ),
            ],
          ),
          CommonSizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            color: statusColor,
            backgroundColor: Colors.grey.shade300,
            minHeight: 12,
            borderRadius: BorderRadius.circular(8),
          ),
          CommonSizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMealItem({
    required String title,
    required String time,
    required List<Widget> stats,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.boxBG,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(title, size: 14, isBold: true),
          CommonSizedBox(height: 2),
          CommonText(time, size: 12, color: AppColors.textSecondary),
          CommonSizedBox(height: 8),
          Wrap(spacing: 6, children: stats),
        ],
      ),
    );
  }

  Widget _mealStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: CommonText(
        "$label  \n$value",
        size: 10,
        color: AppColors.white,
        isBold: true,
      ),
    );
  }

  void showSetGoalsBottomSheet(
    BuildContext context,
    NutritionTrackerController controller,
  ) {
    final TextEditingController caloriesController = TextEditingController();
    final TextEditingController proteinController = TextEditingController();
    final TextEditingController carbsController = TextEditingController();
    final TextEditingController fatsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(nutritionTrackerControllerProvider);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CommonText(
                            "Set Goals",
                            size: 18,
                            isBold: true,
                          ),
                        ),
                        CommonSizedBox(height: 20),

                        CommonTextfieldWithTitle(
                          "Daily Calories",
                          caloriesController,
                          hintText: "Set your daily calories intake",
                          keyboardType: TextInputType.number,
                        ),
                        CommonSizedBox(height: 16),

                        CommonTextfieldWithTitle(
                          "Daily Protein",
                          proteinController,
                          hintText: "Set your daily protein intake",
                          keyboardType: TextInputType.number,
                        ),
                        CommonSizedBox(height: 16),

                        CommonTextfieldWithTitle(
                          "Daily Carbs",
                          carbsController,
                          hintText: "Set your daily carbs intake",
                          keyboardType: TextInputType.number,
                        ),
                        CommonSizedBox(height: 16),

                        CommonTextfieldWithTitle(
                          "Daily Fats",
                          fatsController,
                          hintText: "Set your daily fats intake",
                          keyboardType: TextInputType.number,
                        ),
                        CommonSizedBox(height: 24),

                        CommonButton(
                          "Set Goal",
                          width: double.infinity,
                          isLoading: state.isLoading,
                          onTap: () async {
                            final result = await controller.setFoodGoal(
                              calories:
                                  int.tryParse(caloriesController.text) ?? 2500,
                              proteins:
                                  int.tryParse(proteinController.text) ?? 56,
                              carbs: int.tryParse(carbsController.text) ?? 300,
                              fats: int.tryParse(fatsController.text) ?? 70,
                            );

                            Navigator.pop(context);

                            context.showCommonSnackbar(
                              title: result["title"]!,
                              message: result["message"]!,
                            
                              backgroundColor:
                                  result["title"] == "Success"
                                      ? AppColors.success
                                      : AppColors.error,
                            );
                          },
                        ),
                        CommonSizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
            ),

            Positioned(top: 10, right: 16, child: CommonCloseButton(context)),
          ],
        );
      },
    );
  }
}
