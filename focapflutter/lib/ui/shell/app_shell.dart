import 'package:flutter/material.dart';
import 'package:focapflutter/ui/shell/focap_nav_bar.dart';
import 'package:focapflutter/ui/shell/shell_tab.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  bool get _isOnHome => shell.currentIndex == ShellTab.home.index;

  void _onPopInvoked(bool didPop, Object? result) {
    if (!didPop) shell.goBranch(ShellTab.home.index);
  }

  void _select(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isOnHome,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: shell,
        bottomNavigationBar: FocapNavBar(
          selectedIndex: shell.currentIndex,
          onSelected: _select,
        ),
      ),
    );
  }
}
