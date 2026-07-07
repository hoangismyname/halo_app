DROP VIEW IF EXISTS public.friend_statuses;

CREATE OR REPLACE VIEW public.friend_statuses WITH (security_invoker = true) AS
SELECT 
  p.id, 
  p.username,
  p.display_name,
  p.avatar_url,
  p.is_online,
  p.status_emoji, 
  p.status_text, 
  p.updated_at
FROM public.profiles p
JOIN public.friendships f ON 
  (f.user_id = auth.uid() AND f.friend_id = p.id) OR 
  (f.friend_id = auth.uid() AND f.user_id = p.id)
WHERE f.status = 'accepted';

COMMENT ON VIEW public.friend_statuses IS 'Chỉ trả về trạng thái của những user đã là bạn bè với user hiện tại (đã bổ sung tên và avatar).';
