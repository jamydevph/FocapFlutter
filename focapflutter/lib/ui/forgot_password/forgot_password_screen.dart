import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/router/pop_or_go.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholder(
      title: 'Reset your password',
      path: AppRoutes.forgotPassword,
      links: [
        RouteLink('Back to Login', () => popOrGo(context, AppRoutes.login)),
      ],
    );
  }
}
