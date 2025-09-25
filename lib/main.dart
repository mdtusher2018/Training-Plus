import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/localstorage/local_storage_service.dart';
import 'package:training_plus/core/utils/theme.dart';
import 'package:training_plus/view/intro_and_onBoarging/splash_view.dart';

final _providerScopeKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init(); 
  runApp(ProviderScope(key: _providerScopeKey, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
