"use client";

import { Alert, App, Button, Flex, Form, Input, Modal, Select, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components, paths } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorMessage } from "@/lib/errors";
import { dateTime, rupees } from "@/lib/format";
import { failureText, REFUND_STATUS, reasonText, refundStatus, REQUESTED_BY } from "@/lib/payments";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["AdminRefundOut"];
type Status = NonNullable<paths["/v1/admin/refunds"]["get"]["parameters"]["query"]>["status"];

const PAGE_SIZE = 20;

/**
 * Refunds (§9.1, §9.5, PHASES 6.10): every refund with its reason. Refunds above the approval
 * limit (Settings, ₹500 by default) wait here until Finance approves or rejects them (logged).
 */
export default function RefundsPage() {
  const can = useCan();
  const { message } = App.useApp();
  const [status, setStatus] = useState<Status>(undefined);
  const [page, setPage] = useState(1);
  const [deciding, setDeciding] = useState<{ refund: Row; action: "approve" | "reject" | "retry" } | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<{ reason: string }>();
  const fetchPage = useCallback(
    async () =>
      (await api.GET("/v1/admin/refunds", { params: { query: { status, page, pageSize: PAGE_SIZE } } })).data,
    [status, page],
  );
  const { data, failed, loading, reload } = useLoad(fetchPage, can("refunds.request"));
  const canApprove = can("refunds.approve");

  const decide = async ({ reason }: { reason: string }) => {
    if (!deciding || saving) return;
    setSaving(true);
    const path = {
      approve: "/v1/admin/refunds/{refund_id}/approve",
      reject: "/v1/admin/refunds/{refund_id}/reject",
      retry: "/v1/admin/refunds/{refund_id}/retry",
    }[deciding.action] as "/v1/admin/refunds/{refund_id}/approve";
    try {
      const { error } = await api.POST(path, {
        params: { path: { refund_id: deciding.refund.id } },
        body: { reason: reason.trim() },
      });
      if (error) {
        message.error(errorMessage(error));
        return;
      }
      message.success(
        { approve: "Refund approved.", reject: "Refund rejected.", retry: "The refund will be sent again." }[deciding.action],
      );
      setDeciding(null);
      form.resetFields();
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setSaving(false);
      reload();
    }
  };

  return (
    <Page
      title="Refunds"
      permission="refunds.request"
      description="Refunds of booking fees, newest first. Razorpay returns the money to the patient's payment method in 5 to 7 working days. Refunds above the approval limit wait for Finance."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the refunds. Reload the page." />}
      <Flex gap={8} wrap style={{ marginBottom: 16 }}>
        <Select<Status>
          allowClear
          placeholder="Status"
          style={{ width: 220 }}
          value={status}
          options={Object.entries(REFUND_STATUS).map(([value, s]) => ({ value: value as Status, label: s.label }))}
          onChange={(value) => {
            setStatus(value);
            setPage(1);
          }}
        />
      </Flex>
      <Table<Row>
        rowKey="id"
        loading={loading}
        dataSource={data?.items ?? []}
        locale={{ emptyText: "No refunds" }}
        scroll={{ x: true }}
        pagination={{
          current: page,
          pageSize: PAGE_SIZE,
          total: data?.count ?? 0,
          showSizeChanger: false,
          onChange: setPage,
          showTotal: (total) => (total === 1 ? "1 refund" : `${total} refunds`),
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
          {
            title: "Amount",
            key: "amount",
            render: (_, r) => (
              <span style={{ whiteSpace: "nowrap" }}>
                {rupees(r.amountPaise)} <Typography.Text type="secondary">({r.percent}%)</Typography.Text>
              </span>
            ),
          },
          {
            title: "Reason",
            key: "reason",
            render: (_, r) => (
              <div style={{ minWidth: 220 }}>
                <div>{reasonText(r.reason)}</div>
                <Typography.Text type="secondary">
                  {REQUESTED_BY[r.requestedByType] ?? r.requestedByType}
                  {r.requestedByName && `: ${r.requestedByName}`}
                </Typography.Text>
              </div>
            ),
          },
          {
            title: "Status",
            key: "status",
            render: (_, r) => {
              const s = refundStatus(r);
              return (
                <>
                  <Tag color={s.color}>{s.label}</Tag>
                  {r.approvedByName && (
                    <div>
                      <Typography.Text type="secondary">
                        {r.status === "REJECTED" ? "Rejected" : "Approved"} by {r.approvedByName}
                      </Typography.Text>
                    </div>
                  )}
                  {r.failureReason && (
                    <div>
                      <Typography.Text type="danger">{failureText(r.failureReason)}</Typography.Text>
                    </div>
                  )}
                  {canApprove && r.status === "AWAITING_APPROVAL" && (
                    <Flex gap={8} style={{ marginTop: 8 }}>
                      <Button size="small" type="primary" onClick={() => setDeciding({ refund: r, action: "approve" })}>
                        Approve
                      </Button>
                      <Button size="small" danger onClick={() => setDeciding({ refund: r, action: "reject" })}>
                        Reject
                      </Button>
                    </Flex>
                  )}
                  {canApprove && r.status === "FAILED" && (
                    <Button size="small" style={{ marginTop: 8 }} onClick={() => setDeciding({ refund: r, action: "retry" })}>
                      Send again
                    </Button>
                  )}
                </>
              );
            },
          },
          {
            title: "Dates",
            key: "dates",
            render: (_, r) => (
              <>
                <div style={{ whiteSpace: "nowrap" }}>Asked {dateTime(r.createdAt)}</div>
                {r.processedAt && <Typography.Text type="secondary">Refunded {dateTime(r.processedAt)}</Typography.Text>}
              </>
            ),
          },
          {
            title: "Razorpay",
            key: "rzp",
            render: (_, r) => <Typography.Text style={{ fontSize: 12 }}>{r.razorpayRefundId || "—"}</Typography.Text>,
          },
        ]}
      />
      <Modal
        open={deciding !== null}
        title={
          deciding &&
          `${{ approve: "Approve", reject: "Reject", retry: "Send again:" }[deciding.action]} refund of ${rupees(deciding.refund.amountPaise)} for ${deciding.refund.bookingCode}`
        }
        okText={{ approve: "Approve and send", reject: "Reject", retry: "Send again" }[deciding?.action ?? "approve"]}
        okButtonProps={{ danger: deciding?.action === "reject", loading: saving }}
        onOk={() => form.submit()}
        onCancel={() => {
          setDeciding(null);
          form.resetFields();
        }}
        destroyOnHidden
      >
        <Typography.Paragraph type="secondary">
          {deciding?.action === "reject"
            ? "The patient gets nothing back for this refund."
            : "The money goes back to the patient's payment method through Razorpay."}{" "}
          Reason asked: {deciding && reasonText(deciding.refund.reason)}
        </Typography.Paragraph>
        <Form form={form} layout="vertical" onFinish={decide} preserve={false}>
          <Form.Item
            name="reason"
            label="Your note (logged)"
            rules={[
              {
                validator: (_, value?: string) =>
                  (value ?? "").trim().length >= 3
                    ? Promise.resolve()
                    : Promise.reject(new Error("Write at least 3 characters.")),
              },
            ]}
          >
            <Input.TextArea rows={3} maxLength={300} showCount />
          </Form.Item>
        </Form>
      </Modal>
    </Page>
  );
}
