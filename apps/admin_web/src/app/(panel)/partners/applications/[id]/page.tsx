"use client";

import { ArrowLeftOutlined, LockOutlined } from "@ant-design/icons";
import { Alert, App, Button, Card, Col, Form, Input, Modal, Popconfirm, Row, Space, Spin, Typography } from "antd";
import Link from "next/link";
import { useParams } from "next/navigation";
import { useCallback, useEffect, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import DocChecklist from "@/components/partners/DocChecklist";
import DocumentViewer from "@/components/partners/DocumentViewer";
import PartnerSummary from "@/components/partners/PartnerSummary";
import { errorCode, errorMessage } from "@/lib/errors";
import { dateTime } from "@/lib/format";

type Detail = components["schemas"]["ApplicationDetailOut"];

type Decision = "changes" | "reject" | null;

/**
 * Review one application (§9.4). Opening it claims it for 30 minutes; documents on the left,
 * the selected one on the right. Then approve, request changes or reject.
 */
export default function ReviewPage() {
  const { id } = useParams<{ id: string }>();
  const { message } = App.useApp();
  const can = useCan();
  const [detail, setDetail] = useState<Detail | null>(null);
  const [blocked, setBlocked] = useState<string | null>(null);
  const [selected, setSelected] = useState<string | null>(null);
  const [deciding, setDeciding] = useState<Decision>(null);
  const [busy, setBusy] = useState(false);
  const [form] = Form.useForm<{ text: string }>();

  const reload = useCallback(async () => {
    const { data } = await api.GET("/v1/admin/applications/{application_id}", {
      params: { path: { application_id: id } },
    });
    if (data) setDetail(data);
  }, [id]);

  // Opening the page claims the application (locks it to you for 30 minutes).
  useEffect(() => {
    if (!can("partners.review")) return;
    let current = true;
    void api
      .POST("/v1/admin/applications/{application_id}/claim", { params: { path: { application_id: id } } })
      .then(async ({ data, error }) => {
        if (!current) return;
        if (data) {
          setDetail(data);
          return;
        }
        setBlocked(errorCode(error) === "ALREADY_DECIDED" ? null : errorMessage(error));
        const view = await api.GET("/v1/admin/applications/{application_id}", {
          params: { path: { application_id: id } },
        });
        if (current && view.data) setDetail(view.data);
      });
    return () => {
      current = false;
    };
  }, [can, id]);

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
    await reload();
  };

  const finish = async (kind: "approve" | Decision, text = "") => {
    setBusy(true);
    const path = { params: { path: { application_id: id } } };
    const { data, error } =
      kind === "approve"
        ? await api.POST("/v1/admin/applications/{application_id}/approve", path)
        : kind === "changes"
          ? await api.POST("/v1/admin/applications/{application_id}/request-changes", { ...path, body: { note: text } })
          : await api.POST("/v1/admin/applications/{application_id}/reject", { ...path, body: { reason: text } });
    setBusy(false);
    if (!data) {
      message.error(errorMessage(error));
      return;
    }
    setDetail(data);
    setDeciding(null);
    message.success(
      kind === "approve"
        ? "Approved. The partner gets a push, SMS and email."
        : kind === "changes"
          ? "Sent back to the partner with the reasons."
          : "Application rejected.",
    );
  };

  const release = async () => {
    await api.POST("/v1/admin/applications/{application_id}/release", { params: { path: { application_id: id } } });
    await reload();
  };

  const app = detail?.application;
  const open = app && ["SUBMITTED", "UNDER_REVIEW"].includes(app.status);
  const mine = !!detail?.claimedByMe;

  return (
    <Page
      title={detail ? `Review: ${detail.partner.fullName}` : "Review application"}
      permission="partners.review"
      extra={
        <Link href="/partners/applications">
          <Button icon={<ArrowLeftOutlined />}>Applications</Button>
        </Link>
      }
    >
      {!detail ? (
        <Spin />
      ) : (
        <>
          {blocked && <Alert type="warning" showIcon style={{ marginBottom: 16 }} title={blocked} />}
          {open && mine && app?.claimedUntil && (
            <Alert
              type="info"
              showIcon
              icon={<LockOutlined />}
              style={{ marginBottom: 16 }}
              title={`Locked to you until ${dateTime(app.claimedUntil)}. Other admins can't review it meanwhile.`}
              action={
                <Button size="small" onClick={release}>
                  Release
                </Button>
              }
            />
          )}
          {!open && app && (
            <Alert
              type={app.status === "APPROVED" ? "success" : app.status === "REJECTED" ? "error" : "warning"}
              showIcon
              style={{ marginBottom: 16 }}
              title={`Decided: ${app.status.replace("_", " ").toLowerCase()} by ${app.decidedBy ?? "—"} on ${dateTime(app.decidedAt)}`}
              description={app.notes || undefined}
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
                canReview={!!open && mine}
                onDecide={decideDocument}
              />
            </Col>
            <Col xs={24} xl={11}>
              <div style={{ position: "sticky", top: 16 }}>
                <DocumentViewer documentId={selected} />
              </div>
            </Col>
          </Row>
          {open && mine && (
            <Card size="small" style={{ marginTop: 24 }}>
              <Space wrap>
                {/* an "are you sure" step like reject and request changes have (PHASES 9.11) */}
                <Popconfirm
                  title="Approve this partner?"
                  description="They can switch on Available and get bookings at once. They get a push, SMS and email."
                  okText="Approve"
                  cancelText="Not yet"
                  onConfirm={() => finish("approve")}
                  disabled={!detail.canApprove}
                >
                  <Button type="primary" disabled={!detail.canApprove} loading={busy}>
                    Approve partner
                  </Button>
                </Popconfirm>
                <Button
                  onClick={() => {
                    form.resetFields();
                    setDeciding("changes");
                  }}
                >
                  Request changes
                </Button>
                <Button
                  danger
                  onClick={() => {
                    form.resetFields();
                    setDeciding("reject");
                  }}
                >
                  Reject application
                </Button>
                {!detail.canApprove && (
                  <Typography.Text type="secondary">
                    {detail.missingDocuments.length
                      ? `Approve every required document first (${detail.missingDocuments.length} left).`
                      : "Decide the documents still waiting."}
                  </Typography.Text>
                )}
              </Space>
            </Card>
          )}
          <Modal
            title={deciding === "reject" ? "Reject application (final)" : "Request changes"}
            open={deciding !== null}
            onCancel={() => setDeciding(null)}
            onOk={() => form.submit()}
            okText={deciding === "reject" ? "Reject" : "Send to partner"}
            okButtonProps={{ danger: deciding === "reject", loading: busy }}
            destroyOnHidden
          >
            <Form form={form} layout="vertical" onFinish={({ text }) => finish(deciding, text ?? "")}>
              <Form.Item
                name="text"
                label={deciding === "reject" ? "Reason (the partner sees this)" : "Note to the partner (optional when documents are rejected)"}
                rules={deciding === "reject" ? [{ required: true, min: 3, message: "Write the reason." }] : [{ max: 1000 }]}
              >
                <Input.TextArea autoSize={{ minRows: 3 }} />
              </Form.Item>
            </Form>
          </Modal>
        </>
      )}
    </Page>
  );
}
