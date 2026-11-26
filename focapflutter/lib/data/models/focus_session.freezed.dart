// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FocusSession {

 String get id; String get userId; String get deviceId; int get durationMinutes; int get startedAt; int get endsAt; SessionStatus get status; List<String> get selectedPackages; int get appCount; int get updatedAt; int? get endedAt; SessionEndReason? get endReason; bool get synced;
/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FocusSessionCopyWith<FocusSession> get copyWith => _$FocusSessionCopyWithImpl<FocusSession>(this as FocusSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FocusSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.selectedPackages, _this.selectedPackages)&&(identical(other.appCount, _this.appCount) || other.appCount == _this.appCount)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.endReason, _this.endReason) || other.endReason == _this.endReason)&&(identical(other.synced, _this.synced) || other.synced == _this.synced));
}


@override
int get hashCode {
  final _this = this as FocusSession;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.deviceId,_this.durationMinutes,_this.startedAt,_this.endsAt,_this.status,const DeepCollectionEquality().hash(_this.selectedPackages),_this.appCount,_this.updatedAt,_this.endedAt,_this.endReason,_this.synced);
}

@override
String toString() {
  final _this = this as FocusSession;
  return 'FocusSession(id: ${_this.id}, userId: ${_this.userId}, deviceId: ${_this.deviceId}, durationMinutes: ${_this.durationMinutes}, startedAt: ${_this.startedAt}, endsAt: ${_this.endsAt}, status: ${_this.status}, selectedPackages: ${_this.selectedPackages}, appCount: ${_this.appCount}, updatedAt: ${_this.updatedAt}, endedAt: ${_this.endedAt}, endReason: ${_this.endReason}, synced: ${_this.synced})';
}


}

/// @nodoc
abstract mixin class $FocusSessionCopyWith<$Res>  {
  factory $FocusSessionCopyWith(FocusSession value, $Res Function(FocusSession) _then) = _$FocusSessionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String deviceId, int durationMinutes, int startedAt, int endsAt, SessionStatus status, List<String> selectedPackages, int appCount, int updatedAt, int? endedAt, SessionEndReason? endReason, bool synced
});




}
/// @nodoc
class _$FocusSessionCopyWithImpl<$Res>
    implements $FocusSessionCopyWith<$Res> {
  _$FocusSessionCopyWithImpl(this._self, this._then);

  final FocusSession _self;
  final $Res Function(FocusSession) _then;

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? deviceId = null,Object? durationMinutes = null,Object? startedAt = null,Object? endsAt = null,Object? status = null,Object? selectedPackages = null,Object? appCount = null,Object? updatedAt = null,Object? endedAt = freezed,Object? endReason = freezed,Object? synced = null,}) {
  return _then(FocusSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,selectedPackages: null == selectedPackages ? _self.selectedPackages : selectedPackages // ignore: cast_nullable_to_non_nullable
as List<String>,appCount: null == appCount ? _self.appCount : appCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as int?,endReason: freezed == endReason ? _self.endReason : endReason // ignore: cast_nullable_to_non_nullable
as SessionEndReason?,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FocusSession].
extension FocusSessionPatterns on FocusSession {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FocusSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FocusSession value)  $default,){
final _that = this;
switch (_that) {
case _FocusSession():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FocusSession value)?  $default,){
final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String deviceId,  int durationMinutes,  int startedAt,  int endsAt,  SessionStatus status,  List<String> selectedPackages,  int appCount,  int updatedAt,  int? endedAt,  SessionEndReason? endReason,  bool synced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that.id,_that.userId,_that.deviceId,_that.durationMinutes,_that.startedAt,_that.endsAt,_that.status,_that.selectedPackages,_that.appCount,_that.updatedAt,_that.endedAt,_that.endReason,_that.synced);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String deviceId,  int durationMinutes,  int startedAt,  int endsAt,  SessionStatus status,  List<String> selectedPackages,  int appCount,  int updatedAt,  int? endedAt,  SessionEndReason? endReason,  bool synced)  $default,) {final _that = this;
switch (_that) {
case _FocusSession():
return $default(_that.id,_that.userId,_that.deviceId,_that.durationMinutes,_that.startedAt,_that.endsAt,_that.status,_that.selectedPackages,_that.appCount,_that.updatedAt,_that.endedAt,_that.endReason,_that.synced);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String deviceId,  int durationMinutes,  int startedAt,  int endsAt,  SessionStatus status,  List<String> selectedPackages,  int appCount,  int updatedAt,  int? endedAt,  SessionEndReason? endReason,  bool synced)?  $default,) {final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that.id,_that.userId,_that.deviceId,_that.durationMinutes,_that.startedAt,_that.endsAt,_that.status,_that.selectedPackages,_that.appCount,_that.updatedAt,_that.endedAt,_that.endReason,_that.synced);case _:
  return null;

}
}

}

/// @nodoc


class _FocusSession implements FocusSession {
  const _FocusSession({required this.id, required this.userId, required this.deviceId, required this.durationMinutes, required this.startedAt, required this.endsAt, required this.status, required  List<String> selectedPackages, required this.appCount, required this.updatedAt, this.endedAt, this.endReason, this.synced = false}): _selectedPackages = selectedPackages;
  

@override final  String id;
@override final  String userId;
@override final  String deviceId;
@override final  int durationMinutes;
@override final  int startedAt;
@override final  int endsAt;
@override final  SessionStatus status;
 final  List<String> _selectedPackages;
@override List<String> get selectedPackages {
  if (_selectedPackages is EqualUnmodifiableListView) return _selectedPackages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedPackages);
}

@override final  int appCount;
@override final  int updatedAt;
@override final  int? endedAt;
@override final  SessionEndReason? endReason;
@override@JsonKey() final  bool synced;

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FocusSessionCopyWith<_FocusSession> get copyWith => __$FocusSessionCopyWithImpl<_FocusSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FocusSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.selectedPackages, _selectedPackages)&&(identical(other.appCount, appCount) || other.appCount == appCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.endReason, endReason) || other.endReason == endReason)&&(identical(other.synced, synced) || other.synced == synced));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,deviceId,durationMinutes,startedAt,endsAt,status,const DeepCollectionEquality().hash(_selectedPackages),appCount,updatedAt,endedAt,endReason,synced);
}

@override
String toString() {
    return 'FocusSession(id: $id, userId: $userId, deviceId: $deviceId, durationMinutes: $durationMinutes, startedAt: $startedAt, endsAt: $endsAt, status: $status, selectedPackages: $selectedPackages, appCount: $appCount, updatedAt: $updatedAt, endedAt: $endedAt, endReason: $endReason, synced: $synced)';
}


}

/// @nodoc
abstract mixin class _$FocusSessionCopyWith<$Res> implements $FocusSessionCopyWith<$Res> {
  factory _$FocusSessionCopyWith(_FocusSession value, $Res Function(_FocusSession) _then) = __$FocusSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String deviceId, int durationMinutes, int startedAt, int endsAt, SessionStatus status, List<String> selectedPackages, int appCount, int updatedAt, int? endedAt, SessionEndReason? endReason, bool synced
});




}
/// @nodoc
class __$FocusSessionCopyWithImpl<$Res>
    implements _$FocusSessionCopyWith<$Res> {
  __$FocusSessionCopyWithImpl(this._self, this._then);

  final _FocusSession _self;
  final $Res Function(_FocusSession) _then;

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? deviceId = null,Object? durationMinutes = null,Object? startedAt = null,Object? endsAt = null,Object? status = null,Object? selectedPackages = null,Object? appCount = null,Object? updatedAt = null,Object? endedAt = freezed,Object? endReason = freezed,Object? synced = null,}) {
  return _then(_FocusSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,selectedPackages: null == selectedPackages ? _self._selectedPackages : selectedPackages // ignore: cast_nullable_to_non_nullable
as List<String>,appCount: null == appCount ? _self.appCount : appCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as int?,endReason: freezed == endReason ? _self.endReason : endReason // ignore: cast_nullable_to_non_nullable
as SessionEndReason?,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
