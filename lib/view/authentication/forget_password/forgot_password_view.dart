import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text_field_with_title.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_image.dart';

class ForgotPasswordView extends ConsumerWidget {
  ForgotPasswordView({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgetPasswordControllerProvider);
    final controller = ref.read(forgetPasswordControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: CommonImage(
                  imagePath: ImagePaths.resetPasswordImage,
                  isAsset: true,
                ),
              ),

              CommonSizedBox(height: 12),
              CommonText("Forgot Password?", size: 21, isBold: true),
              CommonSizedBox(height: 8),
              CommonText(
                "No worries, we’ll send you reset\ninstructions",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              CommonSizedBox(height: 24),

              // Email field
              CommonTextfieldWithTitle(
                "Email",
                emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),

              CommonSizedBox(height: 24),

              // Reset Password Button
              CommonButton(
                "Reset Password",
                isLoading: state.isLoading,
                onTap: () async {
                  final email = emailController.text.trim();

                  await controller.forgetPassword(email: email);
                },
              ),

              CommonSizedBox(height: 24),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back),
                    CommonText("  Back to log in", size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
