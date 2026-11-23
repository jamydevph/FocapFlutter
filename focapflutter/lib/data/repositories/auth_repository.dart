import 'package:focapflutter/data/models/user_profile.dart';

abstract interface class AuthRepository {
  UserProfile? get currentUser;

  Future<UserProfile> signIn({required String email, required String password});

  Future<UserProfile> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset({required String email});

  Future<void> signOut();
}
