"use client";

import { ArrowDownOutlined, ArrowUpOutlined, PlusOutlined } from "@ant-design/icons";
import {
  Alert,
  App,
  Button,
  Col,
  Descriptions,
  Drawer,
  Form,
  Input,
  InputNumber,
  Popconfirm,
  Radio,
  Row,
  Segmented,
  Select,
  Space,
  Switch,
  Table,
  Tag,
  Typography,
} from "antd";
import { useCallback, useMemo, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorMessage, formErrors } from "@/lib/errors";
import { minutes, rupees, toPaise, toRupees } from "@/lib/format";
import { useDrawerSize } from "@/lib/useDrawerSize";
import { useLoad } from "@/lib/useLoad";

type Service = components["schemas"]["ServiceOut"];
type ServiceIn = components["schemas"]["ServiceIn"];

const VISIT_TYPES = [
  { value: "HOSPITAL_VISIT", label: "Hospital visit" },
  { value: "HOME_VISIT", label: "Home visit" },
  { value: "ERRAND", label: "Errand" },
];
const visitLabel = (v: string) => VISIT_TYPES.find((t) => t.value === v)?.label ?? v;

interface FormValues extends Omit<ServiceIn, "pricePaise" | "bookingFeePaise"> {
  price: number;
  fee: number;
}

/** Services & prices (ARCHITECTURE §6.6). The balance is always calculated, never typed. */
export default function ServicesPage() {
  const { message } = App.useApp();
  const can = useCan();
  const canManage = can("services.manage");
  const [filter, setFilter] = useState<"ALL" | "COMPANION" | "NURSE">("ALL");
  const [editing, setEditing] = useState<Service | "new" | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<FormValues>();
  const drawerSize = useDrawerSize();
  const price = Form.useWatch("price", form);
  const fee = Form.useWatch("fee", form);

  const fetchServices = useCallback(async () => (await api.GET("/v1/admin/services")).data, []);
  const {
    data: services,
    failed,
    reload: load,
    setData: setServices,
  } = useLoad(fetchServices, can("services.view"));

  const open = (service: Service | "new") => {
    setEditing(service);
    form.resetFields();
    if (service !== "new") {
      form.setFieldsValue({
        ...service,
        partnerType: service.partnerType as ServiceIn["partnerType"],
        visitType: service.visitType as ServiceIn["visitType"],
        price: toRupees(service.pricePaise),
        fee: toRupees(service.bookingFeePaise),
      });
    } else {
      form.setFieldsValue({ partnerType: "COMPANION", visitType: "HOSPITAL_VISIT", durationMin: 120 });
    }
  };

  const save = async (values: FormValues) => {
    const { price: p, fee: f, ...rest } = values;
    const body: ServiceIn = { ...rest, pricePaise: toPaise(p), bookingFeePaise: toPaise(f) };
    setSaving(true);
    const { data: saved, error } =
      editing === "new"
        ? await api.POST("/v1/admin/services", { body })
        : await api.PUT("/v1/admin/services/{service_id}", {
            params: { path: { service_id: (editing as Service).id } },
            body,
          });
    setSaving(false);
    if (!saved) {
      form.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    message.success(editing === "new" ? "Service added." : "Service saved. New prices apply to new bookings only.");
    setEditing(null);
    load();
  };

  const setActive = async (service: Service, active: boolean) => {
    const path = { params: { path: { service_id: service.id } } };
    const { error } = active
      ? await api.POST("/v1/admin/services/{service_id}/activate", path)
      : await api.POST("/v1/admin/services/{service_id}/deactivate", path);
    if (error) message.error(errorMessage(error));
    else message.success(active ? "Shown in the apps again." : "Hidden from the apps.");
    load();
  };

  const remove = async (service: Service) => {
    const { error } = await api.DELETE("/v1/admin/services/{service_id}", {
      params: { path: { service_id: service.id } },
    });
    if (error) message.error(errorMessage(error));
    else message.success("Service deleted.");
    load();
  };

  const move = async (index: number, delta: number) => {
    if (!services) return;
    const ids = services.map((s) => s.id);
    const [moved] = ids.splice(index, 1);
    ids.splice(index + delta, 0, moved);
    setServices(ids.map((id) => services.find((s) => s.id === id)!));
    const { error } = await api.POST("/v1/admin/services/reorder", { body: { ids } });
    if (error) message.error(errorMessage(error));
    load();
  };

  const shown = useMemo(
    () => (services ?? []).filter((s) => filter === "ALL" || s.partnerType === filter),
    [services, filter],
  );

  const columns = [
    ...(canManage && filter === "ALL"
      ? [
          {
            title: "Order",
            key: "order",
            width: 90,
            render: (_: unknown, __: Service, index: number) => (
              <Space size={2}>
                <Button
                  size="small"
                  type="text"
                  icon={<ArrowUpOutlined />}
                  disabled={index === 0}
                  onClick={() => move(index, -1)}
                  aria-label="Move up"
                />
                <Button
                  size="small"
                  type="text"
                  icon={<ArrowDownOutlined />}
                  disabled={index === shown.length - 1}
                  onClick={() => move(index, 1)}
                  aria-label="Move down"
                />
              </Space>
            ),
          },
        ]
      : []),
    {
      title: "Service",
      key: "name",
      render: (_: unknown, s: Service) => (
        <>
          <div style={{ fontWeight: 500 }}>{s.name}</div>
          <Typography.Text type="secondary" style={{ fontSize: 12 }}>
            {[s.nameHi, s.nameOr].filter(Boolean).join(" · ")}
          </Typography.Text>
        </>
      ),
    },
    {
      title: "Type",
      key: "type",
      render: (_: unknown, s: Service) => (
        <Space orientation="vertical" size={2}>
          <Tag color={s.partnerType === "NURSE" ? "green" : "blue"}>
            {s.partnerType === "NURSE" ? "Nurse" : "Companion"}
          </Tag>
          <Typography.Text type="secondary" style={{ fontSize: 12 }}>
            {visitLabel(s.visitType)}
          </Typography.Text>
        </Space>
      ),
    },
    { title: "Total", dataIndex: "pricePaise", key: "price", render: rupees, align: "right" as const },
    {
      title: "Booking fee (online)",
      dataIndex: "bookingFeePaise",
      key: "fee",
      render: rupees,
      align: "right" as const,
    },
    {
      title: "Balance (to partner)",
      dataIndex: "balancePaise",
      key: "balance",
      render: rupees,
      align: "right" as const,
    },
    { title: "Duration", dataIndex: "durationMin", key: "duration", render: minutes },
    {
      title: "Documents",
      dataIndex: "docsRequired",
      key: "docs",
      render: (required: boolean) => (required ? <Tag color="orange">Required</Tag> : "Optional"),
    },
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
            render: (_: unknown, s: Service) => (
              <Space wrap>
                <Button size="small" onClick={() => open(s)}>
                  Edit
                </Button>
                {s.isActive ? (
                  <Popconfirm
                    title="Hide this service from the apps?"
                    description="Existing bookings keep it."
                    onConfirm={() => setActive(s, false)}
                  >
                    <Button size="small">Deactivate</Button>
                  </Popconfirm>
                ) : (
                  <Button size="small" onClick={() => setActive(s, true)}>
                    Activate
                  </Button>
                )}
                <Popconfirm
                  title="Delete this service?"
                  description="Only possible if it was never booked."
                  okButtonProps={{ danger: true }}
                  onConfirm={() => remove(s)}
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

  const balance = typeof price === "number" && typeof fee === "number" ? toPaise(price) - toPaise(fee) : null;

  return (
    <Page
      title="Services & prices"
      permission="services.view"
      description="The patient pays the booking fee online when booking; the balance is paid to the partner after the visit. Price changes apply to new bookings only and are kept in the audit log."
      extra={
        canManage && (
          <Button type="primary" icon={<PlusOutlined />} onClick={() => open("new")}>
            Add service
          </Button>
        )
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the services. Reload the page." />}
      <Segmented
        style={{ marginBottom: 16 }}
        value={filter}
        onChange={(v) => setFilter(v as typeof filter)}
        options={[
          { value: "ALL", label: "All" },
          { value: "COMPANION", label: "Companion" },
          { value: "NURSE", label: "Nurse" },
        ]}
      />
      <Table
        rowKey="id"
        loading={!services && !failed}
        dataSource={shown}
        columns={columns}
        pagination={false}
        scroll={{ x: true }}
      />

      <Drawer
        title={editing === "new" ? "Add service" : "Edit service"}
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
          <Form.Item name="name" label="Name (English)" rules={[{ required: true, min: 2, max: 80 }]}>
            <Input />
          </Form.Item>
          <Row gutter={12}>
            <Col xs={24} sm={12}>
              <Form.Item name="nameHi" label="Name (Hindi)" rules={[{ max: 80 }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12}>
              <Form.Item name="nameOr" label="Name (Odia)" rules={[{ max: 80 }]}>
                <Input />
              </Form.Item>
            </Col>
          </Row>
          <Form.Item name="description" label="Short description (English)" rules={[{ max: 160 }]}>
            <Input.TextArea autoSize={{ minRows: 2 }} />
          </Form.Item>
          <Row gutter={12}>
            <Col xs={24} sm={12}>
              <Form.Item name="descriptionHi" label="Description (Hindi)" rules={[{ max: 160 }]}>
                <Input.TextArea autoSize={{ minRows: 2 }} />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12}>
              <Form.Item name="descriptionOr" label="Description (Odia)" rules={[{ max: 160 }]}>
                <Input.TextArea autoSize={{ minRows: 2 }} />
              </Form.Item>
            </Col>
          </Row>
          <Row gutter={12}>
            <Col xs={24} sm={12}>
              <Form.Item name="partnerType" label="Done by" rules={[{ required: true }]}>
                <Radio.Group
                  optionType="button"
                  options={[
                    { value: "COMPANION", label: "Companion" },
                    { value: "NURSE", label: "Nurse" },
                  ]}
                />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12}>
              <Form.Item
                name="visitType"
                label="Visit type"
                rules={[{ required: true }]}
                tooltip="Decides the job steps and the booking form."
              >
                <Select options={VISIT_TYPES} />
              </Form.Item>
            </Col>
          </Row>
          <Row gutter={12}>
            <Col xs={24} sm={12}>
              <Form.Item name="price" label="Total price" rules={[{ required: true, message: "Enter the price." }]}>
                <InputNumber prefix="₹" min={1} max={100000} precision={2} style={{ width: "100%" }} />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12}>
              <Form.Item
                name="fee"
                label="Booking fee (paid online)"
                dependencies={["price"]}
                rules={[
                  { required: true, message: "Enter the booking fee." },
                  ({ getFieldValue }) => ({
                    validator: (_, value: number) =>
                      value === undefined || value <= (getFieldValue("price") ?? 0)
                        ? Promise.resolve()
                        : Promise.reject(new Error("Can't be more than the total price.")),
                  }),
                ]}
              >
                <InputNumber prefix="₹" min={0} max={100000} precision={2} style={{ width: "100%" }} />
              </Form.Item>
            </Col>
          </Row>
          <Descriptions
            size="small"
            bordered
            column={1}
            style={{ marginBottom: 24 }}
            items={[
              {
                key: "balance",
                label: "Balance (paid to the partner after the visit)",
                children: balance !== null && balance >= 0 ? rupees(balance) : "—",
              },
            ]}
          />
          <Row gutter={12}>
            <Col xs={24} sm={12}>
              <Form.Item
                name="durationMin"
                label="Expected duration (minutes)"
                rules={[{ required: true }]}
                tooltip="Blocks the partner's time."
              >
                <InputNumber min={15} max={1440} step={15} style={{ width: "100%" }} />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12}>
              <Form.Item
                name="docsRequired"
                label="Documents required"
                valuePropName="checked"
                tooltip="e.g. a prescription for injections and IV"
              >
                <Switch />
              </Form.Item>
            </Col>
          </Row>
        </Form>
      </Drawer>
    </Page>
  );
}
