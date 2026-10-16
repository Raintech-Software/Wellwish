"use client";

import { PlusOutlined } from "@ant-design/icons";
import {
  Alert,
  App,
  Button,
  Col,
  Form,
  Input,
  InputNumber,
  Modal,
  Popconfirm,
  Row,
  Segmented,
  Select,
  Space,
  Switch,
  Table,
  Tag,
  Typography,
} from "antd";
import { useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorMessage, formErrors } from "@/lib/errors";
import { useLoad } from "@/lib/useLoad";

type Required = components["schemas"]["RequiredDocumentOut"];
type RequiredIn = components["schemas"]["RequiredDocumentIn"];

const NUMBER_RULES = [
  { value: "NONE", label: "No number" },
  { value: "AADHAAR", label: "Aadhaar (masked, last 4 kept)" },
  { value: "PAN", label: "PAN (masked, last 4 kept)" },
  { value: "TEXT", label: "Licence / registration number" },
];

const fetchRequired = async () => (await api.GET("/v1/admin/required-documents")).data;

/** Partners → Required documents (§6.3, §9.1): what each role must upload. Changes reach the
 * partner app at once (no release needed). */
export default function RequiredDocumentsPage() {
  const { message } = App.useApp();
  const can = useCan();
  const canEdit = can("partners.review");
  const { data, failed, loading, reload } = useLoad(fetchRequired, can("partners.review") || can("partners.add"));
  const [role, setRole] = useState<"COMPANION" | "NURSE">("COMPANION");
  const [editing, setEditing] = useState<Required | "new" | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<RequiredIn>();

  const rows = (data ?? []).filter((r) => r.role === role);

  const open = (row: Required | "new") => {
    setEditing(row);
    form.resetFields();
    if (row === "new") {
      form.setFieldsValue({
        role,
        mandatory: true,
        hasExpiry: false,
        cameraOnly: false,
        isActive: true,
        numberRule: "NONE",
        sort: (rows.at(-1)?.sort ?? 0) + 1,
      });
    } else {
      form.setFieldsValue({ ...row, role: row.role as RequiredIn["role"], numberRule: row.numberRule as RequiredIn["numberRule"] });
    }
  };

  const save = async (values: RequiredIn) => {
    setSaving(true);
    const { data: saved, error } =
      editing === "new"
        ? await api.POST("/v1/admin/required-documents", { body: values })
        : await api.PUT("/v1/admin/required-documents/{required_id}", {
            params: { path: { required_id: (editing as Required).id } },
            body: values,
          });
    setSaving(false);
    if (!saved) {
      form.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    setEditing(null);
    reload();
  };

  const remove = async (row: Required) => {
    const { error } = await api.DELETE("/v1/admin/required-documents/{required_id}", {
      params: { path: { required_id: row.id } },
    });
    if (error) message.error(errorMessage(error));
    reload();
  };

  return (
    <Page
      title="Required documents"
      permission="partners.review"
      description="What each role uploads when registering. Changes show in the partner app at once. A document partners already uploaded can't be deleted: turn it off instead."
      extra={
        canEdit && (
          <Button type="primary" icon={<PlusOutlined />} onClick={() => open("new")}>
            Add document
          </Button>
        )
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the list. Reload the page." />}
      <Segmented
        style={{ marginBottom: 16 }}
        value={role}
        onChange={(v) => setRole(v as typeof role)}
        options={[
          { value: "COMPANION", label: "Companion" },
          { value: "NURSE", label: "Nurse" },
        ]}
      />
      <Table<Required>
        rowKey="id"
        loading={loading}
        dataSource={rows}
        pagination={false}
        scroll={{ x: true }}
        columns={[
          { title: "#", dataIndex: "sort", key: "sort", width: 50 },
          {
            title: "Document",
            key: "label",
            render: (_, r) => (
              <>
                <div style={{ fontWeight: 500 }}>{r.label}</div>
                <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                  {[r.labelHi, r.labelOr].filter(Boolean).join(" · ")} · <code>{r.docType}</code>
                </Typography.Text>
              </>
            ),
          },
          {
            title: "Rules",
            key: "rules",
            render: (_, r) => (
              <Space size={4} wrap>
                {r.mandatory ? <Tag color="blue">Required</Tag> : <Tag>Optional{r.condition ? `: ${r.condition}` : ""}</Tag>}
                {r.hasExpiry && <Tag color="orange">Has expiry</Tag>}
                {r.numberRule !== "NONE" && <Tag>{NUMBER_RULES.find((n) => n.value === r.numberRule)?.label}</Tag>}
                {r.cameraOnly && <Tag>Camera only</Tag>}
              </Space>
            ),
          },
          {
            title: "Status",
            key: "active",
            render: (_, r) => (r.isActive ? <Tag color="success">On</Tag> : <Tag>Off</Tag>),
          },
          ...(canEdit
            ? [
                {
                  title: "",
                  key: "actions",
                  render: (_: unknown, r: Required) => (
                    <Space>
                      <Button size="small" onClick={() => open(r)}>
                        Edit
                      </Button>
                      <Popconfirm title="Delete this document from the list?" okButtonProps={{ danger: true }} onConfirm={() => remove(r)}>
                        <Button size="small" danger>
                          Delete
                        </Button>
                      </Popconfirm>
                    </Space>
                  ),
                },
              ]
            : []),
        ]}
      />
      <Modal
        title={editing === "new" ? "Add required document" : "Edit required document"}
        open={editing !== null}
        onCancel={() => setEditing(null)}
        onOk={() => form.submit()}
        okText="Save"
        confirmLoading={saving}
        destroyOnHidden
        width={640}
      >
        <Form form={form} layout="vertical" onFinish={save} requiredMark="optional">
          <Row gutter={12}>
            <Col span={12}>
              <Form.Item name="role" label="Role" rules={[{ required: true }]}>
                <Select
                  disabled={editing !== "new"}
                  options={[
                    { value: "COMPANION", label: "Companion" },
                    { value: "NURSE", label: "Nurse" },
                  ]}
                />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item
                name="docType"
                label="Code"
                tooltip="Capital letters and _, e.g. FIRST_AID. Can't be changed later."
                rules={[{ required: true, pattern: /^[A-Z][A-Z0-9_]*$/, message: "Like FIRST_AID" }]}
              >
                <Input disabled={editing !== "new"} />
              </Form.Item>
            </Col>
          </Row>
          <Form.Item name="label" label="Name (English)" rules={[{ required: true, min: 2, max: 80 }]}>
            <Input />
          </Form.Item>
          <Row gutter={12}>
            <Col span={12}>
              <Form.Item name="labelHi" label="Name (Hindi)" rules={[{ max: 80 }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="labelOr" label="Name (Odia)" rules={[{ max: 80 }]}>
                <Input />
              </Form.Item>
            </Col>
          </Row>
          <Form.Item name="help" label="Help for the partner" rules={[{ max: 200 }]}>
            <Input />
          </Form.Item>
          <Row gutter={12}>
            <Col span={12}>
              <Form.Item name="helpHi" label="Help (Hindi)" rules={[{ max: 200 }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="helpOr" label="Help (Odia)" rules={[{ max: 200 }]}>
                <Input />
              </Form.Item>
            </Col>
          </Row>
          <Row gutter={12}>
            <Col span={8}>
              <Form.Item name="mandatory" label="Required" valuePropName="checked">
                <Switch />
              </Form.Item>
            </Col>
            <Col span={16}>
              <Form.Item name="condition" label="When it's needed (optional ones)" rules={[{ max: 120 }]}>
                <Input placeholder="If you will drive the patient" />
              </Form.Item>
            </Col>
          </Row>
          <Row gutter={12}>
            <Col span={12}>
              <Form.Item name="conditionHi" label="When it's needed (Hindi)" rules={[{ max: 120 }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="conditionOr" label="When it's needed (Odia)" rules={[{ max: 120 }]}>
                <Input />
              </Form.Item>
            </Col>
          </Row>
          <Row gutter={12}>
            <Col span={8}>
              <Form.Item name="hasExpiry" label="Has an expiry date" valuePropName="checked">
                <Switch />
              </Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item name="cameraOnly" label="Camera only" valuePropName="checked" tooltip="e.g. live selfie">
                <Switch />
              </Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item name="isActive" label="On" valuePropName="checked">
                <Switch />
              </Form.Item>
            </Col>
          </Row>
          <Row gutter={12}>
            <Col span={16}>
              <Form.Item name="numberRule" label="Number on the document" rules={[{ required: true }]}>
                <Select options={NUMBER_RULES} />
              </Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item name="sort" label="Order" rules={[{ required: true }]}>
                <InputNumber min={0} max={1000} style={{ width: "100%" }} />
              </Form.Item>
            </Col>
          </Row>
        </Form>
      </Modal>
    </Page>
  );
}
