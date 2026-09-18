import { AuthForm } from "@/components/auth-form";
import { AuthShell } from "@/components/auth-shell";

export default function LoginPage(){return <AuthShell title="Welcome back" description="Sign in to reconnect with your alumni community."><AuthForm mode="login"/></AuthShell>}
