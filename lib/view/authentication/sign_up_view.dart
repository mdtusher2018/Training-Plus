import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/utils/image_paths.dart';
import 'package:training_plus/view/authentication/after_signup_otp_view.dart';
import 'package:training_plus/view/authentication/sign_in_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

  void _validateAndSignup({String? referralCode}) {
    String name = fullNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      commonSnackbar(
        title: "Error",
        message: "Please fill all the fields",
        backgroundColor: AppColors.error,
      );
      return;
    }

    if (password != confirmPassword) {
      commonSnackbar(
        title: "Error",
        message: "Passwords do not match",
        backgroundColor: AppColors.error,
      );
      return;
    }

    // Success → Move to RootView
    commonSnackbar(
      title: "Success",
      message: "Account created successfully",
      backgroundColor: AppColors.success,
    );

    navigateToPage(AfterSignUpOtpView());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(

            children: [
              CommonImage(imagePath: ImagePaths.logo,isAsset: true,width: 240,),
              SizedBox(height: 8,),
              commonText("Create an account",size: 21),              
              SizedBox(height: 4),
              commonText(
                "Enter the following details\ncarefully to create your account",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),

              // Full Name
              commonTextfieldWithTitle(
                "Full Name",
                fullNameController,
                hintText: "Enter your full name",
              ),
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

              // Confirm Password
              commonTextfieldWithTitle(
                "Confirm Password",
                confirmPasswordController,
                hintText: "Enter your password",
                isPasswordVisible: confirmPasswordVisible,
                issuffixIconVisible: true,
                changePasswordVisibility: () {
                  setState(() {
                    confirmPasswordVisible = !confirmPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Sign Up Button
              commonButton(
                "Sign Up",
                onTap:      _validateAndSignup,
              ),

              const SizedBox(height: 24),
              commonRichText(
                textAlign: TextAlign.center,
                parts: [
                  RichTextPart(text: "Already a user?", color: AppColors.textPrimary,size: 14),
                  RichTextPart(
                    text: "  Sign in",size: 14,
                    color: AppColors.primary,
                    clickRecognized:TapGestureRecognizer()
                    ..onTap = () {
                      navigateToPage(SigninView());
                    },
                    isBold: true,
                  ),
                  
                ],
              ),

              const SizedBox(height: 16),

              // Referral code
              Center(
                child: GestureDetector(
                  onTap: () {
                 showReferralCodeBottomSheet(context,(code) {
                  
                   _validateAndSignup(referralCode: code);
                 },);
                  },
                  child: commonText(
                    "Have a referral code?",
                    size: 14,
                    color: AppColors.primary,

                    isBold: true,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // T&Cs Disclaimer
           commonRichText(
  textAlign: TextAlign.center,
  parts: [
    RichTextPart(
      size: 16,
      text: "By continuing you agree to our\n", color: AppColors.textPrimary),
    RichTextPart(size: 16,
      text: "T&Cs",
      color: AppColors.primary,
      isBold: true,
   
    ),
    RichTextPart(size: 16,text: ". We use your data to offer\nyou a personalized experience.", color: AppColors.textPrimary),
  ],
),

            ],
          ),
        ),
      ),
    );
  }


// Show the bottom sheet
void showReferralCodeBottomSheet(BuildContext context, Function(String) onUse) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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
                padding: MediaQuery.of(ctx).viewInsets.add(const EdgeInsets.fromLTRB(24, 24, 24, 40)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    commonText(
                      "Use referral code",
                      size: 20,
                      isBold: true,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: buildOTPTextField(controllers[index], index, context
                            
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    commonButton(
                      "Use Code",
                      onTap: () {
                        String code = controllers.map((c) => c.text).join();
                        if(code.isEmpty){
                          commonSnackbar(title: "Empty", message: "Please enter a referral code.",backgroundColor: AppColors.error);
                          return;
                        }
                        else if(code.length<6){
                          commonSnackbar(title: "Invalid", message: "Invalid referral code length.",backgroundColor: AppColors.error);
                          return;
                        }else{
                        Get.back();
                        onUse(code); 

                        }
                        
                      },
                    ),
                  ],
                ),
              ),
               Positioned(
                top: 10,right: 10,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.cancel_rounded,size: 30)))
            ],
          );
        }
      );
    },
  ).then((value) {
     for (var controller in controllers) {
      controller.clear();
    }
  },);
}

}
