"use client";

import { App, Alert, DatePicker, Form, Input, InputNumber, Modal, Typography } from "antd";
import dayjs, { type Dayjs } from "dayjs";
import { useEffect, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { TIME_REFUSED } from "@/lib/bookings";
import { errorCode, errorMessage } from "@/lib/errors";
import { dateTime, rupees } from "@/lib/format";
import { fromIstPicker, percentOf, toIstPicker } from "@/lib/payments";

type Booking = components["schemas"]["AdminBookingDetailOut"];

/** What the admin sees when the booking moved on meanwhile (the app's texts are for patients). */
const ADMIN_REFUSAL: Record<string, string> = {
  CANCEL_NOT_ALLOWED: "This booking can't be cancelled any more (the job has started or it is closed).",
  RESCHEDULE_NOT_ALLOWED: "The time can't be changed any more (the job has started or it is closed).",
};

/** A server refusal as one line (a refused time says why). */
function refusal(error: unknown): string {
  const code = errorCode(error);
  const reason = (error as { error?: { details?: { reason?: string } } })?.error?.details?.reason;
  if (code === "TIME_NOT_AVAILABLE" && reason && TIME_REFUSED[reason]) return TIME_REFUSED[reason];
  if (code && ADMIN_REFUSAL[code]) return ADMIN_REFUSAL[code];
  return errorMessage(error);
}

/** The booking changed meanwhile: reload it rather than show stale buttons. */
const STALE = new Set(["CANCEL_NOT_ALLOWED", "RESCHEDULE_NOT_ALLOWED", "CONFLICT", "CONCURRENT_UPDATE"]);

/** At least 3 characters once trimmed (the server trims). */
const reasonRule = {
  validator: (_: unknown, value?: string) =>
    (value ?? "").trim().length >= 3 ? Promise.resolve() : Promise.reject(new Error("Write at least 3 characters.")),
};

/**
 * Cancel + refund (§6.12, PHASES 6.6): any percentage of the paid booking fee, 0–100 (the
 * patient's own cancel uses the Settings %, shown as the default). Refunds above the approval
 * limit wait for Finance. Logged.
 */
export function CancelDialog({
  booking,
  open,
  onClose,
  onDone,
  onStale,
}: {
  booking: Booking;
  open: boolean;
  onClose: () => void;
  onDone: (updated: Booking) => void;
  onStale: () => void;
}) {
  const { message } = App.useApp();
  const [form] = Form.useForm<{ refundPercent: number; reason: string }>();
  const [saving, setSaving] = useState(false);
  const percent = Form.useWatch("refundPercent", form) ?? 0;
  const paid = booking.paidPaise;

  useEffect(() => {
    if (!open) return;
    void api
      .GET("/v1/public/app-config")
      .then(({ data }) => {
        if (data && form.getFieldValue("refundPercent") === undefined) form.setFieldValue("refundPercent", data.refundPercent);
      })
      .catch(() => undefined); // the admin types the % then
  }, [open, form]);

  const submit = async (values: { refundPercent: number; reason: string }) => {
    if (saving) return;
    setSaving(true);
    const before = new Set(booking.refunds.map((r) => r.id));
    try {
      const { data, error } = await api.POST("/v1/admin/bookings/{booking_id}/cancel", {
        params: { path: { booking_id: booking.id } },
        body: { reason: values.reason.trim(), refundPercent: values.refundPercent },
      });
      if (error || !data) {
        message.error(refusal(error));
        if (STALE.has(errorCode(error) ?? "")) onStale();
        return;
      }
      const refund = data.refunds.find((r) => !before.has(r.id));
      message.success(
        refund?.status === "AWAITING_APPROVAL"
          ? `Cancelled. The refund of ${rupees(refund.amountPaise)} waits for Finance.`
          : refund
            ? `Cancelled. ${rupees(refund.amountPaise)} will be refunded.`
            : "Cancelled. Nothing to refund.",
      );
      form.resetFields();
      onDone(data);
    } catch {
      message.error("Couldn't reach the server. Check the booking before trying again.");
      onStale();
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal
      open={open}
      title={`Cancel ${booking.code}`}
      okText="Cancel booking"
      cancelText="Keep booking"
      okButtonProps={{ danger: true, loading: saving }}
      onOk={() => form.submit()}
      onCancel={onClose}
      destroyOnHidden
    >
      <Typography.Paragraph>
        Booking fee paid: <b>{rupees(paid)}</b>. The patient and the member get a message.
      </Typography.Paragraph>
      <Form form={form} layout="vertical" onFinish={submit} preserve={false}>
        <Form.Item
          name="refundPercent"
          label="Refund (% of the booking fee)"
          rules={[{ required: true, message: "Enter 0 to 100." }]}
          extra={paid > 0 ? `Refund: ${rupees(percentOf(paid, percent))}` : "Nothing was paid: nothing to refund."}
        >
          <InputNumber min={0} max={100} precision={0} suffix="%" style={{ width: 140 }} />
        </Form.Item>
        <Form.Item name="reason" label="Reason (logged, shown to staff)" rules={[{ required: true, message: "Write a reason." }, reasonRule]}>
          <Input.TextArea rows={3} maxLength={300} showCount />
        </Form.Item>
      </Form>
      <Alert type="info" showIcon title="Refunds above the approval limit wait for Finance on Payments → Refunds." />
    </Modal>
  );
}

type MinuteStep = 1 | 2 | 3 | 4 | 5 | 6 | 10 | 12 | 15 | 20 | 30;
const STEPS: MinuteStep[] = [5, 10, 15, 20, 30];

/**
 * Reschedule for the patient (§6.17): the same rules as booking, but inside the minimum notice
 * too and not counted against the patient's changes. A partner who had the offer or had accepted
 * must confirm again. Times are India time.
 */
export function RescheduleDialog({
  booking,
  open,
  onClose,
  onDone,
  onStale,
}: {
  booking: Booking;
  open: boolean;
  onClose: () => void;
  onDone: (updated: Booking) => void;
  onStale: () => void;
}) {
  const { message } = App.useApp();
  const [form] = Form.useForm<{ pickupAt: Dayjs; appointmentAt?: Dayjs | null }>();
  const [saving, setSaving] = useState(false);
  const hospital = booking.visitType === "HOSPITAL_VISIT";
  // Pickup times are on the Settings time step (30 min by default).
  const step = STEPS.find((s) => s === booking.timeStepMin) ?? 30;
  const beforeToday = (day: Dayjs) => day.isBefore(dayjs().startOf("day"));

  const submit = async (values: { pickupAt: Dayjs; appointmentAt?: Dayjs | null }) => {
    if (saving) return;
    setSaving(true);
    try {
      const { data, error } = await api.POST("/v1/admin/bookings/{booking_id}/reschedule", {
        params: { path: { booking_id: booking.id } },
        body: {
          pickupAt: fromIstPicker(values.pickupAt),
          appointmentAt: values.appointmentAt ? fromIstPicker(values.appointmentAt) : null,
        },
      });
      if (error || !data) {
        message.error(refusal(error));
        if (STALE.has(errorCode(error) ?? "")) onStale();
        return;
      }
      message.success(`Moved to ${dateTime(data.pickupAt)}.`);
      onDone(data);
    } catch {
      message.error("Couldn't reach the server. Check the booking before trying again.");
      onStale();
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal
      open={open}
      title={`Change date or time of ${booking.code}`}
      okText="Save new time"
      okButtonProps={{ loading: saving }}
      onOk={() => form.submit()}
      onCancel={onClose}
      destroyOnHidden
    >
      <Typography.Paragraph type="secondary">
        Now: {dateTime(booking.pickupAt)}
        {booking.appointmentAt && ` (appointment ${dateTime(booking.appointmentAt)})`}. Price and fee stay as booked.
        {(booking.status === "OFFERED" || booking.status === "ACCEPTED") &&
          " The partner will be asked to confirm the new time."}
      </Typography.Paragraph>
      <Form
        form={form}
        layout="vertical"
        onFinish={submit}
        preserve={false}
        initialValues={{
          pickupAt: toIstPicker(booking.pickupAt),
          appointmentAt: booking.appointmentAt ? toIstPicker(booking.appointmentAt) : null,
        }}
      >
        <Form.Item
          name="pickupAt"
          label={`${hospital ? "Pickup" : "Visit / start"} (India time)`}
          rules={[{ required: true, message: "Pick a date and time." }]}
          extra={`Times every ${step} minutes, within service hours.`}
        >
          <DatePicker
            showTime={{ format: "HH:mm", minuteStep: step }}
            format="D MMM YYYY HH:mm"
            disabledDate={beforeToday}
            style={{ width: 240 }}
          />
        </Form.Item>
        {hospital && (
          <Form.Item
            name="appointmentAt"
            label="Doctor appointment (India time, optional)"
            extra="Same day, after the pickup and within the service's time."
          >
            <DatePicker
              showTime={{ format: "HH:mm", minuteStep: 5 }}
              format="D MMM YYYY HH:mm"
              disabledDate={beforeToday}
              style={{ width: 240 }}
            />
          </Form.Item>
        )}
      </Form>
    </Modal>
  );
}
