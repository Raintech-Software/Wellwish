"use client";

import { Card, Tag, Typography } from "antd";

import { useCan } from "@/auth/AuthProvider";
import Forbidden from "@/components/Forbidden";
import type { MenuPage } from "@/config/menu";

/** Placeholder for a menu page that a later phase builds. */
export default function ComingSoon({ page }: { page: MenuPage }) {
  const can = useCan();
  if (!can(page.permission)) return <Forbidden />;
  return (
    <Card>
      <Typography.Title level={3} style={{ marginTop: 0 }}>
        {page.label}
      </Typography.Title>
      <Typography.Paragraph type="secondary" style={{ maxWidth: 720 }}>
        {page.description}
      </Typography.Paragraph>
      <Tag color="blue">Built in Phase {page.phase}</Tag>
    </Card>
  );
}
