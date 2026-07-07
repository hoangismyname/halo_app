-- Migration: add_location_preferences

ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS is_location_shared BOOLEAN NOT NULL DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS location_precision TEXT NOT NULL DEFAULT 'absolute' CHECK (location_precision IN ('absolute', 'relative'));

COMMENT ON COLUMN public.profiles.is_location_shared IS 'Whether the user shares their location with friends';
COMMENT ON COLUMN public.profiles.location_precision IS 'Precision mode for location sharing: absolute or relative';
