-- ============================================================
-- Enable Supabase Realtime for Chat Tables
-- ============================================================

-- 1. Add tables to the supabase_realtime publication
-- This allows the .stream() method in the Flutter SDK to receive updates.

-- Enable Realtime for messages (critical for chat)
ALTER PUBLICATION supabase_realtime ADD TABLE messages;

-- Enable Realtime for profiles (useful for online status and location)
ALTER PUBLICATION supabase_realtime ADD TABLE profiles;

-- Enable Realtime for chat_rooms (useful for new room notifications)
ALTER PUBLICATION supabase_realtime ADD TABLE chat_rooms;

-- 2. Set replica identity to FULL for these tables
-- This ensures that the Realtime stream receives the full row data for all events (UPDATE/DELETE)
ALTER TABLE messages REPLICA IDENTITY FULL;
ALTER TABLE profiles REPLICA IDENTITY FULL;
ALTER TABLE chat_rooms REPLICA IDENTITY FULL;
