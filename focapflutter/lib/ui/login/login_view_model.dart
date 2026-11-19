import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/models/auth_failure.dart';
import 'package:focapflutter/data/repositories/auth_repository_provider.dart';
import 'package:focapflutter/ui/auth/auth_failure_message.dart';
import 'package:focapflutter/ui/auth/auth_validation.dart';

@immutable
class LoginState {
  const LoginState({
    this.email = '',
    this.password = '',
    this.showErrors = false,
    this.submitting = false,
    this.failureMessage,
  });

  final String email;
  final String password;
  final bool showErrors;
  final bool submitting;
  final String? failureMessage;

  String get trimmedEmail => email.trim();

  String? get emailError =>
      showErrors ? AuthValidation.email(trimmedEmail) : null;

  String? get passwordError {
    if (!showErrors) return null;
    if (password.isEmpty) return 'Enter your password.';
    return null;
  }

  bool get isValid =>
      AuthValidation.email(trimmedEmail) == null && password.isNotEmpty;

  LoginState copyWith({
    String? email,
    String? password,
    bool? showErrors,
    bool? submitting,
    String? failureMessage,
    bool clearFailure = false,
  }) => LoginState(
    email: email ?? this.email,
    password: password ?? this.password,
    showErrors: showErrors ?? this.showErrors,
    submitting: submitting ?? this.submitting,
    failureMessage: clearFailure ? null : failureMessage ?? this.failureMessage,
  );
}

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void emailChanged(String value) =>
      state = state.copyWith(email: value, clearFailure: true);

  void passwordChanged(String value) =>
      state = state.copyWith(password: value, clearFailure: true);

  Future<bool> submit() async {
    if (state.submitting) return false;
    state = state.copyWith(showErrors: true, clearFailure: true);
    if (!state.isValid) return false;

    state = state.copyWith(submitting: true);
    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: state.trimmedEmail, password: state.password);
      if (!ref.mounted) return false;
      state = state.copyWith(submitting: false);
      return true;
    } on AuthException catch (error) {
      return _fail(error.failure);
    } on Object catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'login',
          context: ErrorDescription('while signing in'),
        ),
      );
      return _fail(AuthFailure.unknown);
    }
  }

  bool _fail(AuthFailure failure) {
    if (!ref.mounted) return false;
    state = state.copyWith(
      submitting: false,
      failureMessage: authFailureMessage(failure),
    );
    return false;
  }
}

final loginViewModelProvider =
    NotifierProvider.autoDispose<LoginViewModel, LoginState>(
      LoginViewModel.new,
    );
