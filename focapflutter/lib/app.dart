import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/theme/app_theme.dart';
import 'package:focapflutter/core/theme/theme_mode_provider.dart';
import 'package:focapflutter/ui/token_preview/token_preview_screen.dart';

class FocapApp extends ConsumerWidget {
  const FocapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Focap',
      debugShowCheckedModeBanner: false,
      theme: FocapTheme.light,
      darkTheme: FocapTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      home: const TokenPreviewScreen(),
    );
  }
}
