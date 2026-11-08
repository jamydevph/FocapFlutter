import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholder(
      title: 'Focus',
      path: AppRoutes.dashboard,
      links: [
        RouteLink(
          'Start focus → Session',
          () => context.push(AppRoutes.session),
          primary: true,
        ),
        RouteLink(
          'Blocked apps → App selection',
          () => context.push(AppRoutes.apps),
        ),
        RouteLink('Avatar → Settings', () => context.go(AppRoutes.settings)),
        RouteLink('Log out → Login', () => context.go(AppRoutes.login)),
      ],
    );
  }
}
