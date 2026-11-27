import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/models/focus_session.dart';
import 'package:focapflutter/domain/session_rules.dart';
import 'package:uuid/uuid.dart';

enum SessionRulesStep {
  start('Start (pending)'),
  refuse('Refused start'),
  activate('Native started'),
  failStart('Native start failed'),
  cancel('Cancel'),
  jumpPastEnd('Jump past end'),
  expire('Expire'),
  reconcileWithNative('Reconcile, native has it'),
  reconcileWithoutNative('Reconcile, native has none');

  const SessionRulesStep(this.label);

  final String label;
}

@immutable
class SessionRulesDebugState {
  const SessionRulesDebugState({
    this.session,
    this.clockOffsetMs = 0,
    this.log = const [],
  });

  final FocusSession? session;
  final int clockOffsetMs;
  final List<String> log;
}

class SessionRulesDebugViewModel extends Notifier<SessionRulesDebugState> {
  static const testPackage = 'com.google.android.calendar';
  static const testMinutes = 2;
  static const _logLength = 8;

  @override
  SessionRulesDebugState build() {
    final ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => state = SessionRulesDebugState(
        session: state.session,
        clockOffsetMs: state.clockOffsetMs,
        log: state.log,
      ),
    );
    ref.onDispose(ticker.cancel);
    return const SessionRulesDebugState();
  }

  int get now => DateTime.now().millisecondsSinceEpoch + state.clockOffsetMs;

  String describe() {
    final session = state.session;
    if (session == null) return 'no sample session yet';
    final left = SessionRules.remaining(session, now: now);
    final reason = session.endReason?.value ?? '–';
    return '${session.id.substring(0, 8)} ${session.status.name}, '
        'end reason $reason, ${left.inSeconds} s left, '
        '${SessionRules.focusedMinutes(session)} min focused'
        '${state.clockOffsetMs == 0 ? '' : ', clock +${state.clockOffsetMs ~/ 1000} s'}';
  }

  void run(SessionRulesStep step) {
    final before = state.session;
    try {
      final after = _apply(step, before);
      final isNew =
          step == SessionRulesStep.start || step == SessionRulesStep.refuse;
      final from = isNew ? 'new' : before?.status.name ?? 'none';
      final to = after.status.name;
      final change = step == SessionRulesStep.jumpPastEnd
          ? 'clock +${state.clockOffsetMs ~/ 1000} s'
          : from == to && before == after
          ? 'no change'
          : '$from → $to';
      _record(after, '✓ ${step.label}: $change');
    } on SessionRuleException catch (error) {
      _record(before, '✗ ${step.label}: rejected, ${error.message}');
    }
  }

  FocusSession _apply(SessionRulesStep step, FocusSession? session) {
    if (step == SessionRulesStep.start || step == SessionRulesStep.refuse) {
      final create = step == SessionRulesStep.start
          ? SessionRules.pending
          : SessionRules.refused;
      state = SessionRulesDebugState(log: state.log);
      return create(
        id: const Uuid().v4(),
        userId: 'debug',
        deviceId: 'debug',
        durationMinutes: testMinutes,
        packages: const [testPackage],
        now: now,
        allowDebugDuration: true,
      );
    }
    if (session == null) {
      throw const SessionRuleException('start a sample session first');
    }
    return switch (step) {
      SessionRulesStep.activate => SessionRules.activate(session, now: now),
      SessionRulesStep.failStart => SessionRules.failStart(session, now: now),
      SessionRulesStep.cancel => SessionRules.cancel(session, now: now),
      SessionRulesStep.jumpPastEnd => _jumpPastEnd(session),
      SessionRulesStep.expire => SessionRules.expire(session, now: now),
      SessionRulesStep.reconcileWithNative => SessionRules.reconcile(
        session,
        nativeSessionId: session.id,
        now: now,
      ),
      SessionRulesStep.reconcileWithoutNative => SessionRules.reconcile(
        session,
        nativeSessionId: null,
        now: now,
      ),
      SessionRulesStep.start || SessionRulesStep.refuse => session,
    };
  }

  FocusSession _jumpPastEnd(FocusSession session) {
    final realNow = DateTime.now().millisecondsSinceEpoch;
    state = SessionRulesDebugState(
      session: session,
      clockOffsetMs: session.endsAt - realNow + 1000,
      log: state.log,
    );
    return session;
  }

  void _record(FocusSession? session, String line) {
    state = SessionRulesDebugState(
      session: session,
      clockOffsetMs: state.clockOffsetMs,
      log: [line, ...state.log].take(_logLength).toList(),
    );
  }
}

final sessionRulesDebugProvider =
    NotifierProvider.autoDispose<
      SessionRulesDebugViewModel,
      SessionRulesDebugState
    >(SessionRulesDebugViewModel.new);
