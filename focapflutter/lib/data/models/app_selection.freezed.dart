// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSelection {

 String get packageName; String get label; bool get isBlocked; int get updatedAt;
/// Create a copy of AppSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSelectionCopyWith<AppSelection> get copyWith => _$AppSelectionCopyWithImpl<AppSelection>(this as AppSelection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppSelection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSelection&&(identical(other.packageName, _this.packageName) || other.packageName == _this.packageName)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.isBlocked, _this.isBlocked) || other.isBlocked == _this.isBlocked)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as AppSelection;
  return Object.hash(runtimeType,_this.packageName,_this.label,_this.isBlocked,_this.updatedAt);
}

@override
String toString() {
  final _this = this as AppSelection;
  return 'AppSelection(packageName: ${_this.packageName}, label: ${_this.label}, isBlocked: ${_this.isBlocked}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $AppSelectionCopyWith<$Res>  {
  factory $AppSelectionCopyWith(AppSelection value, $Res Function(AppSelection) _then) = _$AppSelectionCopyWithImpl;
@useResult
$Res call({
 String packageName, String label, bool isBlocked, int updatedAt
});




}
/// @nodoc
class _$AppSelectionCopyWithImpl<$Res>
    implements $AppSelectionCopyWith<$Res> {
  _$AppSelectionCopyWithImpl(this._self, this._then);

  final AppSelection _self;
  final $Res Function(AppSelection) _then;

/// Create a copy of AppSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageName = null,Object? label = null,Object? isBlocked = null,Object? updatedAt = null,}) {
  return _then(AppSelection(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSelection].
extension AppSelectionPatterns on AppSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSelection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSelection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSelection value)  $default,){
final _that = this;
switch (_that) {
case _AppSelection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSelection value)?  $default,){
final _that = this;
switch (_that) {
case _AppSelection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String packageName,  String label,  bool isBlocked,  int updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSelection() when $default != null:
return $default(_that.packageName,_that.label,_that.isBlocked,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String packageName,  String label,  bool isBlocked,  int updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AppSelection():
return $default(_that.packageName,_that.label,_that.isBlocked,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String packageName,  String label,  bool isBlocked,  int updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AppSelection() when $default != null:
return $default(_that.packageName,_that.label,_that.isBlocked,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _AppSelection implements AppSelection {
  const _AppSelection({required this.packageName, required this.label, required this.isBlocked, required this.updatedAt});
  

@override final  String packageName;
@override final  String label;
@override final  bool isBlocked;
@override final  int updatedAt;

/// Create a copy of AppSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSelectionCopyWith<_AppSelection> get copyWith => __$AppSelectionCopyWithImpl<_AppSelection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSelection&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.label, label) || other.label == label)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,packageName,label,isBlocked,updatedAt);
}

@override
String toString() {
    return 'AppSelection(packageName: $packageName, label: $label, isBlocked: $isBlocked, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AppSelectionCopyWith<$Res> implements $AppSelectionCopyWith<$Res> {
  factory _$AppSelectionCopyWith(_AppSelection value, $Res Function(_AppSelection) _then) = __$AppSelectionCopyWithImpl;
@override @useResult
$Res call({
 String packageName, String label, bool isBlocked, int updatedAt
});




}
/// @nodoc
class __$AppSelectionCopyWithImpl<$Res>
    implements _$AppSelectionCopyWith<$Res> {
  __$AppSelectionCopyWithImpl(this._self, this._then);

  final _AppSelection _self;
  final $Res Function(_AppSelection) _then;

/// Create a copy of AppSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageName = null,Object? label = null,Object? isBlocked = null,Object? updatedAt = null,}) {
  return _then(_AppSelection(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
