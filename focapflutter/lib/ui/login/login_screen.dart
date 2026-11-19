import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_shape.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/core/widgets/focap_error_row.dart';
import 'package:focapflutter/core/widgets/focap_logo.dart';
import 'package:focapflutter/core/widgets/focap_primary_button.dart';
import 'package:focapflutter/core/widgets/focap_text_field.dart';
import 'package:focapflutter/ui/login/login_view_model.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _heroHeight = 300.0;
  static const _heroTopPadding = 72.0;
  static const _heroMinContent = 160.0;
  static const _formOverlap = 36.0;
  static const _sideMargin = 20.0;
  static const _maxContentWidth = 600.0;
  static const _minTapTarget = 48.0;
  static const _footerTextHeight = 21.0;
  static const _footerSlack = (_minTapTarget - _footerTextHeight) / 2;

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final signedIn = await viewModel.submit();
    if (!mounted) return;
    if (signedIn) {
      TextInput.finishAutofillContext();
      context.go(AppRoutes.dashboard);
      return;
    }
    final state = ref.read(loginViewModelProvider);
    if (state.emailError != null) {
      _emailFocus.requestFocus();
    } else if (state.passwordError != null) {
      _passwordFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final insets = MediaQuery.paddingOf(context);
    final heroTop = math.max(_heroTopPadding, insets.top + 24);
    final heroHeight = math.max(_heroHeight, heroTop + _heroMinContent);
    final bottomGap = math.max(36, insets.bottom + 16) - _footerSlack;
    final side = EdgeInsets.only(left: insets.left, right: insets.right);
    const contentWidth = _maxContentWidth - 2 * _sideMargin;

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
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _Hero(
                            height: heroHeight,
                            top: heroTop,
                            padding: side,
                            maxContentWidth: _maxContentWidth,
                          ),
                          Padding(
                            padding: side.add(
                              EdgeInsets.fromLTRB(
                                _sideMargin,
                                heroHeight - _formOverlap,
                                _sideMargin,
                                0,
                              ),
                            ),
                            child: _Centered(
                              maxWidth: contentWidth,
                              child: AutofillGroup(
                                onDisposeAction: AutofillContextAction.cancel,
                                child: _FormCard(
                                  state: state,
                                  email: _email,
                                  password: _password,
                                  emailFocus: _emailFocus,
                                  passwordFocus: _passwordFocus,
                                  onEmailChanged: viewModel.emailChanged,
                                  onPasswordChanged: viewModel.passwordChanged,
                                  onSubmit: _submit,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: side.add(
                          EdgeInsets.fromLTRB(
                            _sideMargin,
                            32,
                            _sideMargin,
                            bottomGap,
                          ),
                        ),
                        child: _Centered(
                          maxWidth: contentWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FocapPrimaryButton(
                                label: 'Log in',
                                busyLabel: 'Logging in',
                                showArrow: true,
                                busy: state.submitting,
                                onPressed: _submit,
                              ),
                              const SizedBox(height: 18 - _footerSlack),
                              _CreateAccountLink(
                                enabled: !state.submitting,
                                height: _minTapTarget,
                                onTap: () => context.push(AppRoutes.register),
                              ),
                            ],
                          ),
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

class _Centered extends StatelessWidget {
  const _Centered({required this.maxWidth, required this.child});

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SizedBox(width: double.infinity, child: child),
    ),
  );
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.height,
    required this.top,
    required this.padding,
    required this.maxContentWidth,
  });

  final double height;
  final double top;
  final EdgeInsets padding;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ClipRect(
        child: ColoredBox(
          color: colors.hero,
          child: Stack(
            children: [
              Positioned(
                right: -110,
                top: -60,
                width: 300,
                height: 300,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FocapColors.onHero.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: padding.add(EdgeInsets.fromLTRB(24, top, 24, 0)),
                child: _Centered(
                  maxWidth: maxContentWidth - 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FocapLogo(),
                      const SizedBox(height: 20),
                      Semantics(
                        header: true,
                        child: Text(
                          'Welcome back',
                          style: FocapText.title.copyWith(
                            color: FocapColors.onHero,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Log in to pick up your focus.',
                        style: FocapText.body.copyWith(
                          color: FocapColors.onHeroSoft,
                        ),
                      ),
                    ],
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

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.state,
    required this.email,
    required this.password,
    required this.emailFocus,
    required this.passwordFocus,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
  });

  static const _rowHeight = 44.0;
  static const _tapHeight = 48.0;
  static const _overhang = (_tapHeight - _rowHeight) / 2;

  final LoginState state;
  final TextEditingController email;
  final TextEditingController password;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final failure = state.failureMessage;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: FocapShape.cardLarge,
        boxShadow: FocapShape.raised(Theme.of(context).brightness),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24 - _overhang),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FocapTextField(
              label: 'Email',
              hint: 'you@example.com',
              controller: email,
              focusNode: emailFocus,
              error: state.emailError,
              enabled: !state.submitting,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: onEmailChanged,
              onSubmitted: (_) => passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            FocapTextField(
              label: 'Password',
              controller: password,
              focusNode: passwordFocus,
              error: state.passwordError,
              enabled: !state.submitting,
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onChanged: onPasswordChanged,
              onSubmitted: (_) => onSubmit(),
            ),
            if (failure != null) ...[
              const SizedBox(height: 16),
              FocapErrorRow(failure),
            ],
            const SizedBox(height: 16 - _overhang),
            SizedBox(
              height: _tapHeight,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: state.submitting
                      ? null
                      : () => context.push(AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.accentText,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: const Size(48, _tapHeight),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: FocapText.row.copyWith(fontSize: 14),
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

class _CreateAccountLink extends StatelessWidget {
  const _CreateAccountLink({
    required this.enabled,
    required this.height,
    required this.onTap,
  });

  final bool enabled;
  final double height;
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
          'New to Focap?',
          style: FocapText.body.copyWith(fontSize: 14, color: colors.soft),
        ),
        Semantics(
          button: true,
          enabled: enabled,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: FocapShape.chip,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height, minWidth: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    'Create an account',
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
