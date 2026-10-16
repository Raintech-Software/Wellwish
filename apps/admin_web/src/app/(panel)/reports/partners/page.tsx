"use client";

import { Alert, Table, Tag } from "antd";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import ReportToolbar, { rangeQuery, thisMonth, type Range } from "@/components/reports/ReportToolbar";
import { ROLE_LABEL, STATUS } from "@/lib/partners";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["PartnerPerformanceRowOut"];

/**
 * Reports → Partner performance (§9.1, Phase 9.2): for each approved partner (and anyone else
 * with work on these dates): jobs done, patient not available, offers and how they answered,
 * acceptance %, rating.
 */
export default function PartnerPerformancePage() {
  const can = useCan();
  const [range, setRange] = useState<Range>(thisMonth);
  const query = rangeQuery(range);
  const fetchReport = useCallback(
    async () => (await api.GET("/v1/admin/reports/partners", { params: { query: rangeQuery(range) } })).data,
    [range],
  );
  const { data, failed, loading } = useLoad(fetchReport, can("partners.view"));
  const count = (title: string, key: keyof Row) => ({ title, key, dataIndex: key, align: "right" as const });

  return (
    <Page
      title="Partner performance"
      permission="partners.view"
      description="Each approved partner, and anyone else who had work on these dates: visits done (by the visit's date), patient not available, offers sent then and how they answered, acceptance and rating."
    >
      <ReportToolbar
        range={range}
        onRange={setRange}
        filename={`wellwish-partners-${query.from}-to-${query.to}.csv`}
        download={() => api.GET("/v1/admin/reports/partners/csv", { params: { query }, parseAs: "blob" })}
        note="Not answered: no answer within 2 minutes."
      />
      {failed && <Alert type="error" showIcon title="Couldn't load the report. Try again." style={{ marginBottom: 12 }} />}
      <Table<Row>
        rowKey="partnerId"
        size="small"
        loading={loading}
        dataSource={data?.rows ?? []}
        pagination={{ pageSize: 50, hideOnSinglePage: true }}
        scroll={{ x: true }}
        locale={{ emptyText: "No partners" }}
        columns={[
          {
            title: "Partner",
            key: "name",
            render: (_, r) => <Link href={`/partners/${r.partnerId}`}>{r.name || "—"}</Link>,
          },
          { title: "Role", key: "role", render: (_, r) => ROLE_LABEL[r.role] ?? r.role },
          {
            title: "Status",
            key: "status",
            render: (_, r) => <Tag color={STATUS[r.status]?.color}>{STATUS[r.status]?.label ?? r.status}</Tag>,
          },
          count("Jobs done", "jobs"),
          count("Patient not available", "noShow"),
          count("Offers", "offersReceived"),
          count("Accepted", "offersAccepted"),
          count("Declined", "offersDeclined"),
          count("Not answered", "offersNotAnswered"),
          {
            title: "Acceptance",
            key: "acceptance",
            align: "right",
            sorter: (a, b) => (a.acceptancePercent ?? -1) - (b.acceptancePercent ?? -1),
            render: (_, r) => (r.acceptancePercent == null ? "—" : `${r.acceptancePercent}%`),
          },
          {
            title: "Rating",
            key: "rating",
            align: "right",
            render: (_, r) => (r.ratingAvg == null ? "—" : `★ ${r.ratingAvg.toFixed(1)} (${r.ratingCount})`),
          },
        ]}
      />
    </Page>
  );
}
