import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> plans = [
    {
      "title": "Sport Pro",
      "price": "7.99/mo",
      "features": [
        "Access to All Sports",
        "Workout Tracking",
        "Community Leaderboards",
        "Nutrition Tracker",
        "Running Tracker",
      ]
    },
    {
      "title": "All Elite",
      "price": "19.99/mo",
      "features": [
        "Access to All Sports",
        "Workout Tracking",
        "Community Leaderboards",
        "Nutrition Tracker",
        "Running Tracker",
        "Mental Performance Tools",
        "Customize Weekly Goals",
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBG,
      appBar: authAppBar("Choose Your Plan"),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: _buildPlanCard(
                    title: plan["title"],
                    price: plan["price"],
                    features: List<String>.from(plan["features"]),
                  ),
                );
              },
            ),
          ),

          // Page indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(plans.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                width: _currentPage == index ? 10 : 6,
                height: _currentPage == index ? 10 : 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? AppColors.primary : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),

          // Free trial button
          Padding(
            padding: const EdgeInsets.all(16),
            child: commonButton(
              "Start 7 Day Free Trial",
              color: AppColors.primary,
              textColor: AppColors.white,
              width: double.infinity,
              onTap: () {
                // TODO: Navigate to payment/activation
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required List<String> features,
  }) {
    return Container(
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

          // Features
          Expanded(
            child: ListView.builder(
              itemCount: features.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(child: commonText(features[i], size: 14)),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          commonText(price, size: 18, isBold: true, color: AppColors.primary),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // TODO: Show details
            },
            child: commonText("Learn more",
                size: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
