// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['displayName'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String?,
  bio: json['bio'] as String? ?? '',
  statusEmoji: json['statusEmoji'] as String? ?? '😊',
  statusText: json['statusText'] as String? ?? '',
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  locationUpdatedAt: json['locationUpdatedAt'] == null
      ? null
      : DateTime.parse(json['locationUpdatedAt'] as String),
  isOnline: json['isOnline'] as bool? ?? false,
  lastSeen: json['lastSeen'] == null
      ? null
      : DateTime.parse(json['lastSeen'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'statusEmoji': instance.statusEmoji,
      'statusText': instance.statusText,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'locationUpdatedAt': instance.locationUpdatedAt?.toIso8601String(),
      'isOnline': instance.isOnline,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
