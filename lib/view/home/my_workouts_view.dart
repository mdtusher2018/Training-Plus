import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/home/widgets/workoutCard.dart';
import 'package:training_plus/view/home/workout_details.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class MyWorkoutsView extends StatefulWidget {
  const MyWorkoutsView({super.key});

  @override
  State<MyWorkoutsView> createState() => _MyWorkoutsViewState();
}

class _MyWorkoutsViewState extends State<MyWorkoutsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.mainBG,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: commonText("Active Community", size: 20, isBold: true),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              navigateToPage(WorkoutDetailPage());
            },
            child: SizedBox(
              height: 230,
              child: buildWorkoutCard(
                "Intermediate",
                "Ball Control Mastery",
                "25 min",
                "https://www.rhsmith.umd.edu/sites/default/files/research/featured/2022/11/soccer-player.jpg",
              ),
            ),
          );
        },
      ),
    );
  }
}
