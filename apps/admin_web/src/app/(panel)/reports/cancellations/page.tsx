"use client";

import { Alert, Flex, Statistic, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import ReportToolbar, { rangeQuery, thisMonth, type Range } from "@/components/reports/ReportToolbar";
import { date, dateTime, rupees } from "@/lib/format";
import { REFUND_STATUS, reasonText } from "@/lib/payments";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["CancellationRowOut"];

const BY: Record<string, string> = { PATIENT: "Patient", STAFF: "Admin", SYSTEM: "System", PARTNER: "Partner" };

/**
 * Reports → Cancellations and refunds (§9.1, Phase 9.2): bookings cancelled on these dates (who,
 * why, refund %) and refunds asked for other bookings (after a visit), with the fee paid and what
 * was refunded.
 */
export default function CancellationsReportPage() {
  const can = useCan();
  const [range, setRange] = useState<Range>(thisMonth);
  const query = rangeQuery(range);
  const fetchReport = useCallback(
    async () =>
      (await api.GET("/v1/admin/reports/cancellations", { params: { query: rangeQuery(range) } })).data,
    [range],
  );
  const { data, failed, loading } = useLoad(fetchReport, can("payments.view"));

  return (
    <Page
      title="Cancellations and refunds"
      permission="payments.view"
      description="Bookings cancelled on these dates (by whom, why, the refund %) and refunds asked for other bookings after a visit, with the fee paid and what has been refunded so far."
    >
      <ReportToolbar
        range={range}
        onRange={setRange}
        filename={`wellwish-cancellations-${query.from}-to-${query.to}.csv`}
        download={() => api.GET("/v1/admin/reports/cancellations/csv", { params: { query }, parseAs: "blob" })}
      />
      {failed && <Alert type="error" showIcon title="Couldn't load the report. Try again." style={{ marginBottom: 12 }} />}
      {data && (
        <Flex gap={32} style={{ marginBottom: 16 }}>
          <Statistic title="Bookings cancelled" value={data.cancelled} />
          <Statistic title="Refunded" value={rupees(data.refundedPaise)} />
        </Flex>
      )}
      <Table<Row>
        rowKey={(r) => `${r.kind}-${r.code}-${r.at}`}
        size="small"
        loading={loading}
        dataSource={data?.rows ?? []}
        pagination={{ pageSize: 50, hideOnSinglePage: true }}
        scroll={{ x: true }}
        locale={{ emptyText: "No cancellations or refunds for these dates" }}
        columns={[
          {
            title: "Type",
            key: "kind",
            render: (_, r) =>
              r.kind === "CANCELLED" ? <Tag color="volcano">Cancelled</Tag> : <Tag color="blue">Refund after the visit</Tag>,
          },
          { title: "Booking", key: "code", render: (_, r) => <Link href={`/bookings/${r.bookingId}`}>{r.code}</Link> },
          { title: "Visit", key: "visit", render: (_, r) => date(r.visitDate) },
          { title: "Service", key: "service", dataIndex: "service" },
          { title: "When", key: "at", render: (_, r) => dateTime(r.at) },
          { title: "By", key: "by", render: (_, r) => BY[r.by] ?? r.by },
          {
            title: "Reason",
            key: "reason",
            render: (_, r) => <Typography.Text style={{ maxWidth: 260 }} ellipsis={{ tooltip: true }}>{reasonText(r.reason)}</Typography.Text>,
          },
          { title: "Refund %", key: "percent", align: "right", render: (_, r) => (r.refundPercent == null ? "—" : `${r.refundPercent}%`) },
          { title: "Fee paid", key: "paid", align: "right", render: (_, r) => rupees(r.feePaidPaise) },
          { title: "Refunded", key: "refunded", align: "right", render: (_, r) => rupees(r.refundedPaise) },
          {
            title: "Refund",
            key: "status",
            render: (_, r) =>
              r.refundStatus ? (
                <Tag color={REFUND_STATUS[r.refundStatus]?.color}>{REFUND_STATUS[r.refundStatus]?.label ?? r.refundStatus}</Tag>
              ) : (
                "—"
              ),
          },
        ]}
      />
    </Page>
  );
}
