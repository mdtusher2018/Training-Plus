import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // Selected values for dropdowns
  String? selectedUserType = 'Athlete';
  String? selectedAgeGroup = '18+ Years Old';
  String? selectedSkillLevel = 'Intermediate';
  String? selectedGoals = 'Improve Skills';

  final List<String> userTypes = ['Athlete', 'Coach', 'Parent'];
  final List<String> ageGroups = ['Under 13 Years Old', '13–17 Years Old','18+ Years Old'];
  final List<String> skillLevels = ['Beginner', 'Intermediate', 'Advanced'];

  final List<String> goals = ['Improve Skills', 'Build Strength & Fitness', 'Workout Recovery'
  ,'Enhance Mental Toughness',"Prepare for Tryouts","Have Fun&Stay Active","Compete with Friends","Track Nutrition & Eating"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: commonText(
          'Edit Profile',
      size: 21
        ),centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile image and camera icon
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1664297814064-661d433c03d9?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'), 
                  ),
                  Positioned(
                    bottom: -4,
                    right: -8,
                    child: GestureDetector(
                      onTap: () {
                        // Open camera or gallery to change profile image
                      },
                      child: CircleAvatar
                      (radius: 22,
                        backgroundColor: AppColors.white,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.camera_alt, size: 20,),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Full Name field
            commonTextfieldWithTitle(
              'Full Name',
              nameController,
              hintText: 'Enter your full name',
              enable: true,
            ),
            SizedBox(height: 16),

            // Email field
            commonTextfieldWithTitle(
              'Email',
              emailController,
              hintText: 'Enter your email',
              enable: true,
            ),
            SizedBox(height: 16),

            // User Type Title
            commonText(
              'User Type',
              size: 14.0,
              color: Colors.black,
              isBold: true,
            ),
            // User Type dropdown
            commonDropdown<String>(
              items: userTypes,
              value: selectedUserType,
              hint: 'Select User Type',
              onChanged: (value) {
                setState(() {
                  selectedUserType = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Age Group Title
            commonText(
              'Age Group',
              size: 14.0,
              color: Colors.black,
              isBold: true,
            ),
            // Age Group dropdown
            commonDropdown<String>(
              items: ageGroups,
              value: selectedAgeGroup,
              hint: 'Select Age Group',
              onChanged: (value) {
                setState(() {
                  selectedAgeGroup = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Skill Level Title
            commonText(
              'Skill Level',
              size: 14.0,
              color: Colors.black,
              isBold: true,
            ),
            // Skill Level dropdown
            commonDropdown<String>(
              items: skillLevels,
              value: selectedSkillLevel,
              hint: 'Select Skill Level',
              onChanged: (value) {
                setState(() {
                  selectedSkillLevel = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Goals Title
            commonText(
              'Goals',
              size: 14.0,
              color: Colors.black,
              isBold: true,
            ),
            // Goals dropdown
            commonDropdown<String>(
              items: goals,
              value: selectedGoals,
              hint: 'Select Goals',
              onChanged: (value) {
                setState(() {
                  selectedGoals = value;
                });
              },
            ),
            SizedBox(height: 24),

            // Edit Profile button
         commonButton("Edit Profile")
          ],
        ),
      ),
    );
  }
}
