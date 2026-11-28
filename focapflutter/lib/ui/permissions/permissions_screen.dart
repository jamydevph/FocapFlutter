import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_shape.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/core/widgets/focap_error_row.dart';
import 'package:focapflutter/core/widgets/focap_primary_button.dart';
import 'package:focapflutter/ui/auth/widgets/auth_layout.dart';
import 'package:focapflutter/ui/permissions/permissions_view_model.dart';
import 'package:go_router/go_router.dart';

class PermissionsScreen extends ConsumerWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(permissionsViewModelProvider);
    final viewModel = ref.read(permissionsViewModelProvider.notifier);
    final failure = state.failureMessage;

    return AuthPlainLayout(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: _StatusPill()),
              const SizedBox(width: 12),
              _SettingsLink(onTap: () => context.go(AppRoutes.settings)),
            ],
          ),
          const SizedBox(height: 18),
          Semantics(
            header: true,
            child: Text(
              'One permission to make Focap work',
              style: FocapText.title.copyWith(
                fontSize: 30,
                height: 1.15,
                color: colors.ink,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Android’s Accessibility service tells Focap when you open an app '
            'you chose to block.',
            style: FocapText.body.copyWith(color: colors.soft),
          ),
          const SizedBox(height: 18),
          const _DisclosureCard(),
          const SizedBox(height: 18),
          _RestrictedHelp(open: state.helpOpen, onToggle: viewModel.toggleHelp),
          if (failure != null) ...[
            const SizedBox(height: 16),
            FocapErrorRow(failure),
          ],
        ],
      ),
      button: FocapPrimaryButton(
        label: 'Open Accessibility settings',
        busyLabel: 'Opening Accessibility settings',
        showExternal: true,
        busy: state.opening,
        onPressed: viewModel.openSettings,
      ),
      footer: Padding(
        padding: const EdgeInsets.only(
          top: 12 - (18 - AuthLayout.footerSlack),
          bottom: AuthLayout.footerSlack,
        ),
        child: Text(
          'You can turn it off any time.',
          textAlign: TextAlign.center,
          style: FocapText.bodySmall.copyWith(color: colors.soft),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: colors.block,
          shape: const StadiumBorder(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.blockText,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 8),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Accessibility is off',
                  style: FocapText.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.blockText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsLink extends StatelessWidget {
  const _SettingsLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: colors.accentText,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        minimumSize: const Size(
          AuthLayout.minTapTarget,
          AuthLayout.minTapTarget,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text('Settings', style: FocapText.row.copyWith(fontSize: 14)),
    );
  }
}

enum _Glyph { check, eyeOff, phone, chevron }

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final brightness = Theme.of(context).brightness;
    final rows = [
      (
        _Glyph.check,
        colors.ok,
        colors.okText,
        'Sees only which app opens',
        'Nothing else on your screen',
      ),
      (
        _Glyph.eyeOff,
        colors.accentSoft,
        colors.accentText,
        'Never reads your content',
        'No messages, typing or photos',
      ),
      (
        _Glyph.phone,
        colors.warm,
        colors.warmText,
        'Stays on your phone',
        'Your app list is never uploaded',
      ),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: FocapShape.cardShadow(brightness),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            for (final (index, (glyph, tile, ink, title, subtitle))
                in rows.indexed)
              DecoratedBox(
                decoration: BoxDecoration(
                  border: index == rows.length - 1
                      ? null
                      : Border(bottom: BorderSide(color: colors.line)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: MergeSemantics(
                    child: Row(
                      children: [
                        _IconTile(glyph: glyph, fill: tile, ink: ink),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: FocapText.row.copyWith(
                                  color: colors.ink,
                                ),
                              ),
                              Text(
                                subtitle,
                                style: FocapText.bodySmall.copyWith(
                                  color: colors.soft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.glyph, required this.fill, required this.ink});

  final _Glyph glyph;
  final Color fill;
  final Color ink;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
      ),
      child: SizedBox.square(
        dimension: 42,
        child: Center(
          child: CustomPaint(
            size: const Size.square(20),
            painter: _GlyphPainter(glyph, ink),
          ),
        ),
      ),
    ),
  );
}

class _RestrictedHelp extends StatelessWidget {
  const _RestrictedHelp({required this.open, required this.onToggle});

  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.accentSoft,
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: open,
            child: InkWell(
              onTap: onToggle,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 52),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Is the switch greyed out?',
                          style: FocapText.row.copyWith(
                            fontSize: 14,
                            color: colors.accentText,
                          ),
                        ),
                      ),
                      ExcludeSemantics(
                        child: AnimatedRotation(
                          turns: open ? 0 : 0.5,
                          duration: const Duration(milliseconds: 180),
                          child: CustomPaint(
                            size: const Size.square(18),
                            painter: _GlyphPainter(
                              _Glyph.chevron,
                              colors.accentText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Text(
                      'On Android 13+, open App info → ⋮ → Allow restricted '
                      'settings for Focap, then turn it on.',
                      style: FocapText.bodySmall.copyWith(color: colors.ink),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  const _GlyphPainter(this.glyph, this.color);

  final _Glyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = glyph == _Glyph.chevron ? 18.0 : 20.0;
    final scale = size.width / unit;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = (glyph == _Glyph.chevron ? 1.65 : 5 / 3) * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas
      ..save()
      ..scale(scale)
      ..drawPath(_path(), paint..strokeWidth = paint.strokeWidth / scale)
      ..restore();
  }

  Path _path() => switch (glyph) {
    _Glyph.check =>
      Path()
        ..moveTo(4.17, 10)
        ..lineTo(8.33, 14.17)
        ..lineTo(16.67, 5.83),
    _Glyph.eyeOff =>
      Path()
        ..moveTo(2.5, 2.5)
        ..lineTo(17.5, 17.5)
        ..moveTo(8.83, 5.08)
        ..cubicTo(9.22, 5.03, 9.61, 5, 10, 5)
        ..cubicTo(14.17, 5, 17.5, 10, 17.5, 10)
        ..cubicTo(16.9, 10.98, 16.17, 11.87, 15.33, 12.67)
        ..moveTo(5.25, 6.33)
        ..cubicTo(3.5, 7.67, 2.5, 10, 2.5, 10)
        ..cubicTo(2.5, 10, 5.83, 15, 10, 15)
        ..cubicTo(11.16, 15, 12.31, 14.71, 13.33, 14.17),
    _Glyph.phone =>
      Path()
        ..moveTo(9.17, 15)
        ..lineTo(10.83, 15)
        ..addRRect(
          RRect.fromLTRBR(5, 1.67, 15, 18.33, const Radius.circular(1.67)),
        ),
    _Glyph.chevron =>
      Path()
        ..moveTo(4.5, 11.25)
        ..lineTo(9, 6.75)
        ..lineTo(13.5, 11.25),
  };

  @override
  bool shouldRepaint(_GlyphPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.color != color;
}
