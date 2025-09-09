import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {



  final List<Map<String, dynamic>> plans = [
    {
      "title": "Sport Pro",
      "price": "7.99/mo",
      "features": {
        "Access to All Sports": true,
        "Workout Tracking": true,
        "Community Leaderboards": true,
        "Nutrition Tracker": true,
        "Running Tracker": true,
        "Mental Performance Tools": false,
        "Customize Weekly Goals": false,
      }
    },
    {
      "title": "All Elite",
      "price": "19.99/mo",
      "features": {
        "Access to All Sports": true,
        "Workout Tracking": true,
        "Community Leaderboards": true,
        "Nutrition Tracker": true,
        "Running Tracker": true,
        "Mental Performance Tools": true,
        "Customize Weekly Goals": true,
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBG,
      appBar: authAppBar("Choose Your Plan"),
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
      constraints: BoxConstraints(minHeight: 460),
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
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   
                     
                      Expanded(
                        child: Row(
                          children: [
                            commonText(key, size: 14),
                            if (isPro && key == "Access to All Sports")
                              GestureDetector(
                                onTap: () {
                                  _showInfoBottomSheet(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.info_outline, size: 18),
                                ),
                              )
                          ],
                        ),
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
            if(isPro)Center(child: commonText("Start 7 day free trial",size: 14))
          ],
        ),
      ),
    );
  }

  void _showInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [commonCloseButton()],mainAxisAlignment: MainAxisAlignment.end,),
             
              const SizedBox(height: 12),
              commonText(
                "Sport Pro currently features\n3 additional sports.",
                size: 15,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30,)
         
            ],
          ),
        );
      },
    );
  }
}
