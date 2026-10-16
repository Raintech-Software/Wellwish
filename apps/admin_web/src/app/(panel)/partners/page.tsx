"use client";

import { PlusOutlined } from "@ant-design/icons";
import { Alert, Badge, Button, Flex, Input, Select, Space, Switch, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { PartnerStatusTag } from "@/components/partners/StatusTag";
import { phone, ROLE_LABEL, STATUS } from "@/lib/partners";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["PartnerRowOut"];

interface Filters {
  role?: string;
  status?: string;
  available?: boolean;
  q?: string;
  toReview?: boolean;
}

const PAGE_SIZE = 20;

/** Partners → All partners (§9.1): role, status, available today, both phone numbers. */
export default function PartnersPage() {
  const can = useCan();
  const [filters, setFilters] = useState<Filters>({});
  const [page, setPage] = useState(1);
  const fetchPage = useCallback(
    async () =>
      (await api.GET("/v1/admin/partners", { params: { query: { ...filters, page, pageSize: PAGE_SIZE } } })).data,
    [filters, page],
  );
  const { data, failed, loading } = useLoad(fetchPage, can("partners.view"));

  const filter = (change: Filters) => {
    setFilters({ ...filters, ...change });
    setPage(1);
  };

  return (
    <Page
      title="Partners"
      permission="partners.view"
      description="Companions and nurses. Open one for both phone numbers, documents and status history."
      extra={
        can("partners.add") && (
          <Link href="/partners/new">
            <Button type="primary" icon={<PlusOutlined />}>
              Add partner
            </Button>
          </Link>
        )
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the partners. Reload the page." />}
      <Flex gap={8} wrap align="center" style={{ marginBottom: 16 }}>
        <Input.Search
          allowClear
          placeholder="Name or phone"
          style={{ width: 240 }}
          onSearch={(q) => filter({ q: q.trim() || undefined })}
        />
        <Select
          allowClear
          placeholder="Role"
          style={{ width: 150 }}
          options={Object.entries(ROLE_LABEL).map(([value, label]) => ({ value, label }))}
          onChange={(role?: string) => filter({ role })}
        />
        <Select
          allowClear
          placeholder="Status"
          style={{ width: 180 }}
          options={Object.entries(STATUS).map(([value, s]) => ({ value, label: s.label }))}
          onChange={(status?: string) => filter({ status })}
        />
        <Select
          allowClear
          placeholder="Available today"
          style={{ width: 170 }}
          options={[
            { value: "yes", label: "Available" },
            { value: "no", label: "Not available" },
          ]}
          onChange={(v?: string) => filter({ available: v === undefined ? undefined : v === "yes" })}
        />
        <Flex gap={6} align="center">
          <Switch size="small" onChange={(on) => filter({ toReview: on || undefined })} />
          <Typography.Text>Documents to review</Typography.Text>
        </Flex>
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
          showTotal: (total) => `${total} partners`,
        }}
        columns={[
          {
            title: "Partner",
            key: "name",
            render: (_, r) => (
              <Link href={`/partners/${r.id}`}>
                <div style={{ fontWeight: 500 }}>{r.fullName || "(registering)"}</div>
                <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                  {ROLE_LABEL[r.role]}
                  {r.addedByAdmin && " · added by admin"}
                </Typography.Text>
              </Link>
            ),
          },
          {
            title: "Phones",
            key: "phones",
            render: (_, r) => (
              <Typography.Text style={{ fontSize: 13 }}>
                <a href={`tel:${r.phone}`}>{phone(r.phone)}</a>
                {r.alternatePhone && (
                  <div>
                    <a href={`tel:${r.alternatePhone}`}>{phone(r.alternatePhone)}</a>
                  </div>
                )}
              </Typography.Text>
            ),
          },
          {
            title: "Status",
            key: "status",
            render: (_, r) => (
              <Space size={4} wrap>
                <PartnerStatusTag status={r.status} />
                {r.deleting && <Tag color="magenta">Deletion requested</Tag>}
              </Space>
            ),
          },
          {
            title: "Today",
            key: "available",
            render: (_, r) => (r.availableToday ? <Tag color="cyan">Available</Tag> : "—"),
          },
          { title: "Rating", key: "rating", render: (_, r) => r.ratingAvg ?? "—" },
          {
            title: "Documents",
            key: "docs",
            render: (_, r) => (r.documentsToReview ? <Badge count={r.documentsToReview} title="To review" /> : "—"),
          },
        ]}
      />
    </Page>
  );
}
