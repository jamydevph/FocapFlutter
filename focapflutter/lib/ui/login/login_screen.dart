import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholder(
      title: 'Login',
      path: AppRoutes.login,
      links: [
        RouteLink(
          'Sign in → Focus',
          () => context.go(AppRoutes.dashboard),
          primary: true,
        ),
        RouteLink('Create an account', () => context.push(AppRoutes.register)),
        RouteLink(
          'Forgot password?',
          () => context.push(AppRoutes.forgotPassword),
        ),
      ],
    );
  }
}
