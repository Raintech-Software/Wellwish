"use client";

import { Alert, App, Button, Card, Descriptions, Form, Input, Modal, Spin, Steps, Tag, Typography } from "antd";
import dynamic from "next/dynamic";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import { errorCode, errorMessage } from "@/lib/errors";
import { dateTime, rupees } from "@/lib/format";
import { serverNow } from "@/lib/serverClock";
import { useLoad } from "@/lib/useLoad";
import { BALANCE_MODE, stepLabel } from "@/lib/visit";

const TrackMap = dynamic(() => import("@/components/map/LiveMap").then((m) => m.TrackMap), {
  ssr: false,
  loading: () => <Spin />,
});

type Booking = components["schemas"]["AdminBookingDetailOut"];
type StepName = components["schemas"]["AdminStepIn"]["step"];

const BY: Record<string, string> = { PARTNER: "partner", STAFF: "admin", SYSTEM: "system" };

/** The saved route of a finished job (404 until the job ends). */
function Route({ bookingId }: { bookingId: string }) {
  const can = useCan();
  const fetchTrack = useCallback(
    async () =>
      (await api.GET("/v1/admin/bookings/{booking_id}/track", { params: { path: { booking_id: bookingId } } })).data ??
      null,
    [bookingId],
  );
  const { data, loading } = useLoad(fetchTrack, can("bookings.view"));
  if (loading && !data) return <Spin />;
  if (!data || data.points.length === 0)
    return <Typography.Text type="secondary">No route was recorded for this job.</Typography.Text>;
  return (
    <>
      <Typography.Paragraph type="secondary" style={{ marginBottom: 8 }}>
        {data.km} km · {dateTime(data.startedAt)} to {dateTime(data.endedAt)}
      </Typography.Paragraph>
      <TrackMap points={data.points} />
    </>
  );
}

/**
 * The visit on the booking page (§6.11, PHASES 8.15): each step with its time, who marked it and
 * whether it was far from the place; the visit code locked; "Mark the next step" for the
 * partner after a phone call (no network at the door, the code locked, the phone died; logged
 * with the reason); the balance the partner recorded; the route once the job is over.
 */
export default function VisitCard({
  booking,
  onChanged,
  onStale,
}: {
  booking: Booking;
  onChanged: (b: Booking) => void;
  onStale: () => void;
}) {
  const can = useCan();
  const { message } = App.useApp();
  const [marking, setMarking] = useState(false);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<{ reason: string }>();
  const visit = booking.visit;
  if (!visit) return null;
  const done = new Map(visit.done.map((d) => [d.step, d]));
  const active = booking.status === "ACCEPTED" || booking.status === "IN_PROGRESS";
  const finished = ["COMPLETED", "PATIENT_NO_SHOW"].includes(booking.status);

  const mark = async ({ reason }: { reason: string }) => {
    if (saving || !visit.nextStep) return;
    setSaving(true);
    try {
      const { data, error } = await api.POST("/v1/admin/bookings/{booking_id}/steps", {
        params: { path: { booking_id: booking.id } },
        body: { step: visit.nextStep as StepName, reason: reason.trim() },
      });
      if (error || !data) {
        message.error(
          errorCode(error) === "STEP_OUT_OF_ORDER"
            ? "The partner marked a step meanwhile. The page is up to date now: check and try again."
            : errorMessage(error),
        );
        setMarking(false);
        onStale();
        return;
      }
      message.success(`Marked: ${stepLabel(visit.nextStep)}.`);
      setMarking(false);
      onChanged(data);
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <Card
      size="small"
      title="Visit"
      style={{ marginBottom: 16 }}
      extra={
        <>
          {booking.status === "IN_PROGRESS" && can("live.view") && (
            <Link href="/live">
              <Button size="small">Live map</Button>
            </Link>
          )}
          {active && visit.nextStep && can("bookings.manage") && (
            <Button size="small" type="primary" style={{ marginLeft: 8 }} onClick={() => setMarking(true)}>
              Mark &quot;{stepLabel(visit.nextStep)}&quot;
            </Button>
          )}
        </>
      }
    >
      {visit.otpRetryAt && active && visit.nextStep === visit.otpStep && Date.parse(visit.otpRetryAt) > serverNow() && (
        <Alert
          type="error"
          showIcon
          style={{ marginBottom: 12 }}
          title={`Wrong visit codes: the partner can try again at ${dateTime(visit.otpRetryAt)}. Call the family; you can mark the step now.`}
        />
      )}
      <Steps
        size="small"
        orientation="vertical"
        current={visit.done.length}
        items={visit.steps.map((s) => {
          const d = done.get(s);
          return {
            title: (
              <span>
                {stepLabel(s)}
                {s === visit.otpStep && !d && <Tag style={{ marginLeft: 8 }}>needs the visit code</Tag>}
                {d?.far && (
                  <Tag color="gold" style={{ marginLeft: 8 }}>
                    far from the place
                  </Tag>
                )}
              </span>
            ),
            content: d ? `${dateTime(d.at)} · by ${BY[d.by] ?? d.by}` : undefined,
            status: d ? "finish" : s === visit.nextStep && active ? "process" : "wait",
          };
        })}
      />
      {(visit.balanceCollectedPaise != null || booking.status === "COMPLETED") && (
        <Descriptions
          size="small"
          column={1}
          style={{ marginTop: 8 }}
          items={[
            {
              key: "balance",
              label: "Balance collected (as recorded by the partner)",
              children:
                visit.balanceCollectedPaise != null ? (
                  `${rupees(visit.balanceCollectedPaise)} · ${BALANCE_MODE[visit.balanceMode] ?? visit.balanceMode}`
                ) : (
                  <Typography.Text type="secondary">Not recorded yet</Typography.Text>
                ),
            },
          ]}
        />
      )}
      {finished && (
        <div style={{ marginTop: 12 }}>
          <Typography.Title level={5}>Route</Typography.Title>
          <Route bookingId={booking.id} />
        </div>
      )}
      <Modal
        open={marking}
        title={`Mark "${stepLabel(visit.nextStep)}" for the partner`}
        okText="Mark step"
        okButtonProps={{ loading: saving }}
        onOk={() => form.submit()}
        onCancel={() => setMarking(false)}
        destroyOnHidden
      >
        <Typography.Paragraph type="secondary">
          Only after confirming by phone with the partner (and the family for the visit code). No code is needed
          here. Logged with your reason.
        </Typography.Paragraph>
        <Form form={form} layout="vertical" onFinish={mark} preserve={false}>
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
    </Card>
  );
}
