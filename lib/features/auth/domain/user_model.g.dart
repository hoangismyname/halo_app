// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['display_name'] as String? ?? '',
  avatarUrl: json['avatar_url'] as String?,
  bio: json['bio'] as String? ?? '',
  statusEmoji: json['status_emoji'] as String? ?? '😊',
  statusText: json['status_text'] as String? ?? '',
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  locationUpdatedAt: json['location_updated_at'] == null
      ? null
      : DateTime.parse(json['location_updated_at'] as String),
  isOnline: json['is_online'] as bool? ?? false,
  lastSeen: json['last_seen'] == null
      ? null
      : DateTime.parse(json['last_seen'] as String),
  isLocationShared: json['is_location_shared'] as bool? ?? true,
  locationPrecision: json['location_precision'] as String? ?? 'absolute',
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'status_emoji': instance.statusEmoji,
      'status_text': instance.statusText,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location_updated_at': instance.locationUpdatedAt?.toIso8601String(),
      'is_online': instance.isOnline,
      'last_seen': instance.lastSeen?.toIso8601String(),
      'is_location_shared': instance.isLocationShared,
      'location_precision': instance.locationPrecision,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
