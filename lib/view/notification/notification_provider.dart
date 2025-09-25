
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/view/notification/notification_controller.dart';

/// PROVIDER
final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationState>(
  (ref) => NotificationController(ref),
);


final notificationsScrollControllerProvider =
    Provider.autoDispose<ScrollController>((ref) {
  final controller = ScrollController();

  controller.addListener(() {
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 100) {
      final notifier = ref.read(notificationControllerProvider.notifier);
      notifier.fetchNotifications(loadMore: true);
    }
  });

  return controller;
});


