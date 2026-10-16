"use client";

import { ReloadOutlined } from "@ant-design/icons";
import { Alert, Button, Empty, Flex, Input, Segmented, Table, Tag, Typography } from "antd";
import { useCallback, useEffect, useMemo, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { IS_DEV } from "@/config/env";
import { dateTime } from "@/lib/format";
import { phone } from "@/lib/partners";
import { useLoad } from "@/lib/useLoad";

type Sms = components["schemas"]["DevSmsOut"];
type Mail = components["schemas"]["DevMailOut"];

/** What each SMS template is, in words (common/sms.py). */
const SMS_KIND: Record<string, { label: string; color?: string }> = {
  LOGIN_OTP: { label: "Login code", color: "blue" },
  JOB_OTP: { label: "Visit code", color: "green" },
  SOS_ALERT: { label: "SOS alert", color: "red" },
};

/** The code in a message ("Your code is 482913…" → "482913"), for login and visit codes. */
function codeIn(text: string): string | null {
  return /\b(\d{4,6})\b/.exec(text)?.[1] ?? null;
}

const REFRESH_MS = 5000;

/**
 * Settings → Test messages (local development only): MSG91 and email aren't connected on a
 * developer's PC, so the SMS (login codes, visit codes, SOS alerts…) and emails the app sends
 * are kept for an hour instead. The API answers 404 on real servers, which send for real.
 */
export default function TestMessagesPage() {
  const can = useCan();
  const [kind, setKind] = useState<"sms" | "email">("sms");
  const [search, setSearch] = useState("");
  const [missing, setMissing] = useState(!IS_DEV); // a server build never asks
  const fetchOutbox = useCallback(async () => {
    const { data, response } = await api.GET("/v1/admin/dev/outbox");
    setMissing(response.status === 404);
    return data;
  }, []);
  const { data, failed, loading, reload } = useLoad(fetchOutbox, IS_DEV && can("settings.manage"));

  // new codes appear by themselves while testing (not in a hidden tab, not once the API said 404)
  useEffect(() => {
    if (missing) return;
    const timer = window.setInterval(() => {
      if (!document.hidden) reload();
    }, REFRESH_MS);
    return () => window.clearInterval(timer);
  }, [reload, missing]);

  const needle = search.replace(/\s/g, "").toLowerCase();
  const sms = useMemo(
    () => (data?.sms ?? []).filter((m) => !needle || m.phone.replace(/\s/g, "").includes(needle)),
    [data, needle],
  );
  const email = useMemo(
    () => (data?.email ?? []).filter((m) => !needle || m.to.includes(needle)),
    [data, needle],
  );

  return (
    <Page
      title="Test messages"
      permission="settings.manage"
      description="The SMS and emails the app would have sent: login codes, visit codes, SOS alerts, partner email codes. Local development only (MSG91 and email aren't connected here). The last 50 of the past hour, newest first; refreshes every 5 seconds."
      extra={
        <Button icon={<ReloadOutlined />} loading={loading} onClick={reload}>
          Refresh
        </Button>
      }
    >
      {missing ? (
        <Empty description="Only on a developer's PC. Real servers send SMS by MSG91 and keep no copy." />
      ) : (
        <>
          {failed && <Alert type="error" showIcon title="Couldn't load the messages. Is the API running?" />}
          <Alert
            type="info"
            showIcon
            style={{ marginBottom: 16 }}
            title="Test numbers +91 90000 00001 to 00005 always use the login code 123456 and get no SMS here."
          />
          <Flex gap={12} wrap style={{ marginBottom: 16 }}>
            <Segmented
              value={kind}
              onChange={(v) => setKind(v as "sms" | "email")}
              options={[
                { label: `SMS (${data?.sms.length ?? 0})`, value: "sms" },
                { label: `Email (${data?.email.length ?? 0})`, value: "email" },
              ]}
            />
            <Input.Search
              allowClear
              style={{ maxWidth: 280 }}
              placeholder={kind === "sms" ? "Filter by phone number" : "Filter by email"}
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </Flex>
          {kind === "sms" ? (
            <Table<Sms>
              rowKey={(m) => `${m.at}-${m.phone}-${m.template}`}
              size="small"
              pagination={false}
              scroll={{ x: true }}
              dataSource={sms}
              locale={{ emptyText: "No SMS in the last hour." }}
              columns={[
                { title: "Sent", key: "at", width: 170, render: (_, m) => dateTime(m.at) },
                { title: "To", key: "phone", width: 160, render: (_, m) => phone(m.phone) },
                {
                  title: "Type",
                  key: "template",
                  width: 120,
                  render: (_, m) => <Tag color={SMS_KIND[m.template]?.color}>{SMS_KIND[m.template]?.label ?? m.template}</Tag>,
                },
                {
                  title: "Code",
                  key: "code",
                  width: 110,
                  render: (_, m) => {
                    const code = m.template.endsWith("_OTP") ? codeIn(m.text) : null;
                    return code ? (
                      <Typography.Text strong copyable={{ text: code }} style={{ fontSize: 16 }}>
                        {code}
                      </Typography.Text>
                    ) : (
                      "—"
                    );
                  },
                },
                { title: "Message", key: "text", render: (_, m) => <div style={{ whiteSpace: "pre-wrap" }}>{m.text}</div> },
              ]}
            />
          ) : (
            <Table<Mail>
              rowKey={(m) => `${m.at}-${m.to}`}
              size="small"
              pagination={false}
              scroll={{ x: true }}
              dataSource={email}
              locale={{ emptyText: "No emails in the last hour." }}
              columns={[
                { title: "Sent", key: "at", width: 170, render: (_, m) => dateTime(m.at) },
                { title: "To", key: "to", width: 220, render: (_, m) => m.to },
                { title: "Subject", key: "subject", width: 220, render: (_, m) => m.subject },
                { title: "Message", key: "text", render: (_, m) => <div style={{ whiteSpace: "pre-wrap" }}>{m.text}</div> },
              ]}
            />
          )}
        </>
      )}
    </Page>
  );
}
