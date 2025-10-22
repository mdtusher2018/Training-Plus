import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/intro_and_onBoarging/onboarding_view.dart';
import 'package:training_plus/view/root_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with TickerProviderStateMixin {
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
    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeIn,
    );
    _fadeInController.forward();

    // Navigate after delay
    Timer(const Duration(seconds: 3), () async {
      final localStorage = ref.read(localStorageProvider);
      final token = await localStorage.getString(StorageKey.token);

      if (token != null && token.isNotEmpty) {
        final decoded = decodeJwtPayload(token);
        if (decoded != null &&
            decoded.containsKey("isLoginToken") &&
            decoded['isLoginToken']) {
          context.navigateTo(RootView(), clearStack: true);
        } else {
          // Token exists but doesn't have loginToken
          context.navigateTo(const OnboardingView(), clearStack: true);
        }
      } else {
        // No token stored
        context.navigateTo(const OnboardingView(), clearStack: true);
      }
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
              CommonSizedBox(height: 16),
              CommonText(
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
