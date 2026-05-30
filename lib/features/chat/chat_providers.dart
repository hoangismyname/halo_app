import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data/chat_repository.dart';
import 'dart:developer' as dev;
import 'domain/chat_room_model.dart';

part 'chat_providers.g.dart';

/// List of chat rooms
@riverpod
Future<List<ChatRoomModel>> chatRoomsList(Ref ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getChatRooms();
}

/// List of chat rooms with last message info
@riverpod
Future<List<Map<String, dynamic>>> chatRoomsWithLastMessage(Ref ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getChatRoomsWithLastMessage();
}

// ---------------------------------------------------------------------------
// Paginated messages notifier (replaces messagesStream)
// ---------------------------------------------------------------------------

/// Number of messages loaded per page.
const int _kPageSize = 30;

/// Manages paginated message loading + realtime inserts for a single room.
///
/// - `build()`: fetches the most recent [_kPageSize] messages and subscribes
///   to realtime INSERT events.
/// - `loadMore()`: fetches the next [_kPageSize] older messages and prepends
///   them to the current state.
/// - Realtime inserts are appended to the end of the list automatically.
@riverpod
class ChatRoomMessages extends _$ChatRoomMessages {
  RealtimeChannel? _realtimeChannel;
  bool _hasMore = true;

  /// Whether there are more older messages available to load.
  bool get hasMore => _hasMore;

  @override
  Future<List<Map<String, dynamic>>> build(String roomId) async {
    final repo = ref.read(chatRepositoryProvider);

    // Subscribe to realtime new message inserts
    _realtimeChannel = repo.subscribeNewMessages(roomId, _onNewMessage);

    // Cleanup subscription when provider is disposed
    ref.onDispose(() {
      _realtimeChannel?.unsubscribe();
      _realtimeChannel = null;
    });

    // Fetch initial page (most recent messages)
    final messages = await repo.fetchMessages(roomId, limit: _kPageSize);
    _hasMore = messages.length >= _kPageSize;
    return messages;
  }

  /// Load more older messages (pagination).
  ///
  /// Returns `true` if more messages may be available, `false` if we've
  /// reached the beginning of the conversation.
  Future<bool> loadMore() async {
    if (!_hasMore) return false;

    if (!state.hasValue) return false;
    final currentMessages = state.value;
    if (currentMessages == null || currentMessages.isEmpty) return false;

    // Use the oldest message's timestamp as the cursor
    final oldestTimestamp = currentMessages.first['created_at'] as String?;
    if (oldestTimestamp == null) return false;

    final before = DateTime.parse(oldestTimestamp);
    final repo = ref.read(chatRepositoryProvider);
    final olderMessages = await repo.fetchMessages(
      roomId,
      limit: _kPageSize,
      before: before,
    );

    _hasMore = olderMessages.length >= _kPageSize;

    if (olderMessages.isNotEmpty) {
      // Prepend older messages to the beginning
      state = AsyncData([...olderMessages, ...currentMessages]);
    }

    return _hasMore;
  }

  /// Called when a new message is inserted via realtime subscription.
  void _onNewMessage(Map<String, dynamic> newMessage) {
    if (!state.hasValue) return;
    final currentMessages = state.value;
    if (currentMessages == null) return;

    // Check for duplicate (by id) to be safe
    final newId = newMessage['id'] as String?;
    if (newId != null &&
        currentMessages.any((m) => m['id'] == newId)) {
      return;
    }

    // Append new message to the end
    state = AsyncData([...currentMessages, newMessage]);
  }

  /// Manually add a message to the local state (optimistic update).
  void addLocalMessage(Map<String, dynamic> message) {
    if (!state.hasValue) return;
    final currentMessages = state.value;
    if (currentMessages == null) return;
    state = AsyncData([...currentMessages, message]);
  }
}

/// Chat actions notifier
@riverpod
class ChatActions extends _$ChatActions {
  @override
  FutureOr<void> build() {}

  Future<String?> getOrCreateDM(String otherUserId) async {
    final link = ref.keepAlive();
    try {
      final repo = ref.read(chatRepositoryProvider);
      final roomId = await repo.getOrCreateDMRoom(otherUserId);
      ref.invalidate(chatRoomsListProvider);
      return roomId;
    } catch (e, st) {
      dev.log('getOrCreateDM error: $e\n$st');
      rethrow;
    } finally {
      link.close();
    }
  }

  Future<void> sendMessage({
    required String roomId,
    required String content,
  }) async {
    final repo = ref.read(chatRepositoryProvider);
    await repo.sendMessage(roomId: roomId, content: content);
  }

  Future<void> sendSticker({
    required String roomId,
    required String stickerUrl,
  }) async {
    final repo = ref.read(chatRepositoryProvider);
    await repo.sendSticker(roomId: roomId, stickerUrl: stickerUrl);
  }

  Future<void> sendLocation({
    required String roomId,
    required double latitude,
    required double longitude,
  }) async {
    final repo = ref.read(chatRepositoryProvider);
    await repo.sendLocation(
        roomId: roomId, latitude: latitude, longitude: longitude);
  }
}
