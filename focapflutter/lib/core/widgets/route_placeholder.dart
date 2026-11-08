import 'package:flutter/material.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_typography.dart';

class RouteLink {
  const RouteLink(this.label, this.onTap, {this.primary = false});

  final String label;
  final VoidCallback onTap;
  final bool primary;
}

class RoutePlaceholder extends StatelessWidget {
  const RoutePlaceholder({
    required this.title,
    required this.path,
    this.links = const [],
    this.actions,
    super.key,
  });

  final String title;
  final String path;
  final List<RouteLink> links;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              'Route $path. Placeholder until this screen is built.',
              style: FocapText.body.copyWith(color: colors.soft),
            ),
            const SizedBox(height: 24),
            for (final link in links)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: link.primary
                    ? SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: link.onTap,
                          child: Text(link.label),
                        ),
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: link.onTap,
                          child: Text(link.label),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
