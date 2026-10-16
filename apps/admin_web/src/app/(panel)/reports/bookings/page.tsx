"use client";

import { Alert, Table, Typography } from "antd";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import ReportToolbar, { rangeQuery, thisMonth, type Range } from "@/components/reports/ReportToolbar";
import { date } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";

type Day = components["schemas"]["BookingsReportRowOut"];
type ByService = components["schemas"]["BookingsByServiceOut"];

const COUNTS = [
  { title: "Booked", key: "booked" },
  { title: "Completed", key: "completed" },
  { title: "Cancelled", key: "cancelled" },
  { title: "Patient not available", key: "noShow" },
  { title: "Not finished", key: "open" },
] as const;

/** Reports → Bookings (§9.1, Phase 9.2): paid bookings by visit date and by service. */
export default function BookingsReportPage() {
  const can = useCan();
  const [range, setRange] = useState<Range>(thisMonth);
  const query = rangeQuery(range);
  const fetchReport = useCallback(
    async () => (await api.GET("/v1/admin/reports/bookings", { params: { query: rangeQuery(range) } })).data,
    [range],
  );
  const { data, failed, loading } = useLoad(fetchReport, can("bookings.view"));
  const counts = COUNTS.map((c) => ({ title: c.title, key: c.key, dataIndex: c.key, align: "right" as const }));

  return (
    <Page
      title="Bookings report"
      permission="bookings.view"
      description="Paid bookings by the visit's date (India) and by service: how many were booked, completed, cancelled, patient not available, or are not finished yet."
    >
      <ReportToolbar
        range={range}
        onRange={setRange}
        filename={`wellwish-bookings-${query.from}-to-${query.to}.csv`}
        download={() => api.GET("/v1/admin/reports/bookings/csv", { params: { query }, parseAs: "blob" })}
      />
      {failed && <Alert type="error" showIcon title="Couldn't load the report. Try again." style={{ marginBottom: 12 }} />}
      <Table<Day>
        rowKey={(d) => d.date ?? "total"}
        size="small"
        loading={loading}
        dataSource={data ? [...data.days, data.total] : []}
        pagination={false}
        scroll={{ x: true }}
        locale={{ emptyText: "No paid bookings for these dates" }}
        rowClassName={(d) => (d.date ? "" : "ant-table-row-selected")}
        columns={[
          { title: "Visit date", key: "date", render: (_, d) => (d.date ? date(d.date) : <b>Total</b>) },
          ...counts,
        ]}
      />
      <Typography.Title level={5} style={{ marginTop: 24 }}>
        By service
      </Typography.Title>
      <Table<ByService>
        rowKey="service"
        size="small"
        loading={loading}
        dataSource={data?.services ?? []}
        pagination={false}
        scroll={{ x: true }}
        columns={[{ title: "Service", key: "service", dataIndex: "service" }, ...counts]}
      />
    </Page>
  );
}
