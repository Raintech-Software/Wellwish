"use client";

import { EnvironmentOutlined, PlusOutlined } from "@ant-design/icons";
import { Alert, App, Button, Col, Drawer, Form, Input, InputNumber, Popconfirm, Row, Space, Table, Tag, Typography } from "antd";
import { useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import LocationFields from "@/components/map/LocationFields";
import Page from "@/components/Page";
import { errorMessage, formErrors } from "@/lib/errors";
import { useDrawerSize } from "@/lib/useDrawerSize";
import { useLoad } from "@/lib/useLoad";

type Area = components["schemas"]["ServiceAreaOut"];

interface FormValues {
  city: string;
  name: string;
  lat: string;
  lng: string;
  radiusKm: number;
}

const fetchAreas = async () => (await api.GET("/v1/admin/service-areas")).data;

/** Settings → Service areas (§6.17): bookings are only taken inside an active circle. */
export default function ServiceAreasPage() {
  const { message } = App.useApp();
  const can = useCan();
  const [editing, setEditing] = useState<Area | "new" | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<FormValues>();
  const drawerSize = useDrawerSize(720);

  const { data: areas, failed, loading, reload } = useLoad(fetchAreas, can("settings.manage"));

  const open = (area: Area | "new") => {
    setEditing(area);
    form.resetFields();
    if (area === "new") form.setFieldsValue({ radiusKm: 15 });
    else form.setFieldsValue({ ...area, radiusKm: Number(area.radiusKm) });
  };

  const save = async (values: FormValues) => {
    const body = { ...values, radiusKm: values.radiusKm.toFixed(1) };
    setSaving(true);
    const { data: saved, error } =
      editing === "new"
        ? await api.POST("/v1/admin/service-areas", { body })
        : await api.PUT("/v1/admin/service-areas/{area_id}", {
            params: { path: { area_id: (editing as Area).id } },
            body,
          });
    setSaving(false);
    if (!saved) {
      form.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    message.success("Service area saved.");
    setEditing(null);
    reload();
  };

  const setActive = async (area: Area, active: boolean) => {
    const path = { params: { path: { area_id: area.id } } };
    const { error } = active
      ? await api.POST("/v1/admin/service-areas/{area_id}/activate", path)
      : await api.POST("/v1/admin/service-areas/{area_id}/deactivate", path);
    if (error) message.error(errorMessage(error));
    reload();
  };

  const remove = async (area: Area) => {
    const { error } = await api.DELETE("/v1/admin/service-areas/{area_id}", {
      params: { path: { area_id: area.id } },
    });
    if (error) message.error(errorMessage(error));
    reload();
  };

  const activeCount = (areas ?? []).filter((a) => a.isActive).length;

  const columns = [
    { title: "City", dataIndex: "city", key: "city" },
    { title: "Name", dataIndex: "name", key: "name" },
    {
      title: "Centre",
      key: "centre",
      render: (_: unknown, a: Area) => (
        <Typography.Link
          href={`https://www.openstreetmap.org/?mlat=${a.lat}&mlon=${a.lng}#map=11/${a.lat}/${a.lng}`}
          target="_blank"
          rel="noreferrer"
        >
          <EnvironmentOutlined /> {a.lat}, {a.lng}
        </Typography.Link>
      ),
    },
    { title: "Radius", dataIndex: "radiusKm", key: "radius", render: (km: string) => `${km} km` },
    {
      title: "Status",
      dataIndex: "isActive",
      key: "status",
      render: (active: boolean) => (active ? <Tag color="success">Active</Tag> : <Tag>Off</Tag>),
    },
    {
      title: "",
      key: "actions",
      render: (_: unknown, a: Area) => (
        <Space wrap>
          <Button size="small" onClick={() => open(a)}>
            Edit
          </Button>
          {a.isActive ? (
            <Popconfirm title="Stop taking bookings in this area?" onConfirm={() => setActive(a, false)}>
              <Button size="small">Turn off</Button>
            </Popconfirm>
          ) : (
            <Button size="small" onClick={() => setActive(a, true)}>
              Turn on
            </Button>
          )}
          <Popconfirm title="Delete this service area?" okButtonProps={{ danger: true }} onConfirm={() => remove(a)}>
            <Button size="small" danger>
              Delete
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <Page
      title="Service areas"
      permission="settings.manage"
      description="Patients can only book for addresses inside an active area (a circle around a centre point)."
      extra={
        <Button type="primary" icon={<PlusOutlined />} onClick={() => open("new")}>
          Add area
        </Button>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the service areas. Reload the page." />}
      {areas && activeCount === 0 && (
        <Alert
          type="warning"
          showIcon
          style={{ marginBottom: 16 }}
          title="No active service area: patients won't be able to book anywhere."
        />
      )}
      <Table
        rowKey="id"
        loading={loading}
        dataSource={areas ?? []}
        columns={columns}
        pagination={false}
        scroll={{ x: true }}
      />

      <Drawer
        title={editing === "new" ? "Add service area" : "Edit service area"}
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
            <Col xs={24} sm={8}>
              <Form.Item name="city" label="City" rules={[{ required: true, min: 2, max: 60 }]}>
                <Input placeholder="Bhubaneswar" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={10}>
              <Form.Item name="name" label="Area name" rules={[{ required: true, min: 2, max: 80 }]}>
                <Input placeholder="Bhubaneswar city" />
              </Form.Item>
            </Col>
            <Col xs={24} sm={6}>
              <Form.Item name="radiusKm" label="Radius" rules={[{ required: true }]}>
                <InputNumber min={0.5} max={200} step={0.5} precision={1} suffix="km" style={{ width: "100%" }} />
              </Form.Item>
            </Col>
          </Row>
          <LocationFields form={form} radiusField="radiusKm" />
        </Form>
      </Drawer>
    </Page>
  );
}
