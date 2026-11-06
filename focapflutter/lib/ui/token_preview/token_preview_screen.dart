import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_shape.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/core/theme/theme_mode_provider.dart';
import 'package:focapflutter/core/widgets/tabular_text.dart';

class TokenPreviewScreen extends ConsumerWidget {
  const TokenPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          children: [
            Text('Tokens', style: FocapText.title.copyWith(color: c.ink)),
            const SizedBox(height: 4),
            Text(
              'Focap Modern · ${Theme.of(context).brightness.name}',
              style: FocapText.body.copyWith(color: c.soft),
            ),
            const SizedBox(height: 16),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ButtonSegment(value: ThemeMode.system, label: Text('Auto')),
              ],
              selected: {mode},
              showSelectedIcon: false,
              onSelectionChanged: (picked) =>
                  ref.read(themeModeProvider.notifier).set(picked.first),
            ),
            const _Heading('Colours'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final (name, color) in c.named)
                  _Swatch(name: name, color: color),
              ],
            ),
            const _Heading('Type'),
            const _Countdown(),
            const _TypeRow('Timer · 62 / Bold · equal-width digits'),
            Text('Welcome back', style: FocapText.title.copyWith(color: c.ink)),
            const _TypeRow('Title · 32 / Bold'),
            Text(
              'Custom duration',
              style: FocapText.titleSmall.copyWith(color: c.ink),
            ),
            const _TypeRow('Title small · 26 / Bold'),
            Text('3 apps blocked', style: FocapText.row.copyWith(color: c.ink)),
            const _TypeRow('Row · 15 / SemiBold'),
            Text(
              'Only these get blocked.',
              style: FocapText.body.copyWith(color: c.ink),
            ),
            const _TypeRow('Body · 15 / Regular'),
            Text(
              'Messenger and the rest stay open',
              style: FocapText.bodySmall.copyWith(color: c.soft),
            ),
            const _TypeRow('Body small · 13 / Regular'),
            Text('Completed', style: FocapText.label.copyWith(color: c.ink)),
            const _TypeRow('Label · 12 / Medium'),
            const _Heading('Shape'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Chip('Completed', c.ok, c.okText),
                _Chip('Cancelled', c.grey, c.greyText),
                _Chip("Didn't start", c.warm, c.warmText),
                _Chip('Blocked', c.block, c.blockText),
                _Chip('Selected', c.accentSoft, c.accentText),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: () {}, child: const Text('Start focus')),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(hintText: 'Email')),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: FocapShape.card,
                boxShadow: FocapShape.shadowSoft,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card · radius 20',
                          style: FocapText.row.copyWith(color: c.ink),
                        ),
                        Text(
                          'Soft shadow',
                          style: FocapText.bodySmall.copyWith(color: c.soft),
                        ),
                      ],
                    ),
                  ),
                  Switch(value: true, onChanged: (_) {}),
                  Switch(value: false, onChanged: (_) {}),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: c.hero,
                borderRadius: FocapShape.cardLarge,
                boxShadow: FocapShape.shadowRaised,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hero card · radius 28',
                    style: FocapText.row.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Raised shadow',
                    style: FocapText.bodySmall.copyWith(color: c.navFg),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 44,
                    height: 8,
                    decoration: BoxDecoration(
                      color: c.cap,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 12),
      child: Text(
        text,
        style: FocapText.titleSmall.copyWith(color: context.colors.ink),
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: FocapText.label.copyWith(color: context.colors.soft),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hex = color.toARGB32().toRadixString(16).substring(2).toUpperCase();
    return SizedBox(
      width: 104,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: FocapShape.chip,
              border: Border.all(color: c.line),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: FocapText.label.copyWith(color: c.ink),
            overflow: TextOverflow.ellipsis,
          ),
          Text('#$hex', style: FocapText.label.copyWith(color: c.soft)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text, this.background, this.foreground);

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: FocapShape.chip,
      ),
      child: Text(text, style: FocapText.label.copyWith(color: foreground)),
    );
  }
}

class _Countdown extends StatefulWidget {
  const _Countdown();

  @override
  State<_Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<_Countdown> {
  static const _start = 24 * 60 + 13;
  int _seconds = _start;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds = _seconds == 0 ? _start : _seconds - 1);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return Align(
      alignment: Alignment.centerLeft,
      child: TabularText(
        '$minutes:$seconds',
        style: FocapText.timer.copyWith(color: context.colors.ink),
      ),
    );
  }
}
