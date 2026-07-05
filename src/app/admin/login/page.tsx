"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";

export default function AdminLogin() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    const res = await fetch("/api/admin/login", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ email, password })
    });
    if (res.ok) router.push("/admin");
    else setError((await res.json()).error ?? "login failed");
  }

  return (
    <main className="mx-auto flex min-h-screen max-w-sm flex-col justify-center gap-4 px-6">
      <h1 className="text-2xl font-bold">OXOT Admin</h1>
      <form onSubmit={submit} className="flex flex-col gap-3">
        <input className="rounded-lg border border-border bg-background px-3 py-2"
          type="email" placeholder="email" value={email}
          onChange={(e) => setEmail(e.target.value)} />
        <input className="rounded-lg border border-border bg-background px-3 py-2"
          type="password" placeholder="password" value={password}
          onChange={(e) => setPassword(e.target.value)} />
        {error && <p className="text-sm text-red-500">{error}</p>}
        <Button type="submit">Sign in</Button>
      </form>
    </main>
  );
}
