-- RPCs (Section 5). All SECURITY INVOKER, so RLS applies to the caller.
-- get_feed / get_suggested_readers / summaries / streak are stubs with their
-- final signatures; their bodies land in Phases 3–5.

-- Live username check for onboarding. Case-insensitive; also validates format
-- so the client and server agree.
create function public.username_available(p_username text)
returns boolean
language sql stable security invoker set search_path = ''
as $$
  select lower(p_username) ~ '^[a-z0-9_]{3,20}$'
     and not exists (
       select 1 from public.profiles where username = lower(p_username)
     );
$$;

-- Phase 4: page updates from followed users + own, newest first.
create function public.get_feed(p_cursor timestamptz default null, p_limit int default 20)
returns table (
  id uuid,
  user_id uuid,
  work_id uuid,
  from_page int,
  to_page int,
  pages_read int,
  page_count int,
  progress_pct numeric,
  is_finish boolean,
  note text,
  quote text,
  mood text,
  photo_path text,
  visibility visibility,
  created_at timestamptz,
  author jsonb,
  work jsonb,
  kudos_count int,
  comment_count int,
  viewer_has_kudos boolean
)
language sql stable security invoker set search_path = ''
as $$
  select null::uuid, null::uuid, null::uuid, null::int, null::int, null::int,
         null::int, null::numeric, null::boolean, null::text, null::text,
         null::text, null::text, null::public.visibility, null::timestamptz,
         null::jsonb, null::jsonb, null::int, null::int, null::boolean
  where false;
$$;

-- Phase 4: readers with public updates on works the viewer is reading or wants to read.
create function public.get_suggested_readers(p_limit int default 20)
returns table (
  id uuid,
  username text,
  display_name text,
  avatar_path text,
  shared_work_count int
)
language sql stable security invoker set search_path = ''
as $$
  select null::uuid, null::text, null::text, null::text, null::int where false;
$$;

-- Phase 3: data for monthly templates (Section 8.4).
create function public.get_month_summary(p_year int, p_month int)
returns jsonb
language sql stable security invoker set search_path = ''
as $$ select '{}'::jsonb; $$;

-- Phase 3: data for the annual carousel (Section 8.5).
create function public.get_year_summary(p_year int)
returns jsonb
language sql stable security invoker set search_path = ''
as $$ select '{}'::jsonb; $$;

-- Phase 5: current and longest weekly streak (Section 8.3).
create function public.get_streak()
returns table (current_streak int, longest_streak int)
language sql stable security invoker set search_path = ''
as $$ select 0, 0; $$;

revoke execute on function
  public.username_available(text),
  public.get_feed(timestamptz, int),
  public.get_suggested_readers(int),
  public.get_month_summary(int, int),
  public.get_year_summary(int),
  public.get_streak()
from public, anon;
grant execute on function
  public.username_available(text),
  public.get_feed(timestamptz, int),
  public.get_suggested_readers(int),
  public.get_month_summary(int, int),
  public.get_year_summary(int),
  public.get_streak()
to authenticated;
