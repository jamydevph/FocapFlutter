import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/repositories/account_repository.dart';
import 'package:focapflutter/data/repositories/auth_repository_provider.dart';
import 'package:focapflutter/data/repositories/local_data_providers.dart';
import 'package:focapflutter/data/services/device_info_service.dart';
import 'package:focapflutter/data/services/firestore_service.dart';
import 'package:focapflutter/data/services/package_info_service.dart';
import 'package:focapflutter/data/services/preferences_service.dart';

final preferencesServiceProvider = Provider<PreferencesService>(
  (ref) => throw UnimplementedError(
    'preferencesServiceProvider is overridden in main() once it is open',
  ),
);

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final repository = AccountRepository(
    auth: ref.watch(authServiceProvider),
    firestore: ref.watch(firestoreServiceProvider),
    preferences: ref.watch(preferencesServiceProvider),
    database: ref.watch(localDatabaseProvider),
    deviceInfo: DeviceInfoService(),
    packageInfo: PackageInfoService(),
  );
  ref.onDispose(repository.dispose);
  return repository;
});

final savedNamesProvider = StreamProvider<SavedNames>((ref) async* {
  final repository = ref.watch(accountRepositoryProvider);
  yield repository.savedNames;
  yield* repository.savedNamesChanges;
});
