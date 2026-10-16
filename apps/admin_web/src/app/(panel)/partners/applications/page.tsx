"use client";

import { Alert, Button, Segmented, Space, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { PartnerStatusTag } from "@/components/partners/StatusTag";
import { dateTime } from "@/lib/format";
import { phone, ROLE_LABEL } from "@/lib/partners";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["ApplicationRowOut"];

/** How long it has waited: green under a day, orange under two, red after that. */
function Sla({ hours }: { hours: number }) {
  const color = hours < 24 ? "success" : hours < 48 ? "warning" : "error";
  const text = hours < 1 ? "just now" : hours < 48 ? `${hours} h` : `${Math.floor(hours / 24)} days`;
  return <Tag color={color}>{text}</Tag>;
}

/** Partners → Applications (§9.4): oldest first. Opening one locks it to you for 30 minutes. */
export default function ApplicationsPage() {
  const can = useCan();
  const [role, setRole] = useState("");
  const fetchRows = useCallback(
    async () => (await api.GET("/v1/admin/applications", { params: { query: { role } } })).data,
    [role],
  );
  const { data, failed, loading } = useLoad(fetchRows, can("partners.review"));

  return (
    <Page
      title="Partner applications"
      permission="partners.review"
      description="New companions and nurses waiting for review, oldest first. Check each document and the photo match, then approve, ask for changes or reject."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the applications. Reload the page." />}
      <Segmented
        style={{ marginBottom: 16 }}
        value={role}
        onChange={(v) => setRole(v as string)}
        options={[
          { value: "", label: "All" },
          { value: "COMPANION", label: "Companions" },
          { value: "NURSE", label: "Nurses" },
        ]}
      />
      <Table<Row>
        rowKey="id"
        loading={loading}
        dataSource={data ?? []}
        pagination={false}
        scroll={{ x: true }}
        locale={{ emptyText: "No applications waiting." }}
        columns={[
          {
            title: "Partner",
            key: "name",
            render: (_, r) => (
              <>
                <div style={{ fontWeight: 500 }}>{r.fullName}</div>
                <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                  {ROLE_LABEL[r.role]} · {phone(r.phone)}
                </Typography.Text>
              </>
            ),
          },
          { title: "Status", key: "status", render: (_, r) => <PartnerStatusTag status={r.status} /> },
          {
            title: "Submitted",
            key: "submitted",
            render: (_, r) => (
              <Space orientation="vertical" size={2}>
                <span>{dateTime(r.submittedAt)}</span>
                {r.submittedAt !== r.firstSubmittedAt && (
                  <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                    Re-submitted (first {dateTime(r.firstSubmittedAt)})
                  </Typography.Text>
                )}
              </Space>
            ),
          },
          { title: "Waiting", key: "sla", render: (_, r) => <Sla hours={r.waitingHours} /> },
          { title: "To review", dataIndex: "pendingDocuments", key: "pending", align: "right" },
          {
            title: "Reviewer",
            key: "claimed",
            render: (_, r) =>
              r.claimedBy ? (
                <Tag color={r.claimedByMe ? "blue" : "default"}>{r.claimedByMe ? "You" : r.claimedBy}</Tag>
              ) : (
                "—"
              ),
          },
          {
            title: "",
            key: "open",
            render: (_, r) => (
              <Link href={`/partners/applications/${r.id}`}>
                <Button size="small" type="primary" disabled={!!r.claimedBy && !r.claimedByMe}>
                  {r.claimedByMe ? "Continue" : "Review"}
                </Button>
              </Link>
            ),
          },
        ]}
      />
    </Page>
  );
}
