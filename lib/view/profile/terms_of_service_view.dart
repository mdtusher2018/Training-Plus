import 'package:flutter/material.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class TermsOfServiceView extends StatefulWidget {
  const TermsOfServiceView({super.key});

  @override
  State<TermsOfServiceView> createState() => _TermsOfServiceViewState();
}

class _TermsOfServiceViewState extends State<TermsOfServiceView> {
String termsOfServiceText = '''
Terms of Service

Welcome to our application. Please read these terms of service carefully.

Acceptance of Terms

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque vel velit eget risus ultricies pulvinar non vel nulla. Integer nec sapien nec tortor pulvinar egestas.

User Obligations

In at fermentum nibh. Sed condimentum, diam nec iaculis volutpat, urna lorem fringilla tellus, non posuere nulla lacus nec turpis. Aenean ac justo eget nisl tincidunt convallis.

Account Management

Vivamus in venenatis nulla. Integer vitae massa eu turpis malesuada malesuada. Aenean at eros eget dolor facilisis vestibulum a a tellus.

Prohibited Activities

Suspendisse feugiat laoreet tellus. Vivamus hendrerit, ipsum at imperdiet blandit, nulla purus accumsan massa, nec varius ipsum lorem nec augue.

Termination

Curabitur congue, nunc ut tincidunt iaculis, felis erat dictum justo, vel sagittis dolor nulla vitae nisi.

Limitation of Liability

Donec at semper turpis. Integer tincidunt arcu ac tortor mattis, eget luctus turpis varius. Curabitur euismod a erat at sollicitudin.

Governing Law

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut enim non risus iaculis volutpat.

Contact Us

For questions about these terms, please email us at terms@yourapp.com.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: commonText(
          'Terms of service',
      size: 21
        ),centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: commonText(termsOfServiceText),
  ),
);

  }
}