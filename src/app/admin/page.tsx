import { redirect } from "next/navigation";
import { getAdminSession } from "@/lib/auth";
import { PagesManager } from "@/components/admin/pages-manager";
import { MenuManager } from "@/components/admin/menu-manager";
import { ContactInbox } from "@/components/admin/contact-inbox";
import { HomeContentEditor } from "@/components/admin/home-content-editor";

export default async function AdminDashboard() {
  const session = await getAdminSession();
  if (!session) redirect("/admin/login");
  return (
    <main className="mx-auto max-w-3xl px-6 py-10">
      <header className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-bold">OXOT Admin</h1>
        <span className="text-sm text-muted-foreground">{session.email}</span>
      </header>
      <HomeContentEditor />
      <div className="mt-10"><PagesManager /></div>
      <div className="mt-10"><MenuManager /></div>
      <div className="mt-10"><ContactInbox /></div>
    </main>
  );
}
