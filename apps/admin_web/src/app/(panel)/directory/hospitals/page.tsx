"use client";

import { EnvironmentOutlined, PlusOutlined } from "@ant-design/icons";
import {
  Alert,
  App,
  Button,
  Col,
  Drawer,
  Form,
  Input,
  Popconfirm,
  Row,
  Select,
  Space,
  Table,
  Tag,
  Typography,
} from "antd";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import LocationFields from "@/components/map/LocationFields";
import Page from "@/components/Page";
import PhotoUpload from "@/components/PhotoUpload";
import { errorMessage, formErrors } from "@/lib/errors";
import { useDrawerSize } from "@/lib/useDrawerSize";
import { useLoad } from "@/lib/useLoad";

type Hospital = components["schemas"]["HospitalOut"];
type HospitalIn = components["schemas"]["HospitalIn"];

const HOSPITAL_TYPES = [
  { value: "HOSPITAL", label: "Hospital" },
  { value: "CLINIC", label: "Clinic" },
  { value: "DIAGNOSTIC", label: "Diagnostic centre" },
];

const osmLink = (h: Hospital) =>
  `https://www.openstreetmap.org/?mlat=${h.lat}&mlon=${h.lng}#map=17/${h.lat}/${h.lng}`;

/** Directory → Hospitals (ARCHITECTURE §6.7): address, map pin, OPD hours, departments, photo. */
export default function HospitalsPage() {
  const { message } = App.useApp();
  const can = useCan();
  const canManage = can("directory.manage");
  const [q, setQ] = useState("");
  const [editing, setEditing] = useState<Hospital | "new" | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<HospitalIn>();
  const drawerSize = useDrawerSize(720);

  const fetchHospitals = useCallback(
    async () => (await api.GET("/v1/admin/hospitals", { params: { query: { q } } })).data,
    [q],
  );
  const { data: hospitals, failed, loading, reload } = useLoad(fetchHospitals, can("directory.view"));

  const open = (hospital: Hospital | "new") => {
    setEditing(hospital);
    form.resetFields();
    if (hospital === "new") form.setFieldsValue({ type: "HOSPITAL", city: "Bhubaneswar", departments: [] });
    else form.setFieldsValue({ ...hospital, type: hospital.type as HospitalIn["type"] });
  };

  const save = async (values: HospitalIn) => {
    const body: HospitalIn = { ...values, departments: values.departments ?? [], photoKey: values.photoKey ?? "" };
    setSaving(true);
    const { data: saved, error } =
      editing === "new"
        ? await api.POST("/v1/admin/hospitals", { body })
        : await api.PUT("/v1/admin/hospitals/{hospital_id}", {
            params: { path: { hospital_id: (editing as Hospital).id } },
            body,
          });
    setSaving(false);
    if (!saved) {
      form.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    message.success(editing === "new" ? "Hospital added." : "Hospital saved.");
    setEditing(null);
    reload();
  };

  const setActive = async (h: Hospital, active: boolean) => {
    const path = { params: { path: { hospital_id: h.id } } };
    const { error } = active
      ? await api.POST("/v1/admin/hospitals/{hospital_id}/activate", path)
      : await api.POST("/v1/admin/hospitals/{hospital_id}/deactivate", path);
    if (error) message.error(errorMessage(error));
    reload();
  };

  const remove = async (h: Hospital) => {
    const { error } = await api.DELETE("/v1/admin/hospitals/{hospital_id}", {
      params: { path: { hospital_id: h.id } },
    });
    if (error) message.error(errorMessage(error));
    else message.success("Hospital deleted.");
    reload();
  };

  const columns = [
    {
      title: "Hospital",
      key: "name",
      render: (_: unknown, h: Hospital) => (
        <>
          <div style={{ fontWeight: 500 }}>{h.name}</div>
          <Tag style={{ marginTop: 4 }}>{HOSPITAL_TYPES.find((t) => t.value === h.type)?.label ?? h.type}</Tag>
        </>
      ),
    },
    {
      title: "Address",
      key: "address",
      render: (_: unknown, h: Hospital) => (
        <>
          <div>{h.address}</div>
          <Typography.Link href={osmLink(h)} target="_blank" rel="noreferrer" style={{ fontSize: 12 }}>
            <EnvironmentOutlined /> {h.lat}, {h.lng}
          </Typography.Link>
        </>
      ),
    },
    { title: "OPD hours", dataIndex: "opdHours", key: "opd" },
    { title: "Doctors", dataIndex: "doctorCount", key: "doctors", align: "right" as const },
    {
      title: "Status",
      dataIndex: "isActive",
      key: "status",
      render: (active: boolean) => (active ? <Tag color="success">Active</Tag> : <Tag>Hidden</Tag>),
    },
    ...(canManage
      ? [
          {
            title: "",
            key: "actions",
            render: (_: unknown, h: Hospital) => (
              <Space wrap>
                <Button size="small" onClick={() => open(h)}>
                  Edit
                </Button>
                {h.isActive ? (
                  <Popconfirm title="Hide this hospital from the apps?" onConfirm={() => setActive(h, false)}>
                    <Button size="small">Deactivate</Button>
                  </Popconfirm>
                ) : (
                  <Button size="small" onClick={() => setActive(h, true)}>
                    Activate
                  </Button>
                )}
                <Popconfirm
                  title="Delete this hospital?"
                  description="Only possible if it has no doctors and was never booked."
                  okButtonProps={{ danger: true }}
                  onConfirm={() => remove(h)}
                >
                  <Button size="small" danger>
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
      title="Hospitals"
      permission="directory.view"
      description="Hospitals, clinics and diagnostic centres patients can pick. The pin decides the distance shown in the patient app."
      extra={
        canManage && (
          <Button type="primary" icon={<PlusOutlined />} onClick={() => open("new")}>
            Add hospital
          </Button>
        )
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the hospitals. Reload the page." />}
      <Input.Search
        placeholder="Search name, address or city"
        allowClear
        style={{ maxWidth: 360, marginBottom: 16 }}
        onSearch={(value) => setQ(value.trim())}
      />
      <Table
        rowKey="id"
        loading={loading}
        dataSource={hospitals ?? []}
        columns={columns}
        pagination={{ pageSize: 20, hideOnSinglePage: true }}
        scroll={{ x: true }}
      />

      <Drawer
        title={editing === "new" ? "Add hospital" : "Edit hospital"}
        open={editing !== null}
        onClose={() => setEditing(null)}
        size={drawerSize}
        destroyOnHidden
        extra={
          <Button type="primary" loading={saving} onClick={() => form.submit()}>
            Save
          </Button>
        }
      >
        <Form form={form} layout="vertical" onFinish={save} requiredMark="optional">
          <Row gutter={12}>
            <Col xs={24} sm={16}>
              <Form.Item name="name" label="Name" rules={[{ required: true, min: 2, max: 120 }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col xs={24} sm={8}>
              <Form.Item name="type" label="Type" rules={[{ required: true }]}>
                <Select options={HOSPITAL_TYPES} />
              </Form.Item>
            </Col>
          </Row>
          <Form.Item name="address" label="Address" rules={[{ required: true, min: 5, max: 300 }]}>
            <Input.TextArea autoSize={{ minRows: 2 }} placeholder="Building, street, area, PIN code" />
          </Form.Item>
          <Row gutter={12}>
            <Col xs={24} sm={12}>
              <Form.Item name="city" label="City" rules={[{ max: 60 }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12}>
              <Form.Item name="phone" label="Phone" rules={[{ max: 20 }]}>
                <Input inputMode="tel" />
              </Form.Item>
            </Col>
          </Row>
          <LocationFields form={form} />
          <Form.Item name="opdHours" label="OPD hours" rules={[{ max: 300 }]}>
            <Input placeholder="Mon to Sat 9:00 to 13:00 and 16:00 to 19:00" />
          </Form.Item>
          <Form.Item name="departments" label="Departments" tooltip="Type a name and press Enter.">
            <Select mode="tags" tokenSeparators={[","]} open={false} placeholder="Cardiology, Orthopaedics…" />
          </Form.Item>
          <Form.Item name="photoKey" label="Photo">
            <PhotoUpload
              purpose="hospital_photo"
              currentUrl={editing && editing !== "new" ? editing.photoUrl : null}
            />
          </Form.Item>
        </Form>
      </Drawer>
    </Page>
  );
}
