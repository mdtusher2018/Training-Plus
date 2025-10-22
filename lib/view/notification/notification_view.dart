import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/notification/notification_provider.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/view/notification/notification_controller.dart';


class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationControllerProvider);
    final controller = ref.read(notificationControllerProvider.notifier);
    final scrollController = ref.watch(notificationsScrollControllerProvider);

    // Fetch first page on init
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (state.notifications.isEmpty && !state.isLoading) {
    //     controller.fetchNotifications();
    //   }
    // });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: CommonText("Notifications", size: 20, isBold: true),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchNotifications(loadMore: false);
        },
        child: state.isLoading && state.notifications.isEmpty
            ? const Center(child: CircularProgressIndicator(),)
            : state.notifications.isEmpty
                ? ListView(
                  
                  children:[ SizedBox(
                    height: MediaQuery.sizeOf(context).height*0.8,
                    child: Center(child: _buildEmptyState()))])
                : _buildNotificationList(
                    state, scrollController, state.isLoading),
      ),
    );
    
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset("assest/images/notification/notification.png", width: 120),
        CommonSizedBox(height: 24),
        CommonText("There’s no notifications", size: 21, isBold: true),
        CommonSizedBox(height: 8),
        CommonText(
          "Your notifications will\nappear on this page.",
          size: 16,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
Widget _buildNotificationList(
  NotificationState state,
  ScrollController scrollController,
  bool isLoading,
) {
  return ListView.separated(
    controller: scrollController,
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: state.notifications.length + (isLoading ? 1 : 0),
    separatorBuilder: (_, __) => const Divider(height: 12, color: Colors.grey),
    itemBuilder: (context, index) {
      // Show bottom loader for pagination
      if (index >= state.notifications.length) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final notif = state.notifications[index];
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(color: AppColors.mainBG),
        child: Row(
          children: [
            const Icon(Icons.notifications_active,
                color: AppColors.primary, size: 28),
            CommonSizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    notif.message,
                    size: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  CommonSizedBox(height: 4),
                  CommonText(
                    timeAgo(notif.createdAt),
                    size: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}


}
