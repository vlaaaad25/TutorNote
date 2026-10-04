-- TutorNote Cloud Backup schema
-- Run the whole file in Supabase Dashboard -> SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.tutornote_cloud_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  wrapped_key text not null,
  wrap_iv text not null,
  wrap_salt text not null,
  kdf_iterations integer not null default 250000 check (kdf_iterations >= 100000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.tutornote_backups (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  reason text,
  ciphertext text not null,
  iv text not null,
  snapshot_sha256 text,
  app_version integer not null default 4,
  device_name text
);

create index if not exists tutornote_backups_user_created_idx
  on public.tutornote_backups (user_id, created_at desc);

alter table public.tutornote_cloud_profiles enable row level security;
alter table public.tutornote_backups enable row level security;

-- No unauthenticated access.
revoke all on table public.tutornote_cloud_profiles from anon;
revoke all on table public.tutornote_backups from anon;

-- Signed-in users may use the operations required by TutorNote.
grant select, insert, update, delete on table public.tutornote_cloud_profiles to authenticated;
grant select, insert, update, delete on table public.tutornote_backups to authenticated;

-- Replace policies safely if the script is run again.
drop policy if exists "TutorNote profile select own" on public.tutornote_cloud_profiles;
drop policy if exists "TutorNote profile insert own" on public.tutornote_cloud_profiles;
drop policy if exists "TutorNote profile update own" on public.tutornote_cloud_profiles;
drop policy if exists "TutorNote profile delete own" on public.tutornote_cloud_profiles;
drop policy if exists "TutorNote backup select own" on public.tutornote_backups;
drop policy if exists "TutorNote backup insert own" on public.tutornote_backups;
drop policy if exists "TutorNote backup update own" on public.tutornote_backups;
drop policy if exists "TutorNote backup delete own" on public.tutornote_backups;

create policy "TutorNote profile select own"
  on public.tutornote_cloud_profiles for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "TutorNote profile insert own"
  on public.tutornote_cloud_profiles for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "TutorNote profile update own"
  on public.tutornote_cloud_profiles for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "TutorNote profile delete own"
  on public.tutornote_cloud_profiles for delete
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "TutorNote backup select own"
  on public.tutornote_backups for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "TutorNote backup insert own"
  on public.tutornote_backups for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "TutorNote backup update own"
  on public.tutornote_backups for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "TutorNote backup delete own"
  on public.tutornote_backups for delete
  to authenticated
  using ((select auth.uid()) = user_id);
