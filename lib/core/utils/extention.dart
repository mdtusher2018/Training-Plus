import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension NavigationExtensions on BuildContext {
  Future<T?> navigateTo<T extends Object?>(
    Widget page, {
    bool replace = false,
    bool clearStack = false,
    Duration duration = const Duration(milliseconds: 600),
    Function(dynamic)? onPopCallback,
  }) {
    final route = PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder:
          (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
      transitionDuration: duration,
    );

    Future<T?> future;

    if (clearStack) {
      future = Navigator.of(this).pushAndRemoveUntil(route, (_) => false);
    } else if (replace) {
      future = Navigator.of(this).pushReplacement(route);
    } else {
      future = Navigator.of(this).push(route);
    }

    return future.then((value) {
      onPopCallback?.call(value);
      return value;
    });
  }
}

extension SnackbarExtensions on BuildContext {
  void showCommonSnackbar({
    required String title,
    required String message,
    bool isTop = false,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: backgroundColor,
      flushbarPosition: FlushbarPosition.TOP, // This shows it at top
      margin: EdgeInsets.all(8.r),
      borderRadius: BorderRadius.circular(8.r),
      titleColor: textColor,
      messageColor: textColor,
    ).show(this);
  }
}
