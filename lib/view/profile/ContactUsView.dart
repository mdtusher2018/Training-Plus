import 'package:flutter/material.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("Contact Us", size: 21, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          children: [
            contactCard(
              imagePath: "assest/images/profile/email.png",
              label: "Email",
              textColor: Colors.black,
              onTap: () {
                // Handle email tap
              },
            ),
            const SizedBox(height: 12),
            contactCard(
              imagePath: "assest/images/profile/whatsapp.png",
              label: "Whatsapp",
              textColor: Colors.green,
              onTap: () {
                // Handle WhatsApp tap
              },
            ),
            const SizedBox(height: 12),
            contactCard(
              imagePath: "assest/images/profile/instagram.png",
              label: "Instagram",
              gradient: const LinearGradient(
                colors: [Colors.pink, Colors.orange],
              ),
              onTap: () {
                // Handle Instagram tap
              },
            ),
            const SizedBox(height: 12),
            contactCard(
              imagePath: "assest/images/profile/facebook.png",
              label: "Facebook",
              textColor: Colors.blue,
              onTap: () {
                // Handle Facebook tap
              },
            ),
            const SizedBox(height: 12),
            contactCard(
              imagePath: "assest/images/profile/x.png",
              label: "X",
              textColor: Colors.black,
              onTap: () {
                // Handle Twitter (X) tap
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget contactCard({
    required String imagePath,
    required String label,
    Color? textColor,
    LinearGradient? gradient,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CommonImage(imagePath: imagePath, isAsset: true, height: 36,width: 30,),
            const SizedBox(width: 12),
            gradient != null
                ? ShaderMask(
                    shaderCallback: (bounds) =>
                        gradient.createShader(Offset.zero & bounds.size),
                    child: commonText(label,
                        size: 16, isBold: true, color: Colors.white),
                  )
                : commonText(label,
                    size: 16, isBold: true, color: textColor ?? Colors.black),
          ],
        ),
      ),
    );
  }
}
