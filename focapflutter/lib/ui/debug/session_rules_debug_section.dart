import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/ui/debug/session_rules_debug_view_model.dart';

class SessionRulesDebugSection extends ConsumerWidget {
  const SessionRulesDebugSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(sessionRulesDebugProvider);
    final viewModel = ref.read(sessionRulesDebugProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Session rules', style: FocapText.row.copyWith(color: colors.ink)),
        const SizedBox(height: 4),
        Text(
          'Sample: ${viewModel.describe()}',
          style: FocapText.bodySmall.copyWith(color: colors.soft),
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final step in SessionRulesStep.values)
              TextButton(
                onPressed: () => viewModel.run(step),
                child: Text(step.label),
              ),
          ],
        ),
        for (final line in state.log)
          Text(
            line,
            style: FocapText.bodySmall.copyWith(
              color: line.startsWith('✗') ? colors.danger : colors.okText,
            ),
          ),
      ],
    );
  }
}
