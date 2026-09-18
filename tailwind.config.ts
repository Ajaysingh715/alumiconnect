import type { Config } from "tailwindcss";
export default { content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"], theme: { extend: { colors: { brand: { 50: "#eef5ff", 100: "#d9e8ff", 500: "#2563eb", 700: "#173b75", 800: "#112d5c", 900: "#0a1f44", teal: "#46bcb3" } }, boxShadow: { card: "0 8px 30px rgba(17,45,92,.08)" } } }, plugins: [] } satisfies Config;
