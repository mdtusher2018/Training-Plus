import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/services/link_sharing/universal_link_service.dart';
import 'package:training_plus/core/services/localstorage/local_storage_service.dart';
import 'package:training_plus/core/utils/theme.dart';
import 'package:training_plus/view/intro_and_onBoarging/splash_view.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init(); 
  runApp(ProviderScope(child: ScreenUtilInit(
    designSize: Size(360, 640),
    child: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    final DeepLinkService _deepLinkService = DeepLinkService();
  @override
  void initState() {
    super.initState();
    // Initialize after build to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLinkService.initDeepLinks(context);
    });
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Training Plus',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: SplashView(),

    );
  }
}
