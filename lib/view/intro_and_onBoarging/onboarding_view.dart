import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/utils/image_paths.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with TickerProviderStateMixin {
  int currentPage = 0;
  final int totalPages = 4;
  late final List<AnimationController> _fadeControllers;

  final List<Map<String, String>> onboardingData = [
    {
      "image": ImagePaths.onboarding1,
      "title": "Welcome To Training Plus",
      "subtitle":
          "More Than Training. It’s a Way of Life. Your journey to peak performance starts now",
    },
    {
      "image": ImagePaths.onboarding2,
      "title": "Elite, Multi-Sport Training",
      "subtitle":
          "Access pro-level workout libraries for Soccer, Basketball, Running, and more. Real training for real results.",
    },
    {
      "image": ImagePaths.onboarding3,
      "title": "Train and Grow Together",
      "subtitle":
          "Join challenges, climb leaderboards, and get motivation from a global community of athletes.",
    },
    {
      "image": ImagePaths.onboarding4,
      "title": "Your Extra Edge. Every Day.",
      "subtitle":
          "Create an account to start your free journey or log in to continue",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeControllers = List.generate(
      totalPages,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _fadeControllers[0].value = 1.0;
  }

  void _goToNextPage() {
    if (currentPage < totalPages - 1) {
      _fadeControllers[currentPage].reverse();
      currentPage++;
      _fadeControllers[currentPage].forward();
      setState(() {});
    } else {
      // Navigate to next page like RoleChooseView
      // navigateToPage(RoleChooseView());
    }
  }

  @override
  void dispose() {
    for (var controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(onboardingData.length, (index) {
          final data = onboardingData[index];
          return FadeTransition(
            opacity: _fadeControllers[index],
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Image.asset(
                    data["image"]!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: [
                          const Spacer(),
                          commonText(
                            data["title"]!,
                            size: 26,
                            isBold: true,
                            textAlign: TextAlign.center,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          commonText(
                            data["subtitle"]!,
                            size: 14,
                            textAlign: TextAlign.center,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(height: 40),
                          commonButton(
                            (currentPage < totalPages - 1)
                                ? "Next"
                                : "Get Started",
                            haveNextIcon: true,
                            onTap: _goToNextPage,
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 56,
                    right: 24,
                    child: GestureDetector(
                      onTap: () {
    
                      },
                      child: commonText(
                        "Skip",
                        size: 21,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
