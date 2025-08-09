
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/utils/image_paths.dart';
import 'package:training_plus/view/authentication/forgot_password_otp_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              SizedBox(height: 40,),
              CommonImage(
                imagePath: ImagePaths.resetPasswordImage,
                isAsset: true,
               
              ),
              const SizedBox(height: 12),
              commonText("Forgot Password?", size: 21, isBold: true),
              const SizedBox(height: 8),
              commonText(
                "No Worries, we’ll send you reset\ninstruction",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),

      // Email
              commonTextfieldWithTitle(
                "Email",
                emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),
  


              const SizedBox(height: 24),

              // Verify OTP Button
              commonButton(
                "Reset Password",
                onTap: () {
                   if(emailController.text.isEmpty){
                      commonSnackbar(title: "Empty", message: "Please enter your email.",backgroundColor: AppColors.error);
                    return;
                    }
                    navigateToPage(ForgotPasswordOtpView());
                  commonSnackbar(
                    title: "Verified",
                    message: "OTP verified successfully",
                    backgroundColor: AppColors.success,
                  );
                },
              ),

              const SizedBox(height: 24),

              // Back to sign in
           GestureDetector(
            onTap: (){
              Get.back();
            },
             child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back),commonText("  Back to log in",size: 14)
              ],
             ),
           )
            ],
          ),
        ),
      ),
    );
  }
}
