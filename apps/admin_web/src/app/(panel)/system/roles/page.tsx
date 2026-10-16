"use client";

import { CheckOutlined } from "@ant-design/icons";
import { Alert, Card, Table, Tag, Typography } from "antd";
import { useEffect, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Forbidden from "@/components/Forbidden";
import { colors } from "@/theme";

type Roles = components["schemas"]["RolesOut"];

/** System → Roles: what each admin role can do (ARCHITECTURE §9.2). Read-only. */
export default function RolesPage() {
  const can = useCan();
  const allowed = can("staff.manage");
  const [roles, setRoles] = useState<Roles | null>(null);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    if (!allowed) return;
    api.GET("/v1/admin/roles").then(({ data }) => (data ? setRoles(data) : setFailed(true)));
  }, [allowed]);

  if (!allowed) return <Forbidden />;

  const columns = [
    {
      title: "Permission",
      dataIndex: "description",
      key: "permission",
      render: (description: string, row: { code: string }) => (
        <>
          <div>{description}</div>
          <Typography.Text type="secondary" style={{ fontSize: 12 }}>
            {row.code}
          </Typography.Text>
        </>
      ),
    },
    ...(roles?.roles ?? []).map((role) => ({
      title: (
        <>
          <div>{role.name}</div>
          <Tag style={{ marginTop: 4 }}>
            {role.userCount} {role.userCount === 1 ? "user" : "users"}
          </Tag>
        </>
      ),
      key: role.code,
      align: "center" as const,
      render: (_: unknown, row: { code: string }) =>
        role.permissions.includes(row.code) ? <CheckOutlined style={{ color: colors.brandGreen }} /> : null,
    })),
  ];

  return (
    <Card>
      <Typography.Title level={3} style={{ marginTop: 0 }}>
        Roles
      </Typography.Title>
      <Typography.Paragraph type="secondary">
        What each admin role can do. Roles are fixed; each admin user is given one role (System →
        Admin users).
      </Typography.Paragraph>
      {failed && <Alert type="error" showIcon title="Couldn't load the roles. Reload the page." />}
      <Table
        rowKey="code"
        loading={!roles && !failed}
        dataSource={roles?.permissions ?? []}
        columns={columns}
        pagination={false}
        size="middle"
        scroll={{ x: true }}
      />
    </Card>
  );
}
