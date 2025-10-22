import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';

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
      "title": "Welcome To\nTraining Plus",
      "subtitle":
          "More Than Training. It’s a Way\nof Life. Your journey to peak\nperformance starts now",
    },
    {
      "image": ImagePaths.onboarding2,
      "title": "Elite, Multi-Sport\nTraining",
      "subtitle":
          "Access pro-level workout\nlibraries for Soccer, Basketball,\nRunning, and more. Real training\nfor real results.",
    },
    {
      "image": ImagePaths.onboarding3,
      "title": "Train and Grow\nTogether",
      "subtitle":
          "Join challenges, climb\nleaderboards, and get motivation from\na global community of athletes.",
    },
    {
      "image": ImagePaths.onboarding4,
      "title": "Your Extra Edge.\nEvery Day.",
      "subtitle":
          "Create an account to start your\nfree journey or log in to continue",
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
   
      context.navigateTo(
SigninView());
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
    padding: EdgeInsets.symmetric(horizontal: 16.w), // responsive padding
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8, // 🔑 limit width
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 16.sp,
            children: [
              Flexible(
                child: FittedBox(
                  child: CommonText(
                    data["title"]!,
                    maxline: 2,
                    size: 28,
                    isBold: true,
                    textAlign: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
              ),
            
              Flexible(
                child: FittedBox(
                  child: CommonText(
                    data["subtitle"]!,
                    size: 16,
                    
                    textAlign: TextAlign.center,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
        
              CommonButton(
                (currentPage < totalPages - 1)
                    ? "Next"
                    : "Get Started",
                haveNextIcon: currentPage < totalPages - 1,
                onTap: _goToNextPage,
              ),
     CommonSizedBox(height: 24)
            ],
          ),
        ),
      ],
    ),
  ),
),

                  if(currentPage < totalPages - 1)Positioned(
                    top: 56,
                    right: 24,
                    child: GestureDetector(
                      onTap: () {
                        _fadeControllers[currentPage].reverse();
                        currentPage = totalPages - 1;
                        _fadeControllers[currentPage].forward();
                        setState(() {
                          
                        });
                      },
                      child: CommonText(
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
