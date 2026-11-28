import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/core/router/pop_or_go.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_shape.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/core/widgets/focap_error_row.dart';
import 'package:focapflutter/core/widgets/focap_primary_button.dart';
import 'package:focapflutter/data/models/app_info.dart';
import 'package:focapflutter/ui/app_selection/app_selection_view_model.dart';
import 'package:focapflutter/ui/auth/widgets/auth_layout.dart';

class AppSelectionScreen extends ConsumerWidget {
  const AppSelectionScreen({super.key});

  static const _gap = 16.0;

  String _appCount(int count) => count == 1 ? '1 app' : '$count apps';

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final saved = await ref.read(appSelectionViewModelProvider.notifier).save();
    if (saved && context.mounted) popOrGo(context, AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(appSelectionViewModelProvider);
    final viewModel = ref.read(appSelectionViewModelProvider.notifier);
    final insets = MediaQuery.paddingOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final side = AuthLayout.sideFor(
      width - insets.left - insets.right,
      AuthLayout.sideMargin,
    );
    final horizontal = EdgeInsets.only(
      left: insets.left + side,
      right: insets.right + side,
    );
    final visible = state.visibleApps;
    final busy = state.saving;

    return PopScope(
      canPop: !busy,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: dark ? Brightness.dark : Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: colors.bg,
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: horizontal.copyWith(
                        top: insets.top + AuthPlainLayout.topMargin,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AuthBackButton(
                                  tone: AuthBackTone.surface,
                                  onPressed: busy
                                      ? null
                                      : () => popOrGo(
                                          context,
                                          AppRoutes.dashboard,
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: _CountPill(
                                    label: '${state.blockedCount} selected',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height:
                                  _gap -
                                  (AuthLayout.minTapTarget -
                                          AuthBackButton.size) /
                                      2,
                            ),
                            Semantics(
                              header: true,
                              child: Text(
                                'Pick your distractions',
                                style: FocapText.titleSmall.copyWith(
                                  color: colors.ink,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Only these get blocked. Everything else stays '
                              'open.',
                              style: FocapText.body.copyWith(
                                fontSize: 14,
                                color: colors.soft,
                              ),
                            ),
                            const SizedBox(height: _gap),
                            _SearchField(
                              enabled: !busy,
                              onChanged: viewModel.queryChanged,
                            ),
                            const SizedBox(height: _gap),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: horizontal,
                      sliver: DecoratedSliver(
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(24),
                          ),
                          boxShadow: FocapShape.softShadow(
                            Theme.of(context).brightness,
                          ),
                        ),
                        sliver: SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          sliver: _listSliver(
                            context,
                            state,
                            visible,
                            viewModel,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: horizontal.copyWith(top: _gap, bottom: _gap),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Settings, your home screen and the dialer can’t be '
                          'blocked.',
                          style: FocapText.label.copyWith(
                            fontWeight: FontWeight.w400,
                            color: colors.soft,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: horizontal.copyWith(
                  bottom: AuthLayout.bottomGapFor(insets, hasFooter: false) - 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.saveFailed) ...[
                      const FocapErrorRow(
                        'Couldn’t save your picks. Try again.',
                      ),
                      const SizedBox(height: 12),
                    ],
                    FocapPrimaryButton(
                      label: 'Save · ${_appCount(state.blockedCount)}',
                      busyLabel: 'Saving your picks',
                      busy: busy,
                      onPressed: state.canSave
                          ? () => _save(context, ref)
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listSliver(
    BuildContext context,
    AppSelectionState state,
    List<AppInfo> visible,
    AppSelectionViewModel viewModel,
  ) {
    final colors = context.colors;
    if (state.apps.isEmpty && state.loading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Semantics(
              label: 'Loading your apps',
              child: SizedBox.square(
                dimension: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.accent,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (state.loadFailed) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FocapErrorRow('Couldn’t load your apps.'),
              TextButton(
                onPressed: viewModel.load,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    if (visible.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            state.apps.isEmpty
                ? 'No apps to show.'
                : 'No apps match “${state.query.trim()}”.',
            style: FocapText.body.copyWith(color: colors.soft),
          ),
        ),
      );
    }
    return SliverList.builder(
      itemCount: visible.length,
      itemBuilder: (context, index) {
        final app = visible[index];
        return _AppRow(
          app: app,
          blocked: state.isBlocked(app.packageName),
          last: index == visible.length - 1,
          enabled: !state.saving,
          onToggle: () => viewModel.toggle(app.packageName),
        );
      },
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: colors.accentSoft,
          shape: const StadiumBorder(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: FocapText.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.accentText,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: FocapShape.softShadow(Theme.of(context).brightness),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            const SizedBox(width: 16),
            ExcludeSemantics(
              child: CustomPaint(
                size: const Size.square(18),
                painter: _SearchPainter(colors.soft),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Semantics(
                label: 'Search apps',
                child: TextField(
                  enabled: enabled,
                  onChanged: onChanged,
                  textInputAction: TextInputAction.search,
                  style: FocapText.body.copyWith(color: colors.ink),
                  cursorColor: colors.accent,
                  decoration: InputDecoration(
                    hintText: 'Search apps',
                    hintStyle: FocapText.body.copyWith(color: colors.soft),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({
    required this.app,
    required this.blocked,
    required this.last,
    required this.enabled,
    required this.onToggle,
  });

  final AppInfo app;
  final bool blocked;
  final bool last;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: colors.hairline)),
      ),
      child: MergeSemantics(
        child: Semantics(
          toggled: blocked,
          enabled: enabled,
          onTap: enabled ? onToggle : null,
          child: InkWell(
            onTap: enabled ? onToggle : null,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 62),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    _AppTile(app: app),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FocapText.row.copyWith(color: colors.ink),
                          ),
                          Text(
                            blocked ? 'Blocked during focus' : 'Stays open',
                            style: FocapText.label.copyWith(
                              fontWeight: FontWeight.w400,
                              color: blocked ? colors.blockText : colors.soft,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ExcludeSemantics(
                      child: _FocapSwitch(on: blocked, enabled: enabled),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  const _AppTile({required this.app});

  final AppInfo app;

  static const _size = 40.0;
  static const _radius = BorderRadius.all(Radius.circular(13));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cacheWidth = (_size * MediaQuery.devicePixelRatioOf(context)).round();
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: _radius,
        child: SizedBox.square(
          dimension: _size,
          child: app.icon.isEmpty
              ? ColoredBox(
                  color: colors.accentSoft,
                  child: Center(
                    child: Text(
                      _monogram(app.label),
                      style: FocapText.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.accentText,
                      ),
                    ),
                  ),
                )
              : Image.memory(
                  app.icon,
                  cacheWidth: cacheWidth,
                  gaplessPlayback: true,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  String _monogram(String label) {
    final letters = label.trim().characters.where((c) => c.trim().isNotEmpty);
    if (letters.isEmpty) return '?';
    final first = letters.first.toUpperCase();
    final second = letters.length > 1 ? letters.elementAt(1) : '';
    return '$first$second';
  }
}

class _FocapSwitch extends StatelessWidget {
  const _FocapSwitch({required this.on, required this.enabled});

  final bool on;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 46,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: on ? colors.accent : colors.off,
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(dimension: 22),
          ),
        ),
      ),
    );
  }
}

class _SearchPainter extends CustomPainter {
  const _SearchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 18;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawCircle(Offset(8.25 * scale, 8.25 * scale), 5.25 * scale, paint)
      ..drawLine(
        Offset(12 * scale, 12 * scale),
        Offset(15 * scale, 15 * scale),
        paint,
      );
  }

  @override
  bool shouldRepaint(_SearchPainter oldDelegate) => oldDelegate.color != color;
}
