// home_controller.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/home/home/home_page_model.dart';

/// State class to hold API result
class HomeState {
  final bool isLoading;
  final HomeResponse? response;
  final String? error;

  HomeState({
    this.isLoading = false,
    this.response,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    HomeResponse? response,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error,
    );
  }
}

/// Controller
class HomeController extends StateNotifier<HomeState> {
  final IApiService apiService;

  HomeController(this.apiService) : super(HomeState()){
fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await apiService.get(ApiEndpoints.homePage);
      log(result.toString());
      final homeResponse = HomeResponse.fromJson(result);
      log(homeResponse.toString());
      log(homeResponse.message);
      state = state.copyWith(isLoading: false, response: homeResponse);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }finally{
      state = state.copyWith(isLoading: false);
    }
  }
}


