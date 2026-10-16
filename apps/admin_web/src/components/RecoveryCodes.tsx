"use client";

import { CopyOutlined, DownloadOutlined } from "@ant-design/icons";
import { Alert, App, Button, Checkbox, Flex, Form, Input, Modal, Typography } from "antd";
import { useState } from "react";

import { api } from "@/api/client";
import { useSession } from "@/auth/AuthProvider";
import { staffUpdated } from "@/auth/session";
import { errorMessage } from "@/lib/errors";

/**
 * The 10 one-time recovery codes (ARCHITECTURE §6.4, v2.16), shown once: copy them or download
 * them as a text file, and keep them away from the phone. Each one signs in once when the
 * authenticator app is lost (then a new QR code is scanned).
 */
export function RecoveryCodesList({ codes, email }: { codes: string[]; email?: string }) {
  const { message } = App.useApp();
  const text = codes.join("\n");
  const download = () => {
    const header = `WellWish Admin recovery codes${email ? ` for ${email}` : ""}\nEach code works once.\n\n`;
    const url = URL.createObjectURL(new Blob([header + text + "\n"], { type: "text/plain" }));
    const link = document.createElement("a");
    link.href = url;
    link.download = "wellwish-admin-recovery-codes.txt";
    link.click();
    URL.revokeObjectURL(url);
  };
  return (
    <Flex vertical gap={12}>
      <div
        data-testid="recovery-codes"
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(2, 1fr)",
          gap: "6px 24px",
          fontFamily: "monospace",
          fontSize: 16,
          padding: 12,
          border: "1px dashed #c9d2e0",
          borderRadius: 8,
          textAlign: "center",
        }}
      >
        {codes.map((code) => (
          <span key={code}>{code}</span>
        ))}
      </div>
      <Flex gap={8} wrap>
        <Button
          icon={<CopyOutlined />}
          onClick={() =>
            void navigator.clipboard.writeText(text).then(
              () => message.success("Codes copied."),
              () => message.error("Couldn't copy. Download them instead."),
            )
          }
        >
          Copy all
        </Button>
        <Button icon={<DownloadOutlined />} onClick={download}>
          Download
        </Button>
      </Flex>
    </Flex>
  );
}

/** Shown once after 2FA is set up: the admin confirms they saved the codes before going on. */
export function SaveRecoveryCodes({
  codes,
  email,
  onDone,
}: {
  codes: string[];
  email?: string;
  onDone: () => void;
}) {
  const [saved, setSaved] = useState(false);
  return (
    <Flex vertical gap={16}>
      <Alert
        type="warning"
        showIcon
        title="Save your recovery codes"
        description="If you lose your phone, each code lets you sign in once and set up a new authenticator. Keep them somewhere safe, not on the same phone. They won't be shown again."
      />
      <RecoveryCodesList codes={codes} email={email} />
      <Checkbox checked={saved} onChange={(e) => setSaved(e.target.checked)}>
        I&apos;ve saved these codes somewhere safe
      </Checkbox>
      <Button type="primary" size="large" block disabled={!saved} onClick={onDone}>
        Continue
      </Button>
    </Flex>
  );
}

/** Header menu → "Recovery codes": how many are left, and 10 new ones (needs the password). */
export function RecoveryCodesModal({ open, onClose }: { open: boolean; onClose: () => void }) {
  const { staff } = useSession();
  const [form] = Form.useForm<{ password: string }>();
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [codes, setCodes] = useState<string[] | null>(null);
  const [saved, setSaved] = useState(false);

  const close = () => {
    setCodes(null);
    setSaved(false);
    setError(null);
    form.resetFields();
    onClose();
  };

  // new codes on screen: the old ones are gone, so the dialog closes only after "I've saved
  // them" (the server notes it; until then the panel warns)
  const done = async () => {
    setBusy(true);
    try {
      const { data } = await api.POST("/v1/admin/me/recovery-codes/saved");
      if (data) staffUpdated(data);
    } catch {
      // the warning stays; the admin can make new codes again
    } finally {
      setBusy(false);
      close();
    }
  };

  const make = async ({ password }: { password: string }) => {
    setBusy(true);
    setError(null);
    try {
      const { data, error: failure } = await api.POST("/v1/admin/me/recovery-codes", { body: { password } });
      if (data) {
        setCodes(data.codes);
        if (staff) staffUpdated({ ...staff, recoveryCodesLeft: data.codes.length, recoveryCodesSaved: false });
      } else {
        setError(errorMessage(failure));
      }
    } catch {
      setError("Couldn't reach the server. Please try again.");
    } finally {
      setBusy(false);
    }
  };

  return (
    <Modal
      open={open}
      title="Recovery codes"
      onCancel={codes ? undefined : close}
      closable={!codes}
      mask={{ closable: !codes }}
      keyboard={!codes}
      footer={null}
      destroyOnHidden
    >
      {codes ? (
        <Flex vertical gap={16}>
          <Alert
            type="warning"
            showIcon
            title="Your new codes (the old ones no longer work)"
            description="Save them somewhere safe, away from your phone. They won't be shown again."
          />
          <RecoveryCodesList codes={codes} email={staff?.email} />
          <Checkbox checked={saved} onChange={(e) => setSaved(e.target.checked)}>
            I&apos;ve saved these codes somewhere safe
          </Checkbox>
          <Button type="primary" disabled={!saved} loading={busy} onClick={() => void done()}>
            Done
          </Button>
        </Flex>
      ) : (
        <>
          <Typography.Paragraph>
            You have <strong>{staff?.recoveryCodesLeft ?? 0}</strong> unused recovery codes. Each one signs you in once if
            you lose your phone or authenticator app.
          </Typography.Paragraph>
          <Typography.Paragraph type="secondary">
            Making new codes stops the old ones from working. Enter your password to go on.
          </Typography.Paragraph>
          {error && <Alert type="error" showIcon title={error} style={{ marginBottom: 12 }} />}
          <Form form={form} layout="vertical" onFinish={make} requiredMark={false}>
            <Form.Item name="password" label="Your password" rules={[{ required: true, message: "Enter your password" }]}>
              <Input.Password autoComplete="current-password" />
            </Form.Item>
            <Button type="primary" htmlType="submit" loading={busy} block>
              Make 10 new codes
            </Button>
          </Form>
        </>
      )}
    </Modal>
  );
}
