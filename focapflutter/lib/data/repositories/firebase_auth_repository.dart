import 'package:flutter/foundation.dart';
import 'package:focapflutter/data/models/auth_failure.dart';
import 'package:focapflutter/data/models/user_profile.dart';
import 'package:focapflutter/data/repositories/auth_repository.dart';
import 'package:focapflutter/data/services/auth_service.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._service);

  final AuthService _service;

  static const _userNotFound = 'user-not-found';

  static const _failuresByCode = {
    'invalid-credential': AuthFailure.wrongCredentials,
    'invalid-login-credentials': AuthFailure.wrongCredentials,
    'wrong-password': AuthFailure.wrongCredentials,
    _userNotFound: AuthFailure.wrongCredentials,
    'user-disabled': AuthFailure.accountDisabled,
    'invalid-email': AuthFailure.invalidEmail,
    'email-already-in-use': AuthFailure.emailAlreadyInUse,
    'weak-password': AuthFailure.weakPassword,
    'network-request-failed': AuthFailure.network,
    'too-many-requests': AuthFailure.tooManyRequests,
  };

  @override
  UserProfile? get currentUser => _service.currentUser;

  @override
  Stream<UserProfile?> get authStateChanges => _service.authStateChanges();

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) => _mapped(
    'signing in',
    () => _service.signIn(email: email, password: password),
  );

  @override
  Future<UserProfile> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) => _mapped(
    'creating an account',
    () => _service.createAccount(email: email, password: password),
  );

  @override
  Future<void> sendPasswordReset({required String email}) =>
      _mapped('sending a reset link', () async {
        try {
          await _service.sendPasswordResetEmail(email: email);
        } on AuthServiceException catch (error) {
          if (error.code != _userNotFound) rethrow;
        }
      });

  @override
  Future<void> signOut() => _mapped('signing out', _service.signOut);

  Future<T> _mapped<T>(String action, Future<T> Function() call) async {
    try {
      return await call();
    } on AuthServiceException catch (error, stack) {
      final failure = _failuresByCode[error.code];
      if (failure != null) throw AuthException(failure);
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'auth repository',
          context: ErrorDescription('while $action'),
        ),
      );
      throw const AuthException(AuthFailure.unknown);
    }
  }
}
