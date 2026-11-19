import 'package:focapflutter/data/models/auth_failure.dart';

String authFailureMessage(AuthFailure failure) => switch (failure) {
  AuthFailure.wrongCredentials =>
    "That email and password don't match. Try again.",
  AuthFailure.accountDisabled =>
    'This account has been turned off. Contact support to turn it back on.',
  AuthFailure.invalidEmail => 'Enter a valid email, like you@example.com.',
  AuthFailure.emailAlreadyInUse =>
    'An account already uses this email. Log in instead.',
  AuthFailure.weakPassword => 'Choose a stronger password.',
  AuthFailure.network =>
    "Can't reach Focap. Check your connection and try again.",
  AuthFailure.tooManyRequests =>
    'Too many tries. Wait a moment, then try again.',
  AuthFailure.unknown => 'Something went wrong. Try again.',
};
