import 'package:focapflutter/core/router/app_routes.dart';
import 'package:focapflutter/ui/shell/focap_nav_icon.dart';

enum ShellTab {
  focus(AppRoutes.dashboard, 'Focus', FocapNavGlyph.focus),
  history(AppRoutes.history, 'History', FocapNavGlyph.history),
  settings(AppRoutes.settings, 'Settings', FocapNavGlyph.settings);

  const ShellTab(this.path, this.label, this.glyph);

  final String path;
  final String label;
  final FocapNavGlyph glyph;

  static const home = ShellTab.focus;
}
