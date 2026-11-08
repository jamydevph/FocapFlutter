import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutePlaceholder(title: 'History', path: AppRoutes.history);
  }
}
