import Link from "next/link";
import { Logo } from "./logo";
export function Navbar() { return <header className="border-b bg-white/95"><nav className="container-page flex h-16 items-center justify-between gap-4"><Logo/><div className="hidden items-center gap-6 text-sm font-medium md:flex"><Link href="/about">About</Link><Link href="/directory">Directory</Link><Link href="/events">Events</Link></div><div className="flex items-center gap-2"><Link href="/login" className="btn text-brand-800">Login</Link><Link href="/signup" className="btn-primary">Sign up</Link></div></nav></header>; }
