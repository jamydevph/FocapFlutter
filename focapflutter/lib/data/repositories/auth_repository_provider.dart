import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/repositories/auth_repository.dart';
import 'package:focapflutter/data/repositories/fake_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FakeAuthRepository(),
);
