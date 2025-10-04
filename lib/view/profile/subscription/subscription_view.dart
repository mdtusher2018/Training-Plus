import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/personalization/personalization_provider.dart';
import 'package:training_plus/view/profile/subscription/subscription_controller.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SubscriptionView extends ConsumerStatefulWidget {
  const SubscriptionView({super.key});

  @override
  ConsumerState<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends ConsumerState<SubscriptionView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref
            .read(subscriptionControllerProvider.notifier)
            .switchTabs(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionControllerProvider);
    final controller = ref.read(subscriptionControllerProvider.notifier);
    // Keep tab controller in sync with provider
    if (_tabController.index != state.currentIndex) {
      _tabController.index = state.currentIndex;
    }
    return Scaffold(
      backgroundColor: AppColors.mainBG,
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: commonText(
          "Subscriptions",
          size: 20,
          isBold: true,
          color: AppColors.black,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,

          tabs: [
            Tab(
              child: commonText(
                "Subscriptions",
                color:
                    (state.currentIndex == 0)
                        ? AppColors.primary
                        : AppColors.black,
                isBold: true,
              ),
            ),
            Tab(
              child: commonText(
                "My Subscription",
                color:
                    (state.currentIndex == 1)
                        ? AppColors.primary
                        : AppColors.black,
                isBold: true,
              ),
            ),
          ],
        ),
      ),

      body:
          state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.error != null
              ? RefreshIndicator(
                onRefresh: () async {
                  controller.refreshAll();
                },
                child: commonErrorMassage(
                  context: context,
                  massage: state.error!,
                ),
              )
              : TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Subscriptions Tab
                  RefreshIndicator(
                    onRefresh: () async {
                      await controller.refreshAll();
                    },
                    child: _buildSubscriptions(state, controller),
                  ),

                  // My Subscription Tab
                  RefreshIndicator(
                    onRefresh: () async {
                      await controller.refreshAll();
                    },
                    child: _buildMySubscription(state, controller),
                  ),
                ],
              ),
    );
  }

  Widget _buildSubscriptions(
    SubscriptionState state,
    SubscriptionController controller,
  ) {
    if (state.plans.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: Center(child: commonText("No subscription plans found")),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.plans.length,
      itemBuilder: (context, index) {
        final plan = state.plans[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildPlanCard(
            id: plan.id,
            title: plan.planName,
            price: plan.price,
            features: {
              "Access to All Sports": true,
              "Workout Tracking": true,
              "Community Leaderboards": true,
              "Nutrition Tracker": plan.nutritionTracker,
              "Running Tracker": plan.runningTracker,
              "Mental Performance Tools": true,
              "Customize Weekly Goals": true,
            },
            isPro: plan.planName == "Sport Pro",
            controller: controller,
            priceId: plan.stripePriceId,
          ),
        );
      },
    );
  }

  Widget _buildMySubscription(
    SubscriptionState state,
    SubscriptionController controller,
  ) {
    final mySub = state.mySubscription;

    if (mySub == null) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: Center(child: commonText("No active subscription found")),
          ),
        ],
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildPlanCard(
            id: mySub.id,
            title: mySub.planName,
            price: mySub.subscription.price,
            features: {
              "Access to All Sports": true,
              "Workout Tracking": true,
              "Community Leaderboards": true,
              "Nutrition Tracker": mySub.subscription.nutritionTracker,
              "Running Tracker": mySub.subscription.runningTracker,
              "Mental Performance Tools": true,
              "Customize Weekly Goals": true,
            },
            isPro: mySub.planName == "Sport Pro",
            controller: controller,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String id,
    required String title,
    required num price,
    required Map<String, bool> features,
    required bool isPro,
    required SubscriptionController controller,
    String? priceId,
  }) {
    return Container(
      // constraints: const BoxConstraints(minHeight: 460),
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
          commonSizedBox(height: 2),

          /// Features list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                            ),
                        ],
                      ),
                    ),
                    commonSizedBox(width: 8),
                    Icon(
                      available ? Icons.check : Icons.lock_outline,
                      size: 18,
                    ),
                  ],
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(subscriptionControllerProvider);
                final controller = ref.read(
                  subscriptionControllerProvider.notifier,
                );

                // Check if this button is loading
                final isLoadingButton = state.buttonLoading[id] ?? false;

                return commonButton(
                  isLoadingButton
                      ? "Processing..." // or show a spinner if your button supports it
                      : (priceId != null ? "$price/mo" : "Activated"),
                  width: double.infinity,
                  onTap:
                      isLoadingButton || priceId == null
                          ? null
                          : () async {
                            await controller.purchaseSubscription(
                              context: context,
                              stripePriceId: priceId,
                              subscriptionId: id,
                            );
                          },
                );
              },
            ),
          ),

          if (isPro && priceId != null)
            Center(child: commonText("Start 7 day free trial", size: 14)),
        ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [commonCloseButton(context)],
              ),
              commonSizedBox(height: 12),
              commonText(
                "Sport Pro currently features\n3 additional sports.",
                size: 15,
                textAlign: TextAlign.center,
              ),
              commonSizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
