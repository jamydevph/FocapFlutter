abstract interface class AuthRepository {
  Future<void> signIn({required String email, required String password});
}
