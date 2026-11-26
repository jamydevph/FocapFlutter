import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:focapflutter/data/models/focus_session.dart';
import 'package:focapflutter/data/models/session_status.dart';
import 'package:focapflutter/data/services/local_database.dart';

class SessionRepository {
  SessionRepository(this._database);

  final LocalDatabase _database;

  Future<void> save(FocusSession session) =>
      _database.upsertSession(_toRow(session));

  Future<FocusSession?> byId(String id) async {
    final row = await _database.session(id);
    return row == null ? null : _tryFromRow(row);
  }

  Future<List<FocusSession>> forUser(
    String userId, {
    Set<SessionStatus>? statuses,
  }) async {
    final rows = await _database.sessions(
      userId: userId,
      statuses: statuses?.map((status) => status.name).toList(),
    );
    return [for (final row in rows) ?_tryFromRow(row)];
  }

  FocusSession? _tryFromRow(Map<String, Object?> row) {
    try {
      return _fromRow(row);
    } on Object catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'session repository',
          context: ErrorDescription('while reading session ${row['id']}'),
        ),
      );
      return null;
    }
  }

  FocusSession _fromRow(Map<String, Object?> row) => FocusSession(
    id: row['id']! as String,
    userId: row['user_id']! as String,
    deviceId: row['device_id']! as String,
    durationMinutes: row['duration_minutes']! as int,
    startedAt: row['started_at']! as int,
    endsAt: row['ends_at']! as int,
    endedAt: row['ended_at'] as int?,
    status:
        SessionStatus.tryParse(row['status']! as String) ??
        (throw FormatException('unknown status', row['status'])),
    endReason: SessionEndReason.tryParse(row['end_reason'] as String?),
    selectedPackages: _packages(row['selected_packages']! as String),
    appCount: row['app_count']! as int,
    synced: (row['synced']! as int) == 1,
    updatedAt: row['updated_at']! as int,
  );

  Map<String, Object?> _toRow(FocusSession session) => {
    'id': session.id,
    'user_id': session.userId,
    'device_id': session.deviceId,
    'duration_minutes': session.durationMinutes,
    'started_at': session.startedAt,
    'ends_at': session.endsAt,
    'ended_at': session.endedAt,
    'status': session.status.name,
    'end_reason': session.endReason?.value,
    'selected_packages': jsonEncode(session.selectedPackages),
    'app_count': session.appCount,
    'synced': session.synced ? 1 : 0,
    'updated_at': session.updatedAt,
  };

  List<String> _packages(String encoded) =>
      List<String>.from(jsonDecode(encoded) as List<Object?>);
}
