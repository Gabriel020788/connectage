create table if not exists public.activity_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  source_type text not null check (source_type in ('reminder', 'task')),
  source_id uuid,
  title text not null check (char_length(trim(title)) between 1 and 160),
  activity_type text not null,
  completed_at timestamptz not null default now()
);

create index if not exists activity_history_user_completed_idx
  on public.activity_history(user_id, completed_at desc);

alter table public.activity_history enable row level security;
grant select, insert on public.activity_history to authenticated;
revoke all on public.activity_history from anon;

drop policy if exists "read own activity history" on public.activity_history;
create policy "read own activity history"
  on public.activity_history for select to authenticated
  using ((select auth.uid()) = user_id);
drop policy if exists "insert own activity history" on public.activity_history;
create policy "insert own activity history"
  on public.activity_history for insert to authenticated
  with check ((select auth.uid()) = user_id);

create table if not exists public.trusted_contacts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  full_name text not null check (char_length(trim(full_name)) between 1 and 120),
  relationship text check (relationship is null or char_length(trim(relationship)) <= 60),
  phone text check (phone is null or char_length(trim(phone)) <= 30),
  whatsapp text check (whatsapp is null or char_length(trim(whatsapp)) <= 30),
  email text check (email is null or char_length(trim(email)) <= 160),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists trusted_contacts_user_idx on public.trusted_contacts(user_id);
drop trigger if exists trusted_contacts_set_updated_at on public.trusted_contacts;
create trigger trusted_contacts_set_updated_at
before update on public.trusted_contacts
for each row execute procedure public.set_updated_at();

alter table public.trusted_contacts enable row level security;
grant select, insert, update, delete on public.trusted_contacts to authenticated;
revoke all on public.trusted_contacts from anon;

drop policy if exists "read own trusted contact" on public.trusted_contacts;
create policy "read own trusted contact"
  on public.trusted_contacts for select to authenticated
  using ((select auth.uid()) = user_id);
drop policy if exists "insert own trusted contact" on public.trusted_contacts;
create policy "insert own trusted contact"
  on public.trusted_contacts for insert to authenticated
  with check ((select auth.uid()) = user_id);
drop policy if exists "update own trusted contact" on public.trusted_contacts;
create policy "update own trusted contact"
  on public.trusted_contacts for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
drop policy if exists "delete own trusted contact" on public.trusted_contacts;
create policy "delete own trusted contact"
  on public.trusted_contacts for delete to authenticated
  using ((select auth.uid()) = user_id);
