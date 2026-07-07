import 'env.dart';

/// Supabase configuration - loads url and anonKey from shared Env singleton
class SupabaseConstants {
  SupabaseConstants._();

  static String get url => Env.get('SUPABASE_URL');

  static String get anonKey => Env.get('SUPABASE_ANON_KEY');

  // Table names
  static const String profilesTable = 'profiles';
  static const String friendshipsTable = 'friendships';
  static const String chatRoomsTable = 'chat_rooms';
  static const String chatRoomMembersTable = 'chat_room_members';
  static const String messagesTable = 'messages';
  static const String stickerPacksTable = 'sticker_packs';
  static const String stickersTable = 'stickers';

  // Storage buckets
  static const String avatarsBucket = 'avatars';
  static const String stickersBucket = 'stickers';

  // Realtime channels
  static const String locationChannel = 'location-updates';
  static const String typingChannel = 'typing-indicators';
}
