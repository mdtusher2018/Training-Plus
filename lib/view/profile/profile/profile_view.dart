import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/view/profile/Badge%20Shelf/BadgeShelfView.dart';
import 'package:training_plus/view/profile/ContactUsView.dart';
import 'package:training_plus/view/profile/faq/FaqView.dart';
import 'package:training_plus/view/profile/RunningHistoryView.dart';
import 'package:training_plus/view/profile/profile/edit_profile_view.dart';
import 'package:training_plus/view/profile/feedback/feedback_view.dart';
import 'package:training_plus/view/profile/invite_friends_view.dart';
import 'package:training_plus/view/profile/my_subscription_view.dart';
import 'package:training_plus/view/profile/Trems%20of%20service%20And%20Privacy%20policy/privacy_policy_view.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/view/profile/redeemPointsView.dart';
import 'package:training_plus/view/profile/settings/settings.dart';
import 'package:training_plus/view/profile/Trems%20of%20service%20And%20Privacy%20policy/terms_of_service_view.dart';
import 'package:training_plus/view/profile/profile/widget/reward_tier_card.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ProfileView extends ConsumerWidget {

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
        title: commonText("Profile", size: 21, isBold: true),
        centerTitle: true,
      ),

      body: SafeArea(
        child:
            state.isLoading || state.profile == null
                ? Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(child: Text(state.error!))
                : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Profile Avatar
            Center(
  child: ClipOval(
    child: Image.network(
      getFullImagePath(state.profile!.attributes.image),
      width: 100,
      height: 100,
      fit: BoxFit.cover, // ensures the image fills the circle
      errorBuilder: (context, error, stackTrace) => Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: Icon(Icons.person, size: 50, color: Colors.white),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    ),
  ),
),


                  SizedBox(height: 12),
                    Center(
                      child: Text(
                        state.profile!.attributes.fullName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Reward Tier Card
                    rewardTierCard(state.profile!.attributes.points),

                    const SizedBox(height: 30),

                    // Sections
                    _sectionHeader("General"),
                    sectionTile(
                      "Edit Profile",
                      "assest/images/profile/edit_profile.png",
                      onTap: () {
                        navigateToPage(context: context, EditProfileView());
                      },
                    ),
                    sectionTile(
                      "Settings",
                      "assest/images/profile/settings.png",
                      onTap: () {
                        navigateToPage(context: context, SettingsView());
                      },
                    ),
                    sectionTile(
                      "Redeem Points",
                      "assest/images/profile/redeem_points.png",
                      onTap: () {
                        navigateToPage(context: context, RedeemPointsview());
                      },
                    ),
                    sectionTile(
                      "Running History",
                      "assest/images/profile/running_history.png",
                      onTap: () {
                        navigateToPage(context: context, RunningHistoryView());
                      },
                    ),
                    sectionTile(
                      "Badge Shelf",
                      "assest/images/profile/badge_shelf.png",
                      onTap: () {
                        navigateToPage(context: context, BadgeShelfView());
                      },
                    ),
                    sectionTile(
                      "My Subscription",
                      "assest/images/profile/my_subscription.png",
                      onTap: () {
                        navigateToPage(context: context, MySubscriptionView());
                      },
                    ),

                    const SizedBox(height: 24),

                    _sectionHeader("Support & Help"),
                    sectionTile(
                      "Feedback",
                      "assest/images/profile/feedback.png",
                      onTap: () {
                        navigateToPage(context: context, FeedbackView());
                      },
                    ),
                    sectionTile(
                      "FAQ",
                      "assest/images/profile/faq.png",
                      onTap: () {
                        navigateToPage(context: context, FaqView());
                      },
                    ),
                    sectionTile(
                      "Contact Us",
                      "assest/images/profile/contact_us.png",
                      onTap: () {
                        navigateToPage(context: context, ContactUsView());
                      },
                    ),

                    const SizedBox(height: 24),

                    _sectionHeader("Legal"),
                    sectionTile(
                      "Terms of Service",
                      "assest/images/profile/terms_of_service.png",
                      onTap: () {
                        navigateToPage(context: context, TermsOfServiceView());
                      },
                    ),
                    sectionTile(
                      "Privacy Policy",
                      "assest/images/profile/privacy_policy.png",
                      onTap: () {
                        navigateToPage(context: context, PrivacyPolicyView());
                      },
                    ),

                    const SizedBox(height: 24),

                    _sectionHeader("Others"),
                    sectionTile(
                      "Invite Friends",
                      "assest/images/profile/invite_friends.png",
                      onTap: () {
                        navigateToPage(context: context, InviteFriendsView(inviteCode: state.profile!.attributes.referralCode,));
                      },
                    ),
                    sectionTile(
                      "Logout",
                      "assest/images/profile/logout.png",
                      onTap: () {
                        showLogoutAccountDialog(context);
                      },
                      textColor: Colors.red.shade700,
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: commonText(title, size: 14, isBold: true),
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
      visualDensity: VisualDensity(vertical: -1),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CommonImage(imagePath: imagePath, isAsset: true, width: 28),
      title: commonText(title, size: 14, isBold: true),
      trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
    );
  }

  Future<void> showLogoutAccountDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: commonText(
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
                  child: commonButton(
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
                  child: commonButton(
                    "Logout",
                    color: Colors.red.shade700,
                    textColor: Colors.white,
                    height: 40,
                    width: 100,
                    onTap: () {
                      navigateToPage(
                        context: context,
                        SigninView(),
                        clearStack: true,
                      );
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
