part of 'subscription_view.dart';

class SubscriptionComingSoonView extends StatelessWidget {
  const SubscriptionComingSoonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Icon / Illustration
              Container(
                height: 120.h,
                width: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 60.sp,
                  color: AppColors.primary,
                ),
              ),

              CommonSizedBox(height: 30),

              /// Title
              const CommonText(
                "Premium Subscription",
                size: 22,
                isBold: true,
                textAlign: TextAlign.center,
              ),

              CommonSizedBox(height: 10),

              /// Description
              const CommonText(
                "We're working hard to bring you premium features that will "
                "enhance your training experience.",
                size: 14,
                textAlign: TextAlign.center,
              ),

              CommonSizedBox(height: 25),

              /// Features Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: const [
                    _FeatureItem(text: "Advanced Training Plans"),
                    _FeatureItem(text: "Exclusive Badges & Rewards"),
                    _FeatureItem(text: "Detailed Performance Analytics"),
                    _FeatureItem(text: "Ad-Free Experience"),
                  ],
                ),
              ),

              CommonSizedBox(height: 30),

              /// Notify Button
              CommonButton(
                "Notify Me When Available",
                textSize: 12,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("We'll notify you when it's ready!"),
                    ),
                  );
                },
              ),

              CommonSizedBox(height: 12),

              /// Back Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const CommonText("Go Back", size: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(child: CommonText(text, size: 14)),
        ],
      ),
    );
  }
}
