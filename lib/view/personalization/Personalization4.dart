import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/personalization/widget/CommonSelectableCard.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization4 extends StatefulWidget {
  const Personalization4({super.key});

  @override
  State<Personalization4> createState() => _Personalization4State();
}

class _Personalization4State extends State<Personalization4> {
  String? selectedRole;

  final List<Map<String, String>> ageGroups = [

  {"title": "Youth", "subtitle": "Under 13 Years Old"},
  {"title": "Teen", "subtitle": "13–17 Years Old"},
  {"title": "Adult", "subtitle": "18+ Years Old"},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProgressBar(target: 4),
              const SizedBox(height: 20),
              Center(child: commonText("What's your skill\nlevel?", size: 22, isBold: true, textAlign: TextAlign.center)),
              const SizedBox(height: 30),

              Expanded(
                child: ListView.separated(
                  itemCount: ageGroups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final role = ageGroups[index];
                    final isSelected = selectedRole == role['title'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole = role['title'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color.fromARGB(255, 255, 247, 224) : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                     
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(role['title']!, size: 15, isBold: true),
                                const SizedBox(height: 4),
                                commonText(role['subtitle']!, size: 13, color: AppColors.textSecondary),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              commonButton(
                "Next",iconWidget: Icon(Icons.arrow_forward),
                iconLeft: false,
                onTap: selectedRole != null
                    ? () {
                        navigateToPage(Personalization4());
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }


}
