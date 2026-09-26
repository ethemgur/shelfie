-- Row level security (spec Section 5, "RLS rules"). Every table has RLS on.
-- Policies are granted to `authenticated` only: signed-out (anon) clients can
-- read nothing. The landing page (Phase 4) reads through the service role.

-- ---------------------------------------------------------------------------
-- Helpers. SECURITY DEFINER so they can read `blocks`/`follows` rows the
-- caller can't see (a user must never learn who blocked them, but their
-- queries must still respect it).
-- ---------------------------------------------------------------------------

create function public.is_blocked_between(a uuid, b uuid)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.blocks
    where (blocker_id = a and blocked_id = b)
       or (blocker_id = b and blocked_id = a)
  );
$$;

create function public.is_following(follower uuid, followee uuid)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.follows
    where follower_id = follower and followee_id = followee
  );
$$;

revoke execute on function public.is_blocked_between(uuid, uuid) from public, anon;
revoke execute on function public.is_following(uuid, uuid) from public, anon;
grant execute on function public.is_blocked_between(uuid, uuid) to authenticated;
grant execute on function public.is_following(uuid, uuid) to authenticated;

alter table profiles enable row level security;
alter table works enable row level security;
alter table editions enable row level security;
alter table user_books enable row level security;
alter table page_updates enable row level security;
alter table follows enable row level security;
alter table kudos enable row level security;
alter table comments enable row level security;
alter table blocks enable row level security;
alter table reports enable row level security;
alter table notifications enable row level security;
alter table device_tokens enable row level security;
alter table share_events enable row level security;
alter table weekly_results enable row level security;

-- profiles: anyone authenticated can read; users create/update only their own.
create policy profiles_select on profiles for select to authenticated using (true);
create policy profiles_insert on profiles for insert to authenticated
  with check (id = (select auth.uid()));
create policy profiles_update on profiles for update to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

-- works, editions: read-only for clients. Writes go through the `upsert_book`
-- Edge Function (service role, which bypasses RLS).
create policy works_select on works for select to authenticated using (true);
create policy editions_select on editions for select to authenticated using (true);

-- user_books: owner full access; others can read unless blocked either way.
create policy user_books_owner on user_books for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
create policy user_books_select_others on user_books for select to authenticated
  using (
    user_id <> (select auth.uid())
    and not public.is_blocked_between(user_id, (select auth.uid()))
  );

-- page_updates: owner full access (and only on their own user_books); others
-- see non-deleted public updates, or followers-only updates of people they
-- follow, unless blocked either way. Private updates are owner-only.
create policy page_updates_owner on page_updates for all to authenticated
  using (user_id = (select auth.uid()))
  with check (
    user_id = (select auth.uid())
    and exists (
      select 1 from user_books ub
      where ub.id = user_book_id and ub.user_id = (select auth.uid())
    )
  );
create policy page_updates_select_others on page_updates for select to authenticated
  using (
    user_id <> (select auth.uid())
    and deleted_at is null
    and not public.is_blocked_between(user_id, (select auth.uid()))
    and (
      visibility = 'public'
      or (visibility = 'followers' and public.is_following((select auth.uid()), user_id))
    )
  );

-- follows: readable by everyone signed in (counts, profiles), except rows
-- involving someone who blocked you or whom you blocked. You can only follow
-- as yourself, never someone in a block relationship, and only unfollow
-- yourself.
create policy follows_select on follows for select to authenticated
  using (
    not public.is_blocked_between(follower_id, (select auth.uid()))
    and not public.is_blocked_between(followee_id, (select auth.uid()))
  );
create policy follows_insert on follows for insert to authenticated
  with check (
    follower_id = (select auth.uid())
    and not public.is_blocked_between(follower_id, followee_id)
  );
create policy follows_delete on follows for delete to authenticated
  using (follower_id = (select auth.uid()));

-- kudos: visible/insertable only on updates the viewer can see (the subquery
-- is itself filtered by page_updates RLS) and never across a block. Delete own.
create policy kudos_select on kudos for select to authenticated
  using (
    exists (select 1 from page_updates pu where pu.id = page_update_id)
    and not public.is_blocked_between(user_id, (select auth.uid()))
  );
create policy kudos_insert on kudos for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and exists (select 1 from page_updates pu where pu.id = page_update_id)
  );
create policy kudos_delete on kudos for delete to authenticated
  using (user_id = (select auth.uid()));

-- comments: same visibility as kudos, soft-deleted comments hidden. Delete
-- own, or any comment on your own update.
create policy comments_select on comments for select to authenticated
  using (
    deleted_at is null
    and exists (select 1 from page_updates pu where pu.id = page_update_id)
    and not public.is_blocked_between(user_id, (select auth.uid()))
  );
create policy comments_insert on comments for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and deleted_at is null
    and exists (select 1 from page_updates pu where pu.id = page_update_id)
  );
create policy comments_delete on comments for delete to authenticated
  using (
    user_id = (select auth.uid())
    or exists (
      select 1 from page_updates pu
      where pu.id = page_update_id and pu.user_id = (select auth.uid())
    )
  );

-- blocks, reports, device_tokens, share_events: owner only.
create policy blocks_owner on blocks for all to authenticated
  using (blocker_id = (select auth.uid()))
  with check (blocker_id = (select auth.uid()));
create policy reports_insert on reports for insert to authenticated
  with check (reporter_id = (select auth.uid()));
create policy reports_select on reports for select to authenticated
  using (reporter_id = (select auth.uid()));
create policy device_tokens_owner on device_tokens for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
create policy share_events_insert on share_events for insert to authenticated
  with check (user_id = (select auth.uid()));
create policy share_events_select on share_events for select to authenticated
  using (user_id = (select auth.uid()));

-- notifications: owner can read and mark read (read_at only). Inserts only by
-- triggers / Edge Functions.
create policy notifications_select on notifications for select to authenticated
  using (user_id = (select auth.uid()));
create policy notifications_update on notifications for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
revoke update on notifications from authenticated;
grant update (read_at) on notifications to authenticated;

-- weekly_results: owner read-only; written by the weekly cron job.
create policy weekly_results_select on weekly_results for select to authenticated
  using (user_id = (select auth.uid()));
