import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class MySubscriptionView extends StatefulWidget {
  const MySubscriptionView({super.key});

  @override
  State<MySubscriptionView> createState() => _MySubscriptionViewState();
}

class _MySubscriptionViewState extends State<MySubscriptionView> {



  final List<Map<String, dynamic>> plans = [
    {
      "title": "Sport Pro",
      "price": "Activated",
      "features": {
        "Access to All Sports": true,
        "Workout Tracking": true,
        "Community\nLeaderboards": true,
        "Nutrition Tracker": false,
        "Running Tracker": false,
        "Mental Performance Tools": true,
        "Customize Weekly Goals": true,
      }
    },
    // {
    //   "title": "All Elite",
    //   "price": "19.99/mo",
    //   "features": {
    //     "Access to All Sports": true,
    //     "Workout Tracking": true,
    //     "Community Leaderboards": true,
    //     "Nutrition Tracker": true,
    //     "Running Tracker": true,
    //     "Mental Performance Tools": true,
    //     "Customize Weekly Goals": true,
    //   }
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBG,
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: commonText(
          'My Subscription',
      size: 21
        ),centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PageView.builder(
        
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: _buildPlanCard(
                title: plan["title"],
                price: plan["price"],
                features: Map<String, bool>.from(plan["features"]),
                isPro: plan["title"] == "Sport Pro",
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required Map<String, bool> features,
    required bool isPro,
  }) {
    return SingleChildScrollView(
      child: Container(
      constraints: BoxConstraints(minHeight: 400),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonText(title, size: 22, isBold: true),
            const SizedBox(height: 16),
      
            // Features list
            ListView.builder(
      
              shrinkWrap: true,
              itemCount: features.length,
              itemBuilder: (context, i) {
                final key = features.keys.elementAt(i);
                final available = features[key]!;
            
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   
                     
                      Expanded(
                        child: commonText(key, size: 14),
                      ), const SizedBox(width: 8),   Icon(
                        available ? Icons.check : Icons.lock_outline,
                        size: 18,
                      
                      ),
                    ],
                  ),
                );
              },
            ),
      
            const SizedBox(height: 16),
        
            Padding(
              padding: const EdgeInsets.all(16),
              child: commonButton(
                price,
                width: double.infinity,
                onTap: () {
                  // TODO: Navigate to payment/activation
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
