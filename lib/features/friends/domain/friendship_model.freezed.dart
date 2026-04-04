// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friendship_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendshipModel {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'friend_id') String get friendId; String get status;@JsonKey(name: 'created_at') DateTime? get createdAt;// Joined profile data
@JsonKey(name: 'friend_profile') Map<String, dynamic>? get friendProfile;
/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendshipModelCopyWith<FriendshipModel> get copyWith => _$FriendshipModelCopyWithImpl<FriendshipModel>(this as FriendshipModel, _$identity);

  /// Serializes this FriendshipModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendshipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.friendId, friendId) || other.friendId == friendId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.friendProfile, friendProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,friendId,status,createdAt,const DeepCollectionEquality().hash(friendProfile));

@override
String toString() {
  return 'FriendshipModel(id: $id, userId: $userId, friendId: $friendId, status: $status, createdAt: $createdAt, friendProfile: $friendProfile)';
}


}

/// @nodoc
abstract mixin class $FriendshipModelCopyWith<$Res>  {
  factory $FriendshipModelCopyWith(FriendshipModel value, $Res Function(FriendshipModel) _then) = _$FriendshipModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'friend_id') String friendId, String status,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'friend_profile') Map<String, dynamic>? friendProfile
});




}
/// @nodoc
class _$FriendshipModelCopyWithImpl<$Res>
    implements $FriendshipModelCopyWith<$Res> {
  _$FriendshipModelCopyWithImpl(this._self, this._then);

  final FriendshipModel _self;
  final $Res Function(FriendshipModel) _then;

/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? friendId = null,Object? status = null,Object? createdAt = freezed,Object? friendProfile = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,friendId: null == friendId ? _self.friendId : friendId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,friendProfile: freezed == friendProfile ? _self.friendProfile : friendProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendshipModel].
extension FriendshipModelPatterns on FriendshipModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendshipModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendshipModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendshipModel value)  $default,){
final _that = this;
switch (_that) {
case _FriendshipModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendshipModel value)?  $default,){
final _that = this;
switch (_that) {
case _FriendshipModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'friend_id')  String friendId,  String status, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'friend_profile')  Map<String, dynamic>? friendProfile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendshipModel() when $default != null:
return $default(_that.id,_that.userId,_that.friendId,_that.status,_that.createdAt,_that.friendProfile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'friend_id')  String friendId,  String status, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'friend_profile')  Map<String, dynamic>? friendProfile)  $default,) {final _that = this;
switch (_that) {
case _FriendshipModel():
return $default(_that.id,_that.userId,_that.friendId,_that.status,_that.createdAt,_that.friendProfile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'friend_id')  String friendId,  String status, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'friend_profile')  Map<String, dynamic>? friendProfile)?  $default,) {final _that = this;
switch (_that) {
case _FriendshipModel() when $default != null:
return $default(_that.id,_that.userId,_that.friendId,_that.status,_that.createdAt,_that.friendProfile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendshipModel implements FriendshipModel {
  const _FriendshipModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'friend_id') required this.friendId, this.status = 'pending', @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'friend_profile') final  Map<String, dynamic>? friendProfile}): _friendProfile = friendProfile;
  factory _FriendshipModel.fromJson(Map<String, dynamic> json) => _$FriendshipModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'friend_id') final  String friendId;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
// Joined profile data
 final  Map<String, dynamic>? _friendProfile;
// Joined profile data
@override@JsonKey(name: 'friend_profile') Map<String, dynamic>? get friendProfile {
  final value = _friendProfile;
  if (value == null) return null;
  if (_friendProfile is EqualUnmodifiableMapView) return _friendProfile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendshipModelCopyWith<_FriendshipModel> get copyWith => __$FriendshipModelCopyWithImpl<_FriendshipModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendshipModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendshipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.friendId, friendId) || other.friendId == friendId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._friendProfile, _friendProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,friendId,status,createdAt,const DeepCollectionEquality().hash(_friendProfile));

@override
String toString() {
  return 'FriendshipModel(id: $id, userId: $userId, friendId: $friendId, status: $status, createdAt: $createdAt, friendProfile: $friendProfile)';
}


}

/// @nodoc
abstract mixin class _$FriendshipModelCopyWith<$Res> implements $FriendshipModelCopyWith<$Res> {
  factory _$FriendshipModelCopyWith(_FriendshipModel value, $Res Function(_FriendshipModel) _then) = __$FriendshipModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'friend_id') String friendId, String status,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'friend_profile') Map<String, dynamic>? friendProfile
});




}
/// @nodoc
class __$FriendshipModelCopyWithImpl<$Res>
    implements _$FriendshipModelCopyWith<$Res> {
  __$FriendshipModelCopyWithImpl(this._self, this._then);

  final _FriendshipModel _self;
  final $Res Function(_FriendshipModel) _then;

/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? friendId = null,Object? status = null,Object? createdAt = freezed,Object? friendProfile = freezed,}) {
  return _then(_FriendshipModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,friendId: null == friendId ? _self.friendId : friendId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,friendProfile: freezed == friendProfile ? _self._friendProfile : friendProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
