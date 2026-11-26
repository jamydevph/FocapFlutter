import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._(this._db, this._meta);

  static const fileName = 'focap.db';
  static const schemaVersion = 1;
  static const schemaVersionKey = 'schema_version';

  static const selectionsTable = 'app_selections';
  static const sessionsTable = 'focus_sessions';
  static const metaTable = 'meta';

  static Future<LocalDatabase> open({String? path}) async {
    final location = path ?? p.join(await getDatabasesPath(), fileName);
    final db = await openDatabase(
      location,
      version: schemaVersion,
      onCreate: _create,
      onUpgrade: _upgrade,
    );
    final rows = await db.query(metaTable);
    final meta = {
      for (final row in rows) row['key']! as String: row['value']! as String,
    };
    return LocalDatabase._(db, meta);
  }

  static Future<void> _create(Database db, int version) async {
    final batch = db.batch()
      ..execute('''
        CREATE TABLE $selectionsTable (
          package_name TEXT PRIMARY KEY,
          label TEXT NOT NULL,
          is_blocked INTEGER NOT NULL DEFAULT 0,
          updated_at INTEGER NOT NULL
        )''')
      ..execute('''
        CREATE TABLE $sessionsTable (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          device_id TEXT NOT NULL,
          duration_minutes INTEGER NOT NULL,
          started_at INTEGER NOT NULL,
          ends_at INTEGER NOT NULL,
          ended_at INTEGER,
          status TEXT NOT NULL,
          end_reason TEXT,
          selected_packages TEXT NOT NULL,
          app_count INTEGER NOT NULL,
          synced INTEGER NOT NULL DEFAULT 0,
          updated_at INTEGER NOT NULL
        )''')
      ..execute(
        'CREATE INDEX focus_sessions_user_started '
        'ON $sessionsTable (user_id, started_at)',
      )
      ..execute(
        'CREATE TABLE $metaTable (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
      )
      ..insert(metaTable, {'key': schemaVersionKey, 'value': '$version'});
    await batch.commit(noResult: true);
  }

  static Future<void> _upgrade(Database db, int from, int to) async {
    for (var version = from + 1; version <= to; version++) {
      await _migrations[version]?.call(db);
    }
    await db.insert(metaTable, {
      'key': schemaVersionKey,
      'value': '$to',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static final Map<int, Future<void> Function(Database db)> _migrations = {};

  final Database _db;
  final Map<String, String> _meta;

  String? meta(String key) => _meta[key];

  Future<void> setMeta(Map<String, String> values) async {
    if (values.isEmpty) return;
    final batch = _db.batch();
    for (final MapEntry(:key, :value) in values.entries) {
      batch.insert(metaTable, {
        'key': key,
        'value': value,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
    _meta.addAll(values);
  }

  Future<void> deleteMeta(Iterable<String> keys) async {
    final list = keys.toList();
    if (list.isEmpty) return;
    await _db.delete(
      metaTable,
      where: 'key IN (${List.filled(list.length, '?').join(', ')})',
      whereArgs: list,
    );
    list.forEach(_meta.remove);
  }

  Future<List<Map<String, Object?>>> selections() =>
      _db.query(selectionsTable, orderBy: 'label COLLATE NOCASE');

  Future<void> upsertSelection(Map<String, Object?> row) => _db.insert(
    selectionsTable,
    row,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  static const _maxArguments = 500;

  Future<int> deleteSelections(Iterable<String> packageNames) {
    final packages = packageNames.toList();
    if (packages.isEmpty) return Future.value(0);
    return _db.transaction((txn) async {
      var deleted = 0;
      for (var start = 0; start < packages.length; start += _maxArguments) {
        final chunk = packages.sublist(
          start,
          (start + _maxArguments).clamp(0, packages.length),
        );
        deleted += await txn.delete(
          selectionsTable,
          where:
              'package_name IN (${List.filled(chunk.length, '?').join(', ')})',
          whereArgs: chunk,
        );
      }
      return deleted;
    });
  }

  Future<void> upsertSession(Map<String, Object?> row) => _db.insert(
    sessionsTable,
    row,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  Future<List<Map<String, Object?>>> sessions({
    required String userId,
    List<String>? statuses,
  }) {
    final where = StringBuffer('user_id = ?');
    final args = <Object?>[userId];
    if (statuses != null && statuses.isNotEmpty) {
      where.write(
        ' AND status IN (${List.filled(statuses.length, '?').join(', ')})',
      );
      args.addAll(statuses);
    }
    return _db.query(
      sessionsTable,
      where: where.toString(),
      whereArgs: args,
      orderBy: 'started_at DESC',
    );
  }

  Future<Map<String, Object?>?> session(String id) async {
    final rows = await _db.query(
      sessionsTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }
}
