import type { ReactNode } from "react";

export function AuthShell({ title, description, children }: { title: string; description: string; children: ReactNode }) {
  return <section className="container-page grid min-h-[calc(100vh-8rem)] place-items-center py-12"><div className="card w-full max-w-md"><p className="text-sm font-bold uppercase tracking-wider text-brand-teal">AlumniConnect</p><h1 className="mt-2 text-3xl font-bold">{title}</h1><p className="mt-2 text-sm text-slate-600">{description}</p><div className="mt-7">{children}</div></div></section>;
}
