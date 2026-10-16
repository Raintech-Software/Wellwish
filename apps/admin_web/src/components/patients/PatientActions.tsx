"use client";

import { DeleteOutlined, EditOutlined, StopOutlined, UnlockOutlined } from "@ant-design/icons";
import { App, Button, DatePicker, Form, Input, Modal, Select, Space, Typography } from "antd";
import type { Dayjs } from "dayjs";
import dayjs from "dayjs";
import { useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { errorCode, errorMessage } from "@/lib/errors";
import { GENDER, LANGUAGE } from "@/lib/patients";

type Detail = components["schemas"]["PatientDetailOut"];
type Action = "edit" | "block" | "unblock" | "delete";

interface Values {
  fullName?: string;
  dob?: Dayjs;
  gender?: "FEMALE" | "MALE" | "OTHER";
  language?: "en" | "hi" | "or";
  reason: string;
}

const TEXT: Record<Action, { title: string; ok: string; done: string; danger: boolean; help: string; placeholder: string }> =
  {
    edit: {
      title: "Edit details (only when the patient asks)",
      ok: "Save",
      done: "Details saved",
      danger: false,
      help: "Only change what the patient asked for. What changed and your reason go to the audit log. The phone number is their login and can't be changed here.",
      placeholder: "Asked by phone on 13 Oct: name spelt wrong",
    },
    block: {
      title: "Block from the patient app",
      ok: "Block",
      done: "Blocked: logged out of the app",
      danger: true,
      help: "They are logged out of the WellWish app on every phone at once and can't log in until you unblock them. Their bookings stay as they are: cancel any that must go. If they are also a partner, the partner app is not affected. Logged with your reason.",
      placeholder: "Abusive calls to partners",
    },
    unblock: {
      title: "Unblock",
      ok: "Unblock",
      done: "Unblocked: they can log in again",
      danger: false,
      help: "They can log in to the patient app again. Logged with your reason.",
      placeholder: "Spoke to them, sorted out",
    },
    delete: {
      title: "Start account deletion",
      ok: "Start deletion",
      done: "Deletion started: they are logged out",
      danger: true,
      help: "Only when the patient asked for it (e.g. by phone). They are logged out at once and their personal data is erased after the waiting time, unless they log in again before then. Payment records are kept. Logged with your reason.",
      placeholder: "Asked by phone on 13 Oct to delete the account",
    },
  };

/**
 * The admin's actions on a patient account (§9.1, PHASES 9.10; `patients.manage`): edit the
 * details on the patient's request, block / unblock the patient app (abuse), start account
 * deletion for a patient who asks by phone. Each needs a reason and is audit-logged.
 */
export default function PatientActions({
  id,
  detail,
  onChanged,
}: {
  id: string;
  detail: Detail;
  onChanged: (detail: Detail) => void;
}) {
  const { message } = App.useApp();
  const [action, setAction] = useState<Action | null>(null);
  const [busy, setBusy] = useState(false);
  const [form] = Form.useForm<Values>();
  const blocked = Boolean(detail.patient.blockedAt);

  const open = (next: Action) => {
    form.resetFields();
    if (next === "edit") {
      form.setFieldsValue({
        fullName: detail.patient.fullName,
        dob: detail.dob ? dayjs(detail.dob) : undefined,
        gender: (detail.gender || undefined) as Values["gender"],
        language: detail.language as Values["language"],
      });
    }
    setAction(next);
  };

  const submit = async (values: Values) => {
    if (!action) return;
    setBusy(true);
    const path = { params: { path: { user_id: id } } };
    const reason = values.reason;
    try {
      const result =
        action === "edit"
          ? await api.PUT("/v1/admin/patients/{user_id}", {
              ...path,
              body: {
                fullName: values.fullName ?? "",
                dob: values.dob?.format("YYYY-MM-DD") ?? "",
                gender: values.gender ?? "OTHER",
                language: values.language ?? "en",
                reason,
              },
            })
          : action === "block"
            ? await api.POST("/v1/admin/patients/{user_id}/block", { ...path, body: { reason } })
            : action === "unblock"
              ? await api.POST("/v1/admin/patients/{user_id}/unblock", { ...path, body: { reason } })
              : await api.POST("/v1/admin/patients/{user_id}/deletion", { ...path, body: { reason } });
      if (!result.data) {
        message.error(
          errorCode(result.error) === "ACTIVE_BOOKINGS"
            ? "This patient has a paid booking that isn't finished. Cancel it first, or wait until it's done."
            : errorMessage(result.error),
        );
        return;
      }
      message.success(TEXT[action].done);
      onChanged(result.data);
      setAction(null);
    } catch {
      message.error("No connection. Please try again."); // the request didn't reach the server
    } finally {
      setBusy(false);
    }
  };

  const text = action ? TEXT[action] : null;
  return (
    <>
      <Space wrap>
        <Button icon={<EditOutlined />} onClick={() => open("edit")}>
          Edit details
        </Button>
        {blocked ? (
          <Button icon={<UnlockOutlined />} onClick={() => open("unblock")}>
            Unblock
          </Button>
        ) : (
          <Button danger icon={<StopOutlined />} onClick={() => open("block")}>
            Block
          </Button>
        )}
        {!detail.patient.deletionDueAt && (
          <Button danger icon={<DeleteOutlined />} onClick={() => open("delete")}>
            Start account deletion
          </Button>
        )}
      </Space>
      <Modal
        title={text?.title}
        open={action !== null}
        onCancel={() => setAction(null)}
        onOk={() => form.submit()}
        okText={text?.ok}
        okButtonProps={{ loading: busy, danger: text?.danger }}
        forceRender // the form exists before the dialog opens, so it can be filled in first
      >
        <Typography.Paragraph type="secondary">{text?.help}</Typography.Paragraph>
        <Form form={form} layout="vertical" onFinish={submit}>
          {action === "edit" && (
            <>
              <Form.Item
                name="fullName"
                label="Full name"
                rules={[{ required: true, min: 2, max: 80, message: "Write the name (2+ letters)." }]}
              >
                <Input />
              </Form.Item>
              <Form.Item name="dob" label="Date of birth" rules={[{ required: true, message: "Pick the date." }]}>
                <DatePicker format="D MMM YYYY" disabledDate={(d) => d.isAfter(dayjs(), "day")} />
              </Form.Item>
              <Form.Item name="gender" label="Gender" rules={[{ required: true, message: "Pick one." }]}>
                <Select options={Object.entries(GENDER).map(([value, label]) => ({ value, label }))} />
              </Form.Item>
              <Form.Item name="language" label="App language" rules={[{ required: true, message: "Pick one." }]}>
                <Select options={Object.entries(LANGUAGE).map(([value, label]) => ({ value, label }))} />
              </Form.Item>
            </>
          )}
          <Form.Item
            name="reason"
            label="Reason"
            rules={[{ required: true, min: 5, max: 300, whitespace: true, message: "Write the reason (5+ letters)." }]}
          >
            <Input.TextArea autoSize={{ minRows: 2 }} placeholder={text?.placeholder} />
          </Form.Item>
        </Form>
      </Modal>
    </>
  );
}
