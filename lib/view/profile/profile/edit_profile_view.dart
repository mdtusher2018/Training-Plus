import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_picker/image_picker.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/enums.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  String? selectedUserType;
  String? selectedAgeGroup;
  String? selectedSkillLevel;
  String? selectedGoal;

  final userTypes = ['Athlete', 'Coach', 'Parent'];
  final ageGroups = ['Under 13 Years Old', '13–17 Years Old', '18+ Years Old'];
  final skillLevels = ['Beginner', 'Intermediate', 'Advanced'];
  final goals = [
    'Improve Skills',
    'Build Strength & Fitness',
    'Workout Recovery',
    'Enhance Mental Toughness',
    "Prepare for Tryouts",
    "Have Fun&Stay Active",
    "Compete with Friends",
    "Track Nutrition & Eating",
  ];

  @override
  void initState() {
    super.initState();
    final profileState = ref.read(profileControllerProvider);
    final profile = profileState.profile!.attributes;

    // Initialize controllers and dropdowns from state
    nameController = TextEditingController(text: profile.fullName);
    emailController = TextEditingController(text: profile.email);
    selectedUserType = profile.userType;
    selectedAgeGroup = profile.ageGroup;
    selectedSkillLevel = profile.skillLevel;
    selectedGoal = profile.goal;

    // Convert API → UI friendly labels
    selectedUserType = reverseRoleMap[profile.userType] ?? '';
    selectedAgeGroup = reverseAgeGroupMap[profile.ageGroup] ?? '';
    selectedSkillLevel = reverseSkillLevelMap[profile.skillLevel] ?? '';
    selectedGoal = reverseGoalMap[profile.goal] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Add inside your state class
  XFile? selectedImage;

  // Method to pick image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery, // can also allow camera
      imageQuality: 80, // optional compression
    );

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: CommonText('Edit Profile', size: 21),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          profileState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    // Profile image
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 50.sp,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                selectedImage != null
                                    ? FileImage(
                                      File(selectedImage!.path),
                                    ) // show picked image
                                    : (profileState
                                                .profile
                                                ?.attributes
                                                .image
                                                .isNotEmpty ==
                                            true
                                        ? NetworkImage(
                                          getFullImagePath(
                                            profileState
                                                .profile!
                                                .attributes
                                                .image,
                                          ),
                                        )
                                        : const NetworkImage(
                                          "https://via.placeholder.com/150",
                                        )),
                          ),

                          Positioned(
                            bottom: -4,
                            right: -8,
                            child: GestureDetector(
                              onTap: () async {
                                await pickImage();
                              },
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.white,
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.primary,
                                  child: Icon(Icons.camera_alt, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CommonSizedBox(height: 16),

                    // Full Name field
                    CommonTextfieldWithTitle(
                      'Full Name',
                      nameController,
                      hintText: 'Enter your full name',
                    ),
                    CommonSizedBox(height: 16),

                    // Email field
                    CommonTextfieldWithTitle(
                      'Email',
                      emailController,
                      hintText: 'Enter your email',
                    ),
                    CommonSizedBox(height: 16),

                    // User Type
                    CommonText('User Type', size: 14, isBold: true),
                    CommonDropdown<String>(
                      items: userTypes,
                      value:
                          userTypes.contains(selectedUserType)
                              ? selectedUserType
                              : null,
                      hint: 'Select User Type',
                      onChanged: (value) {
                        setState(() => selectedUserType = value);
                      },
                    ),

                    CommonSizedBox(height: 16),

                    // Age Group
                    CommonText('Age Group', size: 14, isBold: true),
                    CommonDropdown<String>(
                      items: ageGroups,
                      value:
                          ageGroups.contains(selectedAgeGroup)
                              ? selectedAgeGroup
                              : null,
                      hint: 'Select Age Group',
                      onChanged: (value) {
                        setState(() => selectedAgeGroup = value);
                      },
                    ),

                    CommonSizedBox(height: 16),

                    // Skill Level
                    CommonText('Skill Level', size: 14, isBold: true),
                    CommonDropdown<String>(
                      items: skillLevels,
                      value:
                          skillLevels.contains(selectedSkillLevel)
                              ? selectedSkillLevel
                              : null,
                      hint: 'Select Skill Level',
                      onChanged: (value) {
                        setState(() => selectedSkillLevel = value);
                      },
                    ),
                    CommonSizedBox(height: 16),

                    // Goals
                    CommonText('Goals', size: 14, isBold: true),
                    CommonDropdown<String>(
                      items: goals,
                      value: goals.contains(selectedGoal) ? selectedGoal : null,
                      hint: 'Select Goal',
                      onChanged: (value) {
                        setState(() => selectedGoal = value);
                      },
                    ),
                    CommonSizedBox(height: 24),

                    // Save button
                    CommonButton(
                      "Save Profile",
                      isLoading: profileState.isLoading,
                      onTap: () async {
                        await ref
                            .read(profileControllerProvider.notifier)
                            .updateProfile(
                              name: nameController.text,
                              email: emailController.text,
                              userType: selectedUserType ?? '',
                              ageGroup: selectedAgeGroup ?? '',
                              skillLevel: selectedSkillLevel ?? '',
                              goal: selectedGoal ?? '',
                              image:
                                  selectedImage != null
                                      ? File(selectedImage!.path)
                                      : null,
                            );
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
