import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_model.freezed.dart';
part 'chat_room_model.g.dart';

@freezed
abstract class ChatRoomModel with _$ChatRoomModel {
  const factory ChatRoomModel({
    required String id,
    String? name,
    @Default(false) @JsonKey(name: 'is_group') bool isGroup,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Joined data
    @JsonKey(name: 'last_message') Map<String, dynamic>? lastMessage,
    @Default([]) List<Map<String, dynamic>> members,
    @Default(0) @JsonKey(name: 'unread_count') int unreadCount,
  }) = _ChatRoomModel;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);
}
