import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    @JsonKey(name: 'room_id') required String roomId,
    @JsonKey(name: 'sender_id') required String senderId,
    String? content,
    @Default('text') @JsonKey(name: 'message_type') String messageType,
    @JsonKey(name: 'sticker_url') String? stickerUrl,
    @Default({}) Map<String, dynamic> metadata,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Joined sender profile
    @JsonKey(name: 'sender_profile') Map<String, dynamic>? senderProfile,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
