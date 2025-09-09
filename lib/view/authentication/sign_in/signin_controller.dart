import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInState {
  final bool passwordVisible;
  final bool rememberMe;
  final bool isLoading;

  const SignInState({
    this.passwordVisible = true,
    this.rememberMe = false,
    this.isLoading = false,
  });

  SignInState copyWith({bool? passwordVisible, bool? rememberMe, bool? isLoading}) {
    return SignInState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SignInController extends StateNotifier<SignInState> {
  SignInController() : super(const SignInState());

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }
}
