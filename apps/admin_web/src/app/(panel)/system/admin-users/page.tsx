"use client";

import { DownOutlined, PlusOutlined } from "@ant-design/icons";
import {
  Alert,
  App,
  Button,
  Dropdown,
  Form,
  Input,
  Modal,
  Select,
  Space,
  Table,
  Tag,
  Typography,
} from "antd";
import type { MenuProps } from "antd";
import { useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { errorMessage, formErrors } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { useLoad } from "@/lib/useLoad";

type StaffUser = components["schemas"]["StaffUserOut"];

interface AddValues {
  name: string;
  email: string;
  role: string;
  password: string;
}

const fetchUsers = async () => (await api.GET("/v1/admin/staff-users")).data;
const fetchRoles = async () => (await api.GET("/v1/admin/roles")).data?.roles;

/** A random 16-character password (letters, digits) the Super Admin hands over in person. */
function generatePassword(): string {
  const chars = "abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  const bytes = crypto.getRandomValues(new Uint8Array(16));
  return Array.from(bytes, (b) => chars[b % chars.length]).join("");
}

function PasswordField() {
  return (
    <Form.Item
      label="Password"
      required
      extra="At least 12 characters. Give it to them in person; they add their authenticator at the first sign-in."
    >
      <Space.Compact style={{ width: "100%" }}>
        <Form.Item name="password" noStyle rules={[{ required: true, min: 12, max: 256, message: "At least 12 characters." }]}>
          <Input.Password autoComplete="new-password" />
        </Form.Item>
        <Form.Item noStyle shouldUpdate>
          {({ setFieldValue }) => (
            <Button onClick={() => setFieldValue("password", generatePassword())}>Generate</Button>
          )}
        </Form.Item>
      </Space.Compact>
    </Form.Item>
  );
}

/** System → Admin users (§9.1, §9.2): every admin has their own login; a Super Admin gives
 * each one a role. Staff are disabled, never deleted (the audit log points to them). */
export default function AdminUsersPage() {
  const { message, modal } = App.useApp();
  const can = useCan();
  const [adding, setAdding] = useState(false);
  const [editing, setEditing] = useState<StaffUser | null>(null);
  const [passwordFor, setPasswordFor] = useState<StaffUser | null>(null);
  const [saving, setSaving] = useState(false);
  const [addForm] = Form.useForm<AddValues>();
  const [editForm] = Form.useForm<{ name: string; role: string }>();
  const [passwordForm] = Form.useForm<{ password: string }>();

  const allowed = can("staff.manage");
  const { data: users, failed, loading, reload } = useLoad(fetchUsers, allowed);
  const roles = useLoad(fetchRoles, allowed).data ?? [];

  const roleOptions = roles.map((r) => ({ value: r.code, label: r.name }));

  const add = async (values: AddValues) => {
    setSaving(true);
    const { data, error } = await api.POST("/v1/admin/staff-users", { body: values });
    setSaving(false);
    if (!data) {
      addForm.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    message.success(`${data.name} added. They set up 2FA at their first sign-in.`);
    setAdding(false);
    reload();
  };

  const update = async (values: { name: string; role: string }) => {
    if (!editing) return;
    setSaving(true);
    const { data, error } = await api.PUT("/v1/admin/staff-users/{staff_id}", {
      params: { path: { staff_id: editing.id } },
      body: values,
    });
    setSaving(false);
    if (!data) {
      editForm.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    message.success("Saved. A new role applies from their next click.");
    setEditing(null);
    reload();
  };

  const setPassword = async (values: { password: string }) => {
    if (!passwordFor) return;
    setSaving(true);
    const { data, error } = await api.POST("/v1/admin/staff-users/{staff_id}/password", {
      params: { path: { staff_id: passwordFor.id } },
      body: values,
    });
    setSaving(false);
    if (!data) {
      passwordForm.setFields(formErrors(error));
      message.error(errorMessage(error));
      return;
    }
    message.success("New password set. They were signed out everywhere.");
    setPasswordFor(null);
    reload();
  };

  /** Confirm, call, report, reload. */
  const act = (title: string, content: string, call: () => Promise<{ error?: unknown }>, done: string) =>
    modal.confirm({
      title,
      content,
      okText: "Yes",
      onOk: async () => {
        const { error } = await call();
        if (error) message.error(errorMessage(error));
        else message.success(done);
        reload();
      },
    });

  const menuFor = (u: StaffUser): MenuProps["items"] => {
    const path = { params: { path: { staff_id: u.id } } };
    return [
      { key: "edit", label: "Edit name or role", onClick: () => {
        setEditing(u);
        editForm.setFieldsValue({ name: u.name, role: u.role.code });
      } },
      { key: "password", label: "Set a new password", onClick: () => {
        setPasswordFor(u);
        passwordForm.resetFields();
      } },
      {
        key: "2fa",
        label: "Reset 2FA (lost phone)",
        onClick: () =>
          act(
            `Reset 2FA for ${u.name}?`,
            "They are signed out and scan a new QR code at their next sign-in.",
            () => api.POST("/v1/admin/staff-users/{staff_id}/reset-2fa", path),
            "2FA reset.",
          ),
      },
      {
        key: "logout",
        label: "Sign out everywhere",
        disabled: u.activeSessions === 0,
        onClick: () =>
          act(
            `Sign ${u.name} out everywhere?`,
            "Every open session of this admin ends now.",
            () => api.POST("/v1/admin/staff-users/{staff_id}/logout", path),
            "Signed out.",
          ),
      },
      { type: "divider" },
      u.status === "ACTIVE"
        ? {
            key: "disable",
            label: "Disable",
            danger: true,
            disabled: u.isYou,
            onClick: () =>
              act(
                `Disable ${u.name}?`,
                "They are signed out at once and can't sign in. Their history stays in the audit log.",
                () => api.POST("/v1/admin/staff-users/{staff_id}/disable", path),
                "Disabled.",
              ),
          }
        : {
            key: "enable",
            label: "Enable again",
            onClick: () =>
              act(
                `Enable ${u.name}?`,
                "They can sign in again.",
                () => api.POST("/v1/admin/staff-users/{staff_id}/enable", path),
                "Enabled.",
              ),
          },
    ];
  };

  const columns = [
    {
      title: "Name",
      key: "name",
      render: (_: unknown, u: StaffUser) => (
        <>
          <div style={{ fontWeight: 500 }}>
            {u.name} {u.isYou && <Tag color="blue">You</Tag>}
          </div>
          <Typography.Text type="secondary" style={{ fontSize: 12 }}>
            {u.email}
          </Typography.Text>
        </>
      ),
    },
    { title: "Role", key: "role", render: (_: unknown, u: StaffUser) => <Tag>{u.role.name}</Tag> },
    {
      title: "Status",
      key: "status",
      render: (_: unknown, u: StaffUser) =>
        u.status === "ACTIVE" ? <Tag color="success">Active</Tag> : <Tag color="error">Disabled</Tag>,
    },
    {
      title: "2FA",
      key: "2fa",
      render: (_: unknown, u: StaffUser) =>
        u.twoFactorSet ? <Tag color="success">Set up</Tag> : <Tag color="warning">At first sign-in</Tag>,
    },
    { title: "Last sign-in", dataIndex: "lastLoginAt", key: "last", render: dateTime },
    { title: "Open sessions", dataIndex: "activeSessions", key: "sessions", align: "right" as const },
    {
      title: "",
      key: "actions",
      render: (_: unknown, u: StaffUser) => (
        <Dropdown menu={{ items: menuFor(u) }} trigger={["click"]}>
          <Button size="small">
            Actions <DownOutlined />
          </Button>
        </Dropdown>
      ),
    },
  ];

  return (
    <Page
      title="Admin users"
      permission="staff.manage"
      description="Each admin signs in with their own email, password and authenticator app, so the audit log shows who did what. Never share a login."
      extra={
        <Button
          type="primary"
          icon={<PlusOutlined />}
          onClick={() => {
            addForm.resetFields();
            addForm.setFieldsValue({ role: "OPERATIONS" });
            setAdding(true);
          }}
        >
          Add admin
        </Button>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the admin users. Reload the page." />}
      <Table
        rowKey="id"
        loading={loading}
        dataSource={users ?? []}
        columns={columns}
        pagination={false}
        scroll={{ x: true }}
      />

      <Modal
        title="Add admin"
        open={adding}
        onCancel={() => setAdding(false)}
        onOk={() => addForm.submit()}
        okText="Add"
        confirmLoading={saving}
        destroyOnHidden
      >
        <Form form={addForm} layout="vertical" onFinish={add} requiredMark="optional">
          <Form.Item name="name" label="Name" rules={[{ required: true, min: 2, max: 80 }]}>
            <Input />
          </Form.Item>
          <Form.Item name="email" label="Email" rules={[{ required: true, type: "email", max: 254 }]}>
            <Input autoComplete="off" />
          </Form.Item>
          <Form.Item name="role" label="Role" rules={[{ required: true }]} extra="See System → Roles for what each role can do.">
            <Select options={roleOptions} />
          </Form.Item>
          <PasswordField />
        </Form>
      </Modal>

      <Modal
        title={`Edit ${editing?.name ?? ""}`}
        open={editing !== null}
        onCancel={() => setEditing(null)}
        onOk={() => editForm.submit()}
        okText="Save"
        confirmLoading={saving}
        destroyOnHidden
      >
        <Form form={editForm} layout="vertical" onFinish={update} requiredMark="optional">
          <Form.Item name="name" label="Name" rules={[{ required: true, min: 2, max: 80 }]}>
            <Input />
          </Form.Item>
          <Form.Item
            name="role"
            label="Role"
            rules={[{ required: true }]}
            extra={editing?.isYou ? "You can't change your own role." : undefined}
          >
            <Select options={roleOptions} disabled={editing?.isYou} />
          </Form.Item>
        </Form>
      </Modal>

      <Modal
        title={`New password for ${passwordFor?.name ?? ""}`}
        open={passwordFor !== null}
        onCancel={() => setPasswordFor(null)}
        onOk={() => passwordForm.submit()}
        okText="Set password"
        confirmLoading={saving}
        destroyOnHidden
      >
        <Form form={passwordForm} layout="vertical" onFinish={setPassword}>
          <PasswordField />
        </Form>
      </Modal>
    </Page>
  );
}
