"use client";

import { ArrowLeftOutlined } from "@ant-design/icons";
import {
  Alert,
  App,
  Button,
  Col,
  Drawer,
  Form,
  Input,
  Modal,
  Radio,
  Row,
  Space,
  Spin,
  Table,
  Typography,
} from "antd";
import dayjs, { type Dayjs } from "dayjs";
import Link from "next/link";
import { useParams } from "next/navigation";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import DocChecklist from "@/components/partners/DocChecklist";
import DocumentViewer from "@/components/partners/DocumentViewer";
import PartnerFields from "@/components/partners/PartnerFields";
import { PartnerStatusTag } from "@/components/partners/StatusTag";
import PartnerSummary from "@/components/partners/PartnerSummary";
import { errorMessage, formErrors } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { useDrawerSize } from "@/lib/useDrawerSize";
import { useLoad } from "@/lib/useLoad";

type Detail = components["schemas"]["PartnerDetailOut"];
type EditIn = components["schemas"]["PartnerEditIn"];
type History = components["schemas"]["HistoryOut"];

interface EditValues extends Omit<EditIn, "dob"> {
  dob: Dayjs;
}

type Action = "suspend" | "deactivate" | null;

/** Partners → profile (§9.1): both phones, email, documents, status history; suspend etc. */
export default function PartnerPage() {
  const { id } = useParams<{ id: string }>();
  const { message, modal } = App.useApp();
  const can = useCan();
  const fetchDetail = useCallback(
    async () => (await api.GET("/v1/admin/partners/{partner_id}", { params: { path: { partner_id: id } } })).data,
    [id],
  );
  const { data: loaded, failed, setData } = useLoad(fetchDetail, can("partners.view"));
  const detail = loaded as Detail | null;
  const [selected, setSelected] = useState<string | null>(null);
  const [action, setAction] = useState<Action>(null);
  const [editing, setEditing] = useState(false);
  const [busy, setBusy] = useState(false);
  const [reasonForm] = Form.useForm<{ reason: string }>();
  const [editForm] = Form.useForm<EditValues>();
  const drawerSize = useDrawerSize(720);

  const path = { params: { path: { partner_id: id } } };

  const apply = (data: Detail | undefined, error: unknown, done: string) => {
    if (!data) {
      message.error(errorMessage(error));
      return false;
    }
    setData(data);
    message.success(done);
    return true;
  };

  const runAction = async (kind: Exclude<Action, null>, reason: string) => {
    setBusy(true);
    const { data, error } =
      kind === "suspend"
        ? await api.POST("/v1/admin/partners/{partner_id}/suspend", { ...path, body: { reason } })
        : await api.POST("/v1/admin/partners/{partner_id}/deactivate", { ...path, body: { reason } });
    setBusy(false);
    if (apply(data, error, kind === "suspend" ? "Suspended and logged out." : "Deactivated and logged out.")) {
      setAction(null);
    }
  };

  const reinstate = () =>
    modal.confirm({
      title: "Reinstate this partner?",
      content: "They can get jobs again.",
      onOk: async () => {
        const { data, error } = await api.POST("/v1/admin/partners/{partner_id}/reinstate", path);
        apply(data, error, "Reinstated.");
      },
    });

  const forceLogout = () =>
    modal.confirm({
      title: "Log this partner out on their phone?",
      onOk: async () => {
        const { error } = await api.POST("/v1/admin/partners/{partner_id}/logout", path);
        if (error) message.error(errorMessage(error));
        else message.success("Logged out.");
      },
    });

  const decideDocument = async (documentId: string, approve: boolean, reason: string) => {
    const { error } = approve
      ? await api.POST("/v1/admin/partner-documents/{document_id}/approve", {
          params: { path: { document_id: documentId } },
        })
      : await api.POST("/v1/admin/partner-documents/{document_id}/reject", {
          params: { path: { document_id: documentId } },
          body: { reason },
        });
    if (error) message.error(errorMessage(error));
    const fresh = await fetchDetail();
    if (fresh) setData(fresh);
  };

  const openEdit = () => {
    if (!detail) return;
    const p = detail.partner;
    editForm.resetFields();
    editForm.setFieldsValue({
      role: p.role as EditIn["role"],
      fullName: p.fullName,
      dob: p.dob ? dayjs(p.dob) : undefined,
      gender: (p.gender || undefined) as EditIn["gender"],
      address: p.address,
      lat: p.lat ?? undefined,
      lng: p.lng ?? undefined,
      languages: p.languages,
      skills: p.skills,
      emergencyName: p.emergencyName,
      emergencyPhone: p.emergencyPhone,
    });
    setEditing(true);
  };

  const saveEdit = async (values: EditValues) => {
    setBusy(true);
    const { data, error } = await api.PUT("/v1/admin/partners/{partner_id}", {
      ...path,
      body: { ...values, dob: values.dob.format("YYYY-MM-DD"), skills: values.skills ?? [] },
    });
    setBusy(false);
    if (!data) editForm.setFields(formErrors(error));
    if (apply(data, error, "Saved.")) setEditing(false);
  };

  const status = detail?.partner.status;
  const canSuspend = can("partners.suspend");
  const reviewable = status === "APPROVED" || status === "SUSPENDED";
  // §6.20: the partner asked to delete their account (waiting) or it's erased: nothing to edit
  const deleting = !!detail?.partner.deletionDueAt || status === "DELETED";

  return (
    <Page
      title={detail ? detail.partner.fullName || "Partner" : "Partner"}
      permission="partners.view"
      extra={
        <Space wrap>
          <Link href="/partners">
            <Button icon={<ArrowLeftOutlined />}>Partners</Button>
          </Link>
          {detail && can("partners.add") && !deleting && <Button onClick={openEdit}>Edit</Button>}
          {canSuspend && status === "APPROVED" && (
            <Button danger onClick={() => (reasonForm.resetFields(), setAction("suspend"))}>
              Suspend
            </Button>
          )}
          {canSuspend && status === "SUSPENDED" && (
            <Button type="primary" onClick={reinstate}>
              Reinstate
            </Button>
          )}
          {canSuspend && (status === "APPROVED" || status === "SUSPENDED") && (
            <>
              <Button onClick={forceLogout}>Log out</Button>
              <Button danger onClick={() => (reasonForm.resetFields(), setAction("deactivate"))}>
                Deactivate
              </Button>
            </>
          )}
        </Space>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load this partner." />}
      {!detail ? (
        !failed && <Spin />
      ) : (
        <>
          {detail.partner.deletionDueAt && (
            <Alert
              type="warning"
              showIcon
              style={{ marginBottom: 16 }}
              title={`This partner asked to delete their account. Their personal details, phones and documents are erased on ${dateTime(detail.partner.deletionDueAt)}, unless they log in to the Partner app before then.`}
              description="Meanwhile they get no offers and their application isn't reviewed; suspending or deactivating still works. Their past jobs stay, with the name “Former partner”."
            />
          )}
          {status === "DELETED" && (
            <Alert
              type="info"
              showIcon
              style={{ marginBottom: 16 }}
              title="This partner deleted their account: their personal details, phones and documents are erased. Past jobs, fees and reviews stay on record."
            />
          )}
          {detail.partner.suspendedReason === "DOCUMENT_EXPIRED" && status === "SUSPENDED" && (
            <Alert
              type="warning"
              showIcon
              style={{ marginBottom: 16 }}
              title="Suspended because a document expired. Approving the new document reinstates them automatically."
            />
          )}
          {detail.application && ["SUBMITTED", "UNDER_REVIEW"].includes(detail.application.status) && (
            <Alert
              type="info"
              showIcon
              style={{ marginBottom: 16 }}
              title="This partner's application is waiting for review."
              action={
                <Link href={`/partners/applications/${detail.application.id}`}>
                  <Button size="small">Open review</Button>
                </Link>
              }
            />
          )}
          <Row gutter={[24, 24]}>
            <Col xs={24} xl={13}>
              <PartnerSummary partner={detail.partner} />
              <Typography.Title level={5} style={{ marginTop: 24 }}>
                Documents
              </Typography.Title>
              <DocChecklist
                documents={detail.documents}
                selectedId={selected}
                onSelect={setSelected}
                canReview={reviewable && can("partners.review")}
                onDecide={decideDocument}
              />
            </Col>
            <Col xs={24} xl={11}>
              <div style={{ position: "sticky", top: 16 }}>
                <DocumentViewer documentId={selected} height={480} />
              </div>
            </Col>
          </Row>
          <Typography.Title level={5} style={{ marginTop: 24 }}>
            History
          </Typography.Title>
          <Table<History>
            rowKey={(h) => `${h.at}-${h.action}`}
            size="small"
            pagination={{ pageSize: 10, hideOnSinglePage: true }}
            dataSource={detail.history}
            scroll={{ x: true }}
            columns={[
              { title: "When", dataIndex: "at", key: "at", render: dateTime, width: 180 },
              { title: "What", dataIndex: "action", key: "action", render: (a: string) => <code>{a}</code> },
              {
                title: "Change",
                key: "change",
                render: (_, h) => <HistoryChange before={h.before} after={h.after} />,
              },
              { title: "Reason", dataIndex: "reason", key: "reason" },
              { title: "By", key: "by", render: (_, h) => h.by ?? "Partner / system" },
            ]}
          />
        </>
      )}

      <Modal
        title={action === "suspend" ? "Suspend partner" : "Deactivate partner"}
        open={action !== null}
        onCancel={() => setAction(null)}
        onOk={() => reasonForm.submit()}
        okText={action === "suspend" ? "Suspend" : "Deactivate"}
        okButtonProps={{ danger: true, loading: busy }}
        destroyOnHidden
      >
        <Typography.Paragraph type="secondary">
          {action === "suspend"
            ? "They are logged out at once and can't get jobs until reinstated."
            : "Use when the partner leaves. They are logged out; their history stays."}
        </Typography.Paragraph>
        <Form form={reasonForm} layout="vertical" onFinish={({ reason }) => action && runAction(action, reason)}>
          <Form.Item name="reason" label="Reason" rules={[{ required: true, min: 3, max: 300 }]}>
            <Input.TextArea autoSize={{ minRows: 2 }} placeholder="e.g. Two no-shows this week" />
          </Form.Item>
        </Form>
      </Modal>

      <Drawer
        title="Edit partner"
        open={editing}
        onClose={() => setEditing(false)}
        size={drawerSize}
        destroyOnHidden
        extra={
          <Button type="primary" loading={busy} onClick={() => editForm.submit()}>
            Save
          </Button>
        }
      >
        <Form form={editForm} layout="vertical" onFinish={saveEdit} requiredMark="optional">
          <Form.Item name="role" label="Role" rules={[{ required: true }]} extra="Changing the role changes which documents they need.">
            <Radio.Group
              optionType="button"
              options={[
                { value: "COMPANION", label: "Companion" },
                { value: "NURSE", label: "Nurse" },
              ]}
            />
          </Form.Item>
          <PartnerFields form={editForm} />
        </Form>
      </Drawer>
    </Page>
  );
}

function parse(value: string | null | undefined): Record<string, unknown> {
  if (!value) return {};
  try {
    const data: unknown = JSON.parse(value);
    return data && typeof data === "object" ? (data as Record<string, unknown>) : { value: data };
  } catch {
    return { value };
  }
}

const show = (v: unknown) => (typeof v === "object" && v !== null ? JSON.stringify(v) : String(v));

/** An audit change as "OLD → NEW" status tags, or "field: value" lines for other changes. */
function HistoryChange({ before, after }: { before?: string | null; after?: string | null }) {
  const old = parse(before);
  const now = parse(after);
  if (typeof now.status === "string") {
    return (
      <Space size={4} wrap>
        {typeof old.status === "string" && (
          <>
            <PartnerStatusTag status={old.status} />→
          </>
        )}
        <PartnerStatusTag status={now.status} />
      </Space>
    );
  }
  const keys = [...new Set([...Object.keys(old), ...Object.keys(now)])];
  return (
    <Typography.Text style={{ fontSize: 12 }}>
      {keys.map((k) => (
        <div key={k}>
          {k}: {k in old ? `${show(old[k])} → ` : ""}
          {k in now ? show(now[k]) : "—"}
        </div>
      ))}
    </Typography.Text>
  );
}
