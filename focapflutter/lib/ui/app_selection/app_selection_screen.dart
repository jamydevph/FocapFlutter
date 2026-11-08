import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/router/pop_or_go.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';

class AppSelectionScreen extends StatelessWidget {
  const AppSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholder(
      title: 'Pick your distractions',
      path: AppRoutes.apps,
      links: [
        RouteLink(
          'Save → back to Focus',
          () => popOrGo(context, AppRoutes.dashboard),
          primary: true,
        ),
      ],
    );
  }
}
