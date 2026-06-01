-- Remove duplicate friendships (keep the one created first)
DELETE FROM public.friendships
WHERE id IN (
  SELECT id FROM (
    SELECT id, 
           ROW_NUMBER() OVER (PARTITION BY LEAST(user_id, friend_id), GREATEST(user_id, friend_id) ORDER BY created_at ASC) as rn
    FROM public.friendships
  ) t
  WHERE t.rn > 1
);

-- Drop the old unique index that allowed (A, B) and (B, A)
DROP INDEX IF EXISTS public.idx_friendships_unique_pair;

-- Create a new unique index ensuring only one row exists between any two users regardless of direction
CREATE UNIQUE INDEX idx_friendships_unique_pair 
ON public.friendships (LEAST(user_id, friend_id), GREATEST(user_id, friend_id));
