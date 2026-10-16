"use client";

import { IdcardOutlined } from "@ant-design/icons";
import { Alert, App, Button, Card, Descriptions, Flex, Form, Image, Input, Modal, Tag, Typography } from "antd";
import { useCallback, useEffect, useState } from "react";

import { api } from "@/api/client";
import { useCan } from "@/auth/AuthProvider";
import { errorMessage } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { phone, STATUS } from "@/lib/partners";
import { onLiveMessage } from "@/lib/staffSocket";
import { useLoad } from "@/lib/useLoad";

const ID_TYPE: Record<string, string> = {
  AADHAAR: "Aadhaar",
  DRIVING_LICENCE: "Driving licence",
  VOTER_ID: "Voter ID",
  PAN: "PAN card",
};

const ENDED: Record<string, string> = {
  COMPLETED: "the job was completed",
  CANCELLED: "the booking was cancelled",
  UNASSIGNED: "unassigned",
  RESCHEDULED: "the time changed",
  BY_ADMIN: "ended by an admin",
};

/**
 * The booking page's ID card for a temporary partner (ARCHITECTURE §6.19): the ID the admin
 * checked (type and last 4 only), the photo (each view is logged; not for view-only roles), the
 * selfie of this job next to it, who checked and why, and "End app access now" for a problem
 * during the visit. Updates live (the access also ends by itself an hour after Completed).
 * Admins only: the family never sees that the partner is temporary.
 */
export default function TemporaryPartnerCard({ bookingId, onChanged }: { bookingId: string; onChanged: () => void }) {
  const can = useCan();
  const manage = can("bookings.manage");
  const seePhoto = manage || can("partners.review") || can("partners.add");
  const { message } = App.useApp();
  const [opening, setOpening] = useState(false);
  const [ending, setEnding] = useState(false);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<{ reason: string }>();
  const fetchCard = useCallback(
    async () =>
      (
        await api.GET("/v1/admin/bookings/{booking_id}/temporary-partner", {
          params: { path: { booking_id: bookingId } },
        })
      ).data,
    [bookingId],
  );
  const { data, failed, reload } = useLoad(fetchCard, can("bookings.view"));

  useEffect(
    () =>
      onLiveMessage(({ type, data: msg }) => {
        if (type === "live.reconnected" || ((type === "queue.changed" || type === "alert") && msg.bookingId === bookingId)) {
          reload();
        }
      }),
    [bookingId, reload],
  );

  const openPhoto = async () => {
    // opened before the request, while the click still counts: a popup opened after an await
    // is blocked by some browsers
    const tab = window.open("", "_blank");
    setOpening(true);
    try {
      const { data: link, error } = await api.GET("/v1/admin/bookings/{booking_id}/temporary-partner/id-photo", {
        params: { path: { booking_id: bookingId } },
      });
      if (link && tab) {
        tab.opener = null;
        tab.location.href = link.url;
      } else {
        tab?.close();
        message.error(link ? "Allow pop-ups for this site to see the photo." : errorMessage(error));
      }
    } catch {
      tab?.close();
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setOpening(false);
    }
  };

  const endAccess = async ({ reason }: { reason: string }) => {
    if (saving) return;
    setSaving(true);
    try {
      const { error } = await api.POST("/v1/admin/bookings/{booking_id}/temporary-partner/end", {
        params: { path: { booking_id: bookingId } },
        body: { reason: reason.trim() },
      });
      if (error) message.error(errorMessage(error));
      else message.success("Their app access has ended. They are logged out.");
      setEnding(false);
      reload();
      onChanged();
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setSaving(false);
    }
  };

  if (failed) return <Alert type="error" showIcon title="Couldn't load the temporary partner's ID card." />;
  if (!data) return null;
  const status = STATUS[data.status];
  return (
    <Card
      size="small"
      style={{ marginBottom: 16 }}
      title={
        <span>
          <IdcardOutlined /> Temporary partner <Tag color={status?.color}>{status?.label ?? data.status}</Tag>
        </span>
      }
      extra={
        <Flex gap={8}>
          {seePhoto && (
            <Button size="small" loading={opening} onClick={() => void openPhoto()}>
              View ID photo
            </Button>
          )}
          {manage && !data.endedAt && (
            <Button size="small" danger onClick={() => setEnding(true)}>
              End app access now
            </Button>
          )}
        </Flex>
      }
    >
      <Descriptions
        size="small"
        column={{ xs: 1, md: 2 }}
        items={[
          { key: "name", label: "Name", children: data.fullName },
          { key: "phone", label: "Mobile (app login)", children: phone(data.phone) },
          {
            key: "id",
            label: "ID checked",
            children: `${ID_TYPE[data.idType] ?? data.idType} ending ${data.idLast4}`,
          },
          ...(data.nursingRegNo
            ? [{ key: "reg", label: "Nursing registration", children: data.nursingRegNo }]
            : []),
          { key: "by", label: "Checked by", children: `${data.checkedBy}, ${dateTime(data.checkedAt)}` },
          { key: "why", label: "Why temporary", children: data.reason },
          {
            key: "access",
            label: "App access",
            children: data.endedAt ? (
              <Typography.Text type="secondary">
                Ended {dateTime(data.endedAt)} ({ENDED[data.endReason] ?? data.endReason})
              </Typography.Text>
            ) : (
              "This booking only; ends 1 hour after Completed (or at once if cancelled, unassigned or moved)"
            ),
          },
          {
            key: "selfie",
            label: "Selfie for this job",
            children: data.selfieUrl ? (
              <Image src={data.selfieUrl} alt="Selfie for this job" width={96} />
            ) : (
              <Typography.Text type="secondary">Not taken yet (needed before &quot;On the way&quot;)</Typography.Text>
            ),
          },
        ]}
      />
      <Modal
        open={ending}
        title={`End ${data.fullName}'s app access now?`}
        okText="End access"
        okButtonProps={{ danger: true, loading: saving }}
        onOk={() => form.submit()}
        onCancel={() => setEnding(false)}
        destroyOnHidden
      >
        <Typography.Paragraph type="secondary">
          They are logged out at once and can&apos;t open this job again. If the visit isn&apos;t finished, the booking is
          flagged so you can finish it or give it to someone else.
        </Typography.Paragraph>
        <Form form={form} layout="vertical" onFinish={endAccess} requiredMark={false} preserve={false}>
          <Form.Item
            name="reason"
            label="Why (logged)"
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
    </Card>
  );
}
