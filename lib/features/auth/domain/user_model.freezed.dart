// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get username;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'avatar_url') String? get avatarUrl; String get bio;@JsonKey(name: 'status_emoji') String get statusEmoji;@JsonKey(name: 'status_text') String get statusText; double? get latitude; double? get longitude;@JsonKey(name: 'location_updated_at') DateTime? get locationUpdatedAt;@JsonKey(name: 'is_online') bool get isOnline;@JsonKey(name: 'last_seen') DateTime? get lastSeen;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.statusEmoji, statusEmoji) || other.statusEmoji == statusEmoji)&&(identical(other.statusText, statusText) || other.statusText == statusText)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.locationUpdatedAt, locationUpdatedAt) || other.locationUpdatedAt == locationUpdatedAt)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl,bio,statusEmoji,statusText,latitude,longitude,locationUpdatedAt,isOnline,lastSeen,createdAt,updatedAt);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, bio: $bio, statusEmoji: $statusEmoji, statusText: $statusText, latitude: $latitude, longitude: $longitude, locationUpdatedAt: $locationUpdatedAt, isOnline: $isOnline, lastSeen: $lastSeen, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String username,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, String bio,@JsonKey(name: 'status_emoji') String statusEmoji,@JsonKey(name: 'status_text') String statusText, double? latitude, double? longitude,@JsonKey(name: 'location_updated_at') DateTime? locationUpdatedAt,@JsonKey(name: 'is_online') bool isOnline,@JsonKey(name: 'last_seen') DateTime? lastSeen,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarUrl = freezed,Object? bio = null,Object? statusEmoji = null,Object? statusText = null,Object? latitude = freezed,Object? longitude = freezed,Object? locationUpdatedAt = freezed,Object? isOnline = null,Object? lastSeen = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,statusEmoji: null == statusEmoji ? _self.statusEmoji : statusEmoji // ignore: cast_nullable_to_non_nullable
as String,statusText: null == statusText ? _self.statusText : statusText // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,locationUpdatedAt: freezed == locationUpdatedAt ? _self.locationUpdatedAt : locationUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String bio, @JsonKey(name: 'status_emoji')  String statusEmoji, @JsonKey(name: 'status_text')  String statusText,  double? latitude,  double? longitude, @JsonKey(name: 'location_updated_at')  DateTime? locationUpdatedAt, @JsonKey(name: 'is_online')  bool isOnline, @JsonKey(name: 'last_seen')  DateTime? lastSeen, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.bio,_that.statusEmoji,_that.statusText,_that.latitude,_that.longitude,_that.locationUpdatedAt,_that.isOnline,_that.lastSeen,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String bio, @JsonKey(name: 'status_emoji')  String statusEmoji, @JsonKey(name: 'status_text')  String statusText,  double? latitude,  double? longitude, @JsonKey(name: 'location_updated_at')  DateTime? locationUpdatedAt, @JsonKey(name: 'is_online')  bool isOnline, @JsonKey(name: 'last_seen')  DateTime? lastSeen, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.bio,_that.statusEmoji,_that.statusText,_that.latitude,_that.longitude,_that.locationUpdatedAt,_that.isOnline,_that.lastSeen,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String bio, @JsonKey(name: 'status_emoji')  String statusEmoji, @JsonKey(name: 'status_text')  String statusText,  double? latitude,  double? longitude, @JsonKey(name: 'location_updated_at')  DateTime? locationUpdatedAt, @JsonKey(name: 'is_online')  bool isOnline, @JsonKey(name: 'last_seen')  DateTime? lastSeen, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.bio,_that.statusEmoji,_that.statusText,_that.latitude,_that.longitude,_that.locationUpdatedAt,_that.isOnline,_that.lastSeen,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.username, @JsonKey(name: 'display_name') this.displayName = '', @JsonKey(name: 'avatar_url') this.avatarUrl, this.bio = '', @JsonKey(name: 'status_emoji') this.statusEmoji = '😊', @JsonKey(name: 'status_text') this.statusText = '', this.latitude, this.longitude, @JsonKey(name: 'location_updated_at') this.locationUpdatedAt, @JsonKey(name: 'is_online') this.isOnline = false, @JsonKey(name: 'last_seen') this.lastSeen, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String username;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey() final  String bio;
@override@JsonKey(name: 'status_emoji') final  String statusEmoji;
@override@JsonKey(name: 'status_text') final  String statusText;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey(name: 'location_updated_at') final  DateTime? locationUpdatedAt;
@override@JsonKey(name: 'is_online') final  bool isOnline;
@override@JsonKey(name: 'last_seen') final  DateTime? lastSeen;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.statusEmoji, statusEmoji) || other.statusEmoji == statusEmoji)&&(identical(other.statusText, statusText) || other.statusText == statusText)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.locationUpdatedAt, locationUpdatedAt) || other.locationUpdatedAt == locationUpdatedAt)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl,bio,statusEmoji,statusText,latitude,longitude,locationUpdatedAt,isOnline,lastSeen,createdAt,updatedAt);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, bio: $bio, statusEmoji: $statusEmoji, statusText: $statusText, latitude: $latitude, longitude: $longitude, locationUpdatedAt: $locationUpdatedAt, isOnline: $isOnline, lastSeen: $lastSeen, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String username,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, String bio,@JsonKey(name: 'status_emoji') String statusEmoji,@JsonKey(name: 'status_text') String statusText, double? latitude, double? longitude,@JsonKey(name: 'location_updated_at') DateTime? locationUpdatedAt,@JsonKey(name: 'is_online') bool isOnline,@JsonKey(name: 'last_seen') DateTime? lastSeen,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarUrl = freezed,Object? bio = null,Object? statusEmoji = null,Object? statusText = null,Object? latitude = freezed,Object? longitude = freezed,Object? locationUpdatedAt = freezed,Object? isOnline = null,Object? lastSeen = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,statusEmoji: null == statusEmoji ? _self.statusEmoji : statusEmoji // ignore: cast_nullable_to_non_nullable
as String,statusText: null == statusText ? _self.statusText : statusText // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,locationUpdatedAt: freezed == locationUpdatedAt ? _self.locationUpdatedAt : locationUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
