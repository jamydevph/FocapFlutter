import 'package:flutter/material.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/core/widgets/focap_error_row.dart';

class FocapTextField extends StatefulWidget {
  const FocapTextField({
    required this.label,
    required this.controller,
    super.key,
    this.hint,
    this.error,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.errorSpacing = 16,
    this.fillColor,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? error;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final double errorSpacing;
  final Color? fillColor;

  @override
  State<FocapTextField> createState() => _FocapTextFieldState();
}

class _FocapTextFieldState extends State<FocapTextField> {
  static const _radius = BorderRadius.all(Radius.circular(14));
  static const _height = 52.0;
  static const _borderWidth = 1.5;

  FocusNode? _ownFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(FocapTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final focused = _focusNode.hasFocus;
    final error = widget.error;
    final hasError = error != null;
    final borderColor = hasError
        ? colors.danger
        : focused
        ? colors.accent
        : colors.line;

    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: FocapText.bodySmall.copyWith(
              color: colors.ink,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            constraints: const BoxConstraints(minHeight: _height),
            decoration: BoxDecoration(
              borderRadius: _radius,
              boxShadow: focused && !hasError
                  ? [BoxShadow(color: colors.accentSoft, spreadRadius: 4)]
                  : const [],
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              obscureText: widget.obscureText,
              textCapitalization: widget.textCapitalization,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              autofillHints: widget.autofillHints,
              autocorrect: !widget.obscureText,
              enableSuggestions: !widget.obscureText,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: FocapText.body.copyWith(color: colors.ink, fontSize: 16),
              cursorColor: colors.accent,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: FocapText.body.copyWith(
                  color: colors.soft,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: widget.fillColor ?? colors.field,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: _outline(borderColor),
                enabledBorder: _outline(borderColor),
                focusedBorder: _outline(borderColor),
                disabledBorder: _outline(colors.line),
              ),
            ),
          ),
          if (hasError) ...[
            SizedBox(height: widget.errorSpacing),
            FocapErrorRow(error, announce: false),
          ],
        ],
      ),
    );
  }

  OutlineInputBorder _outline(Color color) => OutlineInputBorder(
    borderRadius: _radius,
    borderSide: BorderSide(color: color, width: _borderWidth),
  );
}
