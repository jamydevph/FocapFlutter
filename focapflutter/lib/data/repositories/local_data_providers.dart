import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/repositories/app_selection_repository.dart';
import 'package:focapflutter/data/repositories/installed_apps_repository.dart';
import 'package:focapflutter/data/repositories/session_repository.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform_provider.dart';
import 'package:focapflutter/data/services/local_database.dart';

final localDatabaseProvider = Provider<LocalDatabase>(
  (ref) => throw UnimplementedError(
    'localDatabaseProvider is overridden in main() once it is open',
  ),
);

final appSelectionRepositoryProvider = Provider<AppSelectionRepository>(
  (ref) => AppSelectionRepository(ref.watch(localDatabaseProvider)),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(ref.watch(localDatabaseProvider)),
);

final installedAppsRepositoryProvider = Provider<InstalledAppsRepository>(
  (ref) => InstalledAppsRepository(ref.watch(blockerPlatformProvider)),
);
