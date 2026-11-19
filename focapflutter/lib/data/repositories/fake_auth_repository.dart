import 'package:focapflutter/data/models/auth_failure.dart';
import 'package:focapflutter/data/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.delay = const Duration(milliseconds: 700)});

  final Duration delay;

  static const wrongCredentialsDomain = '@wrong.test';
  static const offlineDomain = '@offline.test';
  static const tooManyRequestsDomain = '@limit.test';
  static const disabledDomain = '@disabled.test';

  @override
  Future<void> signIn({required String email, required String password}) async {
    await Future<void>.delayed(delay);
    final address = email.toLowerCase();
    if (address.endsWith(wrongCredentialsDomain)) {
      throw const AuthException(AuthFailure.wrongCredentials);
    }
    if (address.endsWith(offlineDomain)) {
      throw const AuthException(AuthFailure.network);
    }
    if (address.endsWith(disabledDomain)) {
      throw const AuthException(AuthFailure.accountDisabled);
    }
    if (address.endsWith(tooManyRequestsDomain)) {
      throw const AuthException(AuthFailure.tooManyRequests);
    }
  }
}
