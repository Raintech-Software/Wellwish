"use client";

import { PlusOutlined } from "@ant-design/icons";
import {
  Alert,
  App,
  Badge,
  Button,
  Calendar,
  Col,
  DatePicker,
  Form,
  Input,
  Modal,
  Popconfirm,
  Row,
  Select,
  Table,
  Tag,
  Typography,
} from "antd";
import dayjs, { type Dayjs } from "dayjs";
import { useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorMessage, formErrors } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";

type Blocked = components["schemas"]["BlockedTimeOut"];
type Affected = components["schemas"]["AffectedBookingOut"];

interface FormValues {
  range: [Dayjs, Dayjs];
  reason: string;
  serviceType: "ALL" | "COMPANION" | "NURSE";
}

const SERVICE_TYPES = [
  { value: "ALL", label: "All services" },
  { value: "COMPANION", label: "Companion services only" },
  { value: "NURSE", label: "Nurse services only" },
];

const typeLabel = (t: string | null | undefined) =>
  t === "COMPANION" ? "Companion only" : t === "NURSE" ? "Nurse only" : "All services";

function overlapsDay(b: Blocked, day: Dayjs): boolean {
  const start = day.startOf("day");
  const end = start.add(1, "day");
  return dayjs(b.fromTs).isBefore(end) && dayjs(b.toTs).isAfter(start);
}

const fetchBlocked = async () => (await api.GET("/v1/admin/blocked-times")).data;

/** Settings → Blocked dates (§6.17): holidays or full times patients can't pick. */
export default function BlockedTimesPage() {
  const { message, modal } = App.useApp();
  const can = useCan();
  const [editing, setEditing] = useState<Blocked | "new" | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<FormValues>();

  const { data: rows, failed, loading, reload } = useLoad(fetchBlocked, can("settings.manage"));

  const open = (row: Blocked | "new", day?: Dayjs) => {
    setEditing(row);
    form.resetFields();
    if (row === "new") {
      const start = (day ?? dayjs().add(1, "day")).startOf("day");
      form.setFieldsValue({ range: [start, start.add(1, "day")], serviceType: "ALL" });
    } else {
      form.setFieldsValue({
        range: [dayjs(row.fromTs), dayjs(row.toTs)],
        reason: row.reason,
        serviceType: (row.serviceType as "COMPANION" | "NURSE" | null) ?? "ALL",
      });
    }
  };

  const showAffected = (affected: Affected[]) => {
    if (!affected.length) return;
    modal.warning({
      title: `${affected.length} booking(s) fall inside this block`,
      content: (
        <ul style={{ paddingLeft: 18, margin: 0 }}>
          {affected.map((b) => (
            <li key={b.id}>
              {b.code}: {dateTime(b.pickupAt)} ({b.status})
            </li>
          ))}
        </ul>
      ),
      okText: "I'll move them",
    });
  };

  const save = async (values: FormValues) => {
    const body = {
      fromTs: values.range[0].toISOString(),
      toTs: values.range[1].toISOString(),
      reason: values.reason,
      serviceType: values.serviceType === "ALL" ? null : values.serviceType,
    };
    setSaving(true);
    const { data: saved, error } =
      editing === "new"
        ? await api.POST("/v1/admin/blocked-times", { body })
        : await api.PUT("/v1/admin/blocked-times/{blocked_id}", {
            params: { path: { blocked_id: (editing as Blocked).id } },
            body,
          });
    setSaving(false);
    if (!saved) {
      form.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    message.success("Saved. Patients can't pick these times.");
    setEditing(null);
    showAffected(saved.affectedBookings ?? []);
    reload();
  };

  const remove = async (row: Blocked) => {
    const { error } = await api.DELETE("/v1/admin/blocked-times/{blocked_id}", {
      params: { path: { blocked_id: row.id } },
    });
    if (error) message.error(errorMessage(error));
    reload();
  };

  const upcoming = (rows ?? []).filter((b) => dayjs(b.toTs).isAfter(dayjs()));

  return (
    <Page
      title="Blocked dates"
      permission="settings.manage"
      description="Times patients can't book, e.g. a festival or a bandh. Click a day to block it."
      extra={
        <Button type="primary" icon={<PlusOutlined />} onClick={() => open("new")}>
          Block a time
        </Button>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the blocked dates. Reload the page." />}
      <Row gutter={24}>
        <Col xs={24} xl={14}>
          <Calendar
            onSelect={(day, info) => {
              if (info.source === "date") open("new", day);
            }}
            cellRender={(day, info) => {
              if (info.type !== "date") return info.originNode;
              const blocks = (rows ?? []).filter((b) => overlapsDay(b, day));
              return blocks.map((b) => (
                <div key={b.id} style={{ lineHeight: 1.2 }}>
                  <Badge status="error" text={<span style={{ fontSize: 12 }}>{b.reason}</span>} />
                </div>
              ));
            }}
          />
        </Col>
        <Col xs={24} xl={10}>
          <Typography.Title level={5}>Upcoming</Typography.Title>
          <Table
            rowKey="id"
            size="small"
            loading={loading}
            dataSource={upcoming}
            pagination={false}
            scroll={{ x: true }}
            columns={[
              {
                title: "When",
                key: "when",
                render: (_: unknown, b: Blocked) => (
                  <>
                    <div>{dateTime(b.fromTs)}</div>
                    <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                      to {dateTime(b.toTs)}
                    </Typography.Text>
                  </>
                ),
              },
              {
                title: "Reason",
                key: "reason",
                render: (_: unknown, b: Blocked) => (
                  <>
                    <div>{b.reason}</div>
                    <Tag style={{ marginTop: 4 }}>{typeLabel(b.serviceType)}</Tag>
                  </>
                ),
              },
              {
                title: "",
                key: "actions",
                render: (_: unknown, b: Blocked) => (
                  <>
                    <Button size="small" type="link" onClick={() => open(b)}>
                      Edit
                    </Button>
                    <Popconfirm title="Open these times for booking again?" onConfirm={() => remove(b)}>
                      <Button size="small" type="link" danger>
                        Remove
                      </Button>
                    </Popconfirm>
                  </>
                ),
              },
            ]}
          />
        </Col>
      </Row>

      <Modal
        title={editing === "new" ? "Block a time" : "Edit blocked time"}
        open={editing !== null}
        onCancel={() => setEditing(null)}
        onOk={() => form.submit()}
        okText="Save"
        confirmLoading={saving}
        destroyOnHidden
      >
        <Form form={form} layout="vertical" onFinish={save} requiredMark="optional">
          <Form.Item
            name="range"
            label="From – to (India time)"
            rules={[
              { required: true, message: "Pick the start and end." },
              {
                validator: (_, value?: [Dayjs, Dayjs]) =>
                  !value || value[1].isAfter(value[0])
                    ? Promise.resolve()
                    : Promise.reject(new Error("The end must be after the start.")),
              },
            ]}
          >
            <DatePicker.RangePicker
              showTime={{ format: "HH:mm", minuteStep: 15 }}
              format="D MMM YYYY HH:mm"
              style={{ width: "100%" }}
            />
          </Form.Item>
          <Form.Item name="reason" label="Reason" rules={[{ required: true, min: 2, max: 200 }]}>
            <Input placeholder="Diwali, Rath Yatra, bandh…" />
          </Form.Item>
          <Form.Item name="serviceType" label="Applies to">
            <Select options={SERVICE_TYPES} />
          </Form.Item>
        </Form>
      </Modal>
    </Page>
  );
}
