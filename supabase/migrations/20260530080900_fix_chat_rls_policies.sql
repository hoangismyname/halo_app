-- ============================================================
-- Fix: Chat RLS self-referencing bug
-- ============================================================

-- 1. Helper function (bypasses RLS on chat_room_members)
CREATE OR REPLACE FUNCTION public.is_chat_room_member(p_room_id UUID, p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.chat_room_members
    WHERE room_id = p_room_id AND user_id = p_user_id
  );
$$;

-- 2. Fix chat_room_members: use simple direct check
DROP POLICY IF EXISTS "chat_room_members_select_members" ON public.chat_room_members;
CREATE POLICY "chat_room_members_select_members"
  ON public.chat_room_members FOR SELECT
  TO authenticated
  USING (public.is_chat_room_member(room_id, auth.uid()));

-- 3. Fix chat_rooms: use helper function
DROP POLICY IF EXISTS "chat_rooms_select_members" ON public.chat_rooms;
CREATE POLICY "chat_rooms_select_members"
  ON public.chat_rooms FOR SELECT
  TO authenticated
  USING (public.is_chat_room_member(id, auth.uid()));

-- 4. Fix messages SELECT: use helper function
DROP POLICY IF EXISTS "messages_select_room_members" ON public.messages;
CREATE POLICY "messages_select_room_members"
  ON public.messages FOR SELECT
  TO authenticated
  USING (public.is_chat_room_member(room_id, auth.uid()));

-- 5. Fix messages INSERT: use helper function
DROP POLICY IF EXISTS "messages_insert_room_members" ON public.messages;
CREATE POLICY "messages_insert_room_members"
  ON public.messages FOR INSERT
  TO authenticated
  WITH CHECK (public.is_chat_room_member(room_id, auth.uid()));
