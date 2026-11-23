import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/repositories/auth_repository.dart';
import 'package:focapflutter/data/repositories/firebase_auth_repository.dart';
import 'package:focapflutter/data/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(ref.watch(authServiceProvider)),
);
