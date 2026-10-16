"use client";

import { DownloadOutlined } from "@ant-design/icons";
import { Alert, App, Button, DatePicker, Flex, Input, Select, Table, Typography } from "antd";
import type { Dayjs } from "dayjs";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorMessage } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";

type Entry = components["schemas"]["AuditEntryOut"];

interface Query {
  staffId?: string;
  action?: string;
  entityType?: string;
  entityId?: string;
  from?: string;
  to?: string;
}

const PAGE_SIZE = 20;

function Json({ value }: { value: Record<string, unknown> | null | undefined }) {
  if (!value || !Object.keys(value).length) return <Typography.Text type="secondary">—</Typography.Text>;
  return (
    <pre style={{ margin: 0, fontSize: 12, whiteSpace: "pre-wrap", wordBreak: "break-word" }}>
      {JSON.stringify(value, null, 2)}
    </pre>
  );
}

const fetchChoices = async () => (await api.GET("/v1/admin/audit-log/filters")).data;

/** System → Audit log (§9.1): every admin action, read-only, with CSV export. */
export default function AuditLogPage() {
  const { message } = App.useApp();
  const can = useCan();
  const [page, setPage] = useState(1);
  const [query, setQuery] = useState<Query>({});
  const [exporting, setExporting] = useState(false);
  const allowed = can("audit.view");

  const fetchPage = useCallback(
    async () =>
      (await api.GET("/v1/admin/audit-log", { params: { query: { ...query, page, pageSize: PAGE_SIZE } } })).data,
    [query, page],
  );
  const { data, failed, loading } = useLoad(fetchPage, allowed);
  const choices = useLoad(fetchChoices, allowed).data;

  const filter = (change: Partial<Query>) => {
    setQuery({ ...query, ...change });
    setPage(1);
  };

  const exportCsv = async () => {
    setExporting(true);
    const { data, error, response } = await api.GET("/v1/admin/audit-log/export", {
      params: { query },
      parseAs: "blob",
    });
    setExporting(false);
    if (!data) {
      message.error(errorMessage(error));
      return;
    }
    const name = /filename="([^"]+)"/.exec(response.headers.get("Content-Disposition") ?? "")?.[1];
    const url = URL.createObjectURL(data as Blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = name ?? "wellwish-audit.csv";
    link.click();
    URL.revokeObjectURL(url);
  };

  const columns = [
    { title: "When (IST)", dataIndex: "at", key: "at", render: dateTime, width: 180 },
    {
      title: "Who",
      key: "who",
      render: (_: unknown, e: Entry) => e.staff?.name ?? <Typography.Text type="secondary">System</Typography.Text>,
    },
    { title: "Action", dataIndex: "action", key: "action", render: (a: string) => <code>{a}</code> },
    {
      title: "What",
      key: "entity",
      render: (_: unknown, e: Entry) => (
        <>
          <div>{e.entityType}</div>
          <Typography.Text type="secondary" style={{ fontSize: 12 }} copyable={!!e.entityId}>
            {e.entityId}
          </Typography.Text>
        </>
      ),
    },
    { title: "Reason", dataIndex: "reason", key: "reason" },
    { title: "IP", dataIndex: "ip", key: "ip" },
  ];

  return (
    <Page
      title="Audit log"
      permission="audit.view"
      description="Every admin action, with the values before and after. Nobody can change or delete it."
      extra={
        <Button icon={<DownloadOutlined />} loading={exporting} onClick={exportCsv}>
          Export CSV
        </Button>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the audit log. Reload the page." />}
      <Flex gap={8} wrap style={{ marginBottom: 16 }}>
        <Select
          allowClear
          showSearch
          optionFilterProp="label"
          placeholder="Who"
          style={{ width: 200 }}
          options={(choices?.staff ?? []).map((s) => ({ value: s.id, label: s.name }))}
          onChange={(staffId?: string) => filter({ staffId })}
        />
        <Select
          allowClear
          showSearch
          placeholder="Action"
          style={{ width: 240 }}
          options={(choices?.actions ?? []).map((a) => ({ value: a, label: a }))}
          onChange={(action?: string) => filter({ action })}
        />
        <Select
          allowClear
          placeholder="What"
          style={{ width: 220 }}
          options={(choices?.entityTypes ?? []).map((t) => ({ value: t, label: t }))}
          onChange={(entityType?: string) => filter({ entityType })}
        />
        <Input.Search
          allowClear
          placeholder="Record id"
          style={{ width: 220 }}
          onSearch={(entityId) => filter({ entityId: entityId.trim() || undefined })}
        />
        <DatePicker.RangePicker
          format="D MMM YYYY"
          onChange={(range) => {
            const [from, to] = (range ?? [null, null]) as [Dayjs | null, Dayjs | null];
            filter({ from: from?.format("YYYY-MM-DD"), to: to?.format("YYYY-MM-DD") });
          }}
        />
      </Flex>
      <Table
        rowKey="id"
        loading={loading}
        dataSource={data?.items ?? []}
        columns={columns}
        scroll={{ x: true }}
        expandable={{
          expandedRowRender: (e: Entry) => (
            <Flex gap={24} wrap>
              <div style={{ flex: "1 1 280px" }}>
                <Typography.Text strong>Before</Typography.Text>
                <Json value={e.before} />
              </div>
              <div style={{ flex: "1 1 280px" }}>
                <Typography.Text strong>After</Typography.Text>
                <Json value={e.after} />
              </div>
            </Flex>
          ),
          rowExpandable: (e: Entry) => Boolean(e.before || e.after),
        }}
        pagination={{
          current: page,
          pageSize: PAGE_SIZE,
          total: data?.count ?? 0,
          showSizeChanger: false,
          showTotal: (total) => `${total} entries`,
          onChange: setPage,
        }}
      />
    </Page>
  );
}
