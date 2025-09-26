import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'badge_shelf_model.dart';

class BadgeShelfState {
  final bool isLoading;
  final List<BadgeShelf> badges;
  final String? error;

  BadgeShelfState({
    this.isLoading = false,
    this.badges = const [],
    this.error,
  });

  BadgeShelfState copyWith({
    bool? isLoading,
    List<BadgeShelf>? badges,
    String? error,
  }) {
    return BadgeShelfState(
      isLoading: isLoading ?? this.isLoading,
      badges: badges ?? this.badges,
      error: error,
    );
  }
}

class BadgeShelfController extends StateNotifier<BadgeShelfState> {
  final IApiService apiService;

  BadgeShelfController({required this.apiService})
      : super(BadgeShelfState());

  /// Fetch badges from API
  Future<void> fetchBadges() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.get(ApiEndpoints.badgeShelf);

      if (response != null && response['statusCode'] == 201) {
        final badgeResponse = BadgeShelfResponse.fromJson(response);
        state = state.copyWith(
          badges: badgeResponse.data.attributes,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response?['message'] ?? 'Failed to load badges',
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

