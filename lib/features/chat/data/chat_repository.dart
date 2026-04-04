import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';
import '../domain/chat_room_model.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  String? get _userId => _client.auth.currentUser?.id;

  /// Get all chat rooms for current user
  Future<List<ChatRoomModel>> getChatRooms() async {
    if (_userId == null) return [];

    final data = await _client
        .from(SupabaseConstants.chatRoomMembersTable)
        .select('room_id, chat_rooms(*)')
        .eq('user_id', _userId!);

    final rooms = <ChatRoomModel>[];
    for (final row in data) {
      final room = row['chat_rooms'] as Map<String, dynamic>?;
      if (room != null) {
        rooms.add(ChatRoomModel.fromJson(room));
      }
    }
    return rooms;
  }

  /// Create or get existing DM room
  Future<String> getOrCreateDMRoom(String otherUserId) async {
    if (_userId == null) throw Exception('Not authenticated');

    // Check if DM already exists
    final myRooms = await _client
        .from(SupabaseConstants.chatRoomMembersTable)
        .select('room_id')
        .eq('user_id', _userId!);

    final otherRooms = await _client
        .from(SupabaseConstants.chatRoomMembersTable)
        .select('room_id')
        .eq('user_id', otherUserId);

    final myRoomIds = myRooms.map((r) => r['room_id'] as String).toSet();
    final otherRoomIds = otherRooms.map((r) => r['room_id'] as String).toSet();
    final commonRoomIds = myRoomIds.intersection(otherRoomIds);

    if (commonRoomIds.isNotEmpty) {
      // Verify it's a DM (not group)
      for (final roomId in commonRoomIds) {
        final room = await _client
            .from(SupabaseConstants.chatRoomsTable)
            .select()
            .eq('id', roomId)
            .eq('is_group', false)
            .maybeSingle();
        if (room != null) return roomId;
      }
    }

    // Create new DM room
    final newRoom = await _client
        .from(SupabaseConstants.chatRoomsTable)
        .insert({
          'is_group': false,
          'created_by': _userId!,
        })
        .select()
        .single();

    final roomId = newRoom['id'] as String;

    // Add both members
    await _client.from(SupabaseConstants.chatRoomMembersTable).insert([
      {'room_id': roomId, 'user_id': _userId!},
      {'room_id': roomId, 'user_id': otherUserId},
    ]);

    return roomId;
  }

  /// Stream messages for a room
  Stream<List<Map<String, dynamic>>> streamMessages(String roomId) {
    return _client
        .from(SupabaseConstants.messagesTable)
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at');
  }

  /// Send a text message
  Future<void> sendMessage({
    required String roomId,
    required String content,
    String messageType = 'text',
    String? stickerUrl,
    Map<String, dynamic>? metadata,
  }) async {
    if (_userId == null) return;

    await _client.from(SupabaseConstants.messagesTable).insert({
      'room_id': roomId,
      'sender_id': _userId!,
      'content': content,
      'message_type': messageType,
      'sticker_url': stickerUrl,
      'metadata': metadata ?? {},
    });
  }

  /// Send a sticker
  Future<void> sendSticker({
    required String roomId,
    required String stickerUrl,
  }) async {
    await sendMessage(
      roomId: roomId,
      content: '🎨 Sticker',
      messageType: 'sticker',
      stickerUrl: stickerUrl,
    );
  }

  /// Send current location
  Future<void> sendLocation({
    required String roomId,
    required double latitude,
    required double longitude,
  }) async {
    await sendMessage(
      roomId: roomId,
      content: '📍 Vị trí',
      messageType: 'location',
      metadata: {'latitude': latitude, 'longitude': longitude},
    );
  }

  /// Subscribe to typing indicators via broadcast
  RealtimeChannel subscribeTyping(
      String roomId, void Function(Map<String, dynamic>) onTyping) {
    final channel = _client.channel('typing-$roomId');
    channel
        .onBroadcast(
          event: 'typing',
          callback: (payload) => onTyping(payload),
        )
        .subscribe();
    return channel;
  }

  /// Broadcast typing indicator
  Future<void> broadcastTyping(String roomId) async {
    final channel = _client.channel('typing-$roomId');
    await channel.sendBroadcastMessage(
      event: 'typing',
      payload: {
        'user_id': _userId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Get room members with profiles
  Future<List<Map<String, dynamic>>> getRoomMembers(String roomId) async {
    final data = await _client
        .from(SupabaseConstants.chatRoomMembersTable)
        .select('*, profiles(*)')
        .eq('room_id', roomId);
    return List<Map<String, dynamic>>.from(data);
  }
}

@riverpod
ChatRepository chatRepository(ref) {
  return ChatRepository(Supabase.instance.client);
}
