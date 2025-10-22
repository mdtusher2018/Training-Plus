import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/home/home_providers.dart';
import 'package:training_plus/view/home/widgets/workoutCard.dart';
import 'package:training_plus/view/home/workout_details/workout_details.dart';
import 'package:training_plus/widgets/common_error_message.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';

class MyWorkoutsView extends ConsumerWidget {
  const MyWorkoutsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myWorkoutControllerProvider);
    final controller = ref.read(myWorkoutControllerProvider.notifier);
    final scrollController = ref.watch(myWorkoutScrollControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.mainBG,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: CommonText("My Workouts", size: 20, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchWorkouts();
        },
        child: Builder(
          builder: (context) {
            if (state.data == null && state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return CommonErrorMassage(
                context: context,
                massage: state.error!,
              );
            } else if (state.data == null || state.data!.suggestions.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: CommonText(
                        "No workouts found",
                        size: 16,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              final workouts = state.data!.suggestions;

              return ListView.separated(
                controller: scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: workouts.length + (state.isLoading ? 1 : 0),
                separatorBuilder:
                    (context, index) => CommonSizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index >= workouts.length) {
                    // Bottom loader for pagination
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final workout = workouts[index];
                  return GestureDetector(
                    onTap: () {
                      context.navigateTo(

                        WorkoutDetailPage(id: workout.id),
                      );
                    },
                    child: SizedBox(
                      height: 230,
                      child: buildWorkoutCard(
                        workout.skillLevel,
                        workout.title,
                        workout.watchTime,
                        workout.thumbnail.isNotEmpty
                            ? workout.thumbnail
                            : "https://www.rhsmith.umd.edu/sites/default/files/research/featured/2022/11/soccer-player.jpg",
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
