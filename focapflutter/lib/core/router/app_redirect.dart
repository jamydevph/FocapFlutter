import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

final isSignedInProvider = Provider<bool>((ref) => true);

String? appRedirect(GoRouterState state, {required bool signedIn}) {
  final isPublic = AppRoutes.public.contains(state.matchedLocation);
  if (!signedIn && !isPublic) return AppRoutes.login;
  return null;
}
