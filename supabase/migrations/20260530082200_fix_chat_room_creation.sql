-- ============================================================
-- Fix: Chat Room Creation RLS Bug
-- ============================================================

-- 1. Helper function to check if user is the room creator
CREATE OR REPLACE FUNCTION public.is_chat_room_creator(p_room_id UUID, p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.chat_rooms
    WHERE id = p_room_id AND created_by = p_user_id
  );
$$;

-- 2. Update chat_rooms SELECT policy to ALSO allow the creator to see the room
-- even if they haven't been added to chat_room_members yet.
DROP POLICY IF EXISTS "chat_rooms_select_members" ON public.chat_rooms;
CREATE POLICY "chat_rooms_select_members"
  ON public.chat_rooms FOR SELECT
  TO authenticated
  USING (
    created_by = auth.uid() OR 
    public.is_chat_room_member(id, auth.uid())
  );

-- 3. Update chat_room_members INSERT policy to use the helper function
-- This avoids any circular dependency with chat_rooms SELECT policy
DROP POLICY IF EXISTS "chat_room_members_insert_self_or_creator" ON public.chat_room_members;
CREATE POLICY "chat_room_members_insert_self_or_creator"
  ON public.chat_room_members FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id OR 
    public.is_chat_room_creator(room_id, auth.uid())
  );
