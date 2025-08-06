import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:training_plus/utils/theme.dart';
import 'package:training_plus/view/community/community_view.dart';
import 'package:training_plus/view/home/camera_view.dart';
import 'package:training_plus/view/home/chapters.dart';
import 'package:training_plus/view/home/nutrition_tracker_view.dart';
import 'package:training_plus/view/home/running_gps_view.dart';
import 'package:training_plus/view/home/workout_details.dart';
import 'package:training_plus/view/notification/notification_view.dart';
import 'package:training_plus/view/personalization/subscription.dart';
import 'package:training_plus/view/profile/edit_profile.dart';
import 'package:training_plus/view/progress/recentSessionsView.dart';
import 'package:training_plus/view/progress/widget/progress_view.dart';
import 'package:training_plus/view/training/chooseYourSportChange.dart';
import 'package:training_plus/view/training/training_view.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Training Plus',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: CommunityView(),
    );
  }
}
