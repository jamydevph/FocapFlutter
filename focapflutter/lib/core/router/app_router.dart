import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_redirect.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/ui/app_selection/app_selection_screen.dart';
import 'package:focapflutter/ui/dashboard/dashboard_screen.dart';
import 'package:focapflutter/ui/edit_profile/edit_profile_screen.dart';
import 'package:focapflutter/ui/forgot_password/forgot_password_screen.dart';
import 'package:focapflutter/ui/history/history_screen.dart';
import 'package:focapflutter/ui/login/login_screen.dart';
import 'package:focapflutter/ui/permissions/permissions_screen.dart';
import 'package:focapflutter/ui/register/register_screen.dart';
import 'package:focapflutter/ui/session/session_screen.dart';
import 'package:focapflutter/ui/settings/settings_screen.dart';
import 'package:focapflutter/ui/shell/app_shell.dart';
import 'package:focapflutter/ui/token_preview/token_preview_screen.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'root'),
    initialLocation: AppRoutes.dashboard,
    redirect: (context, state) =>
        appRedirect(state, signedIn: ref.read(isSignedInProvider)),
    onException: (context, state, router) => router.go(AppRoutes.dashboard),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.permissions,
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.apps,
        builder: (context, state) => const AppSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.session,
        builder: (context, state) => const SessionScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.debugTokens,
          builder: (context, state) => const TokenPreviewScreen(),
        ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.listen(isSignedInProvider, (previous, next) => router.refresh());
  ref.onDispose(router.dispose);
  return router;
});
