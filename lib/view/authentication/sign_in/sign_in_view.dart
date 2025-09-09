import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/forgot_password_view.dart';
import 'package:training_plus/view/authentication/sign_in/signin_controller.dart';
import 'package:training_plus/view/authentication/sign_up_view.dart';
import 'package:training_plus/view/root_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'sign_in_provider.dart';

class SigninView extends ConsumerWidget {
  SigninView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SignInState state = ref.watch(signInControllerProvider);
    final SignInController controller = ref.read(signInControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    CommonImage(
                      imagePath: ImagePaths.logo,
                      isAsset: true,
                      width: 240,
                    ),
                    const SizedBox(height: 8),
                    commonText("Welcome back!", size: 21, isBold: true),
                    const SizedBox(height: 4),
                    commonText(
                      "Enter your details and login to your account.",
                      size: 14,
                      textAlign: TextAlign.center,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Email
              commonTextfieldWithTitle(
                "Email",
                emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password
              commonTextfieldWithTitle(
                "Password",
                passwordController,
                hintText: "Enter your password",
                isPasswordVisible: state.passwordVisible,
                issuffixIconVisible: true,
                changePasswordVisibility: controller.togglePasswordVisibility,
              ),

              // Remember Me & Forgot Password
              Align(
                alignment: Alignment.centerLeft,
                child: commonCheckbox(
                  value: state.rememberMe,
                  label: "Remember me",
                  onChanged: (p0) {
                    controller.toggleRememberMe(p0??false);
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Sign In Button
              commonButton(
                "Sign In",
                onTap: () async {
                  if (emailController.text.isEmpty) {
                    commonSnackbar(context: context,
                      title: "Empty",
                      message: "Please enter your email",
                      backgroundColor: AppColors.error,
                    );
                    return;
                  }
                  if (passwordController.text.isEmpty) {
                    commonSnackbar(context: context,
                      title: "Empty",
                      message: "Please enter your password",
                      backgroundColor: AppColors.error,
                    );
                    return;
                  }

                  controller.setLoading(true);

                  try {
                    // Here you call your API using repository
                    // Example: final response = await repository.signIn(email, password);
                    // On success:
                    navigateToPage(context: context,RootView(), clearStack: true);
                  } catch (e) {
                    commonSnackbar(context: context,
                      title: "Error",
                      message: e.toString(),
                      backgroundColor: AppColors.error,
                    );
                  } finally {
                    controller.setLoading(false);
                  }
                },
              ),

              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  navigateToPage(context: context,ForgotPasswordView());
                },
                child: commonText(
                  "Forgot the password?",
                  size: 14,
                  isBold: true,
                ),
              ),
              const SizedBox(height: 32),

              // Sign Up Prompt
              Center(
                child: commonRichText(
                  textAlign: TextAlign.center,
                  parts: [
                    RichTextPart(
                      text: "New to Training Plus?",
                      color: AppColors.textPrimary,
                      size: 14,
                    ),
                    RichTextPart(
                      text: "  Sign up",
                      color: AppColors.primary,
                      size: 14,
                      isBold: true,
                      clickRecognized: TapGestureRecognizer()
                        ..onTap = () {
                          navigateToPage(context: context,SignupView());
                        },
                    ),
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
