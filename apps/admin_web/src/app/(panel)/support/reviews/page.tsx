"use client";

import { Alert, App, Button, Empty, Form, Input, Modal, Segmented, Spin, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorMessage } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";
import { REVIEW_STATUS, REVIEW_TAG, stars } from "@/lib/visit";
import { colors } from "@/theme";

type Review = components["schemas"]["AdminReviewOut"];
type Filter = "all" | "VISIBLE" | "HIDDEN";

/**
 * Reviews (§9.1 Support, PHASES 8.15): every rating with its tags and comment. Hide an abusive
 * one (never deleted; the partner's average leaves it out) or show it again, with a logged
 * reason.
 */
export default function ReviewsPage() {
  const can = useCan();
  const { message } = App.useApp();
  const [filter, setFilter] = useState<Filter>("all");
  const [moderating, setModerating] = useState<Review | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<{ reason: string }>();
  const fetchReviews = useCallback(
    async () => (await api.GET("/v1/admin/reviews", { params: { query: { status: filter, pageSize: 100 } } })).data,
    [filter],
  );
  const { data, failed, loading, reload } = useLoad(fetchReviews, can("support.manage"));

  const moderate = async ({ reason }: { reason: string }) => {
    if (!moderating || saving) return;
    setSaving(true);
    const hide = moderating.status === "VISIBLE";
    try {
      const { error } = await api.POST(
        hide ? "/v1/admin/reviews/{review_id}/hide" : "/v1/admin/reviews/{review_id}/show",
        { params: { path: { review_id: moderating.id } }, body: { reason: reason.trim() } },
      );
      if (error) {
        message.error(errorMessage(error));
        return;
      }
      message.success(hide ? "Review hidden." : "Review shown again.");
      setModerating(null);
      reload();
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <Page
      title="Reviews"
      permission="support.manage"
      description="Ratings families gave after a visit. Hide abusive ones: they stay saved, and the partner's average leaves them out."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the reviews. Reload the page." />}
      <Segmented
        style={{ marginBottom: 16 }}
        value={filter}
        onChange={(v) => setFilter(v as Filter)}
        options={[
          { label: "All", value: "all" },
          { label: "Visible", value: "VISIBLE" },
          { label: "Hidden", value: "HIDDEN" },
        ]}
      />
      {loading && !data && <Spin />}
      <Table<Review>
        rowKey="id"
        size="small"
        dataSource={data?.items ?? []}
        pagination={false}
        locale={{ emptyText: <Empty description="No reviews yet" /> }}
        scroll={{ x: true }}
        columns={[
          { title: "Date", key: "at", render: (_, r) => dateTime(r.createdAt) },
          { title: "Booking", key: "code", render: (_, r) => <Link href={`/bookings/${r.bookingId}`}>{r.code}</Link> },
          {
            title: "Partner",
            key: "partner",
            render: (_, r) =>
              can("partners.view") ? (
                <Link href={`/partners/${r.partnerId}`}>{r.partnerName || "Partner"}</Link>
              ) : (
                r.partnerName || "Partner"
              ),
          },
          {
            title: "Rating",
            key: "stars",
            render: (_, r) => <span style={{ color: colors.gold, whiteSpace: "nowrap" }}>{stars(r.stars)}</span>,
          },
          {
            title: "Tags",
            key: "tags",
            render: (_, r) => r.tags.map((t) => <Tag key={t}>{REVIEW_TAG[t] ?? t}</Tag>),
          },
          {
            title: "Comment",
            key: "comment",
            render: (_, r) => r.comment || <Typography.Text type="secondary">—</Typography.Text>,
          },
          {
            title: "Status",
            key: "status",
            render: (_, r) => (
              <span>
                <Tag color={REVIEW_STATUS[r.status]?.color}>{REVIEW_STATUS[r.status]?.label ?? r.status}</Tag>
                {r.hiddenReason && <Typography.Text type="secondary">{r.hiddenReason}</Typography.Text>}
              </span>
            ),
          },
          {
            title: "",
            key: "actions",
            render: (_, r) => (
              <Button size="small" danger={r.status === "VISIBLE"} onClick={() => setModerating(r)}>
                {r.status === "VISIBLE" ? "Hide" : "Show again"}
              </Button>
            ),
          },
        ]}
      />
      <Modal
        open={!!moderating}
        title={moderating?.status === "VISIBLE" ? `Hide the review for ${moderating?.code}` : `Show the review again`}
        okText={moderating?.status === "VISIBLE" ? "Hide" : "Show again"}
        okButtonProps={{ loading: saving, danger: moderating?.status === "VISIBLE" }}
        onOk={() => form.submit()}
        onCancel={() => setModerating(null)}
        destroyOnHidden
      >
        <Form form={form} layout="vertical" onFinish={moderate} preserve={false}>
          <Form.Item
            name="reason"
            label="Reason (logged)"
            rules={[
              {
                validator: (_, value?: string) =>
                  (value ?? "").trim().length >= 3
                    ? Promise.resolve()
                    : Promise.reject(new Error("Write at least 3 characters.")),
              },
            ]}
          >
            <Input.TextArea rows={2} maxLength={300} showCount />
          </Form.Item>
        </Form>
      </Modal>
    </Page>
  );
}
