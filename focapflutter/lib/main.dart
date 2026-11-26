import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/app.dart';
import 'package:focapflutter/data/repositories/account_repository.dart';
import 'package:focapflutter/data/repositories/account_repository_provider.dart';
import 'package:focapflutter/data/repositories/local_data_providers.dart';
import 'package:focapflutter/data/services/firestore_service.dart';
import 'package:focapflutter/data/services/local_database.dart';
import 'package:focapflutter/data/services/preferences_service.dart';
import 'package:focapflutter/firebase_options.dart';
import 'package:focapflutter/ui/startup_error/storage_error_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirestoreService.configure();
  final preferences = await PreferencesService.open();
  final LocalDatabase database;
  try {
    database = await LocalDatabase.open();
  } on Object catch (error, stack) {
    _reportStartup(error, stack, 'opening the local database');
    runApp(const StorageErrorApp());
    return;
  }
  try {
    await AccountRepository.moveLegacyAccountValues(preferences, database);
  } on Object catch (error, stack) {
    _reportStartup(error, stack, 'moving saved account values');
  }
  runApp(
    ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(preferences),
        localDatabaseProvider.overrideWithValue(database),
      ],
      child: const FocapApp(),
    ),
  );
}

void _reportStartup(Object error, StackTrace stack, String action) =>
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'startup',
        context: ErrorDescription('while $action'),
      ),
    );
