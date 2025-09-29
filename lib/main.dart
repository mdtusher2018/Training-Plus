import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/services/localstorage/local_storage_service.dart';
import 'package:training_plus/core/utils/theme.dart';
import 'package:training_plus/view/intro_and_onBoarging/splash_view.dart';
import 'package:training_plus/view/profile/profile/profile_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init(); 
  runApp(ProviderScope(child: ScreenUtilInit(
    designSize: Size(360, 640),
    child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Training Plus',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: ProfileView(),
    );
  }
}
