-- CampusMarket chat security + realtime setup
-- Run this in Supabase SQL Editor AFTER confirming your messages table has:
-- id, listing_id, sender_id, receiver_id, content, created_at

alter table public.messages enable row level security;

drop policy if exists "Users can read their own chats" on public.messages;
create policy "Users can read their own chats"
on public.messages for select to authenticated
using (auth.uid() = sender_id or auth.uid() = receiver_id);

drop policy if exists "Users can send chat messages" on public.messages;
create policy "Users can send chat messages"
on public.messages for insert to authenticated
with check (auth.uid() = sender_id and auth.uid() <> receiver_id);

-- Add messages to Supabase Realtime only if it is not already there.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'messages'
  ) then
    alter publication supabase_realtime add table public.messages;
  end if;
end $$;
