import { notFound } from "next/navigation";

import ComingSoon from "@/components/ComingSoon";
import { ALL_PAGES, findPage } from "@/config/menu";

/** Placeholder for every menu page until its phase builds the real screen. Unknown paths → 404.
 * Built pages (e.g. /system/roles) have their own route folder. */
export function generateStaticParams() {
  return ALL_PAGES.filter((p) => p.path !== "/" && !p.built).map((p) => ({
    section: p.path.slice(1).split("/"),
  }));
}

export default async function SectionPage({
  params,
}: {
  params: Promise<{ section: string[] }>;
}) {
  const { section } = await params;
  const page = findPage(`/${section.join("/")}`);
  if (!page || page.built) notFound();
  return <ComingSoon page={page} />;
}
