"use client";

import { ArrowLeftOutlined } from "@ant-design/icons";
import { Alert, App, Button, Card, Col, Form, Input, Modal, Popconfirm, Row, Space, Spin, Table, Tabs, Tag, Typography } from "antd";
import Link from "next/link";
import { useParams } from "next/navigation";
import { useCallback, useEffect, useRef, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import LegalText, { FORMAT_HELP, LANGUAGE_NAMES } from "@/components/legal/LegalText";
import Page from "@/components/Page";
import { errorCode, errorMessage } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";
import { STEP } from "@/lib/visit";

type Doc = components["schemas"]["LegalDocumentOut"];
type Version = components["schemas"]["LegalVersionOut"];
type Kind = Doc["kind"];
type Texts = Pick<Doc, "titleEn" | "titleHi" | "titleOr" | "bodyEn" | "bodyHi" | "bodyOr">;

const LANGS = [
  { code: "en", suffix: "En" },
  { code: "hi", suffix: "Hi" },
  { code: "or", suffix: "Or" },
] as const;

/** Who accepts the page again after "ask everyone again" (§6.20). */
const WHO: Record<Kind, string> = {
  TERMS: "every patient",
  PRIVACY: "every patient and partner",
  PARTNER_TERMS: "every partner",
  REFUNDS: "",
};

function texts(doc: Doc): Texts {
  const { titleEn, titleHi, titleOr, bodyEn, bodyHi, bodyOr } = doc;
  return { titleEn, titleHi, titleOr, bodyEn, bodyHi, bodyOr };
}

/** A version's text in each language, read-only (which text someone accepted). */
function DocTabs({ doc }: { doc: Texts }) {
  return (
    <Tabs
      items={LANGS.map(({ code, suffix }) => {
        const title = doc[`title${suffix}`];
        const body = doc[`body${suffix}`];
        return {
          key: code,
          label: LANGUAGE_NAMES[code],
          children:
            title && body ? (
              <div lang={code}>
                <Typography.Title level={4}>{title}</Typography.Title>
                <LegalText text={body} lang={code} />
              </div>
            ) : (
              <Typography.Text type="secondary">Not written in this language: the English text is shown.</Typography.Text>
            ),
        };
      })}
    />
  );
}

/**
 * Settings → Legal pages → one page (ARCHITECTURE §6.20): edit the text in English, Hindi and
 * Odia with a preview, then publish a small fix (nobody is asked again) or a change everyone
 * accepts again at their next app open. Every version stays readable below.
 */
export default function LegalEditPage() {
  const { kind } = useParams<{ kind: Kind }>();
  const can = useCan();
  const { message } = App.useApp();
  const [form] = Form.useForm<Texts>();
  const watched = Form.useWatch([], form) as Texts | undefined;
  const [busy, setBusy] = useState(false);
  const [viewing, setViewing] = useState<Doc | null>(null);
  const [tab, setTab] = useState<string>("en");
  // someone published while this admin was editing: their text stays, with this warning
  const [conflict, setConflict] = useState<Doc | null>(null);
  // the text the form was filled with; "unsaved" = the form differs from it
  const base = useRef<Doc | null>(null);
  const refill = useRef(true); // the first load and after this admin's own publish

  const fetchDoc = useCallback(
    async () => (await api.GET("/v1/admin/legal/{kind}", { params: { path: { kind } } })).data,
    [kind],
  );
  const { data, failed, reload, setData } = useLoad<Doc>(fetchDoc, can("legal.manage"));
  const fetchVersions = useCallback(
    async () => (await api.GET("/v1/admin/legal/{kind}/versions", { params: { path: { kind } } })).data,
    // eslint-disable-next-line react-hooks/exhaustive-deps -- reload the history after a publish
    [kind, data?.version],
  );
  const { data: versions } = useLoad<Version[]>(fetchVersions, can("legal.manage"));

  const unsaved = useCallback(() => {
    if (!base.current) return false;
    const now = form.getFieldsValue();
    const was = texts(base.current);
    return (Object.keys(was) as (keyof Texts)[]).some((k) => (now[k] ?? "") !== (was[k] ?? ""));
  }, [form]);

  // Fill the form when the page opens and after a publish; never over what the admin has typed
  // (a reload after a conflict brings the newest version as the base, the typed text stays).
  useEffect(() => {
    if (!data) return;
    if (refill.current || !unsaved()) form.setFieldsValue(texts(data));
    refill.current = false;
    base.current = data;
  }, [data, form, unsaved]);

  // Unsaved text: the browser asks before closing or reloading the tab.
  useEffect(() => {
    const warn = (event: BeforeUnloadEvent) => {
      if (unsaved()) event.preventDefault();
    };
    window.addEventListener("beforeunload", warn);
    return () => window.removeEventListener("beforeunload", warn);
  }, [unsaved]);

  // The Refund Policy states settings the admin can change (refund %, cut-off, payment time).
  const fetchSettings = useCallback(async () => (await api.GET("/v1/admin/settings")).data, []);
  const { data: settings } = useLoad(fetchSettings, kind === "REFUNDS" && can("settings.manage"));
  const setting = (key: string) =>
    settings?.groups.flatMap((g) => g.settings).find((one) => one.key === key);

  const publish = async (askAgain: boolean) => {
    if (!data || busy) return;
    let values: Texts;
    try {
      values = await form.validateFields();
    } catch {
      setTab("en"); // only the English title and text are required
      message.error("Fill in the English title and text first.");
      return;
    }
    setBusy(true);
    try {
      const { data: saved, error } = await api.POST("/v1/admin/legal/{kind}", {
        params: { path: { kind } },
        body: {
          expectedVersion: data.version,
          askAgain,
          titleEn: values.titleEn ?? "",
          titleHi: values.titleHi ?? "",
          titleOr: values.titleOr ?? "",
          bodyEn: values.bodyEn ?? "",
          bodyHi: values.bodyHi ?? "",
          bodyOr: values.bodyOr ?? "",
        },
      });
      if (!saved) {
        const code = errorCode(error);
        if (code === "LEGAL_VERSION_CHANGED") {
          // the newest version becomes the base; the admin's text is not touched
          const { data: newest } = await api.GET("/v1/admin/legal/{kind}", { params: { path: { kind } } });
          if (newest) {
            setConflict(newest);
            setData(newest);
          } else reload();
          return;
        }
        if (code === "INCOMPLETE_LANGUAGE") {
          const language = String((error as { error?: { details?: { language?: string } } })?.error?.details?.language ?? "");
          if (language) setTab(language);
          message.error(
            `${LANGUAGE_NAMES[language] ?? "A language"}: fill in both the title and the text, or leave both empty.`,
          );
          return;
        }
        message.error(errorMessage(error));
        return;
      }
      setConflict(null);
      refill.current = true; // the published text is the form's base now
      setData(saved);
      const who = WHO[kind].charAt(0).toUpperCase() + WHO[kind].slice(1);
      message.success(
        askAgain
          ? `Version ${saved.version} published. ${who} accepts it at their next app open.`
          : `Version ${saved.version} published.`,
      );
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setBusy(false);
    }
  };

  const openVersion = async (version: number) => {
    try {
      const { data: doc } = await api.GET("/v1/admin/legal/{kind}/versions/{version}", {
        params: { path: { kind, version } },
      });
      if (doc) setViewing(doc);
      else message.error("Couldn't load that version.");
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    }
  };

  const asks = kind !== "REFUNDS"; // the refund policy isn't a consent

  return (
    <Page
      title={data ? data.titleEn : "Legal page"}
      permission="legal.manage"
      description="Edit the text, check the preview, then publish. Hindi and Odia may stay empty: the English text is shown then (fill in both the title and the text of a language, or neither)."
      extra={
        <Space wrap>
          <Link href="/settings/legal">
            <Button icon={<ArrowLeftOutlined />}>Legal pages</Button>
          </Link>
          {data && (
            <Button href={data.publicUrl} target="_blank" rel="noreferrer">
              Public page
            </Button>
          )}
        </Space>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load this page. Reload." />}
      {!data ? (
        !failed && <Spin />
      ) : (
        <>
          <Typography.Paragraph type="secondary">
            Version {data.version}, published {dateTime(data.publishedAt)}
            {data.publishedBy ? ` by ${data.publishedBy}` : " (first draft)"}.
          </Typography.Paragraph>
          {conflict && (
            <Alert
              type="warning"
              showIcon
              closable
              onClose={() => setConflict(null)}
              style={{ marginBottom: 16 }}
              title={`Version ${conflict.version} was published${conflict.publishedBy ? ` by ${conflict.publishedBy}` : ""} while you were editing.`}
              description={`Your text is still here and was not published. Read version ${conflict.version} (Versions → Read), keep what you need from it, then publish yours on top.`}
            />
          )}
          {kind === "REFUNDS" && settings && (
            <Alert
              type="info"
              showIcon
              style={{ marginBottom: 16 }}
              title="The settings this page describes"
              description={`Refund on cancel: ${setting("refund_percent")?.value ?? "?"} % · Patient can cancel until: ${STEP[setting("cancel_cutoff_step")?.value ?? ""] ?? setting("cancel_cutoff_step")?.value ?? "?"} · Unpaid bookings expire after: ${setting("payment_expiry_min")?.value ?? "?"} min. Keep the text in step with them.`}
            />
          )}
          <Form form={form} layout="vertical" disabled={busy}>
            <Tabs
              activeKey={tab}
              onChange={setTab}
              items={LANGS.map(({ code, suffix }) => ({
                key: code,
                label: LANGUAGE_NAMES[code],
                forceRender: true,
                children: (
                  <Row gutter={24}>
                    <Col xs={24} xl={12}>
                      <Form.Item
                        name={`title${suffix}`}
                        label="Title"
                        rules={code === "en" ? [{ required: true, whitespace: true, message: "The English title is needed." }] : []}
                      >
                        <Input maxLength={120} lang={code} />
                      </Form.Item>
                      <Form.Item
                        name={`body${suffix}`}
                        label="Text"
                        extra={FORMAT_HELP}
                        rules={code === "en" ? [{ required: true, whitespace: true, message: "The English text is needed." }] : []}
                      >
                        <Input.TextArea autoSize={{ minRows: 16, maxRows: 36 }} maxLength={100000} lang={code} />
                      </Form.Item>
                    </Col>
                    <Col xs={24} xl={12}>
                      <Typography.Text type="secondary">Preview</Typography.Text>
                      <Card size="small" style={{ marginTop: 4 }}>
                        <Typography.Title level={4} lang={code}>
                          {watched?.[`title${suffix}`] || (code === "en" ? "" : watched?.titleEn)}
                        </Typography.Title>
                        <LegalText
                          text={watched?.[`body${suffix}`] || (code === "en" ? "" : watched?.bodyEn) || ""}
                          lang={code}
                        />
                      </Card>
                    </Col>
                  </Row>
                ),
              }))}
            />
          </Form>
          <Space wrap style={{ marginTop: 8 }}>
            <Popconfirm
              title={asks ? "Publish a small fix?" : "Publish this version?"}
              description={asks ? "For typos and wording. Nobody is asked to accept it again." : "The public page shows it at once."}
              okText="Publish"
              cancelText="Not yet"
              onConfirm={() => publish(false)}
            >
              <Button type={asks ? "default" : "primary"} loading={busy}>
                {asks ? "Publish small fix" : "Publish"}
              </Button>
            </Popconfirm>
            {asks && (
              <Popconfirm
                title="Publish and ask everyone again?"
                description={`For a real change: ${WHO[kind]} must accept the new version at their next app open.`}
                okText="Publish"
                cancelText="Not yet"
                onConfirm={() => publish(true)}
              >
                <Button type="primary" loading={busy}>
                  Publish and ask everyone again
                </Button>
              </Popconfirm>
            )}
          </Space>

          <Card size="small" title="Versions" style={{ marginTop: 24 }}>
            <Table<Version>
              rowKey="version"
              size="small"
              pagination={false}
              dataSource={versions ?? []}
              loading={!versions}
              columns={[
                { title: "Version", dataIndex: "version", key: "version" },
                {
                  title: "",
                  key: "asked",
                  render: (_, v) =>
                    !v.publishedBy ? <Tag>First draft</Tag> : v.askedAgain ? <Tag color="blue">Asked everyone</Tag> : <Tag>Small fix</Tag>,
                },
                {
                  title: "Published",
                  key: "published",
                  render: (_, v) => `${dateTime(v.publishedAt)}${v.publishedBy ? ` by ${v.publishedBy}` : ""}`,
                },
                {
                  title: "",
                  key: "open",
                  render: (_, v) => (
                    <Button size="small" onClick={() => openVersion(v.version)}>
                      Read
                    </Button>
                  ),
                },
              ]}
            />
          </Card>
          <Modal
            open={!!viewing}
            title={viewing ? `${viewing.titleEn} · version ${viewing.version}` : ""}
            footer={null}
            width={760}
            onCancel={() => setViewing(null)}
          >
            {viewing && <DocTabs doc={texts(viewing)} />}
          </Modal>
        </>
      )}
    </Page>
  );
}
