import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/common_used_models/pagination_model.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/notification/notification_model.dart';


/// STATE
class NotificationState {
  final bool isLoading;
  final String? error;
  final List<NotificationItem> notifications;
  final Pagination? pagination;

  NotificationState({
    this.isLoading = false,
    this.error,
    this.notifications = const [],
    this.pagination,
  });

  NotificationState copyWith({
    bool? isLoading,
    String? error,
    List<NotificationItem>? notifications,
    Pagination? pagination,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      notifications: notifications ?? this.notifications,
      pagination: pagination ?? this.pagination,
    );
  }
}

/// CONTROLLER
class NotificationController extends StateNotifier<NotificationState> {
  final Ref ref;

  NotificationController(this.ref) : super(NotificationState());

  /// Fetch notifications (with pagination support)
  Future<void> fetchNotifications({bool loadMore = false}) async {
    try {
      if (state.isLoading) return;

      state = state.copyWith(isLoading: true, error: null);

      final nextPage = loadMore && state.pagination != null
          ? (state.pagination!.currentPage + 1)
          : 1;

      final apiService = ref.read(apiServiceProvider);

      final response = await apiService.get(
        ApiEndpoints.notifications(limit: 10,page: nextPage),
      );

      if (response != null && response['statusCode'] == 200) {
        final notificationResponse = NotificationResponse.fromJson(response);

        final newNotifications =
            notificationResponse.data?.attributes?.notification ?? [];

        final updatedList = loadMore
            ? [...state.notifications, ...newNotifications]
            : newNotifications;

        state = state.copyWith(
          isLoading: false,
          notifications: updatedList,
          pagination: notificationResponse.data?.attributes?.pagination,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response?['message'] ?? "Failed to fetch notifications",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Error: ${e.toString()}",
      );
    }
  }
}
