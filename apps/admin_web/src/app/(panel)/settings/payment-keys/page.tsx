"use client";

import { Alert, App, Button, Card, Descriptions, Form, Input, Skeleton, Tag, Typography } from "antd";
import { useCallback, useEffect, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorCode, errorMessage, formErrors } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";

type Keys = components["schemas"]["GatewayKeysOut"];
type KeysIn = components["schemas"]["GatewayKeysIn"];

const SOURCE: Record<string, string> = {
  ADMIN: "Entered here",
  ENVIRONMENT: "From the server's environment file",
  NONE: "Not set: patients can book, but can't pay online yet",
};

const EVENTS = ["payment.captured", "payment.failed", "order.paid", "refund.processed", "refund.failed"];

/**
 * Settings → Payment keys (§6.12, §12): the Razorpay key id, key secret and webhook secret. The
 * secrets are stored encrypted and never shown again (only their last 4 characters). Saving is
 * logged without the values. Test keys (rzp_test_…) take test payments only.
 */
export default function PaymentKeysPage() {
  const can = useCan();
  const { message } = App.useApp();
  const [form] = Form.useForm<KeysIn>();
  const [saving, setSaving] = useState(false);
  const typedKeyId = Form.useWatch("keyId", form);
  const typedWebhook = Form.useWatch("webhookSecret", form);
  const fetchKeys = useCallback(async () => (await api.GET("/v1/admin/payment-keys")).data, []);
  const { data, failed, setData } = useLoad<Keys>(fetchKeys, can("settings.manage"));

  useEffect(() => {
    if (data) form.setFieldsValue({ keyId: data.keyId, keySecret: "", webhookSecret: "" });
  }, [data, form]);

  const save = async (values: KeysIn) => {
    if (saving) return;
    setSaving(true);
    try {
      const { data: saved, error } = await api.PUT("/v1/admin/payment-keys", {
        body: { keyId: values.keyId.trim(), keySecret: values.keySecret ?? "", webhookSecret: values.webhookSecret ?? "" },
      });
      if (error || !saved) {
        const fields = formErrors(error);
        if (fields.length) form.setFields(fields);
        if (errorCode(error) === "SECRET_REQUIRED") form.setFields([{ name: "keySecret", errors: [errorMessage(error)] }]);
        message.error(errorMessage(error));
        return;
      }
      setData(saved);
      message.success("Razorpay keys saved.");
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setSaving(false);
    }
  };

  const webhookUrl = data && typeof window !== "undefined" ? `${window.location.origin}${data.webhookPath}` : "";
  // Saved here = a blank secret keeps it. Another key id is another Razorpay account or mode
  // (test / live): its webhook has its own secret.
  const savedHere = data?.source === "ADMIN";
  const otherAccount = !!data && !!typedKeyId && typedKeyId.trim() !== data.keyId;

  return (
    <Page
      title="Payment keys"
      permission="settings.manage"
      description="The Razorpay keys used for booking-fee payments. Find them in the Razorpay Dashboard → Account & Settings → API keys. Secrets are stored encrypted and never shown again."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the keys. Reload the page." />}
      {!data && !failed && <Skeleton active />}
      {data && (
        <>
          <Card size="small" title="In use now" style={{ marginBottom: 16 }}>
            <Descriptions
              size="small"
              column={{ xs: 1, md: 2 }}
              items={[
                {
                  key: "source",
                  label: "Keys",
                  children: (
                    <span>
                      {SOURCE[data.source] ?? data.source}
                      {data.mode && (
                        <Tag color={data.mode === "LIVE" ? "green" : "gold"} style={{ marginLeft: 8 }}>
                          {data.mode === "LIVE" ? "LIVE: real money" : "TEST mode"}
                        </Tag>
                      )}
                    </span>
                  ),
                },
                { key: "keyId", label: "Key id", children: data.keyId || "—" },
                {
                  key: "secret",
                  label: "Key secret",
                  children: data.keySecretSet ? `Saved (ends in ${data.keySecretLast4})` : "—",
                },
                {
                  key: "webhook",
                  label: "Webhook secret",
                  children: data.webhookSecretSet ? `Saved (ends in ${data.webhookSecretLast4})` : "Not set",
                },
                {
                  key: "updated",
                  label: "Last changed",
                  children: data.updatedAt ? `${dateTime(data.updatedAt)}${data.updatedBy ? ` by ${data.updatedBy}` : ""}` : "—",
                },
              ]}
            />
          </Card>

          {!data.webhookSecretSet && data.source !== "NONE" && (
            <Alert
              type="warning"
              showIcon
              style={{ marginBottom: 16 }}
              title="Without a webhook secret, a payment is confirmed only when the app reports it or by the check every 10 minutes."
            />
          )}

          <Card size="small" title="Razorpay webhook" style={{ marginBottom: 16 }}>
            <Typography.Paragraph>
              In the Razorpay Dashboard → Webhooks, add a webhook with this URL (use the API&apos;s public address
              if it is served on another domain):
            </Typography.Paragraph>
            <Typography.Paragraph copyable code>
              {webhookUrl}
            </Typography.Paragraph>
            <Typography.Paragraph style={{ marginBottom: 0 }}>
              Events: {EVENTS.map((e) => <Tag key={e}>{e}</Tag>)}
              <br />
              Choose a secret there and enter the same secret below.
            </Typography.Paragraph>
          </Card>

          <Card size="small" title="Change the keys">
            <Form form={form} layout="vertical" onFinish={save} style={{ maxWidth: 520 }} autoComplete="off">
              <Form.Item
                name="keyId"
                label="Key id"
                rules={[
                  { required: true, message: "Enter the key id." },
                  { pattern: /^rzp_(test|live)_[A-Za-z0-9]{6,40}$/, message: "Starts with rzp_test_ or rzp_live_." },
                ]}
              >
                <Input placeholder="rzp_test_…" maxLength={60} autoComplete="off" data-lpignore="true" data-1p-ignore />
              </Form.Item>
              <Form.Item
                name="keySecret"
                label="Key secret"
                extra={savedHere && !otherAccount ? "Leave empty to keep the saved secret." : undefined}
              >
                <Input.Password maxLength={128} autoComplete="off" data-lpignore="true" data-1p-ignore />
              </Form.Item>
              <Form.Item
                name="webhookSecret"
                label="Webhook secret"
                extra={
                  otherAccount
                    ? "A different Razorpay account or mode: enter the webhook secret of its own webhook."
                    : savedHere && data.webhookSecretSet
                      ? "Leave empty to keep the saved secret."
                      : undefined
                }
              >
                <Input.Password maxLength={128} autoComplete="off" data-lpignore="true" data-1p-ignore />
              </Form.Item>
              {otherAccount && !typedWebhook && data.webhookSecretSet && (
                <Alert
                  type="warning"
                  showIcon
                  style={{ marginBottom: 16 }}
                  title="Without the new webhook secret, Razorpay's messages for this account are refused; payments are then confirmed only by the app and the 10-minute check."
                />
              )}
              <Button type="primary" htmlType="submit" loading={saving}>
                Save keys
              </Button>
            </Form>
          </Card>
        </>
      )}
    </Page>
  );
}
