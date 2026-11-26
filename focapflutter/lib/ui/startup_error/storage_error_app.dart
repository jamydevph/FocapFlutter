import 'package:flutter/material.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_theme.dart';
import 'package:focapflutter/core/theme/app_typography.dart';

class StorageErrorApp extends StatelessWidget {
  const StorageErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focap',
      debugShowCheckedModeBanner: false,
      theme: FocapTheme.light,
      darkTheme: FocapTheme.dark,
      home: const _StorageErrorScreen(),
    );
  }
}

class _StorageErrorScreen extends StatelessWidget {
  const _StorageErrorScreen();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Focap can’t start',
                  style: FocapText.titleSmall.copyWith(color: colors.ink),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'It couldn’t open its storage on this phone. Close Focap '
                'and open it again. If this keeps happening, free up some '
                'space on the phone.',
                style: FocapText.body.copyWith(color: colors.soft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
