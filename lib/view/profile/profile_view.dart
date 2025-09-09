import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/authentication/sign_in_view.dart';
import 'package:training_plus/view/profile/BadgeShelfView.dart';
import 'package:training_plus/view/profile/ContactUsView.dart';
import 'package:training_plus/view/profile/FaqView.dart';
import 'package:training_plus/view/profile/RunningHistoryView.dart';
import 'package:training_plus/view/profile/edit_profile_view.dart';
import 'package:training_plus/view/profile/feedback_view.dart';
import 'package:training_plus/view/profile/invite_friends_view.dart';
import 'package:training_plus/view/profile/my_subscription_view.dart';
import 'package:training_plus/view/profile/privacy_policy_view.dart';
import 'package:training_plus/view/profile/redeemPointsView.dart';
import 'package:training_plus/view/profile/settings.dart';
import 'package:training_plus/view/profile/terms_of_service_view.dart';
import 'package:training_plus/view/profile/widget/reward_tier_card.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ProfileView extends StatelessWidget {
  final int userPoints = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(title: commonText("Profile",size: 21,isBold: true),centerTitle: true,),
    
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // Profile Avatar
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  "https://plus.unsplash.com/premium_photo-1664297814064-661d433c03d9?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Name
            Center(child: commonText("Jonathan Michael", size: 18, isBold: true)),

            const SizedBox(height: 20),

            // Reward Tier Card
            rewardTierCard(userPoints),

            const SizedBox(height: 30),

    // Sections
_sectionHeader("General"),
sectionTile("Edit Profile", "assest/images/profile/edit_profile.png", onTap: () {
  navigateToPage(EditProfileView());
}),
sectionTile("Settings", "assest/images/profile/settings.png", onTap: () {
  navigateToPage(SettingsView());
}),
sectionTile("Redeem Points", "assest/images/profile/redeem_points.png", onTap: () {
  navigateToPage(RedeemPointsview());
}),
sectionTile("Running History", "assest/images/profile/running_history.png", onTap: () {
  navigateToPage(RunningHistoryView());
}),
sectionTile("Badge Shelf", "assest/images/profile/badge_shelf.png", onTap: () {
  navigateToPage(BadgeShelfView());
}),
sectionTile("My Subscription", "assest/images/profile/my_subscription.png", onTap: () {
  navigateToPage(MySubscriptionView());
}),

const SizedBox(height: 24),

_sectionHeader("Support & Help"),
sectionTile("Feedback", "assest/images/profile/feedback.png", onTap: () {
  navigateToPage(FeedbackView());
}),
sectionTile("FAQ", "assest/images/profile/faq.png", onTap: () {
  navigateToPage(FaqView());
}),
sectionTile("Contact Us", "assest/images/profile/contact_us.png", onTap: () {
  navigateToPage(ContactUsView());
}),

const SizedBox(height: 24),

_sectionHeader("Legal"),
sectionTile("Terms of Service", "assest/images/profile/terms_of_service.png", onTap: () {
  navigateToPage(TermsOfServiceView());
}),
sectionTile("Privacy Policy", "assest/images/profile/privacy_policy.png", onTap: () {
  navigateToPage(PrivacyPolicyView());
}),

const SizedBox(height: 24),

_sectionHeader("Others"),
sectionTile("Invite Friends", "assest/images/profile/invite_friends.png", onTap: () {
  navigateToPage(InviteFriendsView());
}),
sectionTile("Logout", "assest/images/profile/logout.png", onTap: () {
  showLogoutAccountDialog(context);
}, textColor: Colors.red.shade700),
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

Widget sectionTile(String title, String imagePath, {VoidCallback? onTap, Color? textColor}) {
  return ListTile(
    dense: true,
    visualDensity: VisualDensity(vertical: -1),
    contentPadding: EdgeInsets.zero,
    onTap: onTap,
    leading: CommonImage(imagePath: imagePath,isAsset: true,width: 28,),
    title: commonText(title, size: 14, isBold: true),
    trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
  );
}


  Future<void> showLogoutAccountDialog(
    BuildContext context,
  ) async {
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
                      Get.back();
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
                      navigateToPage(SigninView(),clearStack: true);
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
