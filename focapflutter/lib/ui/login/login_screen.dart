import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/core/widgets/focap_error_row.dart';
import 'package:focapflutter/core/widgets/focap_logo.dart';
import 'package:focapflutter/core/widgets/focap_primary_button.dart';
import 'package:focapflutter/core/widgets/focap_text_field.dart';
import 'package:focapflutter/ui/auth/widgets/auth_layout.dart';
import 'package:focapflutter/ui/login/login_view_model.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _heroSpec = AuthHeroSpec(
    height: 300,
    top: 72,
    insetGap: 24,
    ringSize: 300,
    ringRight: -110,
    ringTop: -60,
    minBelowTop: 160,
  );

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
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return AuthLayout(
      heroSpec: _heroSpec,
      hero: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FocapLogo(),
          SizedBox(height: 20),
          AuthHeroText(
            title: 'Welcome back',
            subtitle: 'Log in to pick up your focus.',
            titleStyle: FocapText.title,
            subtitleStyle: FocapText.body,
          ),
        ],
      ),
      card: AutofillGroup(
        onDisposeAction: AutofillContextAction.cancel,
        child: _LoginForm(
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
      button: FocapPrimaryButton(
        label: 'Log in',
        busyLabel: 'Logging in',
        showArrow: true,
        busy: state.submitting,
        onPressed: _submit,
      ),
      footer: AuthFooterLink(
        prompt: 'New to Focap?',
        action: 'Create an account',
        enabled: !state.submitting,
        onTap: () => context.push(AppRoutes.register),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
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
  static const _overhang = (AuthLayout.minTapTarget - _rowHeight) / 2;

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
    return AuthFormCard(
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
            height: AuthLayout.minTapTarget,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: state.submitting
                    ? null
                    : () => context.push(AppRoutes.forgotPassword),
                style: TextButton.styleFrom(
                  foregroundColor: colors.accentText,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: const Size(48, AuthLayout.minTapTarget),
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
    );
  }
}
