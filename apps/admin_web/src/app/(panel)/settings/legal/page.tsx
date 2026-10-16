"use client";

import { Alert, Button, Space, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useCallback } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import { LANGUAGE_NAMES } from "@/components/legal/LegalText";
import Page from "@/components/Page";
import { dateTime } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";

type Summary = components["schemas"]["LegalSummaryOut"];

/**
 * Settings → Legal pages (ARCHITECTURE §6.20): the Terms of Use, Privacy Policy, Refund Policy
 * and Partner Terms the apps, the consent screens and the store listings show. Super Admins
 * only (`legal.manage`). Each publish is a new version; old ones are kept.
 */
export default function LegalPagesPage() {
  const can = useCan();
  const fetcher = useCallback(async () => (await api.GET("/v1/admin/legal")).data, []);
  const { data, failed } = useLoad<Summary[]>(fetcher, can("legal.manage"));
  const drafts = (data ?? []).some((d) => !d.publishedBy);

  return (
    <Page
      title="Legal pages"
      permission="legal.manage"
      description="What patients and partners accept, shown in the apps and linked from the store listings. Each publish is a new version; older versions stay readable."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the legal pages. Reload the page." />}
      {drafts && (
        <Alert
          type="warning"
          showIcon
          style={{ marginBottom: 16 }}
          title="Some pages are still the first drafts."
          description="They describe what the app really does. A lawyer should check them before launch, and the parts in [square brackets] need WellWish's own details (company name, address, grievance officer)."
        />
      )}
      <Table<Summary>
        rowKey="kind"
        loading={!data && !failed}
        dataSource={data ?? []}
        pagination={false}
        scroll={{ x: 760 }}
        columns={[
          {
            title: "Page",
            key: "title",
            render: (_, r) => <Link href={`/settings/legal/${r.kind}`}>{r.title}</Link>,
          },
          {
            title: "Version",
            key: "version",
            render: (_, r) => (
              <Space size={4} wrap>
                {r.version}
                {!r.publishedBy ? <Tag>First draft</Tag> : r.askedAgain ? <Tag color="blue">Asked everyone</Tag> : <Tag>Small fix</Tag>}
              </Space>
            ),
          },
          {
            title: "Languages",
            key: "languages",
            render: (_, r) => r.languages.map((l) => <Tag key={l}>{LANGUAGE_NAMES[l] ?? l}</Tag>),
          },
          {
            title: "Published",
            key: "published",
            render: (_, r) => `${dateTime(r.publishedAt)}${r.publishedBy ? ` by ${r.publishedBy}` : ""}`,
          },
          {
            title: "",
            key: "actions",
            render: (_, r) => (
              <Space>
                <Link href={`/settings/legal/${r.kind}`}>
                  <Button size="small">Edit</Button>
                </Link>
                <Typography.Link href={r.publicUrl} target="_blank" rel="noreferrer">
                  Public page
                </Typography.Link>
              </Space>
            ),
          },
        ]}
      />
    </Page>
  );
}
