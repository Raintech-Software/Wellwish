"use client";

import { Alert, Flex, Input, Select, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components, paths } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { dateTime, rupees } from "@/lib/format";
import { failureText, METHOD, PAYMENT_STATUS } from "@/lib/payments";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["AdminPaymentOut"];
type Status = NonNullable<paths["/v1/admin/payments"]["get"]["parameters"]["query"]>["status"];

const PAGE_SIZE = 20;

/**
 * Payments (§9.1, PHASES 6.10): every booking-fee payment from Razorpay, newest first. A booking
 * becomes NEW only when Razorpay confirms the payment (the webhook or the 10-minute check).
 */
export default function PaymentsPage() {
  const can = useCan();
  const [status, setStatus] = useState<Status>(undefined);
  const [q, setQ] = useState("");
  const [page, setPage] = useState(1);
  const fetchPage = useCallback(
    async () =>
      (
        await api.GET("/v1/admin/payments", {
          params: { query: { status, q: q || undefined, page, pageSize: PAGE_SIZE } },
        })
      ).data,
    [status, q, page],
  );
  const { data, failed, loading } = useLoad(fetchPage, can("payments.view"));

  return (
    <Page
      title="Payments"
      permission="payments.view"
      description="Booking-fee payments from Razorpay, newest first. Times are India time. Test-mode payments are marked TEST."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the payments. Reload the page." />}
      <Flex gap={8} wrap style={{ marginBottom: 16 }}>
        <Select<Status>
          allowClear
          placeholder="Status"
          style={{ width: 180 }}
          value={status}
          options={Object.entries(PAYMENT_STATUS).map(([value, s]) => ({ value: value as Status, label: s.label }))}
          onChange={(value) => {
            setStatus(value);
            setPage(1);
          }}
        />
        <Input.Search
          allowClear
          maxLength={60}
          placeholder="WW-10001, order_… or pay_…"
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
        locale={{ emptyText: "No payments yet" }}
        scroll={{ x: true }}
        pagination={{
          current: page,
          pageSize: PAGE_SIZE,
          total: data?.count ?? 0,
          showSizeChanger: false,
          onChange: setPage,
          showTotal: (total) => (total === 1 ? "1 payment" : `${total} payments`),
        }}
        columns={[
          {
            title: "Booking",
            key: "booking",
            render: (_, r) =>
              can("bookings.view") ? (
                <Link href={`/bookings/${r.bookingId}`} style={{ whiteSpace: "nowrap" }}>
                  {r.bookingCode}
                </Link>
              ) : (
                r.bookingCode
              ),
          },
          { title: "Amount", key: "amount", render: (_, r) => rupees(r.amountPaise) },
          {
            title: "Status",
            key: "status",
            render: (_, r) => {
              const s = PAYMENT_STATUS[r.status];
              return (
                <>
                  <Tag color={s?.color}>{s?.label ?? r.status}</Tag>
                  {r.mode === "TEST" && <Tag>TEST</Tag>}
                  {r.failureReason && (
                    <div>
                      <Typography.Text type="secondary">{failureText(r.failureReason)}</Typography.Text>
                    </div>
                  )}
                </>
              );
            },
          },
          { title: "Method", key: "method", render: (_, r) => METHOD[r.method] ?? (r.method || "—") },
          {
            title: "Razorpay",
            key: "ids",
            render: (_, r) => (
              <Typography.Text style={{ fontSize: 12 }} copyable={r.razorpayPaymentId ? { text: r.razorpayPaymentId } : false}>
                <div>{r.razorpayOrderId}</div>
                {r.razorpayPaymentId && <div>{r.razorpayPaymentId}</div>}
              </Typography.Text>
            ),
          },
          { title: "Started", key: "created", render: (_, r) => dateTime(r.createdAt) },
          { title: "Paid", key: "captured", render: (_, r) => dateTime(r.capturedAt) },
        ]}
      />
    </Page>
  );
}
