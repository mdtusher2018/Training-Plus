// ignore_for_file: use_build_context_synchronously

import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
import 'package:app_links/app_links.dart';
// import 'package:crypto/crypto.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:training_plus/core/utils/ApiEndpoints.dart';
// import 'package:training_plus/core/utils/global_keys.dart';
// import 'package:training_plus/view/home/Run_Details/run_details_controller.dart';
// import 'package:training_plus/view/home/Run_Details/run_details_view.dart';
import 'package:training_plus/view/home/home_providers.dart';
// import 'package:training_plus/view/root_view.dart';

// class DeepLinkService {
//   static final DeepLinkService _instance = DeepLinkService._internal();
//   factory DeepLinkService() => _instance;
//   DeepLinkService._internal();
//   final AppLinks _appLinks = AppLinks();
//   StreamSubscription<Uri>? _linkSubscription;
//   Future<void> initDeepLinks(BuildContext context) async {
//     // Cold start
//     final initialLink = await _appLinks.getInitialLink();
//     if (initialLink != null) {
//       _handleLink(initialLink, context);
//     }
//     // Foreground/background
//     _linkSubscription = _appLinks.uriLinkStream.listen(
//       (uri) => _handleLink(uri, context),
//       onError: (err) => debugPrint("DeepLink error: $err"),
//     );
//   }
//   void _handleLink(Uri uri, BuildContext context) async {
//     debugPrint("DeepLink received: $uri");
//     if (uri.path.startsWith("/running/")) {
//       final runId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
//       if (runId != null) {
//         try {
//           // Generate unique device signature
//           final deviceSignature = await getDeviceSignature();
//           final apiUrl = Uri.parse(
//             ApiEndpoints.baseUrl + ApiEndpoints.runSharingUrl(runId),
//           ).replace(queryParameters: {"deviceId": deviceSignature});
//           log(apiUrl.toString());
//           debugPrint("API Call: $apiUrl");
//           final response = await http.get(apiUrl);
//           log(response.body.toString());
//           final runData = jsonDecode(response.body);
//           navigatorKey.currentState?.push(
//             MaterialPageRoute(builder: (_) => RunDetailPage(runData: runData)),
//           );
//         } catch (e) {
//           log("Error fetching run details: $e");
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => RootView()),
//           );
//         }
//       }
//     }
//   }
//   Future<String> getDeviceSignature() async {
//     final deviceInfo = DeviceInfoPlugin();
//     String rawId;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       rawId = androidInfo.id;
//     } else if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       rawId = iosInfo.identifierForVendor ?? "unknown";
//     } else {
//       rawId = "unsupported_platform";
//     }
//     // Hash for safety and uniqueness
//     final bytes = utf8.encode(rawId);
//     return sha256.convert(bytes).toString();
//   }
//   void dispose() {
//     _linkSubscription?.cancel();
//   }
// }




/// Handles only link detection and navigation
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initialize deep links
  Future<void> initDeepLinks(BuildContext context,WidgetRef ref) async {
    // Cold start
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink, context,ref);
    }

    // Foreground/background
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) => _handleLink(uri, context,ref),
      onError: (err) => debugPrint("DeepLink error: $err"),
    );
  }

  void _handleLink(Uri uri, BuildContext context,WidgetRef ref) {
    debugPrint("DeepLink received: $uri");

    // Detect type of link
    if (uri.path.startsWith("/running/")) {
      final runId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
      if (runId != null) {
        // Trigger the controller to fetch details
        ref.read(runShareDetailProvider.notifier).fetchRunDetail(runId);
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}

