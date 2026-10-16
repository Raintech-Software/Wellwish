"use client";

import { Alert, App, Button, Card, Col, Flex, Form, Input, InputNumber, Row, Select, Skeleton, Typography } from "antd";
import { useCallback, useEffect, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorMessage, formErrors } from "@/lib/errors";
import { toPaise, toRupees } from "@/lib/format";

type Settings = components["schemas"]["SettingsOut"];
type Setting = components["schemas"]["SettingOut"];

/** Friendly names for choice values. */
const CHOICE_LABELS: Record<string, string> = {
  ON_THE_WAY: "the partner sets off (On the way)",
  REACHED_PATIENT: "the partner reaches the patient",
  "15": "Every 15 minutes",
  "30": "Every 30 minutes",
  "60": "Every hour",
};

const isMoney = (s: Setting) => s.unit === "paise";

/** The form holds numbers for int settings (rupees for money) and text for the rest. */
function toForm(s: Setting): number | string {
  if (s.kind !== "int") return s.value;
  return isMoney(s) ? toRupees(Number(s.value)) : Number(s.value);
}

function fromForm(s: Setting, value: unknown): string {
  if (s.kind !== "int") return String(value ?? "").trim();
  return String(isMoney(s) ? toPaise(Number(value)) : Number(value));
}

function Field({ setting }: { setting: Setting }) {
  const help = [setting.help, `Default: ${defaultText(setting)}`].filter(Boolean).join(" ");
  let input;
  if (setting.kind === "int") {
    input = (
      <InputNumber
        style={{ width: "100%" }}
        min={isMoney(setting) ? toRupees(setting.min ?? 0) : (setting.min ?? undefined)}
        max={isMoney(setting) ? toRupees(setting.max ?? 0) : (setting.max ?? undefined)}
        precision={isMoney(setting) ? 2 : 0}
        prefix={isMoney(setting) ? "₹" : undefined}
        suffix={!isMoney(setting) && setting.unit ? setting.unit : undefined}
      />
    );
  } else if (setting.kind === "choice") {
    input = <Select options={setting.choices.map((c) => ({ value: c, label: CHOICE_LABELS[c] ?? c }))} />;
  } else if (setting.kind === "time") {
    input = <Input placeholder="HH:MM" maxLength={5} style={{ maxWidth: 140 }} />;
  } else if (setting.kind === "phone") {
    input = <Input placeholder="+91 98765 43210" inputMode="tel" />;
  } else {
    input = <Input placeholder="1.2.0" style={{ maxWidth: 160 }} />;
  }
  const rules =
    setting.kind === "time"
      ? [{ required: true, pattern: /^([01]\d|2[0-3]):[0-5]\d$/, message: "Use HH:MM (24 h)." }]
      : setting.kind === "version"
        ? [{ required: true, pattern: /^\d{1,3}\.\d{1,3}\.\d{1,3}$/, message: "Use a version like 1.2.0." }]
        : setting.kind === "phone" && setting.default === ""
          ? []
          : [{ required: true, message: "Required." }];
  return (
    <Form.Item name={setting.key} label={setting.label} extra={help} rules={rules}>
      {input}
    </Form.Item>
  );
}

function defaultText(s: Setting): string {
  if (s.default === "") return "empty";
  if (isMoney(s)) return `₹${toRupees(Number(s.default))}`;
  if (s.kind === "choice") return CHOICE_LABELS[s.default] ?? s.default;
  return s.unit ? `${s.default} ${s.unit}` : s.default;
}

/** Settings → General (ARCHITECTURE §6.17, §11 app_settings): every key, grouped. */
export default function SettingsPage() {
  const { message } = App.useApp();
  const can = useCan();
  const [settings, setSettings] = useState<Settings | null>(null);
  const [failed, setFailed] = useState(false);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<Record<string, number | string>>();

  const apply = useCallback(
    (data: Settings) => {
      setSettings(data);
      const values: Record<string, number | string> = {};
      data.groups.forEach((g) => g.settings.forEach((s) => (values[s.key] = toForm(s))));
      form.setFieldsValue(values);
    },
    [form],
  );

  useEffect(() => {
    if (!can("settings.manage")) return;
    void api.GET("/v1/admin/settings").then(({ data }) => (data ? apply(data) : setFailed(true)));
  }, [can, apply]);

  const save = async (values: Record<string, unknown>) => {
    if (!settings) return;
    const changed: Record<string, string> = {};
    settings.groups.forEach((g) =>
      g.settings.forEach((s) => {
        const next = fromForm(s, values[s.key]);
        if (next !== s.value) changed[s.key] = next;
      }),
    );
    if (!Object.keys(changed).length) {
      message.info("Nothing changed.");
      return;
    }
    setSaving(true);
    const { data, error } = await api.PUT("/v1/admin/settings", { body: { values: changed } });
    setSaving(false);
    if (!data) {
      form.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    apply(data);
    message.success(`Saved ${Object.keys(changed).length} setting(s). The apps use them within a minute.`);
  };

  return (
    <Page
      title="Settings"
      permission="settings.manage"
      description="Rules the apps and the booking flow follow. Every change is kept in the audit log."
      extra={
        <Button type="primary" loading={saving} onClick={() => form.submit()} disabled={!settings}>
          Save changes
        </Button>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the settings. Reload the page." />}
      {!settings && !failed && <Skeleton active />}
      <Form form={form} layout="vertical" onFinish={save} requiredMark={false}>
        <Flex vertical gap={16}>
          {settings?.groups.map((group) => (
            <Card key={group.name} size="small" title={group.name}>
              <Row gutter={24}>
                {group.settings.map((s) => (
                  <Col key={s.key} xs={24} md={12} xl={8}>
                    <Field setting={s} />
                  </Col>
                ))}
              </Row>
            </Card>
          ))}
        </Flex>
      </Form>
      {settings && (
        <Typography.Paragraph type="secondary" style={{ marginTop: 16 }}>
          Service areas and blocked dates have their own pages under Settings.
        </Typography.Paragraph>
      )}
    </Page>
  );
}
