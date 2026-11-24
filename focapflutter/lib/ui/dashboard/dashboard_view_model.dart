import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/repositories/account_repository_provider.dart';
import 'package:focapflutter/data/repositories/auth_repository_provider.dart';

String greetingFor(DateTime time, String name) {
  final part = switch (time.hour) {
    < 12 => 'morning',
    < 18 => 'afternoon',
    _ => 'evening',
  };
  return 'Good $part, $name';
}

final dashboardGreetingProvider = Provider.autoDispose<String?>((ref) {
  final saved = ref.watch(savedNamesProvider).value?.firstName;
  final fallback = ref.watch(authRepositoryProvider).currentUser?.displayName;
  final name = (saved?.trim().isNotEmpty ?? false) ? saved! : fallback?.trim();
  if (name == null || name.isEmpty) return null;
  return greetingFor(DateTime.now(), name);
});
