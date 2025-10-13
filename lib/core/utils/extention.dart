import 'package:flutter/material.dart';

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
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
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
