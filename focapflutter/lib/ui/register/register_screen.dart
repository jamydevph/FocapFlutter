import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/router/pop_or_go.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholder(
      title: 'Register',
      path: AppRoutes.register,
      links: [
        RouteLink(
          'Create account → Focus',
          () => context.go(AppRoutes.dashboard),
          primary: true,
        ),
        RouteLink('Back to Login', () => popOrGo(context, AppRoutes.login)),
      ],
    );
  }
}
