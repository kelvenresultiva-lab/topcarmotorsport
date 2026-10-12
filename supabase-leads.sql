-- Top Car Motor Sport - lead capture
-- Run once in Supabase: SQL Editor > New query > paste > Run.

create table if not exists public.leads (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  name        text not null check (char_length(name) between 1 and 120),
  phone       text not null check (char_length(phone) between 5 and 40),
  message     text not null check (char_length(message) between 1 and 1000),
  source      text check (char_length(source) <= 300),
  status      text not null default 'new' check (status in ('new', 'contacted', 'closed'))
);

create index if not exists leads_created_at_idx on public.leads (created_at desc);

alter table public.leads enable row level security;

-- Website visitors (anonymous) may ONLY add a new lead. They can never read, edit or delete.
drop policy if exists "visitors can create leads" on public.leads;
create policy "visitors can create leads"
  on public.leads for insert
  to anon
  with check (status = 'new');

-- Only the shop owner (this login e-mail) can see and manage leads.
-- If the owner logs in with a different e-mail, change it in the 3 lines below.
drop policy if exists "owner can read leads" on public.leads;
create policy "owner can read leads"
  on public.leads for select
  to authenticated
  using ((auth.jwt() ->> 'email') = 'topcartewksbury@gmail.com');

drop policy if exists "owner can update leads" on public.leads;
create policy "owner can update leads"
  on public.leads for update
  to authenticated
  using ((auth.jwt() ->> 'email') = 'topcartewksbury@gmail.com')
  with check ((auth.jwt() ->> 'email') = 'topcartewksbury@gmail.com');

drop policy if exists "owner can delete leads" on public.leads;
create policy "owner can delete leads"
  on public.leads for delete
  to authenticated
  using ((auth.jwt() ->> 'email') = 'topcartewksbury@gmail.com');
