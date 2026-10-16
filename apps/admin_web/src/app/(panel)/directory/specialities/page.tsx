"use client";

import { PlusOutlined } from "@ant-design/icons";
import { Alert, App, Button, Form, Input, Modal, Popconfirm, Space, Table } from "antd";
import { useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorMessage, formErrors } from "@/lib/errors";
import { useLoad } from "@/lib/useLoad";

type Speciality = components["schemas"]["SpecialityOut"];
type SpecialityIn = components["schemas"]["SpecialityIn"];

const fetchSpecialities = async () => (await api.GET("/v1/admin/specialities")).data;

/** Directory → Specialities: the filter chips in the patient app (§6.7). */
export default function SpecialitiesPage() {
  const { message } = App.useApp();
  const can = useCan();
  const canManage = can("directory.manage");
  const [editing, setEditing] = useState<Speciality | "new" | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<SpecialityIn>();

  const { data: rows, failed, loading, reload } = useLoad(fetchSpecialities, can("directory.view"));

  const open = (row: Speciality | "new") => {
    setEditing(row);
    form.resetFields();
    if (row !== "new") form.setFieldsValue(row);
  };

  const save = async (values: SpecialityIn) => {
    setSaving(true);
    const { data: saved, error } =
      editing === "new"
        ? await api.POST("/v1/admin/specialities", { body: values })
        : await api.PUT("/v1/admin/specialities/{speciality_id}", {
            params: { path: { speciality_id: (editing as Speciality).id } },
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

  const remove = async (row: Speciality) => {
    const { error } = await api.DELETE("/v1/admin/specialities/{speciality_id}", {
      params: { path: { speciality_id: row.id } },
    });
    if (error) message.error(errorMessage(error));
    reload();
  };

  const columns = [
    { title: "Name", dataIndex: "name", key: "name" },
    { title: "Hindi", dataIndex: "nameHi", key: "hi" },
    { title: "Odia", dataIndex: "nameOr", key: "or" },
    { title: "Icon key", dataIndex: "icon", key: "icon" },
    { title: "Doctors", dataIndex: "doctorCount", key: "doctors", align: "right" as const },
    ...(canManage
      ? [
          {
            title: "",
            key: "actions",
            render: (_: unknown, row: Speciality) => (
              <Space>
                <Button size="small" onClick={() => open(row)}>
                  Edit
                </Button>
                <Popconfirm
                  title="Delete this speciality?"
                  description="Only possible when no doctor has it."
                  okButtonProps={{ danger: true }}
                  onConfirm={() => remove(row)}
                >
                  <Button size="small" danger disabled={row.doctorCount > 0}>
                    Delete
                  </Button>
                </Popconfirm>
              </Space>
            ),
          },
        ]
      : []),
  ];

  return (
    <Page
      title="Specialities"
      permission="directory.view"
      description="Used to filter doctors and hospitals in the patient app."
      extra={
        canManage && (
          <Button type="primary" icon={<PlusOutlined />} onClick={() => open("new")}>
            Add speciality
          </Button>
        )
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the specialities. Reload the page." />}
      <Table
        rowKey="id"
        loading={loading}
        dataSource={rows ?? []}
        columns={columns}
        pagination={false}
        scroll={{ x: true }}
      />
      <Modal
        title={editing === "new" ? "Add speciality" : "Edit speciality"}
        open={editing !== null}
        onCancel={() => setEditing(null)}
        onOk={() => form.submit()}
        okText="Save"
        confirmLoading={saving}
        destroyOnHidden
      >
        <Form form={form} layout="vertical" onFinish={save} requiredMark="optional">
          <Form.Item name="name" label="Name (English)" rules={[{ required: true, min: 2, max: 60 }]}>
            <Input />
          </Form.Item>
          <Form.Item name="nameHi" label="Name (Hindi)" rules={[{ max: 60 }]}>
            <Input />
          </Form.Item>
          <Form.Item name="nameOr" label="Name (Odia)" rules={[{ max: 60 }]}>
            <Input />
          </Form.Item>
          <Form.Item name="icon" label="Icon key" tooltip="Which icon the apps show, e.g. heart, bone, eye." rules={[{ max: 40 }]}>
            <Input />
          </Form.Item>
        </Form>
      </Modal>
    </Page>
  );
}
