// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/view/authentication/signup/signup_controller.dart';
import 'package:training_plus/view/profile/Trems%20of%20service%20And%20Privacy%20policy/terms_of_service_view.dart';
import 'package:training_plus/widgets/common_otp_text_field.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text_field_with_title.dart';
import 'package:training_plus/widgets/common_rich_text.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_image.dart';

class SignupView extends ConsumerWidget {
  SignupView({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final List<TextEditingController> referralControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  String? validateSignupForm({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (name.isEmpty) return "Full name cannot be empty";
    if (email.isEmpty) return "Email cannot be empty";
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return "Enter a valid email";
    }
    if (password.isEmpty) return "Password cannot be empty";
    if (password.length < 6) return "Password must be at least 6 characters";
    if (confirmPassword.isEmpty) return "Confirm password cannot be empty";
    if (password != confirmPassword) return "Passwords do not match";

    return null;
  }

  void _validateAndSignup({
    String? referralCode,
    required BuildContext context,
    required SignUpController controller,
    required WidgetRef ref,
  }) async {
    final errorMessage = validateSignupForm(
      name: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    if (errorMessage != null) {
      context.showCommonSnackbar(
        title: "Error",
        message: errorMessage,
        backgroundColor: AppColors.error,
      );
      return;
    }

    await controller.signUp(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      referralCode: referralCode,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpControllerProvider);
    final controller = ref.read(signUpControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: CommonImage(imagePath: ImagePaths.logo, isAsset: true),
              ),
              CommonSizedBox(height: 8),
              CommonText("Create an account", size: 21),
              CommonSizedBox(height: 4),
              CommonText(
                "Enter the following details carefully to create your account",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              CommonSizedBox(height: 24),

              // Full Name
              CommonTextfieldWithTitle(
                "Full Name",
                fullNameController,
                hintText: "Enter your full name",
              ),
              CommonSizedBox(height: 16),

              // Email
              CommonTextfieldWithTitle(
                "Email",
                emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),
              CommonSizedBox(height: 16),

              // Password
              CommonTextfieldWithTitle(
                "Password",
                passwordController,
                hintText: "Enter your password",
                isPasswordVisible: state.passwordVisible,
                issuffixIconVisible: true,
                changePasswordVisibility: controller.togglePasswordVisibility,
              ),
              CommonSizedBox(height: 16),

              // Confirm Password
              CommonTextfieldWithTitle(
                "Confirm Password",
                confirmPasswordController,
                hintText: "Enter your password",
                isPasswordVisible: state.confirmPasswordVisible,
                issuffixIconVisible: true,
                changePasswordVisibility:
                    controller.toggleConfirmPasswordVisibility,
              ),
              CommonSizedBox(height: 30),

              // Sign Up Button
              CommonButton(
                "Sign Up",
                isLoading: state.isLoading,
                onTap: () {
                  _validateAndSignup(
                    context: context,
                    controller: controller,
                    ref: ref,
                  );
                },
              ),
              CommonSizedBox(height: 24),

              // Already a user?
              CommonRichText(
                textAlign: TextAlign.center,
                parts: [
                  RichTextPart(
                    text: "Already a user?",
                    color: AppColors.textPrimary,
                    size: 14,
                  ),
                  RichTextPart(
                    text: "  Sign in",
                    size: 14,
                    color: AppColors.primary,
                    clickRecognized:
                        TapGestureRecognizer()
                          ..onTap = () {
                            context.navigateTo(SigninView());
                          },
                    isBold: true,
                  ),
                ],
              ),
              CommonSizedBox(height: 16),

              // Referral code
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showReferralCodeBottomSheet(context, controller, ref);
                  },
                  child: CommonText(
                    "Have a referral code?",
                    size: 14,
                    color: AppColors.primary,
                    isBold: true,
                  ),
                ),
              ),
              CommonSizedBox(height: 30),

              // T&Cs Disclaimer
              CommonRichText(
                textAlign: TextAlign.center,
                parts: [
                  RichTextPart(
                    size: 16,
                    text: "By continuing you agree to our ",
                    color: AppColors.textPrimary,
                  ),
                  RichTextPart(
                    clickRecognized:
                        TapGestureRecognizer()
                          ..onTap = () {
                            context.navigateTo(TermsOfServiceView());
                          },
                    size: 16,
                    text: "T&Cs",
                    color: AppColors.primary,
                    isBold: true,
                  ),
                  RichTextPart(
                    size: 16,
                    text:
                        ". We use your data to offer you a personalized experience.",
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReferralCodeBottomSheet(
    BuildContext context2,
    SignUpController controller,
    WidgetRef ref,
  ) {
    showModalBottomSheet(
      context: context2,
      isScrollControlled: true,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context2).width),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                Padding(
                  padding: MediaQuery.of(
                    ctx,
                  ).viewInsets.add(EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h)),
                  child: Column(
                    spacing: 24.sp,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText(
                        "Use referral code",
                        size: 20,
                        isBold: true,
                        textAlign: TextAlign.center,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          6,
                          (index) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                              child: CommonOTPTextField(
                                referralControllers[index],
                                index,
                                context,
                              ),
                            ),
                          ),
                        ),
                      ),

                      CommonButton(
                        "Use Code",
                        onTap: () {
                          String code =
                              referralControllers.map((c) => c.text).join();
                          if (code.isEmpty) {
                            context.showCommonSnackbar(
                              title: "Empty",
                              message: "Please enter a referral code.",
                              backgroundColor: AppColors.error,
                            );
                            return;
                          } else if (code.length < 6) {
                            context.showCommonSnackbar(
                              title: "Invalid",
                              message: "Invalid referral code length.",
                              backgroundColor: AppColors.error,
                            );
                            return;
                          } else {
                            Navigator.pop(context);
                            _validateAndSignup(
                              context: context2,
                              referralCode: code,
                              controller: controller,
                              ref: ref,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.cancel_rounded, size: 30.r),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      for (var controller in referralControllers) {
        controller.clear();
      }
    });
  }
}
