import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/data/repositories/account_repository_provider.dart';
import 'package:focapflutter/data/repositories/auth_repository_provider.dart';
import 'package:go_router/go_router.dart';

class AuthSession extends Notifier<bool> {
  @override
  bool build() {
    final auth = ref.watch(authRepositoryProvider);
    final account = ref.watch(accountRepositoryProvider);
    var firstEvent = true;
    final subscription = auth.authStateChanges.listen((user) {
      final isFirst = firstEvent;
      firstEvent = false;
      if (user != null) {
        if (!state) state = true;
        if (isFirst) unawaited(account.completeSignIn(user));
        return;
      }
      if (auth.currentUser != null || !state) return;
      unawaited(account.clearLoggedIn());
      state = false;
    });
    ref.onDispose(subscription.cancel);
    return account.loggedInHint;
  }
}

final isSignedInProvider = NotifierProvider<AuthSession, bool>(AuthSession.new);

String? appRedirect(
  GoRouterState state, {
  required bool signedIn,
  required bool accessibilityOn,
}) {
  final location = state.matchedLocation;
  final isPublic = AppRoutes.public.contains(location);
  if (!signedIn) return isPublic ? null : AppRoutes.login;
  if (isPublic) return AppRoutes.dashboard;
  if (!accessibilityOn) {
    return AppRoutes.reachableWithoutAccessibility.contains(location)
        ? null
        : AppRoutes.permissions;
  }
  if (location == AppRoutes.permissions) return AppRoutes.dashboard;
  return null;
}
