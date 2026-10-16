"use client";

import { Alert, App, Button, Card, Empty, Flex, Input, Segmented, Spin, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useEffect, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { tel } from "@/lib/assignments";
import { errorMessage } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { phone } from "@/lib/partners";
import { onLiveMessage } from "@/lib/staffSocket";
import { useLoad } from "@/lib/useLoad";
import { TICKET_STATUS } from "@/lib/visit";
import { colors } from "@/theme";

type Ticket = components["schemas"]["AdminTicketOut"];

/** The conversation and the reply box for one ticket. */
function TicketThread({ ticket, onChanged }: { ticket: Ticket; onChanged: (t: Ticket) => void }) {
  const { message } = App.useApp();
  const [text, setText] = useState("");
  const [busy, setBusy] = useState<"reply" | "close" | null>(null);

  const send = async (kind: "reply" | "close") => {
    if (busy) return;
    if (kind === "reply" && text.trim().length < 2) {
      message.warning("Write the reply first.");
      return;
    }
    setBusy(kind);
    try {
      const { data, error } =
        kind === "reply"
          ? await api.POST("/v1/admin/tickets/{ticket_id}/reply", {
              params: { path: { ticket_id: ticket.id } },
              body: { text: text.trim() },
            })
          : await api.POST("/v1/admin/tickets/{ticket_id}/close", { params: { path: { ticket_id: ticket.id } } });
      if (error || !data) {
        message.error(errorMessage(error));
        return;
      }
      message.success(kind === "reply" ? "Reply sent. The family gets a message." : "Ticket closed.");
      setText("");
      onChanged(data);
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setBusy(null);
    }
  };

  return (
    <Flex vertical gap={8} style={{ maxWidth: 720 }}>
      <Card size="small">
        <Typography.Text type="secondary">
          {ticket.patientName || "Patient"} · {dateTime(ticket.createdAt)}
        </Typography.Text>
        <div style={{ whiteSpace: "pre-wrap" }}>{ticket.text}</div>
      </Card>
      {ticket.replies.map((r, i) => (
        <Card key={i} size="small" style={{ background: colors.tint, marginLeft: 32 }}>
          <Typography.Text type="secondary">
            {r.name || "WellWish"} · {dateTime(r.at)}
          </Typography.Text>
          <div style={{ whiteSpace: "pre-wrap" }}>{r.text}</div>
        </Card>
      ))}
      {ticket.status !== "CLOSED" && (
        <>
          <Input.TextArea
            rows={3}
            maxLength={1000}
            showCount
            placeholder="Reply to the family (they get a message in the app)"
            value={text}
            onChange={(e) => setText(e.target.value)}
          />
          <Flex gap={8}>
            <Button type="primary" loading={busy === "reply"} onClick={() => void send("reply")}>
              Send reply
            </Button>
            <Button loading={busy === "close"} onClick={() => void send("close")}>
              Close ticket
            </Button>
          </Flex>
        </>
      )}
    </Flex>
  );
}

/**
 * Support tickets (§9.1 Support, PHASES 8.15): problems the family reported within 24 h after a
 * visit. Reply (the family gets a message) and close. Every action is logged.
 */
export default function TicketsPage() {
  const can = useCan();
  const [status, setStatus] = useState<"open" | "all">("open");
  const fetchTickets = useCallback(
    async () => (await api.GET("/v1/admin/tickets", { params: { query: { status, pageSize: 100 } } })).data,
    [status],
  );
  const { data, failed, loading, reload, setData } = useLoad(fetchTickets, can("support.manage"));

  useEffect(
    () =>
      onLiveMessage(({ type }) => {
        if (type === "ticket.new" || type === "live.reconnected") reload();
      }),
    [reload],
  );

  const replaced = (t: Ticket) => {
    if (!data) return;
    const items =
      status === "open" && t.status === "CLOSED"
        ? data.items.filter((x) => x.id !== t.id)
        : data.items.map((x) => (x.id === t.id ? t : x));
    setData({ ...data, items, count: items.length });
  };

  return (
    <Page
      title="Tickets"
      permission="support.manage"
      description="Problems families reported after a visit (up to 24 hours after). Call if needed, reply, then close."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the tickets. Reload the page." />}
      <Segmented
        style={{ marginBottom: 16 }}
        value={status}
        onChange={(v) => setStatus(v as "open" | "all")}
        options={[
          { label: "Open", value: "open" },
          { label: "All", value: "all" },
        ]}
      />
      {loading && !data && <Spin />}
      <Table<Ticket>
        rowKey="id"
        size="small"
        dataSource={data?.items ?? []}
        pagination={false}
        locale={{ emptyText: <Empty description={status === "open" ? "No open tickets" : "No tickets yet"} /> }}
        scroll={{ x: true }}
        expandable={{
          expandedRowRender: (t) => <TicketThread ticket={t} onChanged={replaced} />,
          expandRowByClick: true,
        }}
        columns={[
          { title: "Reported", key: "at", render: (_, t) => dateTime(t.createdAt) },
          {
            title: "Booking",
            key: "code",
            render: (_, t) => (t.bookingId ? <Link href={`/bookings/${t.bookingId}`}>{t.code}</Link> : "—"),
          },
          {
            title: "Family",
            key: "patient",
            render: (_, t) => (
              <span>
                {t.patientName || "Patient"}
                {t.patientPhone && (
                  <>
                    {" · "}
                    <a href={tel(t.patientPhone)} onClick={(e) => e.stopPropagation()}>
                      {phone(t.patientPhone)}
                    </a>
                  </>
                )}
              </span>
            ),
          },
          { title: "Partner", key: "partner", render: (_, t) => t.partnerName || "—" },
          {
            title: "Problem",
            key: "text",
            render: (_, t) => (
              <Typography.Text ellipsis style={{ maxWidth: 320 }}>
                {t.text}
              </Typography.Text>
            ),
          },
          { title: "Replies", key: "replies", render: (_, t) => t.replies.length },
          {
            title: "Status",
            key: "status",
            render: (_, t) => (
              <Tag color={TICKET_STATUS[t.status]?.color}>{TICKET_STATUS[t.status]?.label ?? t.status}</Tag>
            ),
          },
        ]}
      />
    </Page>
  );
}
