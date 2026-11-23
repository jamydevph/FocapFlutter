import 'package:firebase_auth/firebase_auth.dart';
import 'package:focapflutter/data/models/user_profile.dart';

class AuthServiceException implements Exception {
  const AuthServiceException(this.code, [this.message]);

  static const missingUser = 'missing-user';

  final String code;
  final String? message;

  @override
  String toString() => 'AuthServiceException($code, $message)';
}

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  UserProfile? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : _profileOf(user);
  }

  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) => _guard(() async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _requireProfile(credential.user);
  });

  Future<UserProfile> createAccount({
    required String email,
    required String password,
  }) => _guard(() async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _requireProfile(credential.user);
  });

  Future<void> sendPasswordResetEmail({required String email}) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email));

  Future<void> signOut() => _guard(_auth.signOut);

  UserProfile _requireProfile(User? user) {
    if (user == null) {
      throw const AuthServiceException(AuthServiceException.missingUser);
    }
    return _profileOf(user);
  }

  UserProfile _profileOf(User user) => UserProfile(
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
  );

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseException catch (error) {
      throw AuthServiceException(error.code, error.message);
    }
  }
}
