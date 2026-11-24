import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';
import 'package:focapflutter/ui/dashboard/dashboard_view_model.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoutePlaceholder(
      title: 'Focus',
      intro: ref.watch(dashboardGreetingProvider),
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
