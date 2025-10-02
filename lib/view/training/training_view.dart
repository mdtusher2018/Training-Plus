import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/common_used_models/recent_training_model.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/home/workout_details/workout_details.dart';
import 'package:training_plus/view/training/chooseYourSportChange.dart';
import 'package:training_plus/view/training/training_controller.dart';
import 'package:training_plus/view/training/training_model.dart';
import 'package:training_plus/view/training/training_provider.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class TrainingView extends ConsumerStatefulWidget {
  const TrainingView({super.key});

  @override
  ConsumerState<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends ConsumerState<TrainingView> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(trainingControllerProvider.notifier).fetchTrainings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trainingControllerProvider);
    final controller = ref.read(trainingControllerProvider.notifier);
    final completedScrollController = ref.watch(
      completedTrainingScrollControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: commonText("Training", size: 21, fontWeight: FontWeight.bold),
        centerTitle: true,
        toolbarHeight: 60.h, // responsive height
        backgroundColor: AppColors.mainBG,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (selectedTab == 0) {
            await controller.fetchTrainings();
          } else {
            await controller.fetchCompletedTrainings();
          }
        },
        child:
            state.attributes == null && state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null && state.attributes == null
                ? commonErrorMassage(context: context, massage: state.error!)
                : state.attributes == null
                ? commonErrorMassage(context: context, massage: "No data Found")
                : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildCurrentTrainingCard(
                      controller: controller,
                      state: state,
                    ),
                    commonSizedBox(height: 16),
                    _buildTabs(),
                    commonSizedBox(height: 16),
                    if (selectedTab == 0)
                      _buildTrainingList(
                        sessions: state.attributes?.myTrainings ?? [],
                      ),
                    if (selectedTab == 1)
                      _buildCompletedList(
                        sessions: state.completedWorkouts?.result ?? [],
                        isLoading: state.isLoading,
                        error: state.error,
                        scrollController: completedScrollController,
                      ),
                    commonSizedBox(height: 24),
                    _buildWellnessToolkit(state.attributes?.wellness ?? []),
                  ],
                ),
      ),
    );
  }

  Widget _buildCurrentTrainingCard({
    required TrainingController controller,
    required TrainingState state,
  }) {
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
                commonText(
                  state.attributes!.currentTrainning,
                  size: 14,
                  isBold: true,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.fetchCategories();
              navigateToPage(context: context, ChooseYourSportChangeView());
            },
            child: Container(
              padding: const EdgeInsets.all(4),
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
    final controller = ref.read(trainingControllerProvider.notifier);

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
        commonSizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              setState(() => selectedTab = 1);
              await controller.fetchCompletedTrainings();
            },
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

  Widget _buildTrainingList({required List<RecentTraining> sessions}) {
    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: commonText("No trainings found", size: 14),
        ),
      );
    }

    return Column(
      children: sessions.map((s) => _buildTrainingCard(s)).toList(),
    );
  }

  Widget _buildCompletedList({
    required List<RecentTraining> sessions,
    required bool isLoading,
    required String? error,
    required ScrollController scrollController,
  }) {
    if (isLoading && sessions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: commonText(error, size: 14, color: AppColors.error),
        ),
      );
    }

    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: commonText("No completed trainings found", size: 14),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return _buildTrainingCard(sessions[index]);
      },
    );
  }

  Widget _buildTrainingCard(RecentTraining session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        spacing: 16.w,
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: CommonImage(
                imagePath:
                    session.thumbnail ??
                    "https://via.placeholder.com/100x90.png?text=No+Image",

                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText(
                    session.workoutName,
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),

                  commonText(
                    session.skillLevel,
                    size: 14,
                    color: AppColors.green,
                  ),

                  commonText(
                    "${session.watchTime} sec",
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

  Widget _buildWellnessToolkit(List<Wellness> wellnessList) {
    if (wellnessList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: commonText("No wellness toolkit available", size: 14),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonText("Wellness Toolkit", size: 18, fontWeight: FontWeight.w600),
          commonSizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2,
            children:
                wellnessList.map((tool) {
                  return GestureDetector(
                    onTap: () {
                      navigateToPage(
                        context: context,
                        WorkoutDetailPage(id: tool.id),
                      );
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
                          Expanded(
                            child: commonText(
                              tool.title,
                              size: 14,
                              maxline: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          commonText(
                            "${tool.duration} min",
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
