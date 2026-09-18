import { Inbox } from "lucide-react";
export function EmptyState({ title, description }: { title:string; description:string }) { return <div className="card grid min-h-52 place-items-center text-center"><div><Inbox className="mx-auto mb-3 text-brand-500"/><h2 className="text-lg font-semibold">{title}</h2><p className="mt-1 max-w-sm text-sm text-slate-500">{description}</p></div></div>; }
