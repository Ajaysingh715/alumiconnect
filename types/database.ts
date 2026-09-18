export type Role = "alumni" | "admin";
export type Visibility = "public" | "directory" | "private";
export type Profile = { id:string; full_name:string; email:string; graduation_year:number|null; department:string|null; location:string|null; current_company:string|null; job_title:string|null; industry:string|null; bio:string|null; linkedin_url:string|null; avatar_url:string|null; visibility:Visibility; is_approved:boolean; is_active:boolean; created_at:string; updated_at:string };
export type Event = { id:string; title:string; description:string; starts_at:string; ends_at:string|null; location:string; cover_image_url:string|null; is_published:boolean; capacity:number|null; created_by:string; created_at:string };
export type EventRsvp = { id:string; event_id:string; user_id:string; created_at:string; status:"going"|"cancelled" };
