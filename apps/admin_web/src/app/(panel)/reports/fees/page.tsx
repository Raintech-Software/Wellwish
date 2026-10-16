"use client";

import { Alert, Table } from "antd";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import ReportToolbar, { rangeQuery, thisMonth, type Range } from "@/components/reports/ReportToolbar";
import { date, rupees } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";

type Day = components["schemas"]["FeeDayOut"];

/**
 * Reports → Fees collected (§9.1, PHASES 6.10 and 9.2): booking fees per India date (payments,
 * collected, refunded, net), on screen and as a CSV. Each CSV download is logged.
 */
export default function FeesReportPage() {
  const can = useCan();
  const [range, setRange] = useState<Range>(thisMonth);
  const query = rangeQuery(range);
  const fetchReport = useCallback(
    async () => (await api.GET("/v1/admin/reports/fees/days", { params: { query: rangeQuery(range) } })).data,
    [range],
  );
  const { data, failed, loading } = useLoad(fetchReport, can("payments.view"));

  return (
    <Page
      title="Fees collected"
      permission="payments.view"
      description="Booking fees per day (India dates): payments, fees collected, refunded and net. Only paid payments count; refunds count on the day Razorpay completes them."
    >
      <ReportToolbar
        range={range}
        onRange={setRange}
        filename={`wellwish-fees-${query.from}-to-${query.to}.csv`}
        download={() => api.GET("/v1/admin/reports/fees", { params: { query }, parseAs: "blob" })}
      />
      {failed && <Alert type="error" showIcon title="Couldn't load the report. Try again." style={{ marginBottom: 12 }} />}
      <Table<Day>
        rowKey={(d) => d.date ?? "total"}
        size="small"
        loading={loading}
        dataSource={data ? [...data.days, data.total] : []}
        pagination={false}
        scroll={{ x: true }}
        locale={{ emptyText: "No payments for these dates" }}
        rowClassName={(d) => (d.date ? "" : "ant-table-row-selected")}
        columns={[
          { title: "Date", key: "date", render: (_, d) => (d.date ? date(d.date) : <b>Total</b>) },
          { title: "Payments", key: "payments", dataIndex: "payments", align: "right" },
          { title: "Fees collected", key: "collected", align: "right", render: (_, d) => rupees(d.collectedPaise) },
          { title: "Refunded", key: "refunded", align: "right", render: (_, d) => rupees(d.refundedPaise) },
          { title: "Net", key: "net", align: "right", render: (_, d) => <b>{rupees(d.netPaise)}</b> },
        ]}
      />
    </Page>
  );
}
