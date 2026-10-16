"use client";

import { Alert, Flex, Input, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { dateTime } from "@/lib/format";
import { phone } from "@/lib/partners";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["PatientRowOut"];

const PAGE_SIZE = 20;

/** Patients (§9.1): accounts, newest first. Search by name or phone. */
export default function PatientsPage() {
  const can = useCan();
  const [q, setQ] = useState("");
  const [page, setPage] = useState(1);
  const fetchPage = useCallback(
    async () =>
      (await api.GET("/v1/admin/patients", { params: { query: { q: q || undefined, page, pageSize: PAGE_SIZE } } }))
        .data,
    [q, page],
  );
  const { data, failed, loading } = useLoad(fetchPage, can("patients.view"));

  return (
    <Page
      title="Patients"
      permission="patients.view"
      description="Patient accounts with their family members, addresses, documents and bookings. Payments are added with that phase."
      extra={
        can("patients.manage") && (
          <Link href="/patients/deletions">Account deletion requests</Link>
        )
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the patients. Reload the page." />}
      <Flex gap={8} wrap align="center" style={{ marginBottom: 16 }}>
        <Input.Search
          allowClear
          placeholder="Name, or 4+ digits of the phone"
          style={{ width: 280 }}
          onSearch={(value) => {
            setQ(value.trim());
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
          showTotal: (total) => `${total} patients`,
        }}
        columns={[
          {
            title: "Patient",
            key: "name",
            render: (_, r) => (
              <Link href={`/patients/${r.id}`}>
                <div style={{ fontWeight: 500 }}>{r.fullName || "(profile not filled in)"}</div>
              </Link>
            ),
          },
          {
            title: "Phone",
            key: "phone",
            render: (_, r) => <a href={`tel:${r.phone}`}>{phone(r.phone)}</a>,
          },
          { title: "Family members", dataIndex: "memberCount", key: "members" },
          { title: "Joined", key: "joined", render: (_, r) => dateTime(r.createdAt) },
          {
            title: "",
            key: "deletion",
            render: (_, r) =>
              r.deletionDueAt ? (
                <Tag color="orange">Deletion on {dateTime(r.deletionDueAt)}</Tag>
              ) : r.status !== "ACTIVE" ? (
                <Typography.Text type="secondary">{r.status.toLowerCase()}</Typography.Text>
              ) : null,
          },
        ]}
      />
    </Page>
  );
}
