import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data/chat_repository.dart';
import 'domain/chat_room_model.dart';

part 'chat_providers.g.dart';

/// List of chat rooms
@riverpod
Future<List<ChatRoomModel>> chatRoomsList(ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getChatRooms();
}

/// Stream messages for a specific room
@riverpod
Stream<List<Map<String, dynamic>>> messagesStream(ref, String roomId) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.streamMessages(roomId);
}

/// Chat actions notifier
@riverpod
class ChatActions extends _$ChatActions {
  @override
  FutureOr<void> build() {}

  Future<String?> getOrCreateDM(String otherUserId) async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      final roomId = await repo.getOrCreateDMRoom(otherUserId);
      ref.invalidate(chatRoomsListProvider);
      return roomId;
    } catch (e) {
      return null;
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
