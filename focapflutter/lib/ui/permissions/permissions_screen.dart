import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';
import 'package:go_router/go_router.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholder(
      title: 'Permission',
      path: AppRoutes.permissions,
      actions: [
        TextButton(
          onPressed: () => context.go(AppRoutes.settings),
          child: const Text('Settings'),
        ),
      ],
      links: [
        RouteLink(
          'Continue → Focus',
          () => context.go(AppRoutes.dashboard),
          primary: true,
        ),
      ],
    );
  }
}
