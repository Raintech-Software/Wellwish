"use client";

import { Spin } from "antd";
import { useRouter } from "next/navigation";
import { useEffect } from "react";

import { useSession } from "@/auth/AuthProvider";
import AdminShell from "@/components/AdminShell";

/** Every signed-in page uses the sidebar layout. Signed-out visitors go to /login. */
export default function PanelLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  const { status, endReason } = useSession();
  const router = useRouter();

  useEffect(() => {
    if (status !== "signedOut") return;
    router.replace(endReason && endReason !== "logout" ? `/login?reason=${endReason}` : "/login");
  }, [status, endReason, router]);

  if (status !== "signedIn") {
    return (
      <div style={{ minHeight: "100vh", display: "grid", placeItems: "center" }}>
        <Spin size="large" />
      </div>
    );
  }
  return <AdminShell>{children}</AdminShell>;
}
