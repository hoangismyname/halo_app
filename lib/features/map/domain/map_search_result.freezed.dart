// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapSearchResult {

@JsonKey(name: 'place_id') String get placeId; String get formatted;@JsonKey(name: 'address_line1') String? get addressLine1;@JsonKey(name: 'address_line2') String? get addressLine2; double get lat; double get lon;
/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapSearchResultCopyWith<MapSearchResult> get copyWith => _$MapSearchResultCopyWithImpl<MapSearchResult>(this as MapSearchResult, _$identity);

  /// Serializes this MapSearchResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapSearchResult&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.formatted, formatted) || other.formatted == formatted)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,placeId,formatted,addressLine1,addressLine2,lat,lon);

@override
String toString() {
  return 'MapSearchResult(placeId: $placeId, formatted: $formatted, addressLine1: $addressLine1, addressLine2: $addressLine2, lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class $MapSearchResultCopyWith<$Res>  {
  factory $MapSearchResultCopyWith(MapSearchResult value, $Res Function(MapSearchResult) _then) = _$MapSearchResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'place_id') String placeId, String formatted,@JsonKey(name: 'address_line1') String? addressLine1,@JsonKey(name: 'address_line2') String? addressLine2, double lat, double lon
});




}
/// @nodoc
class _$MapSearchResultCopyWithImpl<$Res>
    implements $MapSearchResultCopyWith<$Res> {
  _$MapSearchResultCopyWithImpl(this._self, this._then);

  final MapSearchResult _self;
  final $Res Function(MapSearchResult) _then;

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? placeId = null,Object? formatted = null,Object? addressLine1 = freezed,Object? addressLine2 = freezed,Object? lat = null,Object? lon = null,}) {
  return _then(_self.copyWith(
placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,formatted: null == formatted ? _self.formatted : formatted // ignore: cast_nullable_to_non_nullable
as String,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MapSearchResult].
extension MapSearchResultPatterns on MapSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _MapSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'place_id')  String placeId,  String formatted, @JsonKey(name: 'address_line1')  String? addressLine1, @JsonKey(name: 'address_line2')  String? addressLine2,  double lat,  double lon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
return $default(_that.placeId,_that.formatted,_that.addressLine1,_that.addressLine2,_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'place_id')  String placeId,  String formatted, @JsonKey(name: 'address_line1')  String? addressLine1, @JsonKey(name: 'address_line2')  String? addressLine2,  double lat,  double lon)  $default,) {final _that = this;
switch (_that) {
case _MapSearchResult():
return $default(_that.placeId,_that.formatted,_that.addressLine1,_that.addressLine2,_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'place_id')  String placeId,  String formatted, @JsonKey(name: 'address_line1')  String? addressLine1, @JsonKey(name: 'address_line2')  String? addressLine2,  double lat,  double lon)?  $default,) {final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
return $default(_that.placeId,_that.formatted,_that.addressLine1,_that.addressLine2,_that.lat,_that.lon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapSearchResult implements MapSearchResult {
  const _MapSearchResult({@JsonKey(name: 'place_id') required this.placeId, required this.formatted, @JsonKey(name: 'address_line1') this.addressLine1, @JsonKey(name: 'address_line2') this.addressLine2, required this.lat, required this.lon});
  factory _MapSearchResult.fromJson(Map<String, dynamic> json) => _$MapSearchResultFromJson(json);

@override@JsonKey(name: 'place_id') final  String placeId;
@override final  String formatted;
@override@JsonKey(name: 'address_line1') final  String? addressLine1;
@override@JsonKey(name: 'address_line2') final  String? addressLine2;
@override final  double lat;
@override final  double lon;

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapSearchResultCopyWith<_MapSearchResult> get copyWith => __$MapSearchResultCopyWithImpl<_MapSearchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapSearchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapSearchResult&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.formatted, formatted) || other.formatted == formatted)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,placeId,formatted,addressLine1,addressLine2,lat,lon);

@override
String toString() {
  return 'MapSearchResult(placeId: $placeId, formatted: $formatted, addressLine1: $addressLine1, addressLine2: $addressLine2, lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class _$MapSearchResultCopyWith<$Res> implements $MapSearchResultCopyWith<$Res> {
  factory _$MapSearchResultCopyWith(_MapSearchResult value, $Res Function(_MapSearchResult) _then) = __$MapSearchResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'place_id') String placeId, String formatted,@JsonKey(name: 'address_line1') String? addressLine1,@JsonKey(name: 'address_line2') String? addressLine2, double lat, double lon
});




}
/// @nodoc
class __$MapSearchResultCopyWithImpl<$Res>
    implements _$MapSearchResultCopyWith<$Res> {
  __$MapSearchResultCopyWithImpl(this._self, this._then);

  final _MapSearchResult _self;
  final $Res Function(_MapSearchResult) _then;

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? placeId = null,Object? formatted = null,Object? addressLine1 = freezed,Object? addressLine2 = freezed,Object? lat = null,Object? lon = null,}) {
  return _then(_MapSearchResult(
placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,formatted: null == formatted ? _self.formatted : formatted // ignore: cast_nullable_to_non_nullable
as String,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
