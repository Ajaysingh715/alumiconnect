import { clsx, type ClassValue } from "clsx";
export const cn = (...inputs: ClassValue[]) => clsx(inputs);
export const formatDate = (date: string) => new Intl.DateTimeFormat("en", { dateStyle: "medium", timeStyle: "short" }).format(new Date(date));
