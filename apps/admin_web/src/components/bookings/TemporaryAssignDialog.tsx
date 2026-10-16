"use client";

import { Alert, App, Checkbox, Form, Input, Modal, Select, Typography } from "antd";
import { useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import FileUpload from "@/components/FileUpload";
import { BOOKING_CHANGED } from "@/lib/assignments";
import { errorMessage } from "@/lib/errors";
import { STATUS } from "@/lib/partners";

type State = components["schemas"]["AssignmentStateOut"];
type Values = {
  phone: string;
  fullName: string;
  gender: "FEMALE" | "MALE" | "OTHER";
  idType: "AADHAAR" | "DRIVING_LICENCE" | "VOTER_ID" | "PAN";
  idLast4: string;
  idPhotoKey: string;
  nursingRegNo?: string;
  reason: string;
  idChecked: boolean;
};

const ID_TYPES = [
  { value: "AADHAAR", label: "Aadhaar" },
  { value: "DRIVING_LICENCE", label: "Driving licence" },
  { value: "VOTER_ID", label: "Voter ID" },
  { value: "PAN", label: "PAN card" },
];

/** The server's `normalize_indian_mobile`: separators dropped, then +91 / 91 / 0 before 10 digits. */
const MOBILE = /^(\+91|91(?=\d{10}$)|0(?=\d{10}$))?[6-9]\d{9}$/;

/** At least `min` characters once trimmed, as the server counts them. */
const trimmedMin = (min: number, text: string) => ({
  validator: (_: unknown, value?: string) =>
    (value ?? "").trim().length >= min ? Promise.resolve() : Promise.reject(new Error(text)),
});

/** What each refusal means for the admin filling the form (§6.19). */
function refusal(error: unknown): string {
  const failure = (error as { error?: { code?: string; details?: { status?: string } } } | undefined)?.error;
  switch (failure?.code) {
    case "PHONE_IS_PARTNER": {
      const status = failure.details?.status ?? "";
      return status === "APPROVED"
        ? "This number belongs to an approved partner. Use Assign instead."
        : `This number belongs to a partner or applicant (${STATUS[status]?.label ?? status}). It can't be used for a temporary assign.`;
    }
    case "TEMP_PARTNER_BUSY":
      return "This person is already a temporary partner on another booking.";
    case "TEMP_PARTNER_IS_FAMILY":
      return "This is the number of the family who booked. Use the temporary person's own number.";
    case "OFFER_CHANGED": // the server says who has it now
      return errorMessage(error);
    case "NOT_ASSIGNABLE":
      return "The booking can't take a partner now (accepted or cancelled meanwhile). Close this and check it.";
    default:
      return errorMessage(error);
  }
}

/**
 * "Temporary assign" (ARCHITECTURE §6.19): nobody free, so the admin phones a person, checks
 * their ID and gives them this one booking. It's accepted at once (no 2-minute timer); they get
 * an SMS with the app link and log in with that number. The family sees them like any partner.
 * `expectedAssignmentId` is the offer the admin saw when opening it; `changed` = the booking moved
 * on since (§6.16): the dialog says so and won't submit.
 */
export default function TemporaryAssignDialog({
  bookingId,
  code,
  partnerType,
  expectedAssignmentId,
  changed = false,
  onClose,
  onDone,
}: {
  bookingId: string;
  code: string;
  partnerType: string;
  expectedAssignmentId: string | null;
  changed?: boolean;
  onClose: () => void;
  onDone: (state: State) => void;
}) {
  const { message } = App.useApp();
  const [form] = Form.useForm<Values>();
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const nurse = partnerType === "NURSE";

  const submit = async (values: Values) => {
    if (saving || changed) return;
    setSaving(true);
    setError(null);
    try {
      const { data, error: failure } = await api.POST("/v1/admin/bookings/{booking_id}/temporary-assign", {
        params: { path: { booking_id: bookingId } },
        body: {
          phone: values.phone.trim(),
          fullName: values.fullName.trim(),
          gender: values.gender,
          idType: values.idType,
          idLast4: values.idLast4.trim().toUpperCase(),
          idPhotoKey: values.idPhotoKey,
          nursingRegNo: (values.nursingRegNo ?? "").trim(),
          reason: values.reason.trim(),
          idChecked: values.idChecked,
          expectedAssignmentId,
        },
      });
      if (data) {
        message.success(`${values.fullName.trim()} has ${code}. They get an SMS with the app link.`);
        onDone(data);
      } else {
        setError(refusal(failure));
      }
    } catch {
      setError("Couldn't reach the server. Please try again.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal
      open
      title={`Temporary ${nurse ? "nurse" : "companion"} for ${code}`}
      okText="Give them this booking"
      okButtonProps={{ loading: saving, disabled: changed }}
      onOk={() => form.submit()}
      onCancel={onClose}
      destroyOnHidden
      width={560}
    >
      <Typography.Paragraph type="secondary">
        Only when every partner is busy. Call the person first and check their ID. They get this one booking at once
        and log in to the WellWish Partner app with their number; their access ends with the job. The family sees them
        like any partner.
      </Typography.Paragraph>
      {changed && <Alert type="warning" showIcon style={{ marginBottom: 12 }} title={BOOKING_CHANGED} />}
      {error && <Alert type="error" showIcon style={{ marginBottom: 12 }} title={error} />}
      <Form form={form} layout="vertical" onFinish={submit} requiredMark={false} initialValues={{ idChecked: false }}>
        <Form.Item
          name="phone"
          label="Their mobile number (their app login)"
          rules={[
            {
              required: true,
              validator: (_, value?: string) =>
                MOBILE.test((value ?? "").replace(/[\s\-().]/g, ""))
                  ? Promise.resolve()
                  : Promise.reject(new Error("Enter a 10-digit Indian mobile number")),
            },
          ]}
        >
          <Input inputMode="tel" placeholder="98765 43210" maxLength={16} />
        </Form.Item>
        <Form.Item name="fullName" label="Full name" rules={[trimmedMin(2, "Enter their name")]}>
          <Input maxLength={80} />
        </Form.Item>
        <Form.Item name="gender" label="Gender" rules={[{ required: true, message: "Pick one" }]}>
          <Select
            options={[
              { value: "FEMALE", label: "Female" },
              { value: "MALE", label: "Male" },
              { value: "OTHER", label: "Other" },
            ]}
          />
        </Form.Item>
        <Form.Item name="idType" label="ID you checked" rules={[{ required: true, message: "Pick the ID" }]}>
          <Select options={ID_TYPES} />
        </Form.Item>
        <Form.Item
          name="idLast4"
          label="Last 4 characters of the ID number"
          extra="Never the full number. A pasted full number keeps only its last 4."
          // spaces and dashes dropped, only the end kept: a pasted "1234 5678 9012" is "9012"
          normalize={(value?: string) => (value ?? "").replace(/[\s-]/g, "").slice(-4)}
          rules={[{ required: true, pattern: /^[0-9A-Za-z]{4}$/, message: "Exactly 4 letters or digits" }]}
        >
          <Input style={{ width: 120 }} autoComplete="off" />
        </Form.Item>
        <Form.Item
          name="idPhotoKey"
          label="Photo of the ID"
          extra="A photo or PDF (e.g. sent to you on WhatsApp). Kept private; every view is logged."
          rules={[{ required: true, message: "Upload the ID photo" }]}
        >
          <FileUpload purpose="temp_partner_id" label="Upload ID photo" />
        </Form.Item>
        {nurse && (
          <Form.Item
            name="nursingRegNo"
            label="Nursing registration number (as printed)"
            rules={[{ required: true, message: "Needed for a nurse booking" }]}
          >
            <Input maxLength={40} />
          </Form.Item>
        )}
        <Form.Item
          name="reason"
          label="Why no regular partner (logged)"
          rules={[trimmedMin(3, "Write at least 3 characters")]}
        >
          <Input.TextArea rows={2} maxLength={300} showCount />
        </Form.Item>
        <Form.Item
          name="idChecked"
          valuePropName="checked"
          rules={[
            {
              validator: (_, checked) =>
                checked ? Promise.resolve() : Promise.reject(new Error("Call them and check the ID first")),
            },
          ]}
        >
          <Checkbox>I&apos;ve called this person and checked their ID against the photo</Checkbox>
        </Form.Item>
      </Form>
    </Modal>
  );
}
