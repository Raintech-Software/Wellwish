"use client";

import { AlertOutlined, ArrowRightOutlined } from "@ant-design/icons";
import { Alert, Card, Col, Flex, Row, Statistic, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useEffect } from "react";

import { api } from "@/api/client";
import { useCan } from "@/auth/AuthProvider";
import Forbidden from "@/components/Forbidden";
import { ALERT_KIND } from "@/lib/assignments";
import { colors } from "@/theme";
import { date, dateTime, rupees } from "@/lib/format";
import { onLiveMessage } from "@/lib/staffSocket";
import { useLoad } from "@/lib/useLoad";

const LIVE = new Set(["queue.changed", "alert", "alert.acked", "sos.new", "sos.updated", "live.reconnected"]);

/**
 * Dashboard (§9.1, Phase 9.2): today at a glance. Bookings whose visit is today by status and the
 * Unassigned queue; booking fees today and this month; partner applications waiting; open alerts
 * and SOS. Each card only for roles allowed to see it. Updates live and every minute.
 */
export default function DashboardPage() {
  const can = useCan();
  const fetchDashboard = useCallback(async () => (await api.GET("/v1/admin/dashboard")).data, []);
  const { data, failed, reload } = useLoad(fetchDashboard, can("dashboard.view"));

  useEffect(() => onLiveMessage(({ type }) => LIVE.has(type) && reload()), [reload]);
  useEffect(() => {
    const timer = window.setInterval(() => {
      if (!document.hidden) reload();
    }, 60_000);
    return () => window.clearInterval(timer);
  }, [reload]);

  if (!can("dashboard.view")) return <Forbidden />;
  const b = data?.bookings;
  return (
    <Flex vertical gap={16}>
      <div>
        <Typography.Title level={3} style={{ margin: 0 }}>
          Today
        </Typography.Title>
        <Typography.Text type="secondary">{data ? date(data.date) : " "}</Typography.Text>
      </div>
      {failed && <Alert type="error" showIcon title="Couldn't load the dashboard. It tries again in a minute." />}
      {b && (
        <Card
          title="Bookings with a visit today"
          extra={
            <Link href="/bookings">
              All bookings <ArrowRightOutlined />
            </Link>
          }
        >
          <Row gutter={[16, 16]}>
            {[
              ["Not assigned", b.new, b.new > 0 ? colors.danger : undefined],
              ["Waiting for an answer", b.offered, undefined],
              ["Partner assigned", b.accepted, undefined],
              ["In progress", b.inProgress, colors.primary],
              ["Completed", b.completed, colors.brandGreen],
              ["Patient not available", b.noShow, undefined],
              ["Cancelled", b.cancelled, undefined],
            ].map(([title, value, color]) => (
              <Col key={title as string} xs={12} sm={8} lg={6} xl={3}>
                <Statistic title={title as string} value={value as number} styles={{ content: { color: color as string | undefined } }} />
              </Col>
            ))}
          </Row>
          <Flex gap={8} wrap align="center" style={{ marginTop: 16 }}>
            <Typography.Text strong>Unassigned queue:</Typography.Text>
            <Tag>{b.queueToday} today</Tag>
            <Tag>{b.queueLater} later</Tag>
            {b.queueLate > 0 && <Tag color="red">{b.queueLate} past the assign deadline</Tag>}
            <Link href="/bookings/queue">
              Open the queue <ArrowRightOutlined />
            </Link>
          </Flex>
        </Card>
      )}
      <Row gutter={[16, 16]}>
        {data?.alerts && (
          <Col xs={24} lg={8}>
            <Card
              title={
                <span>
                  <AlertOutlined /> Alerts
                </span>
              }
              extra={<Link href="/live">Live map</Link>}
              style={{ height: "100%" }}
            >
              <Flex gap={32}>
                <Statistic title="Not seen yet" value={data.alerts.open} />
                <Statistic
                  title="SOS open"
                  value={data.alerts.sosOpen}
                  styles={{ content: { color: data.alerts.sosOpen > 0 ? colors.danger : undefined } }}
                />
              </Flex>
              <Flex gap={6} wrap style={{ marginTop: 12 }}>
                {data.alerts.byKind.map((a) => (
                  <Tag key={a.kind} color={ALERT_KIND[a.kind]?.color}>
                    {ALERT_KIND[a.kind]?.label ?? a.kind}: {a.count}
                  </Tag>
                ))}
              </Flex>
            </Card>
          </Col>
        )}
        {data?.fees && (
          <Col xs={24} lg={8}>
            <Card title="Booking fees" extra={<Link href="/reports/fees">Report</Link>} style={{ height: "100%" }}>
              <Flex gap={32} wrap>
                <Statistic title="Collected today" value={rupees(data.fees.collectedPaise)} />
                <Statistic title="Payments today" value={data.fees.payments} />
                <Statistic title="Refunded today" value={rupees(data.fees.refundedPaise)} />
              </Flex>
              <Typography.Paragraph type="secondary" style={{ marginTop: 12, marginBottom: 0 }}>
                This month: {rupees(data.fees.monthCollectedPaise)} collected, {rupees(data.fees.monthNetPaise)} after refunds.
              </Typography.Paragraph>
            </Card>
          </Col>
        )}
        {data?.applications && (
          <Col xs={24} lg={8}>
            <Card
              title="Partner applications"
              extra={<Link href="/partners/applications">Review</Link>}
              style={{ height: "100%" }}
            >
              <Statistic title="Waiting for review" value={data.applications.waiting} />
              {data.applications.oldestAt && (
                <Typography.Paragraph type="secondary" style={{ marginTop: 12, marginBottom: 0 }}>
                  Oldest sent {dateTime(data.applications.oldestAt)}.
                </Typography.Paragraph>
              )}
            </Card>
          </Col>
        )}
      </Row>
    </Flex>
  );
}
