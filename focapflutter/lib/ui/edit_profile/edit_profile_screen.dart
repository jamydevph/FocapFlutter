import 'package:flutter/material.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/router/pop_or_go.dart';
import 'package:focapflutter/core/widgets/route_placeholder.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholder(
      title: 'Edit profile',
      path: AppRoutes.editProfile,
      links: [
        RouteLink(
          'Save → back to Settings',
          () => popOrGo(context, AppRoutes.settings),
          primary: true,
        ),
      ],
    );
  }
}
