import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';
import 'package:training_plus/view/authentication/forget_password/forgot_password_view.dart';
import 'package:training_plus/view/authentication/sign_in/signin_controller.dart';
import 'package:training_plus/view/authentication/signup/sign_up_view.dart';
import 'package:training_plus/view/root_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SigninView extends ConsumerStatefulWidget {
  const SigninView({super.key});

  @override
  ConsumerState<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends ConsumerState<SigninView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Automatically show saved accounts bottom sheet if there are saved logins
    Future.microtask(() async {
      final controller = ref.read(signInControllerProvider.notifier);
      final state = ref.read(signInControllerProvider);
      final localStorage = ref.read(localStorageProvider);
      final savedLogins = await localStorage.getSavedLogins();
      if (savedLogins.isNotEmpty) {
        showSavedAccountsBottomSheet(
          context,
          ref: ref,
          authController: controller,
          isRememberMeChecked: ValueNotifier(state.rememberMe),
          state: state,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final SignInState state = ref.watch(signInControllerProvider);
    final SignInController controller = ref.read(
      signInControllerProvider.notifier,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: CommonImage(
                        imagePath: ImagePaths.logo,
                        isAsset: true,
                      ),
                    ),
                    commonSizedBox(height: 8),
                    commonText("Welcome back!", size: 21, isBold: true),
                    commonSizedBox(height: 4),
                    commonText(
                      "Enter your details and login to your account.",
                      size: 14,
                      textAlign: TextAlign.center,
                      color: AppColors.textSecondary,
                    ),
                    commonSizedBox(height: 24),
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
              commonSizedBox(height: 16),

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
                    controller.toggleRememberMe(p0 ?? false);
                  },
                ),
              ),

              commonSizedBox(height: 16),

              // Sign In Button
              commonButton(
                "Sign In",
                isLoading: state.isLoading,
                onTap: () async {
                  if (emailController.text.isEmpty) {
                   context.showCommonSnackbar(
                 
                      title: "Empty",
                      message: "Please enter your email",
                      backgroundColor: AppColors.error,
                    );
                    return;
                  }
                  if (passwordController.text.isEmpty) {
                   context.showCommonSnackbar(
                 
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
                    final user = await controller.signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    if (user != null) {
                      final localStorage = ref.read(localStorageProvider);
                      await localStorage.saveString(
                        StorageKey.token,
                        user.accessToken,
                      );
                      if (state.rememberMe) {
                        await localStorage.saveLogin(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      }
                      context.navigateTo(RootView(), clearStack: true);
                    }
                  } catch (e) {
                   context.showCommonSnackbar(
                 
                      title: "Error",
                      message: e.toString(),
                      backgroundColor: AppColors.error,
                    );
                  } finally {
                    controller.setLoading(false);
                  }
                },
              ),

              commonSizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  context.navigateTo(ForgotPasswordView());
                },
                child: commonText(
                  "Forgot the password?",
                  size: 14,
                  isBold: true,
                ),
              ),
              commonSizedBox(height: 32),

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
                      clickRecognized:
                          TapGestureRecognizer()
                            ..onTap = () {
                              context.navigateTo(SignupView());
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

  void showSavedAccountsBottomSheet(
    BuildContext context, {
    required WidgetRef ref,
    required SignInController authController,
    required SignInState state,
    required ValueNotifier<bool> isRememberMeChecked,
  }) async {
    final localStorage = ref.read(localStorageProvider);

    final savedLogins = await localStorage.getSavedLogins();
    if (savedLogins.isEmpty) return;

    showModalBottomSheet(
 context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: AppColors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                commonSizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.primary),
                    commonSizedBox(width: 8),
                    commonText("Select an account", size: 16, isBold: true),
                  ],
                ),
                commonSizedBox(height: 12),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children:
                        savedLogins.entries.map((entry) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.account_circle_rounded,
                                color: AppColors.primary,
                                size: 30,
                              ),
                              title: commonText(
                                entry.key,
                                size: 14,
                                isBold: true,
                              ),
                              subtitle: const Text("••••••••"),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () async {
                                  await localStorage.removeLogin(entry.key);
                                  Navigator.pop(context);
                                  // Refresh the bottomsheet
                                  showSavedAccountsBottomSheet(
                                    context,
                                    ref: ref,
                                    authController: authController,
                                    isRememberMeChecked: isRememberMeChecked,
                                    state: state,
                                  );
                                },
                              ),
                              onTap: () async {
                                authController.setLoading(true);

                                try {
                                  final user = await authController.signIn(
                                    email: entry.key,
                                    password: entry.value,
                                  );
                                  if (user != null) {
                                    final localStorage = ref.read(
                                      localStorageProvider,
                                    );
                                    await localStorage.saveString(
                                      StorageKey.token,
                                      user.accessToken,
                                    );
                                    if (state.rememberMe) {
                                      await localStorage.saveLogin(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                    }
                                    context.navigateTo(
                                      RootView(),
                                      clearStack: true,
                                    );
                                  }
                                } catch (e) {
                                 context.showCommonSnackbar(
                               
                                    title: "Error",
                                    message: e.toString(),
                                    backgroundColor: AppColors.error,
                                  );
                                } finally {
                                  authController.setLoading(false);
                                }
                              },
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
