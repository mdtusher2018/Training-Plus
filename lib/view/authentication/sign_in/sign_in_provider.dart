import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/view/authentication/sign_in/signin_controller.dart';

final signInControllerProvider =
    StateNotifierProvider<SignInController, SignInState>((ref) {
  return SignInController();
});
