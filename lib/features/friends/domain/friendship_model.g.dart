// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendshipModel _$FriendshipModelFromJson(Map<String, dynamic> json) =>
    _FriendshipModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      friendId: json['friend_id'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      friendProfile: json['friend_profile'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FriendshipModelToJson(_FriendshipModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'friend_id': instance.friendId,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'friend_profile': instance.friendProfile,
    };
