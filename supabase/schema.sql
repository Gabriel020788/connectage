-- ConectAge - schema aplicado ao projeto Supabase real.
-- Project ref: bcctlrzbknzqctzyxtbn
-- Region: sa-east-1

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  birth_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.reminders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(trim(title)) between 1 and 120),
  type text not null check (type in ('medication', 'appointment', 'water', 'walk', 'commitment')),
  scheduled_at timestamptz not null,
  recurrence text not null default 'none' check (recurrence in ('none', 'daily')),
  notes text check (notes is null or char_length(notes) <= 500),
  completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(trim(title)) between 1 and 160),
  type text not null default 'task' check (type in ('task', 'shopping')),
  completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists reminders_user_date_idx on public.reminders(user_id, scheduled_at);
create index if not exists reminders_user_completed_idx on public.reminders(user_id, completed);
create index if not exists tasks_user_created_idx on public.tasks(user_id, created_at desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  parsed_birth_date date;
begin
  begin
    parsed_birth_date := nullif(new.raw_user_meta_data ->> 'birth_date', '')::date;
  exception when others then
    parsed_birth_date := null;
  end;

  insert into public.profiles (id, full_name, birth_date)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    parsed_birth_date
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at before update on public.profiles
for each row execute procedure public.set_updated_at();

drop trigger if exists reminders_set_updated_at on public.reminders;
create trigger reminders_set_updated_at before update on public.reminders
for each row execute procedure public.set_updated_at();

drop trigger if exists tasks_set_updated_at on public.tasks;
create trigger tasks_set_updated_at before update on public.tasks
for each row execute procedure public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.reminders enable row level security;
alter table public.tasks enable row level security;

grant select, update on public.profiles to authenticated;
grant select, insert, update, delete on public.reminders to authenticated;
grant select, insert, update, delete on public.tasks to authenticated;

revoke all on public.profiles from anon;
revoke all on public.reminders from anon;
revoke all on public.tasks from anon;

revoke all on function public.handle_new_user() from public;
revoke all on function public.handle_new_user() from anon;
revoke all on function public.handle_new_user() from authenticated;
revoke all on function public.set_updated_at() from public;
revoke all on function public.set_updated_at() from anon;
revoke all on function public.set_updated_at() from authenticated;

drop policy if exists "read own profile" on public.profiles;
create policy "read own profile" on public.profiles for select to authenticated using ((select auth.uid()) = id);

drop policy if exists "update own profile" on public.profiles;
create policy "update own profile" on public.profiles for update to authenticated using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

drop policy if exists "read own reminders" on public.reminders;
create policy "read own reminders" on public.reminders for select to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "insert own reminders" on public.reminders;
create policy "insert own reminders" on public.reminders for insert to authenticated with check ((select auth.uid()) = user_id);

drop policy if exists "update own reminders" on public.reminders;
create policy "update own reminders" on public.reminders for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists "delete own reminders" on public.reminders;
create policy "delete own reminders" on public.reminders for delete to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "read own tasks" on public.tasks;
create policy "read own tasks" on public.tasks for select to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "insert own tasks" on public.tasks;
create policy "insert own tasks" on public.tasks for insert to authenticated with check ((select auth.uid()) = user_id);

drop policy if exists "update own tasks" on public.tasks;
create policy "update own tasks" on public.tasks for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists "delete own tasks" on public.tasks;
create policy "delete own tasks" on public.tasks for delete to authenticated using ((select auth.uid()) = user_id);
