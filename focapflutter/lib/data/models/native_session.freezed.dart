// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'native_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NativeSession {

 String get sessionId; int get endsAtMillis; List<String> get packages;
/// Create a copy of NativeSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NativeSessionCopyWith<NativeSession> get copyWith => _$NativeSessionCopyWithImpl<NativeSession>(this as NativeSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NativeSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NativeSession&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.endsAtMillis, _this.endsAtMillis) || other.endsAtMillis == _this.endsAtMillis)&&const DeepCollectionEquality().equals(other.packages, _this.packages));
}


@override
int get hashCode {
  final _this = this as NativeSession;
  return Object.hash(runtimeType,_this.sessionId,_this.endsAtMillis,const DeepCollectionEquality().hash(_this.packages));
}

@override
String toString() {
  final _this = this as NativeSession;
  return 'NativeSession(sessionId: ${_this.sessionId}, endsAtMillis: ${_this.endsAtMillis}, packages: ${_this.packages})';
}


}

/// @nodoc
abstract mixin class $NativeSessionCopyWith<$Res>  {
  factory $NativeSessionCopyWith(NativeSession value, $Res Function(NativeSession) _then) = _$NativeSessionCopyWithImpl;
@useResult
$Res call({
 String sessionId, int endsAtMillis, List<String> packages
});




}
/// @nodoc
class _$NativeSessionCopyWithImpl<$Res>
    implements $NativeSessionCopyWith<$Res> {
  _$NativeSessionCopyWithImpl(this._self, this._then);

  final NativeSession _self;
  final $Res Function(NativeSession) _then;

/// Create a copy of NativeSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? endsAtMillis = null,Object? packages = null,}) {
  return _then(NativeSession(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,endsAtMillis: null == endsAtMillis ? _self.endsAtMillis : endsAtMillis // ignore: cast_nullable_to_non_nullable
as int,packages: null == packages ? _self.packages : packages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [NativeSession].
extension NativeSessionPatterns on NativeSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NativeSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NativeSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NativeSession value)  $default,){
final _that = this;
switch (_that) {
case _NativeSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NativeSession value)?  $default,){
final _that = this;
switch (_that) {
case _NativeSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  int endsAtMillis,  List<String> packages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NativeSession() when $default != null:
return $default(_that.sessionId,_that.endsAtMillis,_that.packages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  int endsAtMillis,  List<String> packages)  $default,) {final _that = this;
switch (_that) {
case _NativeSession():
return $default(_that.sessionId,_that.endsAtMillis,_that.packages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  int endsAtMillis,  List<String> packages)?  $default,) {final _that = this;
switch (_that) {
case _NativeSession() when $default != null:
return $default(_that.sessionId,_that.endsAtMillis,_that.packages);case _:
  return null;

}
}

}

/// @nodoc


class _NativeSession implements NativeSession {
  const _NativeSession({required this.sessionId, required this.endsAtMillis, required  List<String> packages}): _packages = packages;
  

@override final  String sessionId;
@override final  int endsAtMillis;
 final  List<String> _packages;
@override List<String> get packages {
  if (_packages is EqualUnmodifiableListView) return _packages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_packages);
}


/// Create a copy of NativeSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NativeSessionCopyWith<_NativeSession> get copyWith => __$NativeSessionCopyWithImpl<_NativeSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NativeSession&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.endsAtMillis, endsAtMillis) || other.endsAtMillis == endsAtMillis)&&const DeepCollectionEquality().equals(other.packages, _packages));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,endsAtMillis,const DeepCollectionEquality().hash(_packages));
}

@override
String toString() {
    return 'NativeSession(sessionId: $sessionId, endsAtMillis: $endsAtMillis, packages: $packages)';
}


}

/// @nodoc
abstract mixin class _$NativeSessionCopyWith<$Res> implements $NativeSessionCopyWith<$Res> {
  factory _$NativeSessionCopyWith(_NativeSession value, $Res Function(_NativeSession) _then) = __$NativeSessionCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, int endsAtMillis, List<String> packages
});




}
/// @nodoc
class __$NativeSessionCopyWithImpl<$Res>
    implements _$NativeSessionCopyWith<$Res> {
  __$NativeSessionCopyWithImpl(this._self, this._then);

  final _NativeSession _self;
  final $Res Function(_NativeSession) _then;

/// Create a copy of NativeSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? endsAtMillis = null,Object? packages = null,}) {
  return _then(_NativeSession(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,endsAtMillis: null == endsAtMillis ? _self.endsAtMillis : endsAtMillis // ignore: cast_nullable_to_non_nullable
as int,packages: null == packages ? _self._packages : packages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
