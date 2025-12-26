import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/core/utils/session_reset.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/view/profile/subscription/subscription_view.dart';
import 'package:training_plus/view/profile/Badge%20Shelf/BadgeShelfView.dart';
import 'package:training_plus/view/profile/ContactUsView.dart';
import 'package:training_plus/view/profile/faq/FaqView.dart';
import 'package:training_plus/view/profile/running_history/RunningHistoryView.dart';
import 'package:training_plus/view/profile/profile/edit_profile_view.dart';
import 'package:training_plus/view/profile/feedback/feedback_view.dart';
import 'package:training_plus/view/profile/invite_friends_view.dart';
import 'package:training_plus/view/profile/Trems%20of%20service%20And%20Privacy%20policy/privacy_policy_view.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/view/profile/settings/settings.dart';
import 'package:training_plus/view/profile/Trems%20of%20service%20And%20Privacy%20policy/terms_of_service_view.dart';
import 'package:training_plus/view/profile/profile/widget/reward_tier_card.dart';
import 'package:training_plus/widgets/common_error_message.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_image.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);

    // Fetch profile on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.profile == null && !state.isLoading) {
        controller.fetchProfile();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: CommonText("Profile", size: 21, isBold: true),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 70.h,
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchProfile();
          },
          child:
              state.profile == null && state.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : state.profile == null
                  ? CommonErrorMassage(
                    context: context,
                    massage: "No data Found",
                  )
                  : state.error != null
                  ? CommonErrorMassage(context: context, massage: state.error!)
                  : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Profile Avatar
                      Center(
                        child: ClipOval(
                          child: Image.network(
                            getFullImagePath(state.profile!.attributes.image),
                            width: 50.sp,
                            height: 50.sp,
                            fit:
                                BoxFit
                                    .cover, // ensures the image fills the circle
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 12),
                      Center(
                        child: CommonText(
                          state.profile!.attributes.fullName,

                          size: 18,
                          isBold: true,
                        ),
                      ),
                      CommonSizedBox(height: 20),

                      // Reward Tier Card
                      rewardTierCard(state.profile!.attributes.points),

                      CommonSizedBox(height: 30),

                      // Sections
                      _sectionHeader("General"),
                      sectionTile(
                        "Edit Profile",
                        "assest/images/profile/edit_profile.png",
                        onTap: () {
                          context.navigateTo(EditProfileView());
                        },
                      ),
                      sectionTile(
                        "Settings",
                        "assest/images/profile/settings.png",
                        onTap: () {
                          context.navigateTo(SettingsView());
                        },
                      ),
                      //                       sectionTile(
                      //                         "Redeem Points",
                      //                         "assest/images/profile/redeem_points.png",
                      //                         onTap: () {
                      //                           context.navigateTo(
                      //  RedeemPointsview());
                      //                         },
                      //                       ),
                      sectionTile(
                        "Running History",
                        "assest/images/profile/running_history.png",
                        onTap: () {
                          context.navigateTo(RunningHistoryView());
                        },
                      ),
                      sectionTile(
                        "Badge Shelf",
                        "assest/images/profile/badge_shelf.png",
                        onTap: () {
                          context.navigateTo(BadgeShelfView());
                        },
                      ),
                      sectionTile(
                        "Subscription",
                        "assest/images/profile/my_subscription.png",
                        onTap: () {
                          context.navigateTo(SubscriptionView());
                        },
                      ),

                      CommonSizedBox(height: 24),

                      _sectionHeader("Support & Help"),
                      sectionTile(
                        "Feedback",
                        "assest/images/profile/feedback.png",
                        onTap: () {
                          context.navigateTo(FeedbackView());
                        },
                      ),
                      sectionTile(
                        "FAQ",
                        "assest/images/profile/faq.png",
                        onTap: () {
                          context.navigateTo(FaqView());
                        },
                      ),
                      sectionTile(
                        "Contact Us",
                        "assest/images/profile/contact_us.png",
                        onTap: () {
                          context.navigateTo(ContactUsView());
                        },
                      ),

                      CommonSizedBox(height: 24),

                      _sectionHeader("Legal"),
                      sectionTile(
                        "Terms of Service",
                        "assest/images/profile/terms_of_service.png",
                        onTap: () {
                          context.navigateTo(TermsOfServiceView());
                        },
                      ),
                      sectionTile(
                        "Privacy Policy",
                        "assest/images/profile/privacy_policy.png",
                        onTap: () {
                          context.navigateTo(PrivacyPolicyView());
                        },
                      ),

                      CommonSizedBox(height: 24),

                      _sectionHeader("Others"),
                      sectionTile(
                        "Invite Friends",
                        "assest/images/profile/invite_friends.png",
                        onTap: () {
                          context.navigateTo(
                            InviteFriendsView(
                              inviteCode:
                                  state.profile!.attributes.referralCode,
                            ),
                          );
                        },
                      ),
                      sectionTile(
                        "Logout",
                        "assest/images/profile/logout.png",
                        onTap: () {
                          showLogoutAccountDialog(context, ref);
                        },
                        textColor: Colors.red.shade700,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CommonText(title, size: 14, isBold: true),
    );
  }

  Widget sectionTile(
    String title,
    String imagePath, {
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      dense: true,

      onTap: onTap,
      leading: CommonImage(imagePath: imagePath, isAsset: true, width: 28),
      title: CommonText(title, size: 14, isBold: true),
      trailing: Icon(
        Icons.chevron_right,
        size: 16.sp,
        color: AppColors.primary,
      ),
    );
  }

  Future<void> showLogoutAccountDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CommonText(
            "Do you want to Logout?",
            size: 18,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    "Cancel",
                    color: Colors.grey.shade400,
                    textColor: Colors.black,
                    height: 40,
                    width: 100,
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CommonButton(
                    "Logout",
                    color: Colors.red.shade700,
                    textColor: Colors.white,
                    height: 40,
                    width: 100,
                    onTap: () async {
                      // Clear the saved token
                      final localStorage = ref.read(localStorageProvider);
                      await localStorage.remove(StorageKey.token);
                      // final _providerScopeKey = GlobalKey();
                      // runApp(
                      //   ProviderScope(
                      //     key: _providerScopeKey,
                      //     child: const MyApp(),
                      //   ),
                      // );
                      resetSession(ref);
                      context.navigateTo(SigninView(), clearStack: true);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
