"use client";

import { ArrowLeftOutlined } from "@ant-design/icons";
import { Alert, Button, Flex, Select, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { dateTime } from "@/lib/format";
import { DELETION_STATUS } from "@/lib/patients";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["AccountDeletionOut"];
type Status = "PENDING" | "CANCELLED" | "DONE";

const PAGE_SIZE = 20;

/**
 * Patients → Account deletion requests (PHASES 4.5, §12). A patient's "Delete my account" logs
 * them out at once; a daily job removes their personal data 7 days later unless they log in
 * again. Payment records are kept. Only the phone's last 4 digits are kept here.
 */
export default function AccountDeletionsPage() {
  const can = useCan();
  const [status, setStatus] = useState<Status | undefined>();
  const [page, setPage] = useState(1);
  const fetchPage = useCallback(
    async () =>
      (await api.GET("/v1/admin/account-deletions", { params: { query: { status, page, pageSize: PAGE_SIZE } } }))
        .data,
    [status, page],
  );
  const { data, failed, loading } = useLoad(fetchPage, can("patients.manage"));

  return (
    <Page
      title="Account deletion requests"
      permission="patients.manage"
      description="Patients who asked to delete their account. Their data goes 7 days after the request unless they log in again; payment records stay."
      extra={
        <Link href="/patients">
          <Button icon={<ArrowLeftOutlined />}>Patients</Button>
        </Link>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the requests. Reload the page." />}
      <Flex gap={8} style={{ marginBottom: 16 }}>
        <Select
          allowClear
          placeholder="Status"
          style={{ width: 240 }}
          options={Object.entries(DELETION_STATUS).map(([value, s]) => ({ value, label: s.label }))}
          onChange={(value?: Status) => {
            setStatus(value);
            setPage(1);
          }}
        />
      </Flex>
      <Table<Row>
        rowKey="id"
        loading={loading}
        dataSource={data?.items ?? []}
        scroll={{ x: true }}
        pagination={{
          current: page,
          pageSize: PAGE_SIZE,
          total: data?.count ?? 0,
          showSizeChanger: false,
          onChange: setPage,
          showTotal: (total) => `${total} requests`,
        }}
        columns={[
          { title: "Phone", key: "phone", render: (_, r) => `+91 ••••• •${r.phoneLast4}` },
          { title: "Asked", key: "created", render: (_, r) => dateTime(r.createdAt) },
          {
            title: "Status",
            key: "status",
            render: (_, r) => {
              const s = DELETION_STATUS[r.status] ?? { label: r.status, color: "default" };
              return <Tag color={s.color}>{s.label}</Tag>;
            },
          },
          {
            title: "When",
            key: "when",
            render: (_, r) =>
              r.status === "DONE"
                ? `Deleted ${dateTime(r.doneAt)}`
                : r.status === "CANCELLED"
                  ? `Cancelled ${dateTime(r.cancelledAt)}`
                  : `Due ${dateTime(r.dueAt)}`,
          },
          {
            title: "",
            key: "partner",
            render: (_, r) =>
              r.keptPartner ? (
                <Typography.Text type="secondary">Also a partner: partner account kept</Typography.Text>
              ) : null,
          },
        ]}
      />
    </Page>
  );
}
