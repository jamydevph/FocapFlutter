import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_shape.dart';
import 'package:focapflutter/core/theme/app_typography.dart';
import 'package:focapflutter/ui/shell/focap_nav_icon.dart';
import 'package:focapflutter/ui/shell/shell_tab.dart';

class FocapNavBar extends StatelessWidget {
  const FocapNavBar({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const height = 64.0;
  static const sideMargin = 20.0;
  static const bottomMargin = 22.0;
  static const systemBarGap = 8.0;
  static const innerPadding = 6.0;
  static const tabGap = 6.0;
  static const maxTextScale = 1.3;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final systemInset = MediaQuery.viewPaddingOf(context).bottom;
    final bottom = math.max(bottomMargin, systemInset + systemBarGap);
    return Padding(
      padding: EdgeInsets.fromLTRB(sideMargin, 0, sideMargin, bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.nav,
          borderRadius: FocapShape.nav,
          boxShadow: FocapShape.shadowNav,
        ),
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(innerPadding),
            child: MediaQuery.withClampedTextScaling(
              maxScaleFactor: maxTextScale,
              child: Row(
                children: [
                  for (final tab in ShellTab.values) ...[
                    if (tab.index > 0) const SizedBox(width: tabGap),
                    Expanded(
                      child: _NavTab(
                        tab: tab,
                        selected: tab.index == selectedIndex,
                        onTap: () => onSelected(tab.index),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final ShellTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = selected ? colors.onAccent : colors.navFg;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? colors.accent : colors.accent.withValues(alpha: 0),
        borderRadius: FocapShape.navTab,
        clipBehavior: Clip.antiAlias,
        animationDuration: const Duration(milliseconds: 180),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FocapNavIcon(tab.glyph, color: foreground),
              const SizedBox(width: FocapNavBar.tabGap),
              Flexible(
                child: Text(
                  tab.label,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: FocapText.navLabel.copyWith(
                    color: foreground,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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
