import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/router/pop_or_go.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/core/widgets/focap_error_row.dart';
import 'package:focapflutter/core/widgets/focap_primary_button.dart';
import 'package:focapflutter/core/widgets/focap_text_field.dart';
import 'package:focapflutter/ui/auth/widgets/auth_layout.dart';
import 'package:focapflutter/ui/forgot_password/forgot_password_view_model.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late final _seed = ForgotPasswordSeed(widget.initialEmail);
  late final _email = TextEditingController(text: widget.initialEmail);
  final _emailFocus = FocusNode();

  NotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>
  get _provider => forgotPasswordViewModelProvider(_seed);

  @override
  void dispose() {
    _email.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _back() => popOrGo(context, AppRoutes.login);

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    await ref.read(_provider.notifier).submit();
    if (!mounted) return;
    if (ref.read(_provider).emailError != null) _emailFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final viewModel = ref.read(_provider.notifier);
    final colors = context.colors;
    final failure = state.failureMessage;
    final enabled = !state.submitting;

    return PopScope(
      canPop: enabled,
      child: AuthPlainLayout(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AuthBackButton(
                tone: AuthBackTone.surface,
                onPressed: enabled ? _back : null,
              ),
            ),
            const SizedBox(
              height: 56 - (AuthLayout.minTapTarget - AuthBackButton.size),
            ),
            const Align(alignment: Alignment.centerLeft, child: _MailTile()),
            const SizedBox(height: 24),
            Semantics(
              header: true,
              child: Text(
                state.sent ? 'Check your email' : 'Reset your password',
                style: FocapText.title.copyWith(
                  fontSize: 30,
                  color: colors.ink,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.sent
                  ? 'We sent a reset link to your email. Tap it to set a new password.'
                  : 'Enter your email and we’ll send you a link to set a new password.',
              style: FocapText.body.copyWith(color: colors.soft),
            ),
            const SizedBox(height: 28),
            FocapTextField(
              label: 'Email',
              hint: 'you@example.com',
              controller: _email,
              focusNode: _emailFocus,
              error: state.emailError,
              enabled: enabled,
              fillColor: colors.surface,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.send,
              autofillHints: const [AutofillHints.email],
              onChanged: viewModel.emailChanged,
              onSubmitted: (_) => _submit(),
            ),
            if (failure != null) ...[
              const SizedBox(height: 16),
              FocapErrorRow(failure),
            ] else if (state.sent && !state.submitting) ...[
              const SizedBox(height: 18),
              _SentBanner(key: ValueKey(state.sendCount)),
            ],
          ],
        ),
        button: FocapPrimaryButton(
          label: state.sent ? 'Resend link' : 'Send reset link',
          busyLabel: 'Sending the reset link',
          busy: state.submitting,
          onPressed: _submit,
        ),
        footer: AuthFooterLink(
          prompt: 'Remembered it?',
          action: 'Log in',
          enabled: enabled,
          onTap: _back,
        ),
      ),
    );
  }
}

class _MailTile extends StatelessWidget {
  const _MailTile();

  static const _radius = BorderRadius.all(Radius.circular(24));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.accentSoft,
          borderRadius: _radius,
        ),
        child: SizedBox.square(
          dimension: 72,
          child: Center(
            child: CustomPaint(
              size: const Size.square(34),
              painter: _MailPainter(colors.accentText),
            ),
          ),
        ),
      ),
    );
  }
}

class _SentBanner extends StatelessWidget {
  const _SentBanner({super.key});

  static const _radius = BorderRadius.all(Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      liveRegion: true,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.ok, borderRadius: _radius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CustomPaint(
                size: const Size.square(20),
                painter: _CheckPainter(colors.okText),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Link sent. Check your inbox.',
                  style: FocapText.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.okText,
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

class _MailPainter extends CustomPainter {
  const _MailPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 34;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.55 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            4.25 * scale,
            7.083 * scale,
            25.5 * scale,
            19.833 * scale,
          ),
          Radius.circular(4.25 * scale),
        ),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(5.667 * scale, 9.917 * scale)
          ..lineTo(17 * scale, 18.417 * scale)
          ..lineTo(28.333 * scale, 9.917 * scale),
        paint,
      );
  }

  @override
  bool shouldRepaint(_MailPainter oldDelegate) => oldDelegate.color != color;
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 20;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(4.167 * scale, 10 * scale)
        ..lineTo(8.333 * scale, 14.167 * scale)
        ..lineTo(16.667 * scale, 5.833 * scale),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) => oldDelegate.color != color;
}
