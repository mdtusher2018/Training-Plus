import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/root_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatelessWidget {
  final String url;

  const PaymentWebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: commonText("Complete Payment"),backgroundColor: AppColors.white,surfaceTintColor: Colors.transparent,centerTitle: true,),
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
            context.navigateTo(RootView(), clearStack: true);
            commonSnackbar(context: context, title: "Sucess", message: "Package Activated Sucessfully",backgroundColor: AppColors.success);
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse(url))),
    );
  }
}
