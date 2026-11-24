import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/models/auth_failure.dart';
import 'package:focapflutter/data/repositories/account_repository_provider.dart';
import 'package:focapflutter/data/repositories/auth_repository_provider.dart';
import 'package:focapflutter/ui/auth/auth_failure_message.dart';
import 'package:focapflutter/ui/auth/auth_validation.dart';

enum RegisterField { firstName, lastName, email, password, confirm }

@immutable
class RegisterState {
  const RegisterState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.confirm = '',
    this.showErrors = false,
    this.submitting = false,
    this.failureMessage,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirm;
  final bool showErrors;
  final bool submitting;
  final String? failureMessage;

  String get trimmedFirstName => AuthValidation.normalizeName(firstName);
  String get trimmedLastName => AuthValidation.normalizeName(lastName);
  String get trimmedEmail => email.trim();

  String? _check(String? Function() rule) => showErrors ? rule() : null;

  String? get firstNameError =>
      _check(() => AuthValidation.requiredName(trimmedFirstName, 'first'));

  String? get lastNameError =>
      _check(() => AuthValidation.requiredName(trimmedLastName, 'last'));

  String? get emailError => _check(() => AuthValidation.email(trimmedEmail));

  String? get passwordError =>
      _check(() => AuthValidation.newPassword(password));

  String? get confirmError =>
      _check(() => AuthValidation.confirmPassword(password, confirm));

  RegisterField? get firstInvalidField {
    if (firstNameError != null) return RegisterField.firstName;
    if (lastNameError != null) return RegisterField.lastName;
    if (emailError != null) return RegisterField.email;
    if (passwordError != null) return RegisterField.password;
    if (confirmError != null) return RegisterField.confirm;
    return null;
  }

  bool get isValid =>
      AuthValidation.requiredName(trimmedFirstName, 'first') == null &&
      AuthValidation.requiredName(trimmedLastName, 'last') == null &&
      AuthValidation.email(trimmedEmail) == null &&
      AuthValidation.newPassword(password) == null &&
      AuthValidation.confirmPassword(password, confirm) == null;

  RegisterState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirm,
    bool? showErrors,
    bool? submitting,
    String? failureMessage,
    bool clearFailure = false,
  }) => RegisterState(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    password: password ?? this.password,
    confirm: confirm ?? this.confirm,
    showErrors: showErrors ?? this.showErrors,
    submitting: submitting ?? this.submitting,
    failureMessage: clearFailure ? null : failureMessage ?? this.failureMessage,
  );
}

class RegisterViewModel extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  void firstNameChanged(String value) =>
      state = state.copyWith(firstName: value, clearFailure: true);

  void lastNameChanged(String value) =>
      state = state.copyWith(lastName: value, clearFailure: true);

  void emailChanged(String value) =>
      state = state.copyWith(email: value, clearFailure: true);

  void passwordChanged(String value) =>
      state = state.copyWith(password: value, clearFailure: true);

  void confirmChanged(String value) =>
      state = state.copyWith(confirm: value, clearFailure: true);

  Future<bool> submit() async {
    if (state.submitting) return false;
    state = state.copyWith(showErrors: true, clearFailure: true);
    if (!state.isValid) return false;

    state = state.copyWith(submitting: true);
    try {
      final firstName = state.trimmedFirstName;
      final lastName = state.trimmedLastName;
      final auth = ref.read(authRepositoryProvider);
      final account = ref.read(accountRepositoryProvider);
      final user = await auth.register(
        firstName: firstName,
        lastName: lastName,
        email: state.trimmedEmail,
        password: state.password,
      );
      unawaited(
        account.completeRegister(
          user,
          firstName: firstName,
          lastName: lastName,
        ),
      );
      if (!ref.mounted) return true;
      state = state.copyWith(submitting: false);
      return true;
    } on AuthException catch (error) {
      return _fail(error.failure);
    } on Object catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'register',
          context: ErrorDescription('while creating an account'),
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

final registerViewModelProvider =
    NotifierProvider.autoDispose<RegisterViewModel, RegisterState>(
      RegisterViewModel.new,
    );
