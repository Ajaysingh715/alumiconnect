# AlumniConnect

A responsive Next.js and Supabase MVP for a university alumni community. It uses Supabase Auth, PostgreSQL, Storage, and Row Level Security (RLS); the browser application uses only the public anon key.

## What is included now

- Figma-inspired navy, teal, and clean-card design system
- Public home, about, sign-up, sign-in, and password-reset pages
- Supabase Auth integration
- Secure profiles, roles, events, RSVP schema, indexes, triggers, and RLS
- Alumni dashboard, profile viewing/editing, visibility preferences, and avatar uploads
- Foundation routes for directory, events, RSVPs, and administration

## Folder guide

```text
app/                         Next.js routes and page layouts
  login/, signup/, forgot-password/  Authentication screens
  profile/                   Alumni profile and edit screen
  dashboard/                 Authenticated alumni landing screen
  directory/, events/, admin/ Future feature routes already scaffolded
components/                  Reusable interface components and forms
lib/supabase/                Browser and server Supabase clients
lib/auth.ts                  Auth and role protection helpers
supabase/migrations/         Database schema, RLS, and Storage policies
supabase/seed.sql            Optional demo-data guide
types/                       Shared TypeScript types
```

## Setup from zero

### 1. Install Node.js

Install Node.js **20.9 or later** from [nodejs.org](https://nodejs.org). Then reopen your terminal and verify with:

```bash
node --version
npm --version
```

### 2. Install project packages

From the `ALUMIN` folder, run:

```bash
npm install
```

### 3. Apply the Supabase schema

In your Supabase project:

1. Open **SQL Editor**.
2. Create a new query.
3. Copy all contents of `supabase/migrations/202609160001_initial_schema.sql` into it.
4. Click **Run**.

This creates the tables, indexes, profile-creation trigger, role model, avatar bucket, and the security policies. Do this before starting the app.

### 4. Add your Supabase URL and anon key — do this now

Only after the SQL migration has run, create a file called `.env.local` in the project root, beside `package.json`.

Copy this exactly and replace the two values with those from **Supabase Dashboard → Project Settings → API**:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

Use the **anon / publishable key only**. Do not put the service-role key in `.env.local`, Vercel, browser code, or any client-accessible file.

### 5. Configure Auth redirect URLs

In **Supabase Dashboard → Authentication → URL Configuration**, set:

- Site URL: `http://localhost:3000`
- Additional Redirect URL: `http://localhost:3000/**`

When deploying, add your Vercel URL there too, for example `https://your-app.vercel.app/**`.

### 6. Start the app

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

### 7. Test the first user flow

1. Open `/signup` and create an alumni account.
2. Confirm the email if email confirmation is enabled in Supabase Auth.
3. Sign in at `/login`.
4. Open **My profile** at `/profile` and choose **Edit profile**.
5. Fill in professional details, choose visibility, optionally upload an avatar, and save.

The `handle_new_user` database trigger creates both the `profiles` and `user_roles` records automatically at signup. New accounts start as `alumni` and are not publicly visible until an administrator approves them.

## Make a user an administrator

Create the user normally through the sign-up page. In Supabase SQL Editor, find their `auth.users.id`, then run:

```sql
update public.user_roles
set role = 'admin'
where user_id = 'PASTE_THE_USER_UUID_HERE';
```

Admin access is checked in the database through RLS and again in the Next.js route guard. A normal alumni account cannot obtain admin access from the browser.

## Optional demo content

`supabase/seed.sql` is deliberately marked as demo-only and needs your administrator UUID before it can create sample events. Replace `YOUR_ADMIN_UUID` with the UUID of the admin you created, then run it in Supabase SQL Editor.

## Validate before deployment

```bash
npm run lint
npm run build
```

## Deploy to Vercel

1. Push this project to GitHub.
2. Import the repository in Vercel.
3. Add the same two environment variables from `.env.local` in **Vercel → Project Settings → Environment Variables**.
4. Deploy.
5. Add the deployed Vercel URL to Supabase Auth redirect URLs.

No service-role key is needed for this MVP deployment.
