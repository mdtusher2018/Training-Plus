// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class PrivacyPolicyView extends StatelessWidget {
   PrivacyPolicyView({super.key});

   String privacyPolicyText = '''
Privacy Policy

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur aliquet, felis a hendrerit hendrerit, risus erat suscipit odio, vitae tempor mauris lectus eget purus. 

Phasellus eget velit vitae nisi pharetra faucibus. Nulla facilisi. In in nulla sed nisl dictum dapibus. Suspendisse at lorem sit amet nulla faucibus gravida.

Information Collection

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu turpis nec nisl tincidunt elementum in vitae magna. Donec viverra, risus in laoreet pharetra, purus ipsum varius est, ac rhoncus justo lorem nec purus.

Usage of Data

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer tempor lorem a porta varius. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.

Third-party Services

Pellentesque a finibus nunc. Suspendisse potenti. Vivamus tincidunt feugiat quam. Sed at dictum justo. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae.

Security

Vestibulum rhoncus, arcu id convallis tincidunt, metus velit iaculis augue, nec rhoncus metus augue sed libero. 

Contact Us

For any questions about this Privacy Policy, please contact us at privacy@yourapp.com.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: commonText(
          'Privacy Policy',
      size: 21
        ),centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: commonText(privacyPolicyText),
  ),
);

  }
}