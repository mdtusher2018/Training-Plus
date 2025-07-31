import 'dart:async';
import 'package:flutter/material.dart';
import 'package:training_plus/utils/image_paths.dart';
import 'package:training_plus/view/intro_and_onBoarging/onboarding_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    // Fade In Animation
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeInAnimation = CurvedAnimation(parent: _fadeInController, curve: Curves.easeIn);
    _fadeInController.forward();

    // Navigate to onboarding with fade transition after delay
    Timer(const Duration(seconds: 3), () {
      navigateToPage(
        const OnboardingView(),
  
      );
    });
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonImage(
                imagePath: ImagePaths.logo,
                height: 116,
                width: 280,
                isAsset: true,
              ),
              const SizedBox(height: 16),
              commonText(
                "Train Strong. Live\nstrong",
                size: 24,
                isBold: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
