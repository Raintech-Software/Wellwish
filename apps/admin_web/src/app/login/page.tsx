"use client";

import { Alert, Button, Card, Checkbox, Form, Input, QRCode, Space, Typography } from "antd";
import Image from "next/image";
import { useRouter, useSearchParams } from "next/navigation";
import { Suspense, useEffect, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useSession } from "@/auth/AuthProvider";
import { signedIn, staffUpdated } from "@/auth/session";
import { SaveRecoveryCodes } from "@/components/RecoveryCodes";
import { IS_DEV } from "@/config/env";
import { colors } from "@/theme";

type LoginStep = components["schemas"]["StaffLoginOut"];
type Tokens = components["schemas"]["StaffTokenOut"];

const REASONS: Record<string, string> = {
  idle: "You were signed out after 30 minutes without activity.",
  expired: "Your session ended. Please sign in again.",
};

const ERRORS: Record<string, string> = {
  INVALID_CREDENTIALS: "Wrong email or password.",
  LOGIN_LOCKED: "Too many wrong tries. Try again in 15 minutes.",
  TOTP_INVALID: "That code isn't right. Check your authenticator app.",
  RECOVERY_CODE_INVALID: "That recovery code isn't right, or it was used already.",
  LOGIN_EXPIRED: "Sign-in took too long. Please start again.",
  EMAIL_CODE_TOO_SOON: "A code was just sent. Wait a moment before asking for another.",
  EMAIL_CODE_RATE_LIMITED: "Too many emailed codes this hour. Use a recovery code, or try again later.",
};

function errorCode(error: unknown): string | undefined {
  return (error as { error?: { code?: string } } | undefined)?.error?.code;
}

function errorText(error: unknown): string {
  const code = errorCode(error);
  return (code && ERRORS[code]) || "Something went wrong. Please try again.";
}

/** Admin sign-in (ARCHITECTURE §6.4): email + password → (first time) scan the QR code →
 * 6-digit code from the authenticator app. Recovery (v2.16): "Trust this browser for 30 days"
 * (next time the password is enough here), a recovery code when the phone is lost (then a new
 * QR code), and the 10 recovery codes shown once right after 2FA is set up. */
function LoginForm() {
  const router = useRouter();
  const params = useSearchParams();
  const { status } = useSession();
  const [step, setStep] = useState<LoginStep | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [trust, setTrust] = useState(false);
  const [recovering, setRecovering] = useState(false);
  const [recoveryCode, setRecoveryCode] = useState("");
  const [recovered, setRecovered] = useState(false);
  const [toSave, setToSave] = useState<Tokens | null>(null);
  // v2.18: a code by email instead of the authenticator (where it went, when it can be resent)
  const [emailed, setEmailed] = useState<{ to: string; resendAt: number } | null>(null);
  const [now, setNow] = useState(() => Date.now());
  const [typedEmail, setTypedEmail] = useState("");

  useEffect(() => {
    if (status === "signedIn") router.replace("/");
  }, [status, router]);

  // the "Send again" countdown
  useEffect(() => {
    if (!emailed || emailed.resendAt <= Date.now()) return;
    const timer = window.setInterval(() => setNow(Date.now()), 1000);
    return () => window.clearInterval(timer);
  }, [emailed, now]);
  const resendIn = emailed ? Math.max(0, Math.ceil((emailed.resendAt - now) / 1000)) : 0;

  const notice = REASONS[params.get("reason") ?? ""];

  function backToPassword() {
    setStep(null);
    setRecovering(false);
    setRecovered(false);
    setRecoveryCode("");
    setEmailed(null);
  }

  async function emailCode() {
    if (!step) return;
    setBusy(true);
    setError(null);
    const { data, error } = await api.POST("/v1/admin/auth/email-code", {
      body: { challengeToken: step.challengeToken },
    });
    setBusy(false);
    if (data) {
      // the sign-in goes on with the step the code was sent with
      setStep({ ...step, challengeToken: data.challengeToken });
      setEmailed({ to: data.emailMasked, resendAt: Date.now() + data.resendAfterSeconds * 1000 });
      setNow(Date.now());
    } else {
      setError(errorText(error));
      if (errorCode(error) === "LOGIN_EXPIRED") backToPassword();
    }
  }

  async function submitPassword(values: { email: string; password: string }) {
    setTypedEmail(values.email.trim().toLowerCase());
    setBusy(true);
    setError(null);
    const { data, error } = await api.POST("/v1/admin/auth/login", { body: values });
    setBusy(false);
    if (data?.step === "SIGNED_IN" && data.signedIn) {
      // a browser this admin trusted: the password is enough
      signedIn(data.signedIn);
      router.replace("/");
    } else if (data) {
      setStep(data);
      setRecovering(false);
      setRecovered(false);
      setEmailed(null);
    } else setError(errorText(error));
  }

  async function submitCode(code: string) {
    if (!step || code.length !== 6) return;
    setBusy(true);
    setError(null);
    const { data, error } = await api.POST("/v1/admin/auth/totp", {
      body: { challengeToken: step.challengeToken, code, trustBrowser: trust },
    });
    setBusy(false);
    if (data?.recoveryCodes?.length) {
      setToSave(data); // 2FA was just set up: save the codes before going on
    } else if (data) {
      signedIn(data);
      router.replace("/");
    } else {
      setError(errorText(error));
      if (errorCode(error) === "LOGIN_EXPIRED") backToPassword();
    }
  }

  async function submitRecovery() {
    if (!step || recoveryCode.trim().length < 8) return;
    setBusy(true);
    setError(null);
    const { data, error } = await api.POST("/v1/admin/auth/recovery", {
      body: { challengeToken: step.challengeToken, code: recoveryCode.trim() },
    });
    setBusy(false);
    if (data) {
      // the old authenticator no longer works: scan a new QR code on the new phone
      setStep(data);
      setRecovering(false);
      setRecoveryCode("");
      setRecovered(true);
    } else {
      setError(errorText(error));
      if (errorCode(error) === "LOGIN_EXPIRED") backToPassword();
    }
  }

  return (
    <main
      style={{
        minHeight: "100vh",
        display: "grid",
        placeItems: "center",
        padding: 16,
        background: colors.background,
      }}
    >
      <Card style={{ width: "100%", maxWidth: 420 }}>
        <div style={{ textAlign: "center", marginBottom: 24 }}>
          <Image
            src="/logo_full.png"
            alt="WellWish. आपकी सेहत, हमारी ज़िम्मेदारी"
            width={200}
            height={151}
            priority
          />
          <Typography.Title level={4} style={{ margin: "12px 0 4px" }}>
            Admin
          </Typography.Title>
          <Typography.Text type="secondary">
            {toSave ? "Recovery codes" : step ? "Two-step verification" : "Sign in to the operations panel"}
          </Typography.Text>
        </div>

        {notice && !step && <Alert style={{ marginBottom: 16 }} type="info" showIcon title={notice} />}
        {error && <Alert style={{ marginBottom: 16 }} type="error" showIcon title={error} />}

        {!step && (
          <Form layout="vertical" onFinish={submitPassword} requiredMark={false} disabled={busy}>
            <Form.Item
              label="Email"
              name="email"
              rules={[{ required: true, type: "email", message: "Enter your work email" }]}
            >
              <Input type="email" autoComplete="username" placeholder="you@wellwish.in" autoFocus />
            </Form.Item>
            <Form.Item
              label="Password"
              name="password"
              rules={[{ required: true, message: "Enter your password" }]}
            >
              <Input.Password autoComplete="current-password" />
            </Form.Item>
            <Button type="primary" htmlType="submit" block size="large" loading={busy}>
              Sign in
            </Button>
          </Form>
        )}

        {toSave && (
          <SaveRecoveryCodes
            codes={toSave.recoveryCodes ?? []}
            email={toSave.staff.email}
            onDone={() => {
              signedIn(toSave);
              // the server notes "saved"; if this call is lost, the panel warns and offers new codes
              void api
                .POST("/v1/admin/me/recovery-codes/saved")
                .then(({ data }) => {
                  if (data) staffUpdated(data);
                })
                .catch(() => undefined)
                .finally(() => router.replace("/"));
            }}
          />
        )}

        {step && !toSave && (
          <Space orientation="vertical" size="middle" style={{ width: "100%" }}>
            {recovered && (
              <Alert
                type="success"
                showIcon
                title="Recovery code accepted"
                description="Your old authenticator no longer works. Set up the app on your new phone now."
              />
            )}
            {step.step === "TOTP_SETUP" && step.otpauthUri && (
              <>
                <Typography.Paragraph style={{ marginBottom: 0 }}>
                  {recovered ? "Scan" : "First sign-in: scan"} this QR code with Google Authenticator (or any
                  authenticator app), then enter the 6-digit code it shows.
                </Typography.Paragraph>
                <div style={{ display: "flex", justifyContent: "center" }}>
                  <QRCode value={step.otpauthUri} size={200} bordered={false} />
                </div>
                <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                  Can&apos;t scan? Enter this key by hand:{" "}
                  <Typography.Text code copyable data-testid="totp-secret">
                    {step.secret}
                  </Typography.Text>
                </Typography.Text>
              </>
            )}
            {recovering ? (
              <>
                <Typography.Paragraph style={{ marginBottom: 0 }}>
                  Enter one of the recovery codes you saved when you set up 2FA (like{" "}
                  <Typography.Text code>abcd-2345</Typography.Text>). Each code works once; then you set up the
                  authenticator on your new phone.
                </Typography.Paragraph>
                <Input
                  size="large"
                  autoFocus
                  placeholder="xxxx-xxxx"
                  maxLength={12}
                  value={recoveryCode}
                  disabled={busy}
                  onChange={(e) => setRecoveryCode(e.target.value)}
                  onPressEnter={() => void submitRecovery()}
                />
                <Button type="primary" block size="large" loading={busy} onClick={() => void submitRecovery()}>
                  Use recovery code
                </Button>
                <Button type="link" block onClick={() => setRecovering(false)}>
                  Use the authenticator code instead
                </Button>
              </>
            ) : (
              <>
                {step.step === "TOTP" &&
                  (emailed ? (
                    <Alert
                      type="info"
                      showIcon
                      title={`We emailed a 6-digit code to ${emailed.to}`}
                      description={
                        <>
                          Enter it below (it works once, for 10 minutes). The code from your authenticator app works
                          too.
                          {IS_DEV && (
                            // a developer's PC sends no email (SES isn't connected): the code waits in the
                            // dev outbox, which this terminal command prints without signing in
                            <Typography.Paragraph type="secondary" style={{ margin: "8px 0 0", fontSize: 12 }}>
                              This PC doesn&apos;t send emails. Read the code in a terminal in the project folder:{" "}
                              <Typography.Text code copyable>
                                {`.\\ww.ps1 manage mail_outbox ${typedEmail}`}
                              </Typography.Text>
                            </Typography.Paragraph>
                          )}
                        </>
                      }
                    />
                  ) : (
                    <Typography.Paragraph style={{ marginBottom: 0 }}>
                      Enter the 6-digit code from your authenticator app.
                    </Typography.Paragraph>
                  ))}
                {/* above the code: the code is sent as soon as its 6th digit is typed */}
                <Checkbox checked={trust} onChange={(e) => setTrust(e.target.checked)} disabled={busy}>
                  Trust this browser for 30 days
                  <Typography.Text type="secondary" style={{ display: "block", fontSize: 12 }}>
                    Next time your password is enough here. Don&apos;t tick this on a shared computer.
                  </Typography.Text>
                </Checkbox>
                <div style={{ display: "flex", justifyContent: "center" }}>
                  <Input.OTP length={6} size="large" disabled={busy} onChange={(code) => void submitCode(code)} />
                </div>
                {step.step === "TOTP" && (
                  <Typography.Text type="secondary" style={{ fontSize: 13 }}>
                    No phone?{" "}
                    {emailed && resendIn > 0 ? (
                      <>You can ask for another email code in {resendIn} s,</>
                    ) : (
                      <Typography.Link disabled={busy} onClick={() => void emailCode()}>
                        {emailed ? "Email me another code" : "Email me a code"}
                      </Typography.Link>
                    )}{" "}
                    or{" "}
                    <Typography.Link onClick={() => setRecovering(true)}>use a recovery code</Typography.Link>.
                    Neither? Ask a Super Admin to reset your 2FA (System → Admin users).
                  </Typography.Text>
                )}
              </>
            )}
            <Button type="link" block onClick={backToPassword}>
              Back
            </Button>
          </Space>
        )}
      </Card>
    </main>
  );
}

export default function LoginPage() {
  return (
    <Suspense>
      <LoginForm />
    </Suspense>
  );
}
