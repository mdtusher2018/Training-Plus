import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/create_new_password_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ForgotPasswordOtpView extends StatefulWidget {
  const ForgotPasswordOtpView({super.key});

  @override
  State<ForgotPasswordOtpView> createState() => _ForgotPasswordOtpViewState();
}

class _ForgotPasswordOtpViewState extends State<ForgotPasswordOtpView> {
  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

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
                imagePath: ImagePaths.forgetPasswordImage,
                isAsset: true,
               
              ),
              const SizedBox(height: 12),
              commonText("Check your email", size: 21, isBold: true),
              const SizedBox(height: 8),
              commonText(
                "We sent a password reset link to\nuser@example.com",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),

              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: buildOTPTextField(
                          controllers[index], index, context),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              

       commonRichText(
                textAlign: TextAlign.center,
                parts: [
                  RichTextPart(text: "Didn’t receive the code? ", color: AppColors.textPrimary,size: 14),
                  RichTextPart(
                    text: "Resend",size: 14,
                    color: AppColors.primary,
                    clickRecognized:TapGestureRecognizer()
                    ..onTap = () {
                        commonSnackbar(context: context,
                      title: "Resent",
                      message: "OTP code resent successfully",
                      backgroundColor: AppColors.success,
                    );
                    },
                    isBold: true,
                  ),
                  
                ],
              ),


              const SizedBox(height: 24),

              // Verify OTP Button
              commonButton(
                "Verify OTP",
                onTap: () {
                        

                  String code = controllers.map((c) => c.text).join();
                  if(code.isEmpty){
                    commonSnackbar(context: context,title: "Empty", message: "Please enter the OTP.",backgroundColor: AppColors.error);
                    return;
                  }
                  else if(code.length<6){
                    commonSnackbar(context: context,title: "Invalid", message: "Invalid OTP length.",backgroundColor: AppColors.error);
                    return;
                  }
                  navigateToPage(context: context,CreateNewPasswordView());
                              
                  commonSnackbar(context: context,
                    title: "Verified",
                    message: "OTP verified successfully",
                    backgroundColor: AppColors.success,
                  );
                },
              ),

              const SizedBox(height: 24),

              // Back to sign in
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back),commonText("  Back to sign in",size: 14)
            ],
           )
            ],
          ),
        ),
      ),
    );
  }
}
