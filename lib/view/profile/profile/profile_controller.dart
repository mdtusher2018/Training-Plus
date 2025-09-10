import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/profile/profile/profile_model.dart';

class ProfileState {
  final bool isLoading;
  final ProfileModel? profile;
  final String? error;

  ProfileState({
    this.isLoading = false,
    this.profile,
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    ProfileModel? profile,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error ?? this.error,
    );
  }
}

/// Profile controller
class ProfileController extends StateNotifier<ProfileState> {
  final IApiService apiService;

  ProfileController({required this.apiService}) : super(ProfileState());

  /// Fetch profile from API
  Future<void> fetchProfile() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.getProfile); // Replace with actual endpoint

      if (response != null && response['statusCode'] == 200) {
        final profileModel = ProfileModel.fromJson(response);
        state = state.copyWith(profile: profileModel, isLoading: false);
      } else {
        state = state.copyWith(
          error: response['message'] ?? 'Failed to fetch profile',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

 /// Update profile via API (only when user clicks save)
  Future<void> updateProfile({
    required String name,
    required String email,
    required String userType,
    required String ageGroup,
    required String skillLevel,
    required String goal,
    File? image
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final payload = {
        "fullName": name,
        "email": email,
        "userType": userType,
        "ageGroup": ageGroup,
        "skillLevel": skillLevel,
        "goal": goal,
      };

      final response =
          await apiService.multipart(ApiEndpoints.updateProfile, body:payload, files:{if(image!=null) "profileImage":image},method: "PUT" );

      if (response != null && response['statusCode'] == 200) {
        final updatedProfile = ProfileModel.fromJson(response);
        state = state.copyWith(profile: updatedProfile, isLoading: false);
      } else {
        state = state.copyWith(
          error: response?['message'] ?? 'Failed to update profile',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }



}
