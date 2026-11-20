import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/models/auth_failure.dart';
import 'package:focapflutter/data/repositories/auth_repository_provider.dart';
import 'package:focapflutter/ui/auth/auth_failure_message.dart';
import 'package:focapflutter/ui/auth/auth_validation.dart';

class ForgotPasswordSeed {
  ForgotPasswordSeed(this.email);

  final String email;
}

@immutable
class ForgotPasswordState {
  const ForgotPasswordState({
    this.email = '',
    this.showErrors = false,
    this.submitting = false,
    this.sentTo,
    this.sendCount = 0,
    this.failureMessage,
  });

  final String email;
  final bool showErrors;
  final bool submitting;
  final String? sentTo;
  final int sendCount;
  final String? failureMessage;

  String get trimmedEmail => email.trim();

  bool get sent => sentTo != null;

  String? get emailError =>
      showErrors ? AuthValidation.email(trimmedEmail) : null;

  bool get isValid => AuthValidation.email(trimmedEmail) == null;

  ForgotPasswordState copyWith({
    String? email,
    bool? showErrors,
    bool? submitting,
    String? sentTo,
    bool clearSent = false,
    int? sendCount,
    String? failureMessage,
    bool clearFailure = false,
  }) => ForgotPasswordState(
    email: email ?? this.email,
    showErrors: showErrors ?? this.showErrors,
    submitting: submitting ?? this.submitting,
    sentTo: clearSent ? null : sentTo ?? this.sentTo,
    sendCount: sendCount ?? this.sendCount,
    failureMessage: clearFailure ? null : failureMessage ?? this.failureMessage,
  );
}

class ForgotPasswordViewModel extends Notifier<ForgotPasswordState> {
  ForgotPasswordViewModel(this.seed);

  final ForgotPasswordSeed seed;

  @override
  ForgotPasswordState build() => ForgotPasswordState(email: seed.email);

  void emailChanged(String value) => state = state.copyWith(
    email: value,
    clearSent: value.trim() != state.sentTo,
    clearFailure: true,
  );

  Future<bool> submit() async {
    if (state.submitting) return false;
    state = state.copyWith(showErrors: true, clearFailure: true);
    if (!state.isValid) return false;

    final address = state.trimmedEmail;
    state = state.copyWith(submitting: true);
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(email: address);
      if (!ref.mounted) return false;
      state = state.copyWith(
        submitting: false,
        sentTo: address,
        sendCount: state.sendCount + 1,
      );
      return true;
    } on AuthException catch (error) {
      return _fail(error.failure);
    } on Object catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'forgot password',
          context: ErrorDescription('while sending a reset link'),
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

final forgotPasswordViewModelProvider = NotifierProvider.autoDispose
    .family<ForgotPasswordViewModel, ForgotPasswordState, ForgotPasswordSeed>(
      ForgotPasswordViewModel.new,
    );
