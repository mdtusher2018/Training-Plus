import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatelessWidget {
  final String url;

  const PaymentWebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Payment"),backgroundColor: AppColors.white,surfaceTintColor: Colors.transparent,),
      body: WebViewWidget(controller: WebViewController(onPermissionRequest: (request) {
        request.grant();
      },)
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith(ApiEndpoints.baseUrl+ApiEndpoints.paymentCompleate)) {
                Navigator.popUntil(context, (route) {
                  return true;
                },);
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse(url))),
    );
  }
}
