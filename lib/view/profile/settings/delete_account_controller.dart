import 'dart:developer';
import 'package:training_plus/core/base-notifier.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';

class DeleteUserState {
  final bool passwordVisible;
  final bool isLoading;

  const DeleteUserState({this.isLoading = false, this.passwordVisible = false});

  DeleteUserState copyWith({bool? passwordVisible, bool? isLoading}) {
    return DeleteUserState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DeleteUserController extends BaseNotifier<DeleteUserState> {
  final IApiService apiService;

  DeleteUserController({required this.apiService})
    : super(const DeleteUserState());

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Change Password API Call
  Future<bool?> deleteUser({required String password}) async {
    return safeCall(
      onStart: () => setLoading(true),
      onComplete: () => setLoading(false),
      task: () async {
        final response = await apiService.delete(
          ApiEndpoints.deleteUser,
          body: {"password": password},
        );

        log("Delete User Response: $response");

        if (response["statusCode"] == 200) {
          return true;
        }

        return false;
      },
    );
  }
}
/*
         final localStorage = ref.read(localStorageProvider);
                      await localStorage.remove(StorageKey.token);
                      resetSession(ref);
                      context.navigateTo(SigninView(), clearStack: true);
*/