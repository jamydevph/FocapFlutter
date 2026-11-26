import 'package:focapflutter/data/models/app_selection.dart';
import 'package:focapflutter/data/services/local_database.dart';

class AppSelectionRepository {
  AppSelectionRepository(this._database, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final LocalDatabase _database;
  final DateTime Function() _clock;

  Future<List<AppSelection>> load() async =>
      (await _database.selections()).map(_fromRow).toList();

  Future<Set<String>> blockedPackages() async => {
    for (final selection in await load())
      if (selection.isBlocked) selection.packageName,
  };

  Future<AppSelection> setBlocked({
    required String packageName,
    required String label,
    required bool blocked,
  }) async {
    final selection = AppSelection(
      packageName: packageName,
      label: label,
      isBlocked: blocked,
      updatedAt: _clock().millisecondsSinceEpoch,
    );
    await _database.upsertSelection(_toRow(selection));
    return selection;
  }

  Future<int> keepOnly(Iterable<String> installedPackages) async {
    final installed = installedPackages.toSet();
    if (installed.isEmpty) return 0;
    final missing = [
      for (final selection in await load())
        if (!installed.contains(selection.packageName)) selection.packageName,
    ];
    return _database.deleteSelections(missing);
  }

  AppSelection _fromRow(Map<String, Object?> row) => AppSelection(
    packageName: row['package_name']! as String,
    label: row['label']! as String,
    isBlocked: (row['is_blocked']! as int) == 1,
    updatedAt: row['updated_at']! as int,
  );

  Map<String, Object?> _toRow(AppSelection selection) => {
    'package_name': selection.packageName,
    'label': selection.label,
    'is_blocked': selection.isBlocked ? 1 : 0,
    'updated_at': selection.updatedAt,
  };
}
