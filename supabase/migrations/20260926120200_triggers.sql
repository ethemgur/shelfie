-- Triggers that keep derived data consistent.

-- user_books.updated_at
create function public.touch_updated_at()
returns trigger
language plpgsql set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger user_books_touch_updated_at
  before update on user_books
  for each row execute function public.touch_updated_at();

-- Blocking removes existing follows in both directions (Section 5).
-- SECURITY DEFINER: the blocker can't otherwise delete the other user's
-- follow row.
create function public.remove_follows_on_block()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  delete from public.follows
  where (follower_id = new.blocker_id and followee_id = new.blocked_id)
     or (follower_id = new.blocked_id and followee_id = new.blocker_id);
  return new;
end;
$$;

create trigger blocks_remove_follows
  after insert on blocks
  for each row execute function public.remove_follows_on_block();

-- user_books.current_page = to_page of the latest non-deleted update (by
-- created_at). Section 8.1. Leaves current_page alone when a book has no
-- updates left (e.g. imported history).
create function public.sync_current_page()
returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  book_id uuid := coalesce(new.user_book_id, old.user_book_id);
  latest int;
begin
  select pu.to_page into latest
  from public.page_updates pu
  where pu.user_book_id = book_id and pu.deleted_at is null
  order by pu.created_at desc, pu.received_at desc
  limit 1;

  if latest is not null then
    update public.user_books
    set current_page = latest
    where id = book_id and current_page is distinct from latest;
  end if;
  return null;
end;
$$;

create trigger page_updates_sync_current_page
  after insert or update of to_page, deleted_at, created_at or delete on page_updates
  for each row execute function public.sync_current_page();
