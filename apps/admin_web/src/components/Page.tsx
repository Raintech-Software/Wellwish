"use client";

import { Card, Flex, Typography } from "antd";
import type { ReactNode } from "react";

import { useCan } from "@/auth/AuthProvider";
import Forbidden from "@/components/Forbidden";

/** A panel page: title, short help, buttons on the right, then the content in a card.
 * Shows "No access" instead when the role lacks `permission` (§9.2). */
export default function Page({
  title,
  description,
  permission,
  extra,
  children,
}: {
  title: string;
  description?: ReactNode;
  permission: string;
  extra?: ReactNode;
  children: ReactNode;
}) {
  const can = useCan();
  if (!can(permission)) return <Forbidden />;
  return (
    <Card>
      <Flex justify="space-between" align="flex-start" gap={16} wrap>
        <div style={{ minWidth: 0, flex: "1 1 320px" }}>
          <Typography.Title level={3} style={{ marginTop: 0 }}>
            {title}
          </Typography.Title>
          {description && (
            <Typography.Paragraph type="secondary" style={{ maxWidth: 760 }}>
              {description}
            </Typography.Paragraph>
          )}
        </div>
        {extra && (
          <Flex gap={8} wrap>
            {extra}
          </Flex>
        )}
      </Flex>
      {children}
    </Card>
  );
}
