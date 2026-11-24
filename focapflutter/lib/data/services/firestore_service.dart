import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceException implements Exception {
  const FirestoreServiceException(this.code, [this.message]);

  static const timeout = 'timeout';

  final String code;
  final String? message;

  @override
  String toString() => 'FirestoreServiceException($code, $message)';
}

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const requestTimeout = Duration(seconds: 10);

  static void configure() {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
  }

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _user(String uid) =>
      _firestore.collection('users').doc(uid);

  Future<Map<String, Object?>?> readUser(String uid) => _guard(() async {
    final snapshot = await _user(uid)
        .get(const GetOptions(source: Source.server));
    return snapshot.data();
  });

  Future<void> createUser(String uid, Map<String, Object?> data) =>
      _guard(() => _user(uid).set(data));

  Future<void> upsertDevice(
    String uid,
    String deviceId, {
    required Map<String, Object?> fields,
    required Map<String, Object?> createOnlyFields,
  }) => _guard(() async {
    final device = _user(uid).collection('devices').doc(deviceId);
    final existing = await device.get(const GetOptions(source: Source.server));
    if (existing.exists) {
      await device.update(fields);
    } else {
      await device.set({...fields, ...createOnlyFields});
    }
  });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(requestTimeout);
    } on TimeoutException {
      throw const FirestoreServiceException(FirestoreServiceException.timeout);
    } on FirebaseException catch (error) {
      throw FirestoreServiceException(error.code, error.message);
    }
  }
}
