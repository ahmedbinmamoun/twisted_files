-- =====================================================
-- Twisted Files — Supabase Schema
-- Run this in Supabase SQL Editor
-- =====================================================

-- 1. PROFILES table (extends Supabase auth.users)
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  nickname    text not null default 'Detective',
  is_anonymous boolean default true,
  avatar_url  text,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- 2. USER SCORES table
create table if not exists public.user_scores (
  user_id     uuid primary key references public.profiles(id) on delete cascade,
  total_score int not null default 0,
  updated_at  timestamptz default now()
);

-- 3. CASE PROGRESS table
create table if not exists public.case_progress (
  id          uuid default gen_random_uuid() primary key,
  user_id     uuid references public.profiles(id) on delete cascade,
  case_id     text not null,
  completed   boolean default false,
  case_score  int default 0,
  difficulty  text not null check (difficulty in ('easy','medium','hard')),
  updated_at  timestamptz default now(),
  unique(user_id, case_id)
);

-- 4. CASES table (store case JSON data online)
create table if not exists public.cases (
  id          text primary key,
  difficulty  text not null check (difficulty in ('easy','medium','hard')),
  data        jsonb not null,
  created_at  timestamptz default now()
);

-- =====================================================
-- Row Level Security (RLS)
-- =====================================================

alter table public.profiles     enable row level security;
alter table public.user_scores  enable row level security;
alter table public.case_progress enable row level security;
alter table public.cases        enable row level security;

-- Profiles: users can only read/update their own profile
create policy "Users can view own profile"
  on public.profiles for select using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

create policy "Users can insert own profile"
  on public.profiles for insert with check (auth.uid() = id);

-- Scores: users can only read/update their own score
create policy "Users can view own score"
  on public.user_scores for select using (auth.uid() = user_id);

create policy "Users can upsert own score"
  on public.user_scores for insert with check (auth.uid() = user_id);

create policy "Users can update own score"
  on public.user_scores for update using (auth.uid() = user_id);

-- Case progress: users can only manage their own progress
create policy "Users can view own progress"
  on public.case_progress for select using (auth.uid() = user_id);

create policy "Users can insert own progress"
  on public.case_progress for insert with check (auth.uid() = user_id);

create policy "Users can update own progress"
  on public.case_progress for update using (auth.uid() = user_id);

create policy "Users can delete own progress"
  on public.case_progress for delete using (auth.uid() = user_id);

-- Cases: everyone can read cases (public)
create policy "Cases are readable by all"
  on public.cases for select using (true);

-- =====================================================
-- Functions & Triggers
-- =====================================================

-- Auto-create profile + score row when new user signs up
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
declare
  generated_name text;
begin
  -- Generate random detective nickname
  generated_name := 'Detective ' || substr(md5(random()::text), 1, 6);

  insert into public.profiles (id, nickname, is_anonymous)
  values (new.id, generated_name, true)
  on conflict (id) do nothing;

  insert into public.user_scores (user_id, total_score)
  values (new.id, 0)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Update updated_at timestamp automatically
create or replace function public.update_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute procedure public.update_updated_at();

create trigger scores_updated_at
  before update on public.user_scores
  for each row execute procedure public.update_updated_at();

create trigger progress_updated_at
  before update on public.case_progress
  for each row execute procedure public.update_updated_at();
