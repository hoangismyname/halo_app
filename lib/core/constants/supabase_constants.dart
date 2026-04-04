/// Supabase configuration - Replace with your actual project credentials
class SupabaseConstants {
  SupabaseConstants._();

  // TODO(Project Phase 2): Thay thế hai giá trị dưới đây bằng URL và Public Anon Key thật từ Supabase Project của bạn.
  static const String url = 'https://YOUR_PROJECT_ID.supabase.co';

  // TODO: Replace with your Supabase anon key
  static const String anonKey = 'YOUR_ANON_KEY';

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
