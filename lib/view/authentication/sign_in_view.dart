import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/utils/image_paths.dart';
import 'package:training_plus/view/authentication/forgot_password_view.dart';
import 'package:training_plus/view/authentication/sign_up_view.dart';
import 'package:training_plus/view/root_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordVisible = true;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
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
                isPasswordVisible: passwordVisible,
                issuffixIconVisible: true,
                changePasswordVisibility: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),

             

              // Remember Me & Forgot Password
              Align(
                alignment: Alignment.centerLeft,
                child: commonCheckbox(value: rememberMe,
                label: "Remember me",
                 onChanged: (value){      setState(() {
                  rememberMe = value ?? false;
                });}),
              ),
          

              const SizedBox(height: 16),

              // Sign In Button
              commonButton(
                "Sign In",
                onTap: () {
                  if(emailController.text.isEmpty){
                     commonSnackbar(
                    title: "Empty",
                    message: "Please enter your email",
                    backgroundColor: AppColors.error,
                  );
                  return;
                  }
                   if(emailController.text.isEmpty){
                     commonSnackbar(
                    title: "Empty",
                    message: "Please enter your password",
                    backgroundColor: AppColors.error,
                  );
                  return;
                  }
                  // commonSnackbar(
                  //   title: "Login",
                  //   message: "Login process started",
                  //   backgroundColor: AppColors.success,
                  // );
                  navigateToPage(RootView(),clearStack: true);
                  
                },
              ),   const SizedBox(height: 12),
   GestureDetector(
                    onTap: () {
                      navigateToPage(ForgotPasswordView());
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
                          navigateToPage(SignupView());
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
