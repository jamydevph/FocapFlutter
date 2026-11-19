enum AuthFailure {
  wrongCredentials,
  accountDisabled,
  invalidEmail,
  emailAlreadyInUse,
  weakPassword,
  network,
  tooManyRequests,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.failure);

  final AuthFailure failure;

  @override
  String toString() => 'AuthException(${failure.name})';
}
