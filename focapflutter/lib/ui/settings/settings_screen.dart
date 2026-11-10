import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholder(
      title: 'Settings',
      path: AppRoutes.settings,
      links: [
        RouteLink(
          'Edit → Edit profile',
          () => context.push(AppRoutes.editProfile),
        ),
        RouteLink(
          'Accessibility → Permission',
          () => context.push(AppRoutes.permissions),
        ),
        RouteLink('Log out → Login', () => context.go(AppRoutes.login)),
        if (kDebugMode)
          RouteLink('Debug tools', () => context.push(AppRoutes.debug)),
      ],
    );
  }
}
