import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:training_plus/utils/theme.dart';
import 'package:training_plus/view/home/camera_view.dart';
import 'package:training_plus/view/home/nutrition_tracker_view.dart';
import 'package:training_plus/view/home/running_gps_view.dart';



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
      home: ScanCameraPage(),
    );
  }
}
