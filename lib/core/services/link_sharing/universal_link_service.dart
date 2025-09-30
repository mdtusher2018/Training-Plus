import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:training_plus/view/authentication/signup/sign_up_view.dart';
import 'package:training_plus/view/root_view.dart';

/// DeepLinkService handles deep links and navigates accordingly
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;

  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initialize listeners
  Future<void> initDeepLinks(BuildContext context) async {
    // Cold start
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink, context);
    }

    // Foreground/background
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) => _handleLink(uri, context),
      onError: (err) => debugPrint("DeepLink error: $err"),
    );
  }

  /// Handle links based on path
  void _handleLink(Uri uri, BuildContext context) {
    debugPrint("DeepLink received: $uri");

    if (uri.path.startsWith("/share/run/")) {
      // Navigate to Home (RootPage)
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return RootView();
      },));
    } else if (uri.path.startsWith("/share/refarel/")) {
 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return SignupView();
      },));
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
