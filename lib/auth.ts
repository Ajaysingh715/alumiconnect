import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import type { Role } from "@/types/database";
export async function getCurrentUser() { const supabase = await createClient(); const { data: { user } } = await supabase.auth.getUser(); return user; }
export async function requireRole(role?: Role) { const user = await getCurrentUser(); if (!user) redirect("/login"); if (!role) return user; const supabase = await createClient(); const { data } = await supabase.from("user_roles").select("role").eq("user_id", user.id).single(); if (data?.role !== role) redirect("/dashboard"); return user; }
