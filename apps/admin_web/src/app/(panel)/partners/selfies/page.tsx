"use client";

import { Alert, Card, Col, DatePicker, Empty, Flex, Image, Row, Spin, Tag, Typography } from "antd";
import dayjs, { type Dayjs } from "dayjs";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { dateTime } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";

/** Today's date in India: the selfie day and the latest date that can be picked. */
const indiaToday = (): Dayjs =>
  dayjs(new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Kolkata" }).format(new Date()));

/**
 * Selfie checks (§6.15, PHASES 7.10): each partner takes a selfie once a day before switching
 * "Available today" on. Spot-check them against the approved profile photo.
 */
export default function SelfiesPage() {
  const can = useCan();
  const [day, setDay] = useState<Dayjs>(indiaToday);
  const fetchPage = useCallback(
    async () =>
      (await api.GET("/v1/admin/selfies", { params: { query: { date: day.format("YYYY-MM-DD"), pageSize: 100 } } }))
        .data,
    [day],
  );
  const { data, failed, loading } = useLoad(fetchPage, can("partners.review"));

  return (
    <Page
      title="Selfie checks"
      permission="partners.review"
      description="Partners take a selfie once a day before going available. Compare it with their approved photo; suspend from the partner's page if it isn't them."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the selfies. Reload the page." />}
      <Flex gap={8} style={{ marginBottom: 16 }}>
        <DatePicker
          value={day}
          allowClear={false}
          format="D MMM YYYY"
          disabledDate={(d) => d.isAfter(indiaToday(), "day")}
          onChange={(value) => value && setDay(value)}
        />
      </Flex>
      {loading && !data && <Spin />}
      {data && data.items.length === 0 && <Empty description="No selfies that day" />}
      <Row gutter={[16, 16]}>
        {(data?.items ?? []).map((s) => (
          <Col key={s.id} xs={24} sm={12} lg={8} xl={6}>
            <Card size="small">
              <Flex gap={8} justify="center">
                <div style={{ textAlign: "center" }}>
                  <Image src={s.selfieUrl ?? undefined} alt="Selfie" width={110} height={110} style={{ objectFit: "cover" }} />
                  <div>
                    <Typography.Text type="secondary">Selfie</Typography.Text>
                  </div>
                </div>
                <div style={{ textAlign: "center" }}>
                  <Image src={s.photoUrl ?? undefined} alt="Approved photo" width={110} height={110} style={{ objectFit: "cover" }} />
                  <div>
                    <Typography.Text type="secondary">Approved photo</Typography.Text>
                  </div>
                </div>
              </Flex>
              <div style={{ marginTop: 8 }}>
                <Link href={`/partners/${s.partnerId}`}>{s.partnerName || "Partner"}</Link>{" "}
                <Tag>{s.role === "NURSE" ? "Nurse" : "Companion"}</Tag>
              </div>
              <Typography.Text type="secondary">{dateTime(s.at)}</Typography.Text>
            </Card>
          </Col>
        ))}
      </Row>
    </Page>
  );
}
