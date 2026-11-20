import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_shape.dart';
import 'package:focapflutter/core/theme/app_typography.dart';

@immutable
class AuthHeroSpec {
  const AuthHeroSpec({
    required this.height,
    required this.top,
    required this.insetGap,
    required this.ringSize,
    required this.ringRight,
    required this.ringTop,
    this.minBelowTop,
  });

  final double height;
  final double top;
  final double insetGap;
  final double ringSize;
  final double ringRight;
  final double ringTop;
  final double? minBelowTop;

  double topFor(double statusBar) => math.max(top, statusBar + insetGap);

  double heightFor(double heroTop) {
    final below = minBelowTop;
    if (below == null) return height + heroTop - top;
    return math.max(height, heroTop + below);
  }
}

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.hero,
    required this.heroSpec,
    required this.card,
    required this.button,
    super.key,
    this.footer,
  });

  final Widget hero;
  final AuthHeroSpec heroSpec;
  final Widget card;
  final Widget button;
  final Widget? footer;

  static const formOverlap = 36.0;
  static const heroContentClearance = 16.0;
  static const sideMargin = 20.0;
  static const heroSideMargin = 24.0;
  static const maxContentWidth = 600.0;
  static const minTapTarget = 48.0;
  static const _bottomMargin = 36.0;
  static const _footerTextHeight = 21.0;
  static const footerSlack = (minTapTarget - _footerTextHeight) / 2;

  static double sideFor(double width, double margin) =>
      math.max(margin, (width - maxContentWidth) / 2 + margin);

  static double bottomGapFor(EdgeInsets insets, {required bool hasFooter}) =>
      math.max(_bottomMargin, insets.bottom + 16) -
      (hasFooter ? footerSlack : 0);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final insets = MediaQuery.paddingOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final heroTop = heroSpec.topFor(insets.top);
    final heroHeight = heroSpec.heightFor(heroTop);
    final hasFooter = footer != null;
    final bottomGap = bottomGapFor(insets, hasFooter: hasFooter);
    final side = sideFor(width - insets.left - insets.right, sideMargin);
    final heroSide = sideFor(
      width - insets.left - insets.right,
      heroSideMargin,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: colors.bg,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _AuthHero(
                        spec: heroSpec,
                        layoutHeight: heroHeight - formOverlap,
                        padding: EdgeInsets.fromLTRB(
                          insets.left + heroSide,
                          heroTop,
                          insets.right + heroSide,
                          heroContentClearance,
                        ),
                        child: hero,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: insets.left + side,
                          right: insets.right + side,
                        ),
                        child: card,
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          insets.left + side,
                          32,
                          insets.right + side,
                          bottomGap,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            button,
                            if (footer case final footer?) ...[
                              const SizedBox(height: 18 - footerSlack),
                              footer,
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: insets.top,
              child: ColoredBox(color: colors.hero),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthPlainLayout extends StatelessWidget {
  const AuthPlainLayout({
    required this.content,
    required this.button,
    super.key,
    this.footer,
  });

  final Widget content;
  final Widget button;
  final Widget? footer;

  static const topMargin = 20.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final insets = MediaQuery.paddingOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final side = AuthLayout.sideFor(
      width - insets.left - insets.right,
      AuthLayout.sideMargin,
    );
    final hasFooter = footer != null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
        statusBarBrightness: dark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: colors.bg,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      insets.left + side,
                      insets.top + topMargin,
                      insets.right + side,
                      AuthLayout.bottomGapFor(insets, hasFooter: hasFooter),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        content,
                        const Spacer(),
                        const SizedBox(height: 32),
                        button,
                        if (footer case final footer?) ...[
                          const SizedBox(height: 18 - AuthLayout.footerSlack),
                          footer,
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: insets.top,
              child: ColoredBox(color: colors.bg),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({
    required this.spec,
    required this.layoutHeight,
    required this.padding,
    required this.child,
  });

  final AuthHeroSpec spec;
  final double layoutHeight;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: -AuthLayout.formOverlap,
          child: ClipRect(
            child: ColoredBox(
              color: colors.hero,
              child: Stack(
                children: [
                  Positioned(
                    right: spec.ringRight,
                    top: spec.ringTop,
                    width: spec.ringSize,
                    height: spec.ringSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: FocapColors.onHero.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: layoutHeight,
          ),
          child: Padding(padding: padding, child: child),
        ),
      ],
    );
  }
}

class AuthHeroText extends StatelessWidget {
  const AuthHeroText({
    required this.title,
    required this.subtitle,
    required this.titleStyle,
    required this.subtitleStyle,
    super.key,
  });

  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        header: true,
        child: Text(
          title,
          style: titleStyle.copyWith(color: FocapColors.onHero),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        subtitle,
        style: subtitleStyle.copyWith(color: FocapColors.onHeroSoft),
      ),
    ],
  );
}

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({required this.padding, required this.child, super.key});

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: FocapShape.cardLarge,
        boxShadow: FocapShape.raised(Theme.of(context).brightness),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    required this.prompt,
    required this.action,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final String prompt;
  final String action;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: [
        Text(
          prompt,
          style: FocapText.body.copyWith(fontSize: 14, color: colors.soft),
        ),
        Semantics(
          button: true,
          enabled: enabled,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: FocapShape.chip,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AuthLayout.minTapTarget,
                minWidth: AuthLayout.minTapTarget,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    action,
                    style: FocapText.row.copyWith(
                      fontSize: 14,
                      color: colors.accentText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum AuthBackTone { hero, surface }

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({
    required this.onPressed,
    super.key,
    this.tone = AuthBackTone.hero,
  });

  final VoidCallback? onPressed;
  final AuthBackTone tone;

  static const double size = 44;
  static const _radius = BorderRadius.all(Radius.circular(14));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onSurface = tone == AuthBackTone.surface;
    final lightSurface =
        onSurface && Theme.of(context).brightness == Brightness.light;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: 'Back',
      onTap: onPressed,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox.square(
          dimension: AuthLayout.minTapTarget,
          child: Align(
            alignment: Alignment.topLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: _radius,
                boxShadow: lightSurface ? FocapShape.shadowSoft : null,
              ),
              child: Material(
                color: onSurface
                    ? colors.surface
                    : FocapColors.onHero.withValues(alpha: 0.1),
                borderRadius: _radius,
                child: InkWell(
                  onTap: onPressed,
                  borderRadius: _radius,
                  child: SizedBox.square(
                    dimension: size,
                    child: Center(
                      child: CustomPaint(
                        size: const Size.square(20),
                        painter: _ChevronPainter(
                          onSurface ? colors.ink : FocapColors.onHero,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 20;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6667 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(12.5 * scale, 5 * scale)
      ..lineTo(7.5 * scale, 10 * scale)
      ..lineTo(12.5 * scale, 15 * scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ChevronPainter oldDelegate) => oldDelegate.color != color;
}
