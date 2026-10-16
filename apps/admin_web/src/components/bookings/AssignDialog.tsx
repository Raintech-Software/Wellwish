"use client";

import { PhoneOutlined } from "@ant-design/icons";
import { Alert, App, Avatar, Button, Modal, Space, Table, Tag, Typography } from "antd";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { BOOKING_CHANGED, tel } from "@/lib/assignments";
import { errorMessage } from "@/lib/errors";
import { phone } from "@/lib/partners";
import { useLoad } from "@/lib/useLoad";

type Candidate = components["schemas"]["CandidateOut"];
type State = components["schemas"]["AssignmentStateOut"];

/**
 * Assign / reassign (§6.10, §9.3): approved partners of the right type who are free then,
 * "available today" first, then nearest. Both phone numbers with call buttons. Assigning
 * someone else withdraws the current offer. `expectedAssignmentId` is the offer the admin saw
 * when opening it; `changed` = the booking moved on since (the card reloaded live): the dialog
 * says so and assigns nothing. The server refuses a stale one too (§6.16) and the dialog closes.
 */
export default function AssignDialog({
  bookingId,
  code,
  expectedAssignmentId,
  changed = false,
  open,
  onClose,
  onDone,
}: {
  bookingId: string;
  code: string;
  expectedAssignmentId: string | null;
  changed?: boolean;
  open: boolean;
  onClose: () => void;
  onDone: (state: State) => void;
}) {
  const { message } = App.useApp();
  const [busy, setBusy] = useState<string | null>(null);
  const fetchCandidates = useCallback(
    async () =>
      (
        await api.GET("/v1/admin/bookings/{booking_id}/candidates", {
          params: { path: { booking_id: bookingId } },
        })
      ).data,
    [bookingId],
  );
  const { data, failed, loading, reload } = useLoad(fetchCandidates, open);

  const assign = async (candidate: Candidate) => {
    if (busy || changed) return;
    setBusy(candidate.partnerId);
    try {
      const { data: state, error } = await api.POST("/v1/admin/bookings/{booking_id}/assign", {
        params: { path: { booking_id: bookingId } },
        body: { partnerId: candidate.partnerId, expectedAssignmentId },
      });
      if (error || !state) {
        message.error(errorMessage(error));
        if ((error as { error?: { code?: string } } | undefined)?.error?.code === "OFFER_CHANGED") onClose();
        else reload();
        return;
      }
      message.success(`Offered to ${candidate.fullName}. They have 2 minutes to answer.`);
      onDone(state);
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setBusy(null);
    }
  };

  return (
    <Modal open={open} title={`Assign ${code}`} onCancel={onClose} footer={null} width={960} destroyOnHidden>
      <Typography.Paragraph type="secondary">
        Free partners of the right type, available today first, then nearest to the pickup. Call
        them first if you like; the offer goes to their app (and SMS).
      </Typography.Paragraph>
      {changed && <Alert type="warning" showIcon style={{ marginBottom: 12 }} title={BOOKING_CHANGED} />}
      {failed && <Alert type="error" showIcon title="Couldn't load the partners. Close and try again." />}
      <Table<Candidate>
        rowKey="partnerId"
        size="small"
        loading={loading}
        dataSource={data ?? []}
        pagination={false}
        scroll={{ x: true, y: 420 }}
        locale={{ emptyText: "No free partner of this type at that time" }}
        columns={[
          {
            title: "Partner",
            key: "name",
            render: (_, c) => (
              <Space>
                <Avatar src={c.photoUrl ?? undefined}>{c.fullName.charAt(0)}</Avatar>
                <div>
                  <div style={{ fontWeight: 500 }}>{c.fullName}</div>
                  <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                    {[c.gender && c.gender.charAt(0) + c.gender.slice(1).toLowerCase(), c.languages.join(", ")]
                      .filter(Boolean)
                      .join(" · ")}
                  </Typography.Text>
                </div>
              </Space>
            ),
          },
          {
            title: "Today",
            key: "available",
            render: (_, c) =>
              c.availableToday ? <Tag color="green">Available</Tag> : <Tag>Not switched on</Tag>,
          },
          {
            title: "Distance",
            key: "distance",
            render: (_, c) => (c.distanceKm != null ? `${c.distanceKm} km` : "—"),
          },
          {
            title: "This week",
            key: "jobs",
            render: (_, c) => `${c.jobsThisWeek} ${c.jobsThisWeek === 1 ? "job" : "jobs"}`,
          },
          {
            title: "Rating",
            key: "rating",
            render: (_, c) => (c.ratingAvg ? `★ ${c.ratingAvg} (${c.ratingCount})` : "—"),
          },
          {
            title: "Call",
            key: "phones",
            render: (_, c) => (
              <Space orientation="vertical" size={0}>
                <a href={tel(c.phone)} style={{ whiteSpace: "nowrap" }}>
                  <PhoneOutlined /> {phone(c.phone)}
                </a>
                {c.alternatePhone && (
                  <a href={tel(c.alternatePhone)} style={{ whiteSpace: "nowrap" }}>
                    <PhoneOutlined /> {phone(c.alternatePhone)} (alt)
                  </a>
                )}
              </Space>
            ),
          },
          {
            title: "",
            key: "assign",
            render: (_, c) =>
              c.offeredNow ? (
                <Tag color="gold">Offered now</Tag>
              ) : (
                <Button
                  type="primary"
                  size="small"
                  loading={busy === c.partnerId}
                  disabled={busy !== null || changed}
                  onClick={() => void assign(c)}
                >
                  Assign
                </Button>
              ),
          },
        ]}
      />
    </Modal>
  );
}
