// session_reset.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';

import 'package:training_plus/view/notification/notification_provider.dart';
import 'package:training_plus/view/profile/profile_providers.dart';


void resetSession(WidgetRef ref) {
  ref.invalidate(localStorageProvider);
  ref.invalidate(signInControllerProvider);
  ref.invalidate(notificationControllerProvider);
  ref.invalidate(runningHistoryControllerProvider);

  // Add more providers here if needed
}
