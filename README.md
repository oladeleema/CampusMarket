# CampusMarket — Supabase-connected chat

## What is connected
- `listings` are loaded from Supabase instead of being the only source of marketplace data.
- A listing carries its real `id` and seller account id (`seller_id`, with fallbacks for `user_id`, `owner_id`, or `created_by`).
- `Message Seller` opens the chat for that exact listing and seller.
- Messages are filtered to the two participants and the listing.
- Supabase Realtime updates the conversation when a new message is inserted.
- Login/signup uses Supabase Auth.
- Seller names are loaded from `profiles` when that table exists.

## Expected Supabase schema
### listings
At minimum, the frontend expects a table named `listings` with a primary key `id` and a seller/auth-user column such as `seller_id`. Common display fields are `title`, `price`, `category`, `condition`, `description`, `location`, `image_url`, and `created_at`.

### messages
The existing `messages` table should contain:
- `id`
- `listing_id`
- `sender_id`
- `receiver_id`
- `content`
- `created_at`

### profiles
If you have a `profiles` table, the chat looks for `id` plus one of `full_name`, `name`, or `username`.

## Supabase setup
1. Put your Supabase project URL and public anon/publishable key in `.env` using the names in `.env.example`.
2. Open Supabase SQL Editor.
3. Run `supabase_chat_setup.sql`.
4. Make sure your listings' seller column contains the authenticated user's UUID from `auth.users.id`.
5. Start the app with `npm install` then `npm run dev`.

Never put a Supabase service-role key or any secret API key in the frontend.
