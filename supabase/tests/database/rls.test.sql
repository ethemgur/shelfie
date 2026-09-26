-- RLS policy tests (Phase 1 acceptance: users cannot read others' private
-- data). Run with `npx supabase test db`.
--
-- Cast: A = author, B = stranger, C = follows A, D = blocked by A.
begin;
create extension if not exists pgtap with schema extensions;
select plan(47);

-- ---------------------------------------------------------------- fixtures --
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'a@test.dev'),
  ('00000000-0000-0000-0000-00000000000b', 'b@test.dev'),
  ('00000000-0000-0000-0000-00000000000c', 'c@test.dev'),
  ('00000000-0000-0000-0000-00000000000d', 'd@test.dev');
insert into profiles (id, username, display_name) values
  ('00000000-0000-0000-0000-00000000000a', 'author', 'A'),
  ('00000000-0000-0000-0000-00000000000b', 'stranger', 'B'),
  ('00000000-0000-0000-0000-00000000000c', 'follower', 'C'),
  ('00000000-0000-0000-0000-00000000000d', 'blocked', 'D');
insert into works (id, title, authors) values
  ('10000000-0000-0000-0000-000000000001', 'Work One', '{Someone}');
insert into editions (id, work_id, isbn13, page_count, source) values
  ('20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '9780141439518', 384, 'open_library');
insert into user_books (id, user_id, work_id, edition_id, shelf) values
  ('30000000-0000-0000-0000-00000000000a', '00000000-0000-0000-0000-00000000000a', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'currently_reading'),
  ('30000000-0000-0000-0000-00000000000d', '00000000-0000-0000-0000-00000000000d', '10000000-0000-0000-0000-000000000001', null, 'want_to_read');
insert into page_updates (id, user_id, user_book_id, work_id, from_page, to_page, page_count, visibility, local_date, created_at, deleted_at, quote) values
  ('40000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000a', '30000000-0000-0000-0000-00000000000a', '10000000-0000-0000-0000-000000000001', 0, 50, 384, 'public', '2026-09-01', '2026-09-01 10:00Z', null, 'public quote'),
  ('40000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-00000000000a', '30000000-0000-0000-0000-00000000000a', '10000000-0000-0000-0000-000000000001', 50, 90, 384, 'followers', '2026-09-02', '2026-09-02 10:00Z', null, 'followers quote'),
  ('40000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-00000000000a', '30000000-0000-0000-0000-00000000000a', '10000000-0000-0000-0000-000000000001', 90, 120, 384, 'private', '2026-09-03', '2026-09-03 10:00Z', null, 'private quote'),
  ('40000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-00000000000a', '30000000-0000-0000-0000-00000000000a', '10000000-0000-0000-0000-000000000001', 120, 130, 384, 'public', '2026-09-04', '2026-09-04 10:00Z', now(), 'deleted quote');
insert into follows (follower_id, followee_id) values
  ('00000000-0000-0000-0000-00000000000c', '00000000-0000-0000-0000-00000000000a');
insert into blocks (blocker_id, blocked_id) values
  ('00000000-0000-0000-0000-00000000000a', '00000000-0000-0000-0000-00000000000d');
insert into reports (reporter_id, target_type, target_id, reason) values
  ('00000000-0000-0000-0000-00000000000a', 'profile', '00000000-0000-0000-0000-00000000000d', 'spam');
insert into notifications (id, user_id, type, actor_id) values
  ('50000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000a', 'new_follower', '00000000-0000-0000-0000-00000000000c');
insert into share_events (user_id, template_id, family, format, target) values
  ('00000000-0000-0000-0000-00000000000a', 'session_minimal', 'session', 'story', 'system_share');
insert into device_tokens (user_id, token, platform) values
  ('00000000-0000-0000-0000-00000000000a', 'token-a', 'android');

-- ----------------------------------------------------------------- triggers --
select is(
  (select current_page from user_books where id = '30000000-0000-0000-0000-00000000000a'),
  120,
  'current_page follows the latest non-deleted update'
);

-- -------------------------------------------------------------------- anon --
set local role anon;
set local request.jwt.claims to '{"role": "anon"}';
select is((select count(*) from profiles), 0::bigint, 'anon: sees no profiles');
select is((select count(*) from works), 0::bigint, 'anon: sees no works');
select is((select count(*) from page_updates), 0::bigint, 'anon: sees no page updates');
select is((select count(*) from user_books), 0::bigint, 'anon: sees no user_books');
reset role;

-- --------------------------------------------------------------- stranger B --
set local role authenticated;
set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-00000000000b", "role": "authenticated"}';

select is((select count(*) from profiles), 4::bigint, 'B: reads all profiles');
select is((select count(*) from works), 1::bigint, 'B: reads works');
select is((select count(*) from editions), 1::bigint, 'B: reads editions');
select results_eq(
  $$ select quote from page_updates order by created_at $$,
  $$ values ('public quote'::text) $$,
  'B: sees only A''s public, non-deleted update'
);
select is((select count(*) from user_books where user_id = '00000000-0000-0000-0000-00000000000a'), 1::bigint,
  'B: shelves are public');
select is((select count(*) from blocks), 0::bigint, 'B: cannot see other users'' blocks');
select is((select count(*) from reports), 0::bigint, 'B: cannot see other users'' reports');
select is((select count(*) from notifications), 0::bigint, 'B: cannot see other users'' notifications');
select is((select count(*) from share_events), 0::bigint, 'B: cannot see other users'' share events');
select is((select count(*) from device_tokens), 0::bigint, 'B: cannot see other users'' device tokens');
select is((select count(*) from weekly_results), 0::bigint, 'B: cannot see other users'' weekly results');

select throws_ok(
  $$ insert into works (title) values ('Vandalised') $$,
  '42501', null, 'B: cannot write works directly'
);
select throws_ok(
  $$ insert into editions (work_id, source) values ('10000000-0000-0000-0000-000000000001', 'user') $$,
  '42501', null, 'B: cannot write editions directly'
);
select throws_ok(
  $$ insert into user_books (id, user_id, work_id, shelf)
     values ('30000000-0000-0000-0000-0000000000ff', '00000000-0000-0000-0000-00000000000a', '10000000-0000-0000-0000-000000000001', 'read') $$,
  '42501', null, 'B: cannot add books to A''s shelves'
);
select throws_ok(
  $$ insert into page_updates (id, user_id, user_book_id, work_id, from_page, to_page, page_count, visibility, local_date, created_at)
     values ('40000000-0000-0000-0000-0000000000ff', '00000000-0000-0000-0000-00000000000b', '30000000-0000-0000-0000-00000000000a', '10000000-0000-0000-0000-000000000001', 0, 10, 384, 'public', '2026-09-05', now()) $$,
  '42501', null, 'B: cannot log updates against A''s book'
);
update profiles set display_name = 'hacked' where id = '00000000-0000-0000-0000-00000000000a';
update user_books set shelf = 'dnf' where id = '30000000-0000-0000-0000-00000000000a';
delete from page_updates where user_id = '00000000-0000-0000-0000-00000000000a';

-- B can add their own book and follow A.
insert into user_books (id, user_id, work_id, shelf)
  values ('30000000-0000-0000-0000-00000000000b', '00000000-0000-0000-0000-00000000000b', '10000000-0000-0000-0000-000000000001', 'want_to_read');
select is((select count(*) from user_books where user_id = '00000000-0000-0000-0000-00000000000b'), 1::bigint,
  'B: can add a book to own shelf');
select throws_ok(
  $$ insert into follows (follower_id, followee_id) values ('00000000-0000-0000-0000-00000000000c', '00000000-0000-0000-0000-00000000000b') $$,
  '42501', null, 'B: cannot create follows on someone else''s behalf'
);

-- Kudos and comments only on visible updates.
select lives_ok(
  $$ insert into kudos (user_id, page_update_id) values ('00000000-0000-0000-0000-00000000000b', '40000000-0000-0000-0000-000000000001') $$,
  'B: can give kudos to a public update'
);
select throws_ok(
  $$ insert into kudos (user_id, page_update_id) values ('00000000-0000-0000-0000-00000000000b', '40000000-0000-0000-0000-000000000003') $$,
  '42501', null, 'B: cannot give kudos to a private update'
);
select throws_ok(
  $$ insert into kudos (user_id, page_update_id) values ('00000000-0000-0000-0000-00000000000b', '40000000-0000-0000-0000-000000000002') $$,
  '42501', null, 'B: cannot give kudos to a followers-only update without following'
);
insert into comments (id, page_update_id, user_id, body)
  values ('60000000-0000-0000-0000-00000000000b', '40000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000b', 'Nice');
select throws_ok(
  $$ insert into comments (page_update_id, user_id, body) values ('40000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-00000000000b', 'Sneaky') $$,
  '42501', null, 'B: cannot comment on a private update'
);
select is(public.username_available('author'), false, 'username_available: taken');
select is(public.username_available('Fresh_name'), true, 'username_available: free (case-insensitive)');
select is(public.username_available('no'), false, 'username_available: too short');
reset role;

select is((select display_name from profiles where id = '00000000-0000-0000-0000-00000000000a'), 'A',
  'B''s update of A''s profile changed nothing');
select is((select shelf::text from user_books where id = '30000000-0000-0000-0000-00000000000a'), 'currently_reading',
  'B''s update of A''s shelf changed nothing');
select is((select count(*) from page_updates where user_id = '00000000-0000-0000-0000-00000000000a'), 4::bigint,
  'B''s delete of A''s updates removed nothing');

-- -------------------------------------------------------------- follower C --
set local role authenticated;
set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-00000000000c", "role": "authenticated"}';
select results_eq(
  $$ select quote from page_updates order by created_at $$,
  $$ values ('public quote'::text), ('followers quote'::text) $$,
  'C: sees public and followers-only updates, not private or deleted'
);
select is((select count(*) from comments), 1::bigint, 'C: sees B''s comment on a visible update');
delete from comments where id = '60000000-0000-0000-0000-00000000000b';
reset role;
select is((select count(*) from comments), 1::bigint, 'C cannot delete B''s comment');

-- ---------------------------------------------------------------- blocked D --
set local role authenticated;
set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-00000000000d", "role": "authenticated"}';
select is((select count(*) from page_updates), 0::bigint, 'D: sees none of A''s updates');
select is((select count(*) from user_books where user_id = '00000000-0000-0000-0000-00000000000a'), 0::bigint,
  'D: cannot see A''s shelves');
select is((select count(*) from kudos), 0::bigint, 'D: sees no kudos on A''s updates');
select throws_ok(
  $$ insert into kudos (user_id, page_update_id) values ('00000000-0000-0000-0000-00000000000d', '40000000-0000-0000-0000-000000000001') $$,
  '42501', null, 'D: cannot give kudos to A'
);
select throws_ok(
  $$ insert into follows (follower_id, followee_id) values ('00000000-0000-0000-0000-00000000000d', '00000000-0000-0000-0000-00000000000a') $$,
  '42501', null, 'D: cannot follow A'
);
reset role;

-- ---------------------------------------------------------------- author A --
set local role authenticated;
set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-00000000000a", "role": "authenticated"}';
select is((select count(*) from page_updates), 4::bigint, 'A: sees all own updates incl. private and deleted');
select is((select count(*) from user_books where user_id = '00000000-0000-0000-0000-00000000000d'), 0::bigint,
  'A: cannot see shelves of someone A blocked');
select is((select count(*) from reports), 1::bigint, 'A: sees own reports');
select lives_ok(
  $$ update notifications set read_at = now() where id = '50000000-0000-0000-0000-000000000001' $$,
  'A: can mark own notification read'
);
select throws_ok(
  $$ update notifications set type = 'kudos' where id = '50000000-0000-0000-0000-000000000001' $$,
  '42501', null, 'A: cannot change anything but read_at on notifications'
);
delete from comments where id = '60000000-0000-0000-0000-00000000000b';
select is((select count(*) from comments), 0::bigint, 'A: can delete comments on own update');

-- Blocking removes follows both ways.
insert into blocks (blocker_id, blocked_id) values
  ('00000000-0000-0000-0000-00000000000a', '00000000-0000-0000-0000-00000000000c');
reset role;
select is((select count(*) from follows where follower_id = '00000000-0000-0000-0000-00000000000c'), 0::bigint,
  'blocking removes existing follows');

select * from finish();
rollback;
