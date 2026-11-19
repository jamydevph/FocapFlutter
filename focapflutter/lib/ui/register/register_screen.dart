import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/router/pop_or_go.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/core/widgets/focap_error_row.dart';
import 'package:focapflutter/core/widgets/focap_primary_button.dart';
import 'package:focapflutter/core/widgets/focap_text_field.dart';
import 'package:focapflutter/ui/auth/widgets/auth_layout.dart';
import 'package:focapflutter/ui/register/register_view_model.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  static const _heroSpec = AuthHeroSpec(
    height: 250,
    top: 20,
    insetGap: 20,
    ringSize: 260,
    ringRight: -90,
    ringTop: -40,
  );

  final _controllers = {
    for (final field in RegisterField.values) field: TextEditingController(),
  };
  final _focus = {for (final field in RegisterField.values) field: FocusNode()};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final node in _focus.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _back() => popOrGo(context, AppRoutes.login);

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final viewModel = ref.read(registerViewModelProvider.notifier);
    final registered = await viewModel.submit();
    if (!mounted) return;
    if (registered) {
      TextInput.finishAutofillContext();
      context.go(AppRoutes.dashboard);
      return;
    }
    final invalid = ref.read(registerViewModelProvider).firstInvalidField;
    if (invalid != null) _focus[invalid]!.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerViewModelProvider);
    final viewModel = ref.read(registerViewModelProvider.notifier);

    return PopScope(
      canPop: !state.submitting,
      child: AuthLayout(
        heroSpec: _heroSpec,
        hero: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthBackButton(onPressed: state.submitting ? null : _back),
            const SizedBox(
              height: 32 - (AuthLayout.minTapTarget - AuthBackButton.size),
            ),
            AuthHeroText(
              title: 'Create your account',
              subtitle: 'Your history follows you to a new phone.',
              titleStyle: FocapText.title.copyWith(fontSize: 30),
              subtitleStyle: FocapText.body.copyWith(fontSize: 14),
            ),
          ],
        ),
        card: AutofillGroup(
          onDisposeAction: AutofillContextAction.cancel,
          child: _RegisterForm(
            state: state,
            controllers: _controllers,
            focus: _focus,
            viewModel: viewModel,
            onSubmit: _submit,
          ),
        ),
        button: FocapPrimaryButton(
          label: 'Create account',
          busyLabel: 'Creating your account',
          busy: state.submitting,
          onPressed: _submit,
        ),
        footer: AuthFooterLink(
          prompt: 'Already have one?',
          action: 'Log in',
          enabled: !state.submitting,
          onTap: _back,
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.state,
    required this.controllers,
    required this.focus,
    required this.viewModel,
    required this.onSubmit,
  });

  static const _gap = 14.0;
  static const _minNameFieldWidth = 120.0;
  static const _cardPadding = 20.0;

  bool _namesSideBySide(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final insets = MediaQuery.paddingOf(context);
    final side = AuthLayout.sideFor(
      width - insets.left - insets.right,
      AuthLayout.sideMargin,
    );
    final cardInner =
        width - insets.left - insets.right - 2 * side - 2 * _cardPadding;
    final fieldWidth = (cardInner - _gap) / 2;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return fieldWidth / scale >= _minNameFieldWidth;
  }

  final RegisterState state;
  final Map<RegisterField, TextEditingController> controllers;
  final Map<RegisterField, FocusNode> focus;
  final RegisterViewModel viewModel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final failure = state.failureMessage;
    final enabled = !state.submitting;

    final sideBySide = _namesSideBySide(context);

    void next(RegisterField field) => focus[field]!.requestFocus();

    return AuthFormCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flex(
            direction: sideBySide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: sideBySide
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.stretch,
            children: [
              _NameSlot(
                expand: sideBySide,
                child: FocapTextField(
                  label: 'First name',
                  hint: 'Naruto',
                  controller: controllers[RegisterField.firstName]!,
                  focusNode: focus[RegisterField.firstName],
                  error: state.firstNameError,
                  errorSpacing: _gap,
                  enabled: enabled,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.givenName],
                  onChanged: viewModel.firstNameChanged,
                  onSubmitted: (_) => next(RegisterField.lastName),
                ),
              ),
              const SizedBox.square(dimension: _gap),
              _NameSlot(
                expand: sideBySide,
                child: FocapTextField(
                  label: 'Last name',
                  hint: 'Uzumaki',
                  controller: controllers[RegisterField.lastName]!,
                  focusNode: focus[RegisterField.lastName],
                  error: state.lastNameError,
                  errorSpacing: _gap,
                  enabled: enabled,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.familyName],
                  onChanged: viewModel.lastNameChanged,
                  onSubmitted: (_) => next(RegisterField.email),
                ),
              ),
            ],
          ),
          const SizedBox(height: _gap),
          FocapTextField(
            label: 'Email',
            hint: 'you@example.com',
            controller: controllers[RegisterField.email]!,
            focusNode: focus[RegisterField.email],
            error: state.emailError,
            errorSpacing: _gap,
            enabled: enabled,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            onChanged: viewModel.emailChanged,
            onSubmitted: (_) => next(RegisterField.password),
          ),
          const SizedBox(height: _gap),
          FocapTextField(
            label: 'Password',
            controller: controllers[RegisterField.password]!,
            focusNode: focus[RegisterField.password],
            error: state.passwordError,
            errorSpacing: _gap,
            enabled: enabled,
            obscureText: true,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            onChanged: viewModel.passwordChanged,
            onSubmitted: (_) => next(RegisterField.confirm),
          ),
          const SizedBox(height: _gap),
          FocapTextField(
            label: 'Confirm password',
            controller: controllers[RegisterField.confirm]!,
            focusNode: focus[RegisterField.confirm],
            error: state.confirmError,
            errorSpacing: _gap,
            enabled: enabled,
            obscureText: true,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            onChanged: viewModel.confirmChanged,
            onSubmitted: (_) => onSubmit(),
          ),
          if (failure != null) ...[
            const SizedBox(height: _gap),
            FocapErrorRow(failure),
          ],
        ],
      ),
    );
  }
}

class _NameSlot extends StatelessWidget {
  const _NameSlot({required this.expand, required this.child});

  final bool expand;
  final Widget child;

  @override
  Widget build(BuildContext context) => expand ? Expanded(child: child) : child;
}
