-- DEMO DATA ONLY. Create these accounts through Supabase Auth, then replace UUIDs below.
-- This keeps passwords out of source control and follows Supabase's secure Auth workflow.
-- After creating an approved admin and alumni users, run the event inserts below.
-- update public.user_roles set role='admin' where user_id='YOUR_ADMIN_UUID';
-- update public.profiles set is_approved=true where id in ('ALUMNI_UUID_1','ALUMNI_UUID_2');
insert into public.events (title, description, starts_at, ends_at, location, is_published, capacity, created_by) values
('Alumni Homecoming 2026', 'Reconnect with classmates, meet current students, and celebrate the AlumniConnect community.', now() + interval '30 days', now() + interval '30 days 4 hours', 'University Auditorium', true, 300, 'YOUR_ADMIN_UUID'),
('Career Stories: Technology', 'A practical panel discussion with alumni working in software, product, and data roles.', now() + interval '14 days', now() + interval '14 days 2 hours', 'Innovation Hall', true, 120, 'YOUR_ADMIN_UUID');
