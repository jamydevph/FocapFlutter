import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/router/pop_or_go.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholder(
      title: 'Focus mode on',
      path: AppRoutes.session,
      links: [
        RouteLink(
          'End session → Focus',
          () => popOrGo(context, AppRoutes.dashboard),
          primary: true,
        ),
      ],
    );
  }
}
