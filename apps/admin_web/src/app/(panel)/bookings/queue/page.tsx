"use client";

import { WarningOutlined } from "@ant-design/icons";
import { Alert, Badge, Button, Flex, Segmented, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useEffect, useRef, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import AssignDialog from "@/components/bookings/AssignDialog";
import TemporaryAssignDialog from "@/components/bookings/TemporaryAssignDialog";
import { clock, useSecondsLeft } from "@/lib/assignments";
import { PARTNER_TYPE, VISIT_TYPE } from "@/lib/bookings";
import { dateTime } from "@/lib/format";
import { serverNow } from "@/lib/serverClock";
import { onLiveMessage } from "@/lib/staffSocket";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["QueueRowOut"];
type When = "today" | "tomorrow" | "later";

const PAGE_SIZE = 50;

/** Today's date in India ("2026-10-10"): the Today / Tomorrow / Later groups move at midnight. */
const indiaDay = () => new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Kolkata" }).format(new Date());

/** The time now, ticking every 30 s: a row turns red the moment its deadline passes. */
function useNow(): number {
  const [now, setNow] = useState(() => serverNow());
  useEffect(() => {
    const id = setInterval(() => setNow(serverNow()), 30_000);
    return () => clearInterval(id);
  }, []);
  return now;
}

function OfferStatus({ row }: { row: Row }) {
  const left = useSecondsLeft(row.offer?.timeoutAt);
  if (row.problem === "PARTNER_UNAVAILABLE") return <Tag color="red">Partner unavailable: reassign</Tag>;
  if (!row.offer) return row.problem === "RECONFIRM" ? <Tag color="orange">New time not confirmed</Tag> : <Tag color="cyan">New</Tag>;
  const late = left !== null && left < 0;
  return (
    <div>
      <Tag color={late ? "orange" : "gold"}>
        {row.offer.kind === "RECONFIRM" ? "Confirming new time" : "Waiting"}
        {left !== null && ` · ${late ? "no answer " : ""}${clock(left)}`}
      </Tag>
      <div>
        <Typography.Text type="secondary">{row.offer.partnerName}</Typography.Text>
      </div>
    </div>
  );
}

/**
 * Unassigned queue (§6.17, §9.3, PHASES 7.11): paid bookings without a partner yet, soonest
 * first, grouped Today / Tomorrow / Later. Red past the assign deadline (6 PM the day before or
 * 3 h before pickup). Updates live; new bookings chime (the panel's live alerts).
 */
export default function QueuePage() {
  const can = useCan();
  const [when, setWhen] = useState<When>("today");
  const [page, setPage] = useState(1);
  const [assigning, setAssigning] = useState<Row | null>(null);
  const [temporaryFor, setTemporaryFor] = useState<Row | null>(null); // §6.19
  const now = useNow();
  const fetchPage = useCallback(
    async () =>
      (await api.GET("/v1/admin/assignments/queue", { params: { query: { when, page, pageSize: PAGE_SIZE } } })).data,
    [when, page],
  );
  const fetchCounts = useCallback(async () => (await api.GET("/v1/admin/assignments/queue/counts")).data, []);
  const { data, failed, loading, reload } = useLoad(fetchPage, can("bookings.view"));
  const counts = useLoad(fetchCounts, can("bookings.view"));
  const reloadCounts = counts.reload;

  useEffect(
    () =>
      onLiveMessage(({ type }) => {
        if (type === "queue.changed" || type === "alert" || type === "live.reconnected") {
          reload();
          reloadCounts();
        }
      }),
    [reload, reloadCounts],
  );

  // After midnight (India time) yesterday's "Tomorrow" is today's "Today": reload the groups.
  const day = useRef(indiaDay());
  useEffect(() => {
    const id = setInterval(() => {
      if (indiaDay() === day.current) return;
      day.current = indiaDay();
      reload();
      reloadCounts();
    }, 60_000);
    return () => clearInterval(id);
  }, [reload, reloadCounts]);
  const isLate = (r: Row) => r.late || Date.parse(r.deadlineAt) <= now;

  const label = (key: When, text: string) => (
    <Badge count={counts.data?.[key] ?? 0} size="small" offset={[8, -2]} color={key === "today" ? "red" : "blue"}>
      <span>{text}</span>
    </Badge>
  );

  return (
    <Page
      title="Unassigned queue"
      permission="bookings.view"
      description="Paid bookings waiting for a partner, soonest first. Red = past the assign deadline (6 PM the evening before, or 3 hours before pickup). Times are India time. The list updates by itself."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the queue. Reload the page." />}
      <Flex gap={8} wrap style={{ marginBottom: 16 }}>
        <Segmented<When>
          value={when}
          onChange={(value) => {
            setWhen(value);
            setPage(1);
          }}
          options={[
            { value: "today", label: label("today", "Today") },
            { value: "tomorrow", label: label("tomorrow", "Tomorrow") },
            { value: "later", label: label("later", "Later") },
          ]}
        />
      </Flex>
      <Table<Row>
        rowKey="id"
        loading={loading}
        dataSource={data?.items ?? []}
        pagination={
          (data?.count ?? 0) > PAGE_SIZE
            ? { current: page, pageSize: PAGE_SIZE, total: data?.count ?? 0, showSizeChanger: false, onChange: setPage }
            : false
        }
        scroll={{ x: true }}
        locale={{ emptyText: "Nothing waiting here" }}
        onRow={(r) => ({ style: isLate(r) ? { background: "#fff1f0" } : undefined })}
        columns={[
          {
            title: "Booking",
            key: "code",
            render: (_, r) => (
              <Link href={`/bookings/${r.id}`}>
                <span style={{ fontWeight: 500, whiteSpace: "nowrap" }}>{r.code}</span>
              </Link>
            ),
          },
          {
            title: "Pickup",
            key: "pickup",
            render: (_, r) => (
              <>
                <div style={{ whiteSpace: "nowrap" }}>{dateTime(r.pickupAt)}</div>
                {isLate(r) ? (
                  <Typography.Text type="danger">
                    <WarningOutlined /> Past the deadline
                  </Typography.Text>
                ) : (
                  <Typography.Text type="secondary">Assign by {dateTime(r.deadlineAt)}</Typography.Text>
                )}
              </>
            ),
          },
          {
            title: "Service",
            key: "service",
            render: (_, r) => (
              <>
                <div>{r.serviceName}</div>
                <Typography.Text type="secondary">
                  {PARTNER_TYPE[r.partnerType] ?? r.partnerType} · {VISIT_TYPE[r.visitType] ?? r.visitType}
                </Typography.Text>
              </>
            ),
          },
          { title: "For", key: "member", render: (_, r) => r.memberName || "—" },
          { title: "Hospital", key: "hospital", render: (_, r) => r.hospitalName || "—" },
          { title: "Status", key: "offer", render: (_, r) => <OfferStatus row={r} /> },
          {
            title: "",
            key: "actions",
            render: (_, r) => (
              <Flex gap={8} align="center">
                {r.openAlerts > 0 && <Badge count={r.openAlerts} title="Open alerts" />}
                {r.status === "ACCEPTED" ? (
                  <Link href={`/bookings/${r.id}`}>
                    <Button size="small">Open</Button>
                  </Link>
                ) : (
                  can("bookings.manage") && (
                    <>
                      <Button type={r.offer ? "default" : "primary"} size="small" onClick={() => setAssigning(r)}>
                        {r.offer ? "Reassign" : "Assign"}
                      </Button>
                      <Button size="small" onClick={() => setTemporaryFor(r)}>
                        Temporary
                      </Button>
                    </>
                  )
                )}
              </Flex>
            ),
          },
        ]}
      />
      {temporaryFor && (
        <TemporaryAssignDialog
          bookingId={temporaryFor.id}
          code={temporaryFor.code}
          partnerType={temporaryFor.partnerType}
          expectedAssignmentId={temporaryFor.offer?.assignmentId ?? null}
          onClose={() => {
            setTemporaryFor(null);
            reload();
            reloadCounts();
          }}
          onDone={() => {
            setTemporaryFor(null);
            reload();
            reloadCounts();
          }}
        />
      )}
      {assigning && (
        <AssignDialog
          bookingId={assigning.id}
          code={assigning.code}
          expectedAssignmentId={assigning.offer?.assignmentId ?? null}
          open
          onClose={() => {
            setAssigning(null);
            reload();
            reloadCounts();
          }}
          onDone={() => {
            setAssigning(null);
            reload();
            reloadCounts();
          }}
        />
      )}
    </Page>
  );
}
