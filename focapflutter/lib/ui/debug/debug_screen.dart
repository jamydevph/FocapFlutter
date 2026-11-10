import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_shape.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/ui/debug/debug_view_model.dart';
import 'package:go_router/go_router.dart';

class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(debugViewModelProvider);
    final viewModel = ref.read(debugViewModelProvider.notifier);
    final event = state.lastAccessibilityEvent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug tools'),
        actions: [
          TextButton(
            onPressed: () => context.push(AppRoutes.debugTokens),
            child: const Text('Tokens'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              'Blocker: ${state.platformName}',
              style: FocapText.row.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 4),
            Text(
              'accessibilityChanged: ${event ?? 'no event yet'}',
              style: FocapText.bodySmall.copyWith(color: colors.soft),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: state.running.isEmpty ? viewModel.runAll : null,
                child: const Text('Run every check'),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Calls that open a system screen run only on their own tap.',
              style: FocapText.bodySmall.copyWith(color: colors.soft),
            ),
            const SizedBox(height: 16),
            for (final call in DebugViewModel.calls)
              _CallTile(
                call: call,
                result: state.results[call.name],
                running: state.running.contains(call.name),
                onRun: () => viewModel.run(call),
              ),
          ],
        ),
      ),
    );
  }
}

class _CallTile extends StatelessWidget {
  const _CallTile({
    required this.call,
    required this.result,
    required this.running,
    required this.onRun,
  });

  final DebugCall call;
  final String? result;
  final bool running;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final failed = result?.startsWith('error') ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: colors.surface,
        borderRadius: FocapShape.button,
        child: InkWell(
          borderRadius: FocapShape.button,
          onTap: running ? null : onRun,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call.name,
                        style: FocapText.row.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        running ? 'running…' : result ?? 'not run',
                        style: FocapText.bodySmall.copyWith(
                          color: failed ? colors.danger : colors.soft,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.play_arrow_rounded, color: colors.accentText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
