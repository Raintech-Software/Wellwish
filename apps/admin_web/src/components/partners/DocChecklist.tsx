"use client";

import { CheckOutlined, CloseOutlined, EyeOutlined } from "@ant-design/icons";
import { Button, Form, Input, Modal, Space, Table, Tag, Typography } from "antd";
import { useState } from "react";

import type { components } from "@/api/schema";
import { DocStatusTag } from "@/components/partners/StatusTag";
import { dateTime } from "@/lib/format";

type DocState = components["schemas"]["DocStateOut"];
type Doc = components["schemas"]["DocumentOut"];

interface Row {
  key: string;
  label: string;
  required: DocState["required"];
  status: string;
  doc: Doc | null;
  renewal: boolean;
}

/**
 * The partner's documents for their role: one line per required document, plus a line for a
 * renewal waiting for review. View opens it in the viewer; approve/reject when `canReview`.
 */
export default function DocChecklist({
  documents,
  selectedId,
  onSelect,
  canReview,
  onDecide,
}: {
  documents: DocState[];
  selectedId: string | null;
  onSelect: (documentId: string) => void;
  canReview: boolean;
  onDecide: (documentId: string, approve: boolean, reason: string) => Promise<void>;
}) {
  const [rejecting, setRejecting] = useState<Doc | null>(null);
  const [busy, setBusy] = useState<string | null>(null);
  const [form] = Form.useForm<{ reason: string }>();

  const rows: Row[] = documents.flatMap((d) => {
    const main: Row = {
      key: d.required.docType,
      label: d.required.label,
      required: d.required,
      status: d.status,
      doc: d.document ?? null,
      renewal: false,
    };
    return d.replacement
      ? [
          main,
          {
            key: `${d.required.docType}-renewal`,
            label: `${d.required.label} (renewal)`,
            required: d.required,
            status: d.replacement.status,
            doc: d.replacement,
            renewal: true,
          },
        ]
      : [main];
  });

  const decide = async (doc: Doc, approve: boolean, reason = "") => {
    setBusy(doc.id);
    try {
      await onDecide(doc.id, approve, reason);
    } finally {
      setBusy(null);
    }
  };

  return (
    <>
      <Table<Row>
        rowKey="key"
        size="small"
        pagination={false}
        dataSource={rows}
        scroll={{ x: true }}
        rowClassName={(r) => (r.doc && r.doc.id === selectedId ? "ant-table-row-selected" : "")}
        columns={[
          {
            title: "Document",
            key: "label",
            render: (_, r) => (
              <>
                <div style={{ fontWeight: 500 }}>{r.label}</div>
                <Space size={4} wrap>
                  {r.required.mandatory ? <Tag>Required</Tag> : <Tag>Optional</Tag>}
                  {r.required.condition && (
                    <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                      {r.required.condition}
                    </Typography.Text>
                  )}
                </Space>
              </>
            ),
          },
          {
            title: "Status",
            key: "status",
            render: (_, r) => (
              <>
                <DocStatusTag status={r.status} />
                {r.doc?.rejectReason && (
                  <Typography.Paragraph type="danger" style={{ margin: "4px 0 0", fontSize: 12 }}>
                    {r.doc.rejectReason}
                  </Typography.Paragraph>
                )}
              </>
            ),
          },
          {
            title: "Details",
            key: "details",
            render: (_, r) =>
              r.doc ? (
                <Typography.Text style={{ fontSize: 12 }}>
                  {r.doc.numberMasked && <div>No. {r.doc.numberMasked}</div>}
                  {r.doc.expiresOn && <div>Valid till {r.doc.expiresOn}</div>}
                  <div style={{ color: "rgba(0,0,0,.45)" }}>Uploaded {dateTime(r.doc.createdAt)}</div>
                  {r.doc.reviewedBy && <div style={{ color: "rgba(0,0,0,.45)" }}>By {r.doc.reviewedBy}</div>}
                </Typography.Text>
              ) : (
                "—"
              ),
          },
          {
            title: "",
            key: "actions",
            render: (_, r) =>
              r.doc ? (
                <Space wrap>
                  <Button size="small" icon={<EyeOutlined />} onClick={() => onSelect(r.doc!.id)}>
                    View
                  </Button>
                  {canReview && (r.status === "PENDING" || (!r.renewal && r.status !== "EXPIRED")) && (
                    <>
                      <Button
                        size="small"
                        type={r.status === "APPROVED" ? "default" : "primary"}
                        icon={<CheckOutlined />}
                        disabled={r.status === "APPROVED"}
                        loading={busy === r.doc.id}
                        onClick={() => decide(r.doc!, true)}
                      >
                        Approve
                      </Button>
                      <Button
                        size="small"
                        danger
                        icon={<CloseOutlined />}
                        disabled={r.status === "REJECTED"}
                        onClick={() => {
                          form.resetFields();
                          setRejecting(r.doc);
                        }}
                      >
                        Reject
                      </Button>
                    </>
                  )}
                </Space>
              ) : null,
          },
        ]}
      />
      <Modal
        title="Reject document"
        open={rejecting !== null}
        onCancel={() => setRejecting(null)}
        onOk={() => form.submit()}
        okText="Reject"
        okButtonProps={{ danger: true }}
        destroyOnHidden
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={async ({ reason }) => {
            if (rejecting) await decide(rejecting, false, reason);
            setRejecting(null);
          }}
        >
          <Form.Item
            name="reason"
            label="Reason (the partner sees this)"
            rules={[{ required: true, min: 3, max: 300, message: "Write what is wrong, e.g. photo is blurred." }]}
          >
            <Input.TextArea autoSize={{ minRows: 2 }} placeholder="Photo is blurred, please upload a clear one." />
          </Form.Item>
        </Form>
      </Modal>
    </>
  );
}
