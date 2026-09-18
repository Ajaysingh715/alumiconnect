import Link from "next/link";
import { UsersRound } from "lucide-react";
export function Logo() { return <Link href="/" className="flex items-center gap-2 font-bold text-brand-800"><span className="grid h-9 w-9 place-items-center rounded-xl bg-brand-800 text-white"><UsersRound size={19}/></span><span>AlumniConnect</span></Link>; }
