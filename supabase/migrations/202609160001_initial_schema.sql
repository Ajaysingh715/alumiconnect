-- AlumniConnect schema. Apply in Supabase SQL Editor or `supabase db push`.
create extension if not exists pgcrypto;

create type public.app_role as enum ('alumni', 'admin');
create type public.profile_visibility as enum ('public', 'directory', 'private');
create type public.rsvp_status as enum ('going', 'cancelled');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '', email text not null, graduation_year smallint check (graduation_year between 1900 and 2100),
  department text, location text, current_company text, job_title text, industry text, bio text check (char_length(bio) <= 1000),
  linkedin_url text check (linkedin_url is null or linkedin_url ~ '^https://'), avatar_url text,
  visibility public.profile_visibility not null default 'directory', is_approved boolean not null default false, is_active boolean not null default true,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table public.user_roles (user_id uuid primary key references auth.users(id) on delete cascade, role public.app_role not null default 'alumni', created_at timestamptz not null default now());
create table public.events (
  id uuid primary key default gen_random_uuid(), title text not null check (char_length(title) between 3 and 150), description text not null check (char_length(description) between 10 and 5000),
  starts_at timestamptz not null, ends_at timestamptz, location text not null, cover_image_url text, is_published boolean not null default false,
  capacity integer check (capacity is null or capacity > 0), created_by uuid not null references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
  constraint event_dates_valid check (ends_at is null or ends_at > starts_at)
);
create table public.event_rsvps (
  id uuid primary key default gen_random_uuid(), event_id uuid not null references public.events(id) on delete cascade, user_id uuid not null references auth.users(id) on delete cascade,
  status public.rsvp_status not null default 'going', created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(event_id, user_id)
);
create index profiles_directory_idx on public.profiles (is_active, is_approved, visibility, graduation_year, department, location);
create index events_public_idx on public.events (is_published, starts_at);
create index rsvps_event_idx on public.event_rsvps (event_id, status);

-- Public avatar bucket. Users may write only to a folder named with their own auth UUID.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('avatars', 'avatars', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;
create policy "avatar images are public" on storage.objects for select using (bucket_id = 'avatars');
create policy "users upload own avatar" on storage.objects for insert to authenticated with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "users update own avatar" on storage.objects for update to authenticated using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "users delete own avatar" on storage.objects for delete to authenticated using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

create or replace function public.set_updated_at() returns trigger language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;
create trigger profiles_updated before update on public.profiles for each row execute procedure public.set_updated_at();
create trigger events_updated before update on public.events for each row execute procedure public.set_updated_at();
create trigger rsvps_updated before update on public.event_rsvps for each row execute procedure public.set_updated_at();
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path = public as $$ begin insert into public.profiles(id, full_name, email) values (new.id, coalesce(new.raw_user_meta_data->>'full_name',''), new.email); insert into public.user_roles(user_id, role) values (new.id, 'alumni'); return new; end; $$;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = public as $$ select exists (select 1 from public.user_roles where user_id = auth.uid() and role = 'admin'); $$;

alter table public.profiles enable row level security; alter table public.user_roles enable row level security; alter table public.events enable row level security; alter table public.event_rsvps enable row level security;
create policy "visible approved profiles" on public.profiles for select using ((is_active and is_approved and visibility in ('public','directory')) or id = auth.uid() or public.is_admin());
create policy "users update own profile" on public.profiles for update using (id = auth.uid()) with check (id = auth.uid() and is_approved = (select is_approved from public.profiles p where p.id = auth.uid()) and is_active = (select is_active from public.profiles p where p.id = auth.uid()));
create policy "admins update profiles" on public.profiles for update using (public.is_admin()) with check (public.is_admin());
create policy "users view own role" on public.user_roles for select using (user_id = auth.uid() or public.is_admin());
create policy "admins manage roles" on public.user_roles for all using (public.is_admin()) with check (public.is_admin());
create policy "published events readable" on public.events for select using (is_published or public.is_admin());
create policy "admins manage events" on public.events for all using (public.is_admin()) with check (public.is_admin());
create policy "users view own rsvps" on public.event_rsvps for select using (user_id = auth.uid() or public.is_admin());
create policy "users create own rsvp" on public.event_rsvps for insert with check (user_id = auth.uid() and status = 'going' and exists (select 1 from public.events e where e.id=event_id and e.is_published));
create policy "users change own rsvp" on public.event_rsvps for update using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "admins manage rsvps" on public.event_rsvps for all using (public.is_admin()) with check (public.is_admin());
