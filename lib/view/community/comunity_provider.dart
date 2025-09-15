import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/community/community_controller.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, CommunityState>((ref) {
  final apiService = ref.read(apiServiceProvider); // your ApiService provider
  final controller=CommunityController(apiService);
  return controller;
});
