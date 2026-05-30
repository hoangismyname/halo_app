import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';
import '../domain/chat_room_model.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final SupabaseClient _client;

  /// In-memory cache: otherUserId → roomId for DM rooms.
  /// Survives as long as the repository instance lives (keepAlive provider).
  final Map<String, String> _dmCache = {};

  ChatRepository(this._client);

  String? get _userId => _client.auth.currentUser?.id;

  /// Get all chat rooms for current user
  Future<List<ChatRoomModel>> getChatRooms() async {
    final uid = _userId;
    if (uid == null) return [];

    final data = await _client
        .from(SupabaseConstants.chatRoomMembersTable)
        .select('room_id, chat_rooms(*)')
        .eq('user_id', uid);

    final rooms = <ChatRoomModel>[];
    for (final row in data) {
      final room = row['chat_rooms'] as Map<String, dynamic>?;
      if (room != null) {
        rooms.add(ChatRoomModel.fromJson(room));
      }
    }
    return rooms;
  }

  /// Get all chat rooms with last message info, sorted by most recent activity.
  ///
  /// Wraps each room query in try/catch so a single failure doesn't crash
  /// the entire list. Rooms that fail to fetch metadata are skipped gracefully.
  Future<List<Map<String, dynamic>>> getChatRoomsWithLastMessage() async {
    final uid = _userId;
    if (uid == null) return [];

    // Get all rooms the user is a member of
    final memberships = await _client
        .from(SupabaseConstants.chatRoomMembersTable)
        .select('room_id, chat_rooms(*)')
        .eq('user_id', uid);

    final results = <Map<String, dynamic>>[];
    for (final row in memberships) {
      try {
        final room = row['chat_rooms'] as Map<String, dynamic>?;
        if (room == null) continue;

        final roomId = room['id'] as String;

        // Get last message for this room (single query, not stream)
        final lastMsgData = await _client
            .from(SupabaseConstants.messagesTable)
            .select('content, message_type, created_at, sender_id')
            .eq('room_id', roomId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        // Get other member profiles for DM room name
        final members = await _client
            .from(SupabaseConstants.chatRoomMembersTable)
            .select('user_id, profiles(*)')
            .eq('room_id', roomId)
            .neq('user_id', uid);

        String? otherName;
        String? otherAvatar;
        bool otherOnline = false;
        if (members.isNotEmpty) {
          final profile = members.first['profiles'] as Map<String, dynamic>?;
          if (profile != null) {
            otherName =
                profile['display_name'] as String? ??
                profile['username'] as String?;
            otherAvatar = profile['avatar_url'] as String?;
            otherOnline = profile['is_online'] as bool? ?? false;
          }
        }

        results.add({
          'room': ChatRoomModel.fromJson(room),
          'last_message': lastMsgData?['content'] as String?,
          'last_message_type': lastMsgData?['message_type'] as String?,
          'last_message_time': lastMsgData?['created_at'] as String?,
          'other_name': otherName ?? room['name'] ?? 'Chat',
          'other_avatar': otherAvatar,
          'other_online': otherOnline,
        });
      } catch (e) {
        debugPrint('Skipping room due to error: $e');
        // Skip this room but continue processing others
      }
    }

    // Sort by last message time, newest first
    results.sort((a, b) {
      final aTime = a['last_message_time'] as String?;
      final bTime = b['last_message_time'] as String?;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime);
    });

    return results;
  }

  /// Create or get existing DM room.
  ///
  /// Uses an in-memory cache so repeated lookups for the same friend
  /// return instantly without any network round-trip.
  Future<String> getOrCreateDMRoom(String otherUserId) async {
    // Fast path: return cached room ID
    final cached = _dmCache[otherUserId];
    if (cached != null) return cached;

    final uid = _userId;
    if (uid == null) throw Exception('Not authenticated');

    // Check if DM already exists by querying rooms where both users are members
    final myRooms = await _client
        .from(SupabaseConstants.chatRoomMembersTable)
        .select('room_id')
        .eq('user_id', uid);

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
        if (room != null) {
          _dmCache[otherUserId] = roomId;
          return roomId;
        }
      }
    }

    // Generate UUID client-side to bypass RLS select() issues
    final roomId = const Uuid().v4();

    // Create new DM room without .select()
    await _client
        .from(SupabaseConstants.chatRoomsTable)
        .insert({'id': roomId, 'is_group': false, 'created_by': uid});

    // Add members sequentially.
    // We add the current user first so they become a member, satisfying the RLS policy
    // for chat_rooms, which then allows the second insert to succeed.
    await _client.from(SupabaseConstants.chatRoomMembersTable).insert({
      'room_id': roomId, 'user_id': uid,
    });

    await _client.from(SupabaseConstants.chatRoomMembersTable).insert({
      'room_id': roomId, 'user_id': otherUserId,
    });

    _dmCache[otherUserId] = roomId;
    return roomId;
  }

  /// Stream messages for a room in real-time.
  ///
  /// @deprecated Use [fetchMessages] + [subscribeNewMessages] instead.
  /// This fetches ALL rows before listening, causing slow load on rooms
  /// with many messages.
  Stream<List<Map<String, dynamic>>> streamMessages(String roomId) {
    return _client
        .from(SupabaseConstants.messagesTable)
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: true);
  }

  /// Fetch a page of messages for [roomId], ordered newest-first.
  ///
  /// - [limit]: number of messages per page (default 30).
  /// - [before]: if provided, fetches messages created before this timestamp
  ///   (for "load more" pagination).
  ///
  /// Returns messages sorted ascending (oldest first) so the UI can
  /// prepend them naturally.
  Future<List<Map<String, dynamic>>> fetchMessages(
    String roomId, {
    int limit = 30,
    DateTime? before,
  }) async {
    var query = _client
        .from(SupabaseConstants.messagesTable)
        .select()
        .eq('room_id', roomId);

    if (before != null) {
      query = query.lt('created_at', before.toUtc().toIso8601String());
    }

    final data = await query
        .order('created_at', ascending: false)
        .limit(limit);

    // Reverse so messages are oldest-first for the UI
    return List<Map<String, dynamic>>.from(data.reversed);
  }

  /// Subscribe to new message inserts for [roomId] via Supabase Realtime.
  ///
  /// Returns the [RealtimeChannel] so the caller can unsubscribe on dispose.
  /// Only listens for INSERT events — much lighter than `.stream()` which
  /// re-fetches all matching rows.
  RealtimeChannel subscribeNewMessages(
    String roomId,
    void Function(Map<String, dynamic> newMessage) onInsert,
  ) {
    final channel = _client.channel('messages-$roomId');
    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: SupabaseConstants.messagesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: roomId,
          ),
          callback: (payload) {
            final newRecord = payload.newRecord;
            onInsert(newRecord);
          },
        )
        .subscribe();
    return channel;
  }

  /// Send a text message
  Future<void> sendMessage({
    required String roomId,
    required String content,
    String messageType = 'text',
    String? stickerUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final uid = _userId;
    if (uid == null) return;

    await _client.from(SupabaseConstants.messagesTable).insert({
      'room_id': roomId,
      'sender_id': uid,
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
    String roomId,
    void Function(Map<String, dynamic>) onTyping,
  ) {
    final channel = _client.channel('typing-$roomId');
    channel
        .onBroadcast(event: 'typing', callback: (payload) => onTyping(payload))
        .subscribe();
    return channel;
  }

  /// Broadcast typing indicator
  Future<void> broadcastTyping(String roomId) async {
    final uid = _userId;
    if (uid == null) return;

    final channel = _client.channel('typing-$roomId');
    await channel.sendBroadcastMessage(
      event: 'typing',
      payload: {
        'user_id': uid,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
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

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(Supabase.instance.client);
}
