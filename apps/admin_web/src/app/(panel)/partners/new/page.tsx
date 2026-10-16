"use client";

import { ArrowLeftOutlined } from "@ant-design/icons";
import { App, Button, Card, Checkbox, Col, DatePicker, Form, Input, Radio, Row, Space, Table, Tag, Typography } from "antd";
import type { Dayjs } from "dayjs";
import dayjs from "dayjs";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import FileUpload from "@/components/FileUpload";
import Page from "@/components/Page";
import PartnerFields from "@/components/partners/PartnerFields";
import PhotoUpload from "@/components/PhotoUpload";
import { errorMessage, formErrors } from "@/lib/errors";
import { useLoad } from "@/lib/useLoad";

type Required = components["schemas"]["RequiredDocumentOut"];
type AddIn = components["schemas"]["AddPartnerIn"];

interface DocValues {
  fileKey?: string;
  number?: string;
  expiresOn?: Dayjs;
}

interface Values extends Omit<AddIn, "dob" | "documents"> {
  dob: Dayjs;
  docs: Record<string, DocValues>;
}

const fetchRequired = async () => (await api.GET("/v1/admin/required-documents")).data;

const NUMBER_HINT: Record<string, string> = {
  AADHAAR: "12-digit Aadhaar (only the last 4 are kept)",
  PAN: "10-character PAN (only the last 4 are kept)",
  TEXT: "Number on the document",
};

/** Partners → Add partner (§6.3, §9.4): same form, saved as Approved; the partner gets an SMS. */
export default function AddPartnerPage() {
  const { message } = App.useApp();
  const can = useCan();
  const router = useRouter();
  const [form] = Form.useForm<Values>();
  const [saving, setSaving] = useState(false);
  const role = (Form.useWatch("role", form) as string | undefined) ?? "COMPANION";
  const { data: allRequired } = useLoad(fetchRequired, can("partners.add"));
  const required = (allRequired ?? []).filter((r) => r.role === role && r.isActive);

  const save = async (values: Values) => {
    const documents = required
      .filter((r) => values.docs?.[r.docType]?.fileKey)
      .map((r) => {
        const d = values.docs[r.docType];
        return {
          docType: r.docType,
          fileKey: d.fileKey!,
          number: d.number ?? "",
          expiresOn: d.expiresOn ? d.expiresOn.format("YYYY-MM-DD") : null,
        };
      });
    const { docs: _docs, dob, ...rest } = values;
    void _docs;
    setSaving(true);
    const { data, error } = await api.POST("/v1/admin/partners", {
      body: { ...rest, dob: dob.format("YYYY-MM-DD"), skills: rest.skills ?? [], documents },
    });
    setSaving(false);
    if (!data) {
      form.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    message.success(`${data.fullName} added. They get an SMS with the app link.`);
    router.push(`/partners/${data.id}`);
  };

  return (
    <Page
      title="Add partner"
      permission="partners.add"
      description="For someone recruited in person. Upload and check every document; the partner is saved as Approved and logs in with OTP on the login phone. They verify the alternate phone and email at the first login."
      extra={
        <Link href="/partners">
          <Button icon={<ArrowLeftOutlined />}>Partners</Button>
        </Link>
      }
    >
      <Form
        form={form}
        layout="vertical"
        onFinish={save}
        requiredMark="optional"
        initialValues={{ role: "COMPANION", languages: ["Odia"], skills: [] }}
        style={{ maxWidth: 900 }}
      >
        <Card size="small" title="Role and contact" style={{ marginBottom: 16 }}>
          <Form.Item name="role" label="Role" rules={[{ required: true }]}>
            <Radio.Group
              optionType="button"
              options={[
                { value: "COMPANION", label: "Companion" },
                { value: "NURSE", label: "Nurse" },
              ]}
            />
          </Form.Item>
          <Row gutter={12}>
            <Col xs={24} sm={8}>
              <Form.Item name="phone" label="Login phone" rules={[{ required: true, max: 20 }]}>
                <Input inputMode="tel" placeholder="98765 43210" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={8}>
              <Form.Item
                name="alternatePhone"
                label="Alternate phone"
                dependencies={["phone"]}
                rules={[
                  { required: true, max: 20 },
                  ({ getFieldValue }) => ({
                    validator: (_, v: string) =>
                      !v || v.replace(/\D/g, "").slice(-10) !== String(getFieldValue("phone") ?? "").replace(/\D/g, "").slice(-10)
                        ? Promise.resolve()
                        : Promise.reject(new Error("Must differ from the login phone.")),
                  }),
                ]}
              >
                <Input inputMode="tel" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={8}>
              <Form.Item name="email" label="Email" rules={[{ required: true, type: "email", max: 254 }]}>
                <Input />
              </Form.Item>
            </Col>
          </Row>
        </Card>

        <Card size="small" title="Profile" style={{ marginBottom: 16 }}>
          <Form.Item name="photoKey" label="Profile photo" rules={[{ required: true, message: "Upload a photo." }]}>
            <PhotoUpload purpose="partner_photo" />
          </Form.Item>
          <PartnerFields form={form} />
        </Card>

        <Card size="small" title="Documents" style={{ marginBottom: 16 }}>
          <Table<Required>
            rowKey="docType"
            size="small"
            pagination={false}
            dataSource={required}
            scroll={{ x: true }}
            columns={[
              {
                title: "Document",
                key: "label",
                render: (_, r) => (
                  <>
                    <div style={{ fontWeight: 500 }}>{r.label}</div>
                    <Space size={4}>
                      {r.mandatory ? <Tag color="blue">Required</Tag> : <Tag>Optional</Tag>}
                      {r.condition && (
                        <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                          {r.condition}
                        </Typography.Text>
                      )}
                    </Space>
                  </>
                ),
              },
              {
                title: "File",
                key: "file",
                render: (_, r) => (
                  <Form.Item
                    name={["docs", r.docType, "fileKey"]}
                    style={{ margin: 0 }}
                    rules={r.mandatory ? [{ required: true, message: "Upload it." }] : []}
                  >
                    <FileUpload purpose="kyc_document" />
                  </Form.Item>
                ),
              },
              {
                title: "Number / valid till",
                key: "details",
                render: (_, r) => (
                  <Space orientation="vertical" size={4} style={{ width: 220 }}>
                    {r.numberRule !== "NONE" && (
                      <Form.Item
                        name={["docs", r.docType, "number"]}
                        style={{ margin: 0 }}
                        rules={r.mandatory ? [{ required: true, message: "Enter the number." }] : []}
                      >
                        <Input placeholder={NUMBER_HINT[r.numberRule]} />
                      </Form.Item>
                    )}
                    {r.hasExpiry && (
                      <Form.Item
                        name={["docs", r.docType, "expiresOn"]}
                        style={{ margin: 0 }}
                        rules={r.mandatory ? [{ required: true, message: "Enter the valid-till date." }] : []}
                      >
                        <DatePicker
                          placeholder="Valid till"
                          format="D MMM YYYY"
                          style={{ width: "100%" }}
                          disabledDate={(d) => !d.isAfter(dayjs(), "day")}
                        />
                      </Form.Item>
                    )}
                    {r.numberRule === "NONE" && !r.hasExpiry && "—"}
                  </Space>
                ),
              },
            ]}
          />
        </Card>

        <Form.Item
          name="checked"
          valuePropName="checked"
          rules={[
            {
              validator: (_, v: boolean) =>
                v ? Promise.resolve() : Promise.reject(new Error("Confirm you checked the documents.")),
            },
          ]}
        >
          <Checkbox>I checked every document against the original and the photo matches the person.</Checkbox>
        </Form.Item>
        <Button type="primary" htmlType="submit" loading={saving}>
          Add as approved partner
        </Button>
      </Form>
    </Page>
  );
}
