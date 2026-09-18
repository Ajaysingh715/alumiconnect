import "./globals.css";
import type { Metadata } from "next";
import { Navbar } from "@/components/navbar";
import { Footer } from "@/components/footer";
export const metadata: Metadata = { title: "AlumniConnect", description: "The alumni community, connected." };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="en"><body className="min-h-screen"><Navbar /><main>{children}</main><Footer /></body></html>; }
