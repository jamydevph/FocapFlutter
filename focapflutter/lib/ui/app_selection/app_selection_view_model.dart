import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/models/app_info.dart';
import 'package:focapflutter/data/repositories/local_data_providers.dart';

@immutable
class AppSelectionState {
  const AppSelectionState({
    this.apps = const [],
    this.stored = const {},
    this.flips = const {},
    this.query = '',
    this.loading = true,
    this.saving = false,
    this.loadFailed = false,
    this.saveFailed = false,
  });

  final List<AppInfo> apps;
  final Set<String> stored;
  final Set<String> flips;
  final String query;
  final bool loading;
  final bool saving;
  final bool loadFailed;
  final bool saveFailed;

  Set<String> get blocked => {
    for (final app in apps)
      if (isBlocked(app.packageName)) app.packageName,
  };

  int get blockedCount => blocked.length;

  bool get canSave => !loading && !saving && !loadFailed;

  List<AppInfo> get visibleApps {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return apps;
    return [
      for (final app in apps)
        if (app.label.toLowerCase().contains(needle)) app,
    ];
  }

  bool isBlocked(String packageName) =>
      stored.contains(packageName) != flips.contains(packageName);

  AppSelectionState copyWith({
    List<AppInfo>? apps,
    Set<String>? stored,
    Set<String>? flips,
    String? query,
    bool? loading,
    bool? saving,
    bool? loadFailed,
    bool? saveFailed,
  }) => AppSelectionState(
    apps: apps ?? this.apps,
    stored: stored ?? this.stored,
    flips: flips ?? this.flips,
    query: query ?? this.query,
    loading: loading ?? this.loading,
    saving: saving ?? this.saving,
    loadFailed: loadFailed ?? this.loadFailed,
    saveFailed: saveFailed ?? this.saveFailed,
  );
}

class AppSelectionViewModel extends Notifier<AppSelectionState> {
  @override
  AppSelectionState build() {
    final cached = ref.read(installedAppsRepositoryProvider).cached;
    Future.microtask(load);
    return AppSelectionState(apps: cached ?? const []);
  }

  Future<void> load() async {
    if (!ref.mounted) return;
    state = state.copyWith(loading: true, loadFailed: false);
    final selections = ref.read(appSelectionRepositoryProvider);
    try {
      final previous = await selections.blockedPackages();
      if (!ref.mounted) return;
      state = state.copyWith(
        stored: previous,
        apps: _ordered(const [], state.apps, previous),
      );
      final fresh = await ref.read(installedAppsRepositoryProvider).load();
      if (!ref.mounted) return;
      final installed = {for (final app in fresh) app.packageName};
      if (installed.isNotEmpty) await selections.keepOnly(installed);
      final stored = await selections.blockedPackages();
      if (!ref.mounted) return;
      state = state.copyWith(
        apps: _ordered(state.apps, fresh, stored),
        stored: stored,
        flips: state.flips.where(installed.contains).toSet(),
        loading: false,
      );
    } on Object catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'app selection',
          context: ErrorDescription('while loading the installed apps'),
        ),
      );
      if (!ref.mounted) return;
      state = state.copyWith(loading: false, loadFailed: true);
    }
  }

  List<AppInfo> _ordered(
    List<AppInfo> current,
    List<AppInfo> fresh,
    Set<String> stored,
  ) {
    final byPackage = {for (final app in fresh) app.packageName: app};
    final kept = [for (final app in current) ?byPackage[app.packageName]];
    final known = {for (final app in kept) app.packageName};
    final added = [
      for (final app in fresh)
        if (!known.contains(app.packageName)) app,
    ];
    return [
      ...kept,
      for (final app in added)
        if (stored.contains(app.packageName)) app,
      for (final app in added)
        if (!stored.contains(app.packageName)) app,
    ];
  }

  void queryChanged(String value) => state = state.copyWith(query: value);

  void toggle(String packageName) {
    final flips = {...state.flips};
    if (!flips.remove(packageName)) flips.add(packageName);
    state = state.copyWith(flips: flips, saveFailed: false);
  }

  Future<bool> save() async {
    if (!state.canSave) return false;
    state = state.copyWith(saving: true, saveFailed: false);
    final repository = ref.read(appSelectionRepositoryProvider);
    final labels = {for (final app in state.apps) app.packageName: app.label};
    final blocked = state.blocked;
    try {
      for (final package in state.flips) {
        final label = labels[package];
        if (label == null) continue;
        await repository.setBlocked(
          packageName: package,
          label: label,
          blocked: blocked.contains(package),
        );
      }
      if (!ref.mounted) return true;
      state = state.copyWith(saving: false, stored: blocked, flips: const {});
      return true;
    } on Object catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'app selection',
          context: ErrorDescription('while saving the picks'),
        ),
      );
      if (!ref.mounted) return false;
      state = state.copyWith(saving: false, saveFailed: true);
      return false;
    }
  }
}

final appSelectionViewModelProvider =
    NotifierProvider.autoDispose<AppSelectionViewModel, AppSelectionState>(
      AppSelectionViewModel.new,
    );
