"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { ShieldCheck, LogIn } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default function AdminLogin() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError(""); setBusy(true);
    const res = await fetch("/api/admin/login", {
      method: "POST", headers: { "content-type": "application/json" },
      body: JSON.stringify({ email, password })
    });
    if (res.ok) router.push("/admin");
    else { setError((await res.json()).error ?? "Login failed"); setBusy(false); }
  }

  return (
    <main className="relative flex min-h-screen items-center justify-center overflow-hidden bg-muted/30 px-6">
      {/* ambient brand glow */}
      <div className="pointer-events-none absolute -top-40 right-0 h-96 w-96 rounded-full bg-primary/15 blur-3xl" />
      <div className="pointer-events-none absolute -bottom-40 -left-10 h-96 w-96 rounded-full bg-primary/10 blur-3xl" />
      <Card className="relative w-full max-w-sm shadow-xl">
        <CardHeader className="items-center text-center">
          <div className="mb-2 flex h-11 w-11 items-center justify-center rounded-xl bg-primary text-primary-foreground shadow-sm">
            <ShieldCheck className="h-5 w-5" />
          </div>
          <CardTitle className="text-xl">OXOT Admin</CardTitle>
          <CardDescription>Sign in to the content studio</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={submit} className="space-y-4">
            <div className="space-y-1.5">
              <Label htmlFor="email">Email</Label>
              <Input id="email" type="email" placeholder="you@oxot.nl" value={email} onChange={(e) => setEmail(e.target.value)} autoComplete="username" />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="password">Password</Label>
              <Input id="password" type="password" placeholder="••••••••" value={password} onChange={(e) => setPassword(e.target.value)} autoComplete="current-password" />
            </div>
            {error && <p className="text-sm text-destructive">{error}</p>}
            <Button type="submit" className="w-full" disabled={busy}>
              <LogIn className="h-4 w-4" /> {busy ? "Signing in…" : "Sign in"}
            </Button>
          </form>
        </CardContent>
      </Card>
    </main>
  );
}
