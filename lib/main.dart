import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:training_plus/utils/theme.dart';
import 'package:training_plus/view/authentication/after_signup_otp_view.dart';
import 'package:training_plus/view/authentication/create_new_password_view.dart';
import 'package:training_plus/view/authentication/forgot_password_otp_view.dart';
import 'package:training_plus/view/authentication/forgot_password_view.dart';
import 'package:training_plus/view/authentication/sign_in_view.dart';
import 'package:training_plus/view/authentication/sign_up_view.dart';
import 'package:training_plus/view/intro_and_onBoarging/onboarding_view.dart';
import 'package:training_plus/view/intro_and_onBoarging/splash_view.dart';
import 'package:training_plus/view/personalization/Personalization_2.dart';
import 'package:training_plus/view/personalization/Personalization_1.dart';
import 'package:training_plus/view/personalization/personalized_view.dart'; // your AppColors

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
      home: Personalization1(),
    );
  }
}
