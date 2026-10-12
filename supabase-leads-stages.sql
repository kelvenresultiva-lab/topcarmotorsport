-- Top Car Motor Sport - editable Kanban columns
-- Run ONCE in Supabase: SQL Editor > New query > paste > Run.
-- (Run supabase-leads.sql first if you have not already.)
-- Your existing leads are kept exactly as they are.

create table if not exists public.lead_stages (
  key        text primary key check (key ~ '^[a-z0-9_]{1,40}$'),
  name       text not null check (char_length(name) between 1 and 40),
  position   int  not null default 0,
  created_at timestamptz not null default now()
);

insert into public.lead_stages (key, name, position) values
  ('new',       'New',       0),
  ('contacted', 'Contacted', 1),
  ('closed',    'Closed',    2)
on conflict (key) do nothing;

-- Leads may now use any column that exists in lead_stages (instead of a fixed list of 3).
alter table public.leads drop constraint if exists leads_status_check;
alter table public.leads drop constraint if exists leads_status_fkey;
alter table public.leads
  add constraint leads_status_fkey
  foreign key (status) references public.lead_stages (key)
  on update cascade on delete restrict;

alter table public.lead_stages enable row level security;

-- Only the shop owner can see and edit the columns. If the owner logs in with a
-- different e-mail, change it in the 4 lines below.
drop policy if exists "owner can read stages" on public.lead_stages;
create policy "owner can read stages"
  on public.lead_stages for select to authenticated
  using ((auth.jwt() ->> 'email') = 'topcartewksbury@gmail.com');

drop policy if exists "owner can add stages" on public.lead_stages;
create policy "owner can add stages"
  on public.lead_stages for insert to authenticated
  with check ((auth.jwt() ->> 'email') = 'topcartewksbury@gmail.com');

drop policy if exists "owner can rename stages" on public.lead_stages;
create policy "owner can rename stages"
  on public.lead_stages for update to authenticated
  using ((auth.jwt() ->> 'email') = 'topcartewksbury@gmail.com')
  with check ((auth.jwt() ->> 'email') = 'topcartewksbury@gmail.com');

-- The "new" column can be renamed but never removed: website leads always arrive there.
drop policy if exists "owner can delete stages" on public.lead_stages;
create policy "owner can delete stages"
  on public.lead_stages for delete to authenticated
  using ((auth.jwt() ->> 'email') = 'topcartewksbury@gmail.com' and key <> 'new');
