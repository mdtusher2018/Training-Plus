import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  // Static notification list (createdAt as String)
  final List<NotificationItem> notifications = const [
    NotificationItem(
      message: "Your workout plan has been updated.",
      createdAt: "2025-08-04 14:30:00",
      isRead: false,
    ),
    NotificationItem(
      message: "You have a new challenge available!",
      createdAt: "2025-08-03 09:15:00",
      isRead: true,
    ),
    NotificationItem(
      message: "Don't forget to log your meals today.",
      createdAt: "2025-08-02 17:45:00",
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new)),
        title: commonText("Notifications", size: 20, isBold: true),
        centerTitle: true,
      ),
      body: notifications.isEmpty ? _buildEmptyState() : _buildNotificationList(),
    );
  }

  Widget _buildEmptyState() {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assest/images/notification/notification.png",width: 120,),
          const SizedBox(height: 24),
          commonText("There’s no notifications", size: 21, isBold: true),
          const SizedBox(height: 8),
          commonText(
            "Your notifications will\nappear on this page.",
            size: 16,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => Divider(height: 12,color: Colors.grey,),
      itemBuilder: (context, index) {
        final notif = notifications[index];
     

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: 
                AppColors.white,
          ),
          child: Row(
            children: [
              Icon(Icons.notifications_active, color: AppColors.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonText(
                      notif.message,
                      size: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 4),
                    commonText(
                      _formatDate(notif.createdAt),
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return "${difference.inMinutes} minutes ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hours ago";
      } else {
        return "${difference.inDays} days ago";
      }
    } catch (e) {
      return dateString; // fallback to raw text if parsing fails
    }
  }
}

// Simple static model for notifications (createdAt is String now)
class NotificationItem {
  final String message;
  final String createdAt;
  final bool isRead;

  const NotificationItem({
    required this.message,
    required this.createdAt,
    required this.isRead,
  });
}
