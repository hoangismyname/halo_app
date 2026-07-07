-- ============================================================
-- Halo App - Initial Database Schema
-- ============================================================
-- A location-based social network with real-time features:
-- user profiles, friendships, chat rooms, messages, stickers,
-- and location sharing via Supabase Realtime broadcast.
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- 1. PROFILES TABLE
-- Extended user data linked 1:1 with auth.users
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id                UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username          TEXT NOT NULL UNIQUE,
  display_name      TEXT NOT NULL DEFAULT '',
  avatar_url        TEXT,
  bio               TEXT NOT NULL DEFAULT '',
  status_emoji      TEXT NOT NULL DEFAULT '😊',
  status_text       TEXT NOT NULL DEFAULT '',
  latitude          DOUBLE PRECISION,
  longitude         DOUBLE PRECISION,
  location_updated_at TIMESTAMPTZ,
  is_online         BOOLEAN NOT NULL DEFAULT FALSE,
  last_seen         TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.profiles IS 'Extended user profile data, 1:1 with auth.users';

-- ─────────────────────────────────────────────────────────────
-- 2. FRIENDSHIPS TABLE
-- Self-referencing friendship / friend-request join table
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.friendships (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  friend_id   UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  status      TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT friendships_user_not_self CHECK (user_id <> friend_id)
);

COMMENT ON TABLE public.friendships IS 'Friendship requests and accepted friendships between users';

-- ─────────────────────────────────────────────────────────────
-- 3. CHAT ROOMS TABLE
-- Direct message (1:1) and group chat rooms
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.chat_rooms (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT,
  is_group    BOOLEAN NOT NULL DEFAULT FALSE,
  created_by  UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.chat_rooms IS 'Chat rooms for DMs and group conversations';

-- ─────────────────────────────────────────────────────────────
-- 4. CHAT ROOM MEMBERS TABLE
-- Join table linking users to chat rooms
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.chat_room_members (
  id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,

  CONSTRAINT chat_room_members_unique_room_user UNIQUE (room_id, user_id)
);

COMMENT ON TABLE public.chat_room_members IS 'Membership mapping between users and chat rooms';

-- ─────────────────────────────────────────────────────────────
-- 5. MESSAGES TABLE
-- Individual chat messages within a room
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.messages (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id       UUID NOT NULL REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
  sender_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  content       TEXT,
  message_type  TEXT NOT NULL DEFAULT 'text' CHECK (message_type IN ('text', 'sticker', 'location')),
  sticker_url   TEXT,
  metadata      JSONB NOT NULL DEFAULT '{}',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.messages IS 'Chat messages within rooms, supports text/sticker/location types';

-- ─────────────────────────────────────────────────────────────
-- 6. STICKER PACKS TABLE (reserved for future feature)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.sticker_packs (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL,
  description   TEXT,
  cover_url     TEXT,
  is_premium    BOOLEAN NOT NULL DEFAULT FALSE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.sticker_packs IS 'Sticker pack metadata';

-- ─────────────────────────────────────────────────────────────
-- 7. STICKERS TABLE (reserved for future feature)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.stickers (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pack_id     UUID REFERENCES public.sticker_packs(id) ON DELETE CASCADE,
  url         TEXT NOT NULL,
  tags        TEXT[],
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.stickers IS 'Individual stickers within packs';

-- ============================================================
-- INDEXES
-- ============================================================

-- Profiles
CREATE INDEX IF NOT EXISTS idx_profiles_username ON public.profiles (username);
CREATE INDEX IF NOT EXISTS idx_profiles_location ON public.profiles (latitude, longitude)
  WHERE latitude IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_profiles_online ON public.profiles (is_online);

-- Friendships
CREATE INDEX IF NOT EXISTS idx_friendships_user_id ON public.friendships (user_id);
CREATE INDEX IF NOT EXISTS idx_friendships_friend_id ON public.friendships (friend_id);
CREATE INDEX IF NOT EXISTS idx_friendships_status ON public.friendships (status);
CREATE UNIQUE INDEX IF NOT EXISTS idx_friendships_unique_pair ON public.friendships (user_id, friend_id);

-- Chat rooms
CREATE INDEX IF NOT EXISTS idx_chat_rooms_created_by ON public.chat_rooms (created_by);
CREATE INDEX IF NOT EXISTS idx_chat_rooms_is_group ON public.chat_rooms (is_group);

-- Chat room members
CREATE INDEX IF NOT EXISTS idx_chat_room_members_room_id ON public.chat_room_members (room_id);
CREATE INDEX IF NOT EXISTS idx_chat_room_members_user_id ON public.chat_room_members (user_id);

-- Messages
CREATE INDEX IF NOT EXISTS idx_messages_room_id ON public.messages (room_id);
CREATE INDEX IF NOT EXISTS idx_messages_room_created ON public.messages (room_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON public.messages (sender_id);

-- Stickers
CREATE INDEX IF NOT EXISTS idx_stickers_pack_id ON public.stickers (pack_id);

-- ============================================================
-- TRIGGERS
-- ============================================================

-- Trigger: auto-create profile when a new user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, username, display_name, created_at, updated_at)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1)),
    NOW(),
    NOW()
  );
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Trigger: auto-update updated_at on profiles
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS set_profiles_updated_at ON public.profiles;
CREATE TRIGGER set_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================
-- RLS is enabled on every table in the public schema.
-- Policies match the actual access patterns used by the app.

-- ── Profiles ──
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Anyone authenticated can view all profiles
CREATE POLICY "profiles_select_all_authenticated"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (TRUE);

-- Users can insert only their own profile (used during sign-up)
CREATE POLICY "profiles_insert_own"
  ON public.profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Users can update only their own profile
CREATE POLICY "profiles_update_own"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ── Friendships ──
ALTER TABLE public.friendships ENABLE ROW LEVEL SECURITY;

-- Users can see friendships where they are either party
CREATE POLICY "friendships_select_involved"
  ON public.friendships FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id OR auth.uid() = friend_id);

-- Users can create friendships as the sender
CREATE POLICY "friendships_insert_as_sender"
  ON public.friendships FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Users can accept requests (update status) as the recipient
CREATE POLICY "friendships_update_as_recipient"
  ON public.friendships FOR UPDATE
  TO authenticated
  USING (auth.uid() = friend_id)
  WITH CHECK (auth.uid() = friend_id);

-- Users can delete friendships where they are either party
CREATE POLICY "friendships_delete_involved"
  ON public.friendships FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id OR auth.uid() = friend_id);

-- ── Chat Rooms ──
ALTER TABLE public.chat_rooms ENABLE ROW LEVEL SECURITY;

-- Users can see rooms they are members of
CREATE POLICY "chat_rooms_select_members"
  ON public.chat_rooms FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.chat_room_members crm
      WHERE crm.room_id = id AND crm.user_id = auth.uid()
    )
  );

-- Any authenticated user can create a room
CREATE POLICY "chat_rooms_insert_any"
  ON public.chat_rooms FOR INSERT
  TO authenticated
  WITH CHECK (TRUE);

-- Only the creator can update room settings
CREATE POLICY "chat_rooms_update_creator"
  ON public.chat_rooms FOR UPDATE
  TO authenticated
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

-- Only the creator can delete a room
CREATE POLICY "chat_rooms_delete_creator"
  ON public.chat_rooms FOR DELETE
  TO authenticated
  USING (auth.uid() = created_by);

-- ── Chat Room Members ──
ALTER TABLE public.chat_room_members ENABLE ROW LEVEL SECURITY;

-- Users can see members of rooms they belong to
CREATE POLICY "chat_room_members_select_members"
  ON public.chat_room_members FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.chat_room_members crm2
      WHERE crm2.room_id = room_id AND crm2.user_id = auth.uid()
    )
  );

-- Users can add themselves or room creators can add others
CREATE POLICY "chat_room_members_insert_self_or_creator"
  ON public.chat_room_members FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id
    OR EXISTS (
      SELECT 1 FROM public.chat_rooms cr
      WHERE cr.id = room_id AND cr.created_by = auth.uid()
    )
  );

-- Users can remove themselves from rooms
CREATE POLICY "chat_room_members_delete_self"
  ON public.chat_room_members FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ── Messages ──
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Users can read messages from rooms they are members of
CREATE POLICY "messages_select_room_members"
  ON public.messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.chat_room_members crm
      WHERE crm.room_id = room_id AND crm.user_id = auth.uid()
    )
  );

-- Users can send messages to rooms they are members of
-- Note: UPDATE requires SELECT policy first (Postgres requirement)
CREATE POLICY "messages_insert_room_members"
  ON public.messages FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.chat_room_members crm
      WHERE crm.room_id = room_id AND crm.user_id = auth.uid()
    )
  );

-- Users can update only their own messages
CREATE POLICY "messages_update_own"
  ON public.messages FOR UPDATE
  TO authenticated
  USING (auth.uid() = sender_id)
  WITH CHECK (auth.uid() = sender_id);

-- Users can delete only their own messages
CREATE POLICY "messages_delete_own"
  ON public.messages FOR DELETE
  TO authenticated
  USING (auth.uid() = sender_id);

-- ── Sticker Packs ──
ALTER TABLE public.sticker_packs ENABLE ROW LEVEL SECURITY;

-- All authenticated users can browse sticker packs
CREATE POLICY "sticker_packs_select_all"
  ON public.sticker_packs FOR SELECT
  TO authenticated
  USING (TRUE);

-- Admin-only insert/update/delete (future admin role)
-- For now, allow any authenticated user (will be tightened later)
CREATE POLICY "sticker_packs_insert_authenticated"
  ON public.sticker_packs FOR INSERT
  TO authenticated
  WITH CHECK (TRUE);

CREATE POLICY "sticker_packs_update_authenticated"
  ON public.sticker_packs FOR UPDATE
  TO authenticated
  USING (TRUE)
  WITH CHECK (TRUE);

CREATE POLICY "sticker_packs_delete_authenticated"
  ON public.sticker_packs FOR DELETE
  TO authenticated
  USING (TRUE);

-- ── Stickers ──
ALTER TABLE public.stickers ENABLE ROW LEVEL SECURITY;

-- All authenticated users can browse stickers
CREATE POLICY "stickers_select_all"
  ON public.stickers FOR SELECT
  TO authenticated
  USING (TRUE);

CREATE POLICY "stickers_insert_authenticated"
  ON public.stickers FOR INSERT
  TO authenticated
  WITH CHECK (TRUE);

CREATE POLICY "stickers_update_authenticated"
  ON public.stickers FOR UPDATE
  TO authenticated
  USING (TRUE)
  WITH CHECK (TRUE);

CREATE POLICY "stickers_delete_authenticated"
  ON public.stickers FOR DELETE
  TO authenticated
  USING (TRUE);

-- ============================================================
-- STORAGE BUCKETS
-- ============================================================

-- Insert storage buckets directly into the storage.buckets table
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  ('avatars', 'avatars', TRUE, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']),
  ('stickers', 'stickers', TRUE, 2097152, ARRAY['image/png', 'image/webp', 'image/gif'])
ON CONFLICT (id) DO NOTHING;

-- Storage policies for avatars bucket
-- Public read
CREATE POLICY "avatars_public_read"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

-- Authenticated users can upload their own avatars
CREATE POLICY "avatars_insert_authenticated"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Users can update their own avatars (upsert requires INSERT + UPDATE + SELECT)
CREATE POLICY "avatars_update_own"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  )
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Users can delete their own avatars
CREATE POLICY "avatars_delete_own"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Storage policies for stickers bucket
-- Public read
CREATE POLICY "stickers_public_read"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'stickers');

-- Authenticated users can upload stickers
CREATE POLICY "stickers_insert_authenticated"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'stickers');

-- Authenticated users can update stickers
CREATE POLICY "stickers_update_authenticated"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'stickers')
  WITH CHECK (bucket_id = 'stickers');

-- Authenticated users can delete stickers
CREATE POLICY "stickers_delete_authenticated"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'stickers');

-- ============================================================
-- GRANT API ACCESS
-- ============================================================
-- Ensure anon and authenticated roles can access the tables
-- via the Supabase Data API (REST/GraphQL).

GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL ROUTINES IN SCHEMA public TO anon, authenticated;
