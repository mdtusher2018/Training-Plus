import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/global_keys.dart';

abstract class BaseNotifier<T> extends StateNotifier<T> {
  BaseNotifier(super.state);

  // Reactive fields for UI listening
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  Future<R?> safeCall<R>({
    required Future<R> Function() task,
    String? successMessage,
    bool showErrorSnack = true,
    bool showSuccessSnack = false,
    void Function()? onStart,
    void Function()? onComplete,
  }) async {
    try {
      onStart?.call();
      isLoading.value = true;
      errorMessage.value = null;

      final result = await task();

      if (showSuccessSnack && successMessage != null) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          context.showCommonSnackbar(title: "Success", message: successMessage);
        }
      }

      return result;
    } catch (e, stack) {
      debugPrint("❌ Exception: $e\n$stack");
      errorMessage.value = e.toString();

      if (showErrorSnack) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          context.showCommonSnackbar(
            title: "Error",
            message: errorMessage.value ?? "Something went wrong",
          );
        }
      }
      return null;
    } finally {
      isLoading.value = false;
      onComplete?.call();
    }
  }
}
