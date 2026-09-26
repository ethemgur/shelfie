-- Core schema (spec Section 5). RLS policies live in the next migration.

create type shelf as enum ('want_to_read', 'currently_reading', 'read', 'dnf');
create type book_format as enum ('print', 'ebook', 'audiobook');
create type visibility as enum ('public', 'followers', 'private');
create type notification_type as enum (
  'kudos', 'comment', 'friend_update_same_book',
  'goal_nudge', 'monthly_ready', 'annual_ready', 'new_follower'
);
create type report_target as enum ('page_update', 'comment', 'profile');

-- One row per auth user
create table profiles (
  id uuid primary key references auth.users on delete cascade,
  username text unique not null check (username ~ '^[a-z0-9_]{3,20}$'),
  display_name text not null check (char_length(display_name) between 1 and 50),
  avatar_path text,
  bio text check (char_length(bio) <= 160),
  weekly_page_goal int not null default 150 check (weekly_page_goal between 10 and 5000),
  default_visibility visibility not null default 'followers',
  timezone text not null default 'UTC',          -- IANA tz, used for local dates/weeks
  onboarding_completed_at timestamptz,
  created_at timestamptz not null default now()
);

-- A book independent of edition
create table works (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subtitle text,
  authors text[] not null default '{}',
  first_published_year int,
  cover_url text,
  open_library_work_key text unique,
  created_at timestamptz not null default now()
);
create index works_title_search on works using gin (to_tsvector('simple', title));

-- A specific edition of a work
create table editions (
  id uuid primary key default gen_random_uuid(),
  work_id uuid not null references works on delete cascade,
  isbn13 text unique check (isbn13 ~ '^97[89][0-9]{10}$'),
  isbn10 text check (isbn10 ~ '^[0-9]{9}[0-9X]$'),
  format book_format not null default 'print',
  page_count int check (page_count > 0),
  publisher text,
  published_date text,
  language text,
  cover_url text,
  source text not null check (source in ('open_library', 'google_books', 'user')),
  created_by uuid references auth.users on delete set null, -- set for source = 'user'
  created_at timestamptz not null default now()
);
create index on editions (work_id);

-- A user's relationship with a work (one per user per work in MVP)
create table user_books (
  id uuid primary key,                           -- client-generated
  user_id uuid not null references profiles on delete cascade,
  work_id uuid not null references works,
  edition_id uuid references editions,
  page_count_override int check (page_count_override > 0), -- if edition has no page count
  shelf shelf not null,
  current_page int not null default 0 check (current_page >= 0),
  started_at date,
  finished_at date,
  rating numeric(2,1) check (rating is null or (rating between 0.5 and 5 and (rating * 2) = floor(rating * 2))),
  review_line text check (char_length(review_line) <= 280),
  source text not null default 'app' check (source in ('app', 'goodreads_import', 'storygraph_import')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, work_id)
);
create index on user_books (user_id, shelf);
create index on user_books (work_id);

-- The core event. One row per page update.
create table page_updates (
  id uuid primary key,                           -- client-generated
  user_id uuid not null references profiles on delete cascade,
  user_book_id uuid not null references user_books on delete cascade,
  work_id uuid not null references works,
  edition_id uuid references editions,
  from_page int not null check (from_page >= 0),
  to_page int not null check (to_page >= 0),
  pages_read int generated always as (greatest(to_page - from_page, 0)) stored,
  page_count int not null check (page_count > 0), -- snapshot at time of update
  progress_pct numeric(5,2) generated always as (least(100, round(to_page * 100.0 / page_count, 2))) stored,
  is_finish boolean not null default false,
  note text check (char_length(note) <= 280),
  quote text check (char_length(quote) <= 400),
  mood text check (mood in ('cosy', 'gripped', 'emotional', 'funny', 'thoughtful', 'slow going')),
  photo_path text,
  visibility visibility not null,
  local_date date not null,                      -- user's local calendar date at creation
  created_at timestamptz not null,               -- client time
  received_at timestamptz not null default now(),
  deleted_at timestamptz
);
create index on page_updates (user_id, local_date);
create index on page_updates (work_id, created_at desc);
create index on page_updates (created_at desc);
create index on page_updates (user_book_id, created_at desc);

create table follows (
  follower_id uuid references profiles on delete cascade,
  followee_id uuid references profiles on delete cascade,
  created_at timestamptz not null default now(),
  primary key (follower_id, followee_id),
  check (follower_id <> followee_id)
);
create index on follows (followee_id);

create table kudos (
  user_id uuid references profiles on delete cascade,
  page_update_id uuid references page_updates on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, page_update_id)
);
create index on kudos (page_update_id);

create table comments (
  id uuid primary key default gen_random_uuid(),
  page_update_id uuid not null references page_updates on delete cascade,
  user_id uuid not null references profiles on delete cascade,
  body text not null check (char_length(body) between 1 and 500),
  anchor_pct numeric(5,2),                       -- commenter's progress in this work when commenting (null = not reading it)
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);
create index on comments (page_update_id, created_at);

create table blocks (
  blocker_id uuid references profiles on delete cascade,
  blocked_id uuid references profiles on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);
create index on blocks (blocked_id);

create table reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references profiles on delete cascade,
  target_type report_target not null,
  target_id uuid not null,
  reason text not null check (char_length(reason) between 1 and 1000),
  created_at timestamptz not null default now()
);

create table notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  type notification_type not null,
  actor_id uuid references profiles on delete cascade,
  page_update_id uuid references page_updates on delete cascade,
  payload jsonb not null default '{}',
  read_at timestamptz,
  created_at timestamptz not null default now()
);
create index on notifications (user_id, created_at desc);

create table device_tokens (
  user_id uuid references profiles on delete cascade,
  token text not null,
  platform text not null check (platform in ('ios', 'android')),
  updated_at timestamptz not null default now(),
  primary key (user_id, token)
);

-- Share exports, for the share-rate metric
create table share_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  template_id text not null,
  family text not null,
  format text not null check (format in ('story', 'post', 'sticker', 'carousel')),
  target text not null check (target in ('instagram_stories', 'system_share', 'save_to_photos', 'copy_link')),
  source_id uuid,                                -- page_update_id / user_book_id when applicable
  created_at timestamptz not null default now()
);

-- Closed weeks, written by a pg_cron job (Section 8.3, Phase 5)
create table weekly_results (
  user_id uuid references profiles on delete cascade,
  week_start date not null,           -- Monday
  pages int not null,
  goal int not null,                  -- goal in effect when the week closed
  met boolean not null,
  primary key (user_id, week_start)
);
