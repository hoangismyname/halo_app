// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String?,
      messageType: json['message_type'] as String? ?? 'text',
      stickerUrl: json['sticker_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      senderProfile: json['sender_profile'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'sender_id': instance.senderId,
      'content': instance.content,
      'message_type': instance.messageType,
      'sticker_url': instance.stickerUrl,
      'metadata': instance.metadata,
      'created_at': instance.createdAt?.toIso8601String(),
      'sender_profile': instance.senderProfile,
    };
