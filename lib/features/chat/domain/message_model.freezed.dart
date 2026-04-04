// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageModel {

 String get id;@JsonKey(name: 'room_id') String get roomId;@JsonKey(name: 'sender_id') String get senderId; String? get content;@JsonKey(name: 'message_type') String get messageType;@JsonKey(name: 'sticker_url') String? get stickerUrl; Map<String, dynamic> get metadata;@JsonKey(name: 'created_at') DateTime? get createdAt;// Joined sender profile
@JsonKey(name: 'sender_profile') Map<String, dynamic>? get senderProfile;
/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageModelCopyWith<MessageModel> get copyWith => _$MessageModelCopyWithImpl<MessageModel>(this as MessageModel, _$identity);

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.stickerUrl, stickerUrl) || other.stickerUrl == stickerUrl)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.senderProfile, senderProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,senderId,content,messageType,stickerUrl,const DeepCollectionEquality().hash(metadata),createdAt,const DeepCollectionEquality().hash(senderProfile));

@override
String toString() {
  return 'MessageModel(id: $id, roomId: $roomId, senderId: $senderId, content: $content, messageType: $messageType, stickerUrl: $stickerUrl, metadata: $metadata, createdAt: $createdAt, senderProfile: $senderProfile)';
}


}

/// @nodoc
abstract mixin class $MessageModelCopyWith<$Res>  {
  factory $MessageModelCopyWith(MessageModel value, $Res Function(MessageModel) _then) = _$MessageModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'sender_id') String senderId, String? content,@JsonKey(name: 'message_type') String messageType,@JsonKey(name: 'sticker_url') String? stickerUrl, Map<String, dynamic> metadata,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'sender_profile') Map<String, dynamic>? senderProfile
});




}
/// @nodoc
class _$MessageModelCopyWithImpl<$Res>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._self, this._then);

  final MessageModel _self;
  final $Res Function(MessageModel) _then;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomId = null,Object? senderId = null,Object? content = freezed,Object? messageType = null,Object? stickerUrl = freezed,Object? metadata = null,Object? createdAt = freezed,Object? senderProfile = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as String,stickerUrl: freezed == stickerUrl ? _self.stickerUrl : stickerUrl // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,senderProfile: freezed == senderProfile ? _self.senderProfile : senderProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageModel].
extension MessageModelPatterns on MessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageModel value)  $default,){
final _that = this;
switch (_that) {
case _MessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'sender_id')  String senderId,  String? content, @JsonKey(name: 'message_type')  String messageType, @JsonKey(name: 'sticker_url')  String? stickerUrl,  Map<String, dynamic> metadata, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'sender_profile')  Map<String, dynamic>? senderProfile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
return $default(_that.id,_that.roomId,_that.senderId,_that.content,_that.messageType,_that.stickerUrl,_that.metadata,_that.createdAt,_that.senderProfile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'sender_id')  String senderId,  String? content, @JsonKey(name: 'message_type')  String messageType, @JsonKey(name: 'sticker_url')  String? stickerUrl,  Map<String, dynamic> metadata, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'sender_profile')  Map<String, dynamic>? senderProfile)  $default,) {final _that = this;
switch (_that) {
case _MessageModel():
return $default(_that.id,_that.roomId,_that.senderId,_that.content,_that.messageType,_that.stickerUrl,_that.metadata,_that.createdAt,_that.senderProfile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'sender_id')  String senderId,  String? content, @JsonKey(name: 'message_type')  String messageType, @JsonKey(name: 'sticker_url')  String? stickerUrl,  Map<String, dynamic> metadata, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'sender_profile')  Map<String, dynamic>? senderProfile)?  $default,) {final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
return $default(_that.id,_that.roomId,_that.senderId,_that.content,_that.messageType,_that.stickerUrl,_that.metadata,_that.createdAt,_that.senderProfile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageModel implements MessageModel {
  const _MessageModel({required this.id, @JsonKey(name: 'room_id') required this.roomId, @JsonKey(name: 'sender_id') required this.senderId, this.content, @JsonKey(name: 'message_type') this.messageType = 'text', @JsonKey(name: 'sticker_url') this.stickerUrl, final  Map<String, dynamic> metadata = const {}, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'sender_profile') final  Map<String, dynamic>? senderProfile}): _metadata = metadata,_senderProfile = senderProfile;
  factory _MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'room_id') final  String roomId;
@override@JsonKey(name: 'sender_id') final  String senderId;
@override final  String? content;
@override@JsonKey(name: 'message_type') final  String messageType;
@override@JsonKey(name: 'sticker_url') final  String? stickerUrl;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
// Joined sender profile
 final  Map<String, dynamic>? _senderProfile;
// Joined sender profile
@override@JsonKey(name: 'sender_profile') Map<String, dynamic>? get senderProfile {
  final value = _senderProfile;
  if (value == null) return null;
  if (_senderProfile is EqualUnmodifiableMapView) return _senderProfile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageModelCopyWith<_MessageModel> get copyWith => __$MessageModelCopyWithImpl<_MessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.stickerUrl, stickerUrl) || other.stickerUrl == stickerUrl)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._senderProfile, _senderProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,senderId,content,messageType,stickerUrl,const DeepCollectionEquality().hash(_metadata),createdAt,const DeepCollectionEquality().hash(_senderProfile));

@override
String toString() {
  return 'MessageModel(id: $id, roomId: $roomId, senderId: $senderId, content: $content, messageType: $messageType, stickerUrl: $stickerUrl, metadata: $metadata, createdAt: $createdAt, senderProfile: $senderProfile)';
}


}

/// @nodoc
abstract mixin class _$MessageModelCopyWith<$Res> implements $MessageModelCopyWith<$Res> {
  factory _$MessageModelCopyWith(_MessageModel value, $Res Function(_MessageModel) _then) = __$MessageModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'sender_id') String senderId, String? content,@JsonKey(name: 'message_type') String messageType,@JsonKey(name: 'sticker_url') String? stickerUrl, Map<String, dynamic> metadata,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'sender_profile') Map<String, dynamic>? senderProfile
});




}
/// @nodoc
class __$MessageModelCopyWithImpl<$Res>
    implements _$MessageModelCopyWith<$Res> {
  __$MessageModelCopyWithImpl(this._self, this._then);

  final _MessageModel _self;
  final $Res Function(_MessageModel) _then;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomId = null,Object? senderId = null,Object? content = freezed,Object? messageType = null,Object? stickerUrl = freezed,Object? metadata = null,Object? createdAt = freezed,Object? senderProfile = freezed,}) {
  return _then(_MessageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as String,stickerUrl: freezed == stickerUrl ? _self.stickerUrl : stickerUrl // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,senderProfile: freezed == senderProfile ? _self._senderProfile : senderProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
