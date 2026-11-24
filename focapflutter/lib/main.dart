import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/app.dart';
import 'package:focapflutter/data/repositories/account_repository_provider.dart';
import 'package:focapflutter/data/services/firestore_service.dart';
import 'package:focapflutter/data/services/preferences_service.dart';
import 'package:focapflutter/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirestoreService.configure();
  final preferences = await PreferencesService.open();
  runApp(
    ProviderScope(
      overrides: [preferencesServiceProvider.overrideWithValue(preferences)],
      child: const FocapApp(),
    ),
  );
}
