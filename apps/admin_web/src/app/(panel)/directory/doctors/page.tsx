"use client";

import { PlusOutlined } from "@ant-design/icons";
import {
  Alert,
  App,
  Avatar,
  Button,
  Drawer,
  Flex,
  Form,
  Input,
  Popconfirm,
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
import Page from "@/components/Page";
import PhotoUpload from "@/components/PhotoUpload";
import { errorMessage, formErrors } from "@/lib/errors";
import { useDrawerSize } from "@/lib/useDrawerSize";
import { useLoad } from "@/lib/useLoad";

type Doctor = components["schemas"]["DoctorOut"];
type DoctorIn = components["schemas"]["DoctorIn"];

const LANGUAGES = ["Odia", "Hindi", "English", "Bengali", "Telugu"];

const fetchSpecialities = async () => (await api.GET("/v1/admin/specialities")).data;
const fetchHospitals = async () => (await api.GET("/v1/admin/hospitals")).data;

interface Filters {
  q: string;
  specialityId?: string;
  hospitalId?: string;
}

/** Directory → Doctors (§6.7). Doctors don't log in and can't be booked. */
export default function DoctorsPage() {
  const { message } = App.useApp();
  const can = useCan();
  const canManage = can("directory.manage");
  const [filters, setFilters] = useState<Filters>({ q: "" });
  const [editing, setEditing] = useState<Doctor | "new" | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<DoctorIn>();
  const drawerSize = useDrawerSize();

  const allowed = can("directory.view");
  const fetchDoctors = useCallback(
    async () => (await api.GET("/v1/admin/doctors", { params: { query: filters } })).data,
    [filters],
  );
  const { data: doctors, failed, loading, reload } = useLoad(fetchDoctors, allowed);
  const specialities = useLoad(fetchSpecialities, allowed).data ?? [];
  const hospitals = useLoad(fetchHospitals, allowed).data ?? [];

  const applyFilters = (change: Partial<Filters>) => setFilters({ ...filters, ...change });

  const open = (doctor: Doctor | "new") => {
    setEditing(doctor);
    form.resetFields();
    if (doctor !== "new") {
      form.setFieldsValue({
        ...doctor,
        specialityId: doctor.speciality.id,
        hospitalIds: doctor.hospitals.map((h) => h.id),
      });
    } else {
      form.setFieldsValue({ languages: ["Odia", "English"], hospitalIds: [] });
    }
  };

  const save = async (values: DoctorIn) => {
    const body: DoctorIn = {
      ...values,
      hospitalIds: values.hospitalIds ?? [],
      languages: values.languages ?? [],
      photoKey: values.photoKey ?? "",
    };
    setSaving(true);
    const { data: saved, error } =
      editing === "new"
        ? await api.POST("/v1/admin/doctors", { body })
        : await api.PUT("/v1/admin/doctors/{doctor_id}", {
            params: { path: { doctor_id: (editing as Doctor).id } },
            body,
          });
    setSaving(false);
    if (!saved) {
      form.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    message.success(editing === "new" ? "Doctor added." : "Doctor saved.");
    setEditing(null);
    reload();
  };

  const setActive = async (d: Doctor, active: boolean) => {
    const path = { params: { path: { doctor_id: d.id } } };
    const { error } = active
      ? await api.POST("/v1/admin/doctors/{doctor_id}/activate", path)
      : await api.POST("/v1/admin/doctors/{doctor_id}/deactivate", path);
    if (error) message.error(errorMessage(error));
    reload();
  };

  const remove = async (d: Doctor) => {
    const { error } = await api.DELETE("/v1/admin/doctors/{doctor_id}", {
      params: { path: { doctor_id: d.id } },
    });
    if (error) message.error(errorMessage(error));
    else message.success("Doctor deleted.");
    reload();
  };

  const columns = [
    {
      title: "Doctor",
      key: "name",
      render: (_: unknown, d: Doctor) => (
        <Flex gap={10} align="center">
          <Avatar src={d.photoUrl || undefined}>{d.fullName.replace(/^Dr\.?\s*/i, "").charAt(0)}</Avatar>
          <div>
            <div style={{ fontWeight: 500 }}>{d.fullName}</div>
            <Typography.Text type="secondary" style={{ fontSize: 12 }}>
              {d.qualifications}
            </Typography.Text>
          </div>
        </Flex>
      ),
    },
    { title: "Speciality", key: "speciality", render: (_: unknown, d: Doctor) => d.speciality.name },
    {
      title: "Hospitals",
      key: "hospitals",
      render: (_: unknown, d: Doctor) => d.hospitals.map((h) => <Tag key={h.id}>{h.name}</Tag>),
    },
    { title: "OPD", dataIndex: "opdInfo", key: "opd" },
    { title: "Languages", key: "languages", render: (_: unknown, d: Doctor) => d.languages.join(", ") },
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
            render: (_: unknown, d: Doctor) => (
              <Space wrap>
                <Button size="small" onClick={() => open(d)}>
                  Edit
                </Button>
                {d.isActive ? (
                  <Button size="small" onClick={() => setActive(d, false)}>
                    Deactivate
                  </Button>
                ) : (
                  <Button size="small" onClick={() => setActive(d, true)}>
                    Activate
                  </Button>
                )}
                <Popconfirm
                  title="Delete this doctor?"
                  description="Only possible if no booking names them."
                  okButtonProps={{ danger: true }}
                  onConfirm={() => remove(d)}
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
      title="Doctors"
      permission="directory.view"
      description="Helps patients say whom they're seeing and helps the companion find the right department."
      extra={
        canManage && (
          <Button type="primary" icon={<PlusOutlined />} onClick={() => open("new")} disabled={!specialities.length}>
            Add doctor
          </Button>
        )
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the doctors. Reload the page." />}
      {canManage && !specialities.length && doctors && (
        <Alert
          type="info"
          showIcon
          style={{ marginBottom: 16 }}
          title="Add a speciality first (Directory → Specialities)."
        />
      )}
      <Flex gap={8} wrap style={{ marginBottom: 16 }}>
        <Input.Search
          placeholder="Search by name"
          allowClear
          style={{ width: 260 }}
          onSearch={(q) => applyFilters({ q })}
        />
        <Select
          allowClear
          placeholder="Speciality"
          style={{ width: 200 }}
          options={specialities.map((s) => ({ value: s.id, label: s.name }))}
          onChange={(specialityId?: string) => applyFilters({ specialityId })}
        />
        <Select
          allowClear
          showSearch
          optionFilterProp="label"
          placeholder="Hospital"
          style={{ width: 240 }}
          options={hospitals.map((h) => ({ value: h.id, label: h.name }))}
          onChange={(hospitalId?: string) => applyFilters({ hospitalId })}
        />
      </Flex>
      <Table
        rowKey="id"
        loading={loading}
        dataSource={doctors ?? []}
        columns={columns}
        pagination={{ pageSize: 20, hideOnSinglePage: true }}
        scroll={{ x: true }}
      />

      <Drawer
        title={editing === "new" ? "Add doctor" : "Edit doctor"}
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
          <Form.Item name="fullName" label="Full name" rules={[{ required: true, min: 2, max: 80 }]}>
            <Input placeholder="Dr. …" />
          </Form.Item>
          <Form.Item name="specialityId" label="Speciality" rules={[{ required: true, message: "Choose a speciality." }]}>
            <Select
              showSearch
              optionFilterProp="label"
              options={specialities.map((s) => ({ value: s.id, label: s.name }))}
            />
          </Form.Item>
          <Form.Item name="qualifications" label="Qualifications" rules={[{ max: 200 }]}>
            <Input placeholder="MBBS, MD (Medicine)" />
          </Form.Item>
          <Form.Item name="hospitalIds" label="Hospitals">
            <Select
              mode="multiple"
              showSearch
              optionFilterProp="label"
              options={hospitals.map((h) => ({ value: h.id, label: h.name }))}
            />
          </Form.Item>
          <Form.Item name="opdInfo" label="OPD days and times" rules={[{ max: 300 }]}>
            <Input placeholder="Mon, Wed and Fri 10:00 to 13:00" />
          </Form.Item>
          <Form.Item name="languages" label="Languages">
            <Select mode="tags" options={LANGUAGES.map((l) => ({ value: l, label: l }))} />
          </Form.Item>
          <Form.Item name="photoKey" label="Photo">
            <PhotoUpload purpose="doctor_photo" currentUrl={editing && editing !== "new" ? editing.photoUrl : null} />
          </Form.Item>
        </Form>
      </Drawer>
    </Page>
  );
}
