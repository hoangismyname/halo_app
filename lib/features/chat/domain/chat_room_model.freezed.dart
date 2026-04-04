// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoomModel {

 String get id; String? get name;@JsonKey(name: 'is_group') bool get isGroup;@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'created_at') DateTime? get createdAt;// Joined data
@JsonKey(name: 'last_message') Map<String, dynamic>? get lastMessage; List<Map<String, dynamic>> get members;@JsonKey(name: 'unread_count') int get unreadCount;
/// Create a copy of ChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomModelCopyWith<ChatRoomModel> get copyWith => _$ChatRoomModelCopyWithImpl<ChatRoomModel>(this as ChatRoomModel, _$identity);

  /// Serializes this ChatRoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isGroup, isGroup) || other.isGroup == isGroup)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.lastMessage, lastMessage)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isGroup,createdBy,createdAt,const DeepCollectionEquality().hash(lastMessage),const DeepCollectionEquality().hash(members),unreadCount);

@override
String toString() {
  return 'ChatRoomModel(id: $id, name: $name, isGroup: $isGroup, createdBy: $createdBy, createdAt: $createdAt, lastMessage: $lastMessage, members: $members, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class $ChatRoomModelCopyWith<$Res>  {
  factory $ChatRoomModelCopyWith(ChatRoomModel value, $Res Function(ChatRoomModel) _then) = _$ChatRoomModelCopyWithImpl;
@useResult
$Res call({
 String id, String? name,@JsonKey(name: 'is_group') bool isGroup,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'last_message') Map<String, dynamic>? lastMessage, List<Map<String, dynamic>> members,@JsonKey(name: 'unread_count') int unreadCount
});




}
/// @nodoc
class _$ChatRoomModelCopyWithImpl<$Res>
    implements $ChatRoomModelCopyWith<$Res> {
  _$ChatRoomModelCopyWithImpl(this._self, this._then);

  final ChatRoomModel _self;
  final $Res Function(ChatRoomModel) _then;

/// Create a copy of ChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? isGroup = null,Object? createdBy = freezed,Object? createdAt = freezed,Object? lastMessage = freezed,Object? members = null,Object? unreadCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isGroup: null == isGroup ? _self.isGroup : isGroup // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRoomModel].
extension ChatRoomModelPatterns on ChatRoomModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomModel value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name, @JsonKey(name: 'is_group')  bool isGroup, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_message')  Map<String, dynamic>? lastMessage,  List<Map<String, dynamic>> members, @JsonKey(name: 'unread_count')  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomModel() when $default != null:
return $default(_that.id,_that.name,_that.isGroup,_that.createdBy,_that.createdAt,_that.lastMessage,_that.members,_that.unreadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name, @JsonKey(name: 'is_group')  bool isGroup, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_message')  Map<String, dynamic>? lastMessage,  List<Map<String, dynamic>> members, @JsonKey(name: 'unread_count')  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomModel():
return $default(_that.id,_that.name,_that.isGroup,_that.createdBy,_that.createdAt,_that.lastMessage,_that.members,_that.unreadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name, @JsonKey(name: 'is_group')  bool isGroup, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_message')  Map<String, dynamic>? lastMessage,  List<Map<String, dynamic>> members, @JsonKey(name: 'unread_count')  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomModel() when $default != null:
return $default(_that.id,_that.name,_that.isGroup,_that.createdBy,_that.createdAt,_that.lastMessage,_that.members,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomModel implements ChatRoomModel {
  const _ChatRoomModel({required this.id, this.name, @JsonKey(name: 'is_group') this.isGroup = false, @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'last_message') final  Map<String, dynamic>? lastMessage, final  List<Map<String, dynamic>> members = const [], @JsonKey(name: 'unread_count') this.unreadCount = 0}): _lastMessage = lastMessage,_members = members;
  factory _ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);

@override final  String id;
@override final  String? name;
@override@JsonKey(name: 'is_group') final  bool isGroup;
@override@JsonKey(name: 'created_by') final  String? createdBy;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
// Joined data
 final  Map<String, dynamic>? _lastMessage;
// Joined data
@override@JsonKey(name: 'last_message') Map<String, dynamic>? get lastMessage {
  final value = _lastMessage;
  if (value == null) return null;
  if (_lastMessage is EqualUnmodifiableMapView) return _lastMessage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<Map<String, dynamic>> _members;
@override@JsonKey() List<Map<String, dynamic>> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

@override@JsonKey(name: 'unread_count') final  int unreadCount;

/// Create a copy of ChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomModelCopyWith<_ChatRoomModel> get copyWith => __$ChatRoomModelCopyWithImpl<_ChatRoomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isGroup, isGroup) || other.isGroup == isGroup)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._lastMessage, _lastMessage)&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isGroup,createdBy,createdAt,const DeepCollectionEquality().hash(_lastMessage),const DeepCollectionEquality().hash(_members),unreadCount);

@override
String toString() {
  return 'ChatRoomModel(id: $id, name: $name, isGroup: $isGroup, createdBy: $createdBy, createdAt: $createdAt, lastMessage: $lastMessage, members: $members, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomModelCopyWith<$Res> implements $ChatRoomModelCopyWith<$Res> {
  factory _$ChatRoomModelCopyWith(_ChatRoomModel value, $Res Function(_ChatRoomModel) _then) = __$ChatRoomModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name,@JsonKey(name: 'is_group') bool isGroup,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'last_message') Map<String, dynamic>? lastMessage, List<Map<String, dynamic>> members,@JsonKey(name: 'unread_count') int unreadCount
});




}
/// @nodoc
class __$ChatRoomModelCopyWithImpl<$Res>
    implements _$ChatRoomModelCopyWith<$Res> {
  __$ChatRoomModelCopyWithImpl(this._self, this._then);

  final _ChatRoomModel _self;
  final $Res Function(_ChatRoomModel) _then;

/// Create a copy of ChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? isGroup = null,Object? createdBy = freezed,Object? createdAt = freezed,Object? lastMessage = freezed,Object? members = null,Object? unreadCount = null,}) {
  return _then(_ChatRoomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isGroup: null == isGroup ? _self.isGroup : isGroup // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessage: freezed == lastMessage ? _self._lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
