import 'dart:async';
import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/intro_and_onBoarging/onboarding_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
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
      navigateToPage(context: context,
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
