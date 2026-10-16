"use client";

import { PhoneOutlined } from "@ant-design/icons";
import { Alert, App, Button, Card, Empty, Flex, Form, Input, Modal, Spin, Table, Tag, Typography } from "antd";
import dynamic from "next/dynamic";
import Link from "next/link";
import { useCallback, useEffect, useRef, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { ALERT_KIND, tel } from "@/lib/assignments";
import { errorCode, errorMessage } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { phone } from "@/lib/partners";
import { onLiveMessage } from "@/lib/staffSocket";
import { useLoad } from "@/lib/useLoad";
import { eta, farStepNote, pointLink, SOS_SIDE, SOS_STATUS, stepLabel } from "@/lib/visit";
import { colors } from "@/theme";

const LiveMap = dynamic(() => import("@/components/map/LiveMap"), {
  ssr: false,
  loading: () => <Spin />,
});

type Job = components["schemas"]["LiveJobOut"];
type Sos = components["schemas"]["AdminSosOut"];
type AlertRow = components["schemas"]["AlertOut"];

/** The visit's alerts shown here (assignment alerts stay on the queue and the booking page). */
const VISIT_ALERTS = ["NOT_STARTED", "NO_LOCATION", "FAR_STEP", "MOCK_GPS", "OTP_LOCKED", "NO_SHOW", "NOT_COMPLETED"];

function alertDetail(a: AlertRow): string {
  const d = a.details as Record<string, unknown>;
  if (a.kind === "FAR_STEP") return farStepNote(d);
  return a.partnerName || String(d.partner ?? "");
}

/**
 * Live (§9.1, PHASES 8.15): SOS first (acknowledge, resolve with a note), the map of every job in
 * progress (moves with each point; grey when no point for 2 minutes), and the visit's alerts (not
 * on the way 30 minutes after pickup, no location, a step marked far away, fake GPS, the visit code
 * locked, patient not available, not completed). Everything updates live.
 */
export default function LivePage() {
  const can = useCan();
  const view = can("live.view");
  const manage = can("live.manage");
  const silence = manage || can("bookings.manage");
  const { message, notification } = App.useApp();

  const fetchJobs = useCallback(async () => (await api.GET("/v1/admin/live")).data, []);
  const fetchSos = useCallback(
    async () => (await api.GET("/v1/admin/sos", { params: { query: { status: "active", pageSize: 50 } } })).data,
    [],
  );
  const fetchAlerts = useCallback(
    async () =>
      (await api.GET("/v1/admin/alerts", { params: { query: { open: true, kind: VISIT_ALERTS, pageSize: 100 } } }))
        .data,
    [],
  );
  const jobs = useLoad(fetchJobs, view);
  const sos = useLoad(fetchSos, view);
  const alerts = useLoad(fetchAlerts, view && can("bookings.view"));
  const [resolving, setResolving] = useState<Sos | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<{ notes: string }>();

  const { data: jobList, setData: setJobs, reload: reloadJobs } = jobs;
  const reloadSos = sos.reload;
  const reloadAlerts = alerts.reload;
  // the jobs on the map (read by the socket listener without re-subscribing on every point)
  const shown = useRef<Set<string>>(new Set());
  useEffect(() => {
    shown.current = new Set((jobList ?? []).map((j) => j.bookingId));
  }, [jobList]);

  // Live: points move the markers (from the latest list, so close messages don't undo each
  // other); a step, SOS or alert reloads that part.
  useEffect(
    () =>
      onLiveMessage(({ type, data }) => {
        if (type === "live.reconnected") {
          reloadJobs();
          reloadSos();
          reloadAlerts();
        } else if (type === "job.location") {
          const id = String(data.bookingId ?? "");
          if (!shown.current.has(id)) {
            reloadJobs(); // a job this page doesn't have yet
            return;
          }
          setJobs((list) =>
            list?.map((j) =>
              j.bookingId === id
                ? {
                    ...j,
                    lat: String(data.lat),
                    lng: String(data.lng),
                    at: String(data.at),
                    etaMin: (data.etaMin as number | null) ?? null,
                    step: String(data.step ?? j.step),
                    stale: false,
                  }
                : j,
            ) ?? list,
          );
        } else if (type === "job.step") reloadJobs();
        else if (type === "sos.new" || type === "sos.updated") reloadSos();
        else if (type === "alert" || type === "alert.acked") reloadAlerts();
      }),
    [setJobs, reloadJobs, reloadSos, reloadAlerts],
  );

  // "No point for 2 minutes" turns grey without a message: check again every minute.
  useEffect(() => {
    if (!view) return;
    const id = setInterval(reloadJobs, 60_000);
    return () => clearInterval(id);
  }, [view, reloadJobs]);

  const acknowledge = async (s: Sos) => {
    try {
      const { error } = await api.POST("/v1/admin/sos/{sos_id}/ack", { params: { path: { sos_id: s.id } } });
      if (error) message.error(errorMessage(error));
      else message.success(`SOS ${s.code} acknowledged.`);
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    }
    reloadSos();
  };

  const resolve = async ({ notes }: { notes: string }) => {
    if (!resolving || saving) return;
    setSaving(true);
    try {
      const { error } = await api.POST("/v1/admin/sos/{sos_id}/resolve", {
        params: { path: { sos_id: resolving.id } },
        body: { notes: notes.trim() },
      });
      if (error) {
        message.error(errorMessage(error));
        if (errorCode(error) === "SOS_ALREADY_RESOLVED") {
          setResolving(null);
          reloadSos();
        }
        return;
      }
      message.success(`SOS ${resolving.code} resolved.`);
      setResolving(null);
      reloadSos();
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setSaving(false);
    }
  };

  const ackAlert = async (a: AlertRow) => {
    try {
      const { error } = await api.POST("/v1/admin/alerts/{alert_id}/ack", { params: { path: { alert_id: a.id } } });
      if (error) message.error(errorMessage(error));
      else notification.destroy(`alert-${a.id}`); // its banner goes too
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    }
    reloadAlerts();
  };

  const activeSos = sos.data?.items ?? [];
  const visitAlerts = alerts.data?.items ?? [];
  // the SOS being resolved was closed by someone else meanwhile: the dialog closes
  const resolvingGone = !!resolving && !!sos.data && !activeSos.some((s) => s.id === resolving.id);

  return (
    <Page
      title="Live map"
      permission="live.view"
      description="Jobs in progress with the partner's last point (every 10 s; grey after 2 minutes without one), SOS and the visit's alerts. Updates live."
    >
      {(jobs.failed || sos.failed || alerts.failed) && (
        <Alert
          type="error"
          showIcon
          style={{ marginBottom: 16 }}
          title="Couldn't load all of the live map (no network?). It tries again every minute; or reload the page."
        />
      )}

      {activeSos.length > 0 && (
        <Card
          size="small"
          title={<span style={{ color: colors.danger }}>SOS</span>}
          style={{ marginBottom: 16, borderColor: colors.danger }}
        >
          <Table<Sos>
            rowKey="id"
            size="small"
            pagination={false}
            dataSource={activeSos}
            scroll={{ x: true }}
            columns={[
              {
                title: "Booking",
                key: "code",
                render: (_, s) => (
                  <span>
                    <Link href={`/bookings/${s.bookingId}`}>{s.code}</Link>{" "}
                    <Tag color={SOS_STATUS[s.status]?.color}>{SOS_STATUS[s.status]?.label ?? s.status}</Tag>
                  </span>
                ),
              },
              {
                title: "Pressed by",
                key: "side",
                render: (_, s) => `${SOS_SIDE[s.side] ?? s.side} · ${dateTime(s.raisedAt)}`,
              },
              {
                title: "Partner / patient",
                key: "who",
                render: (_, s) => (
                  <span>
                    {s.partnerName}
                    {s.partnerPhone && (
                      <Button size="small" type="link" icon={<PhoneOutlined />} href={tel(s.partnerPhone)}>
                        {phone(s.partnerPhone)}
                      </Button>
                    )}
                    <div>
                      <Typography.Text type="secondary">For {s.memberName}</Typography.Text>
                    </div>
                  </span>
                ),
              },
              {
                title: "Where",
                key: "where",
                render: (_, s) =>
                  s.lat && s.lng ? (
                    <>
                      <a href={pointLink(s.lat, s.lng)} target="_blank" rel="noreferrer">
                        Open map
                      </a>
                      {s.mockLocation && (
                        <Tag color="red" style={{ marginLeft: 8 }}>
                          Fake location app: call them
                        </Tag>
                      )}
                    </>
                  ) : (
                    <Typography.Text type="secondary">No location sent</Typography.Text>
                  ),
              },
              {
                title: "",
                key: "actions",
                render: (_, s) =>
                  manage && (
                    <Flex gap={8}>
                      {s.status === "OPEN" && (
                        <Button size="small" type="primary" danger onClick={() => void acknowledge(s)}>
                          Acknowledge
                        </Button>
                      )}
                      <Button size="small" onClick={() => setResolving(s)}>
                        Resolve
                      </Button>
                    </Flex>
                  ),
              },
              {
                title: "Acknowledged",
                key: "ack",
                render: (_, s) => (s.ackBy ? `${s.ackBy} · ${dateTime(s.ackAt)}` : "—"),
              },
            ]}
          />
        </Card>
      )}

      <Card size="small" title={`Jobs in progress (${jobList?.length ?? 0})`} style={{ marginBottom: 16 }}>
        {jobList ? <LiveMap jobs={jobList} sos={activeSos} /> : <Spin />}
        <Table<Job>
          rowKey="bookingId"
          size="small"
          style={{ marginTop: 12 }}
          pagination={false}
          dataSource={jobList ?? []}
          locale={{ emptyText: <Empty description="No jobs in progress" /> }}
          scroll={{ x: true }}
          columns={[
            {
              title: "Booking",
              key: "code",
              render: (_, j) => <Link href={`/bookings/${j.bookingId}`}>{j.code}</Link>,
            },
            { title: "Step", key: "step", render: (_, j) => stepLabel(j.step) },
            {
              title: "Partner",
              key: "partner",
              render: (_, j) => (
                <span>
                  {j.partnerName}
                  {j.partnerPhone && (
                    <Button size="small" type="link" icon={<PhoneOutlined />} href={tel(j.partnerPhone)}>
                      {phone(j.partnerPhone)}
                    </Button>
                  )}
                  {j.partnerAlternatePhone && (
                    <Button size="small" type="link" icon={<PhoneOutlined />} href={tel(j.partnerAlternatePhone)}>
                      {phone(j.partnerAlternatePhone)} (alternate)
                    </Button>
                  )}
                </span>
              ),
            },
            { title: "For", key: "member", render: (_, j) => `${j.memberName} · ${j.serviceName}` },
            {
              title: "Last point",
              key: "at",
              render: (_, j) =>
                j.at ? (
                  <span>
                    {dateTime(j.at)} {j.stale && <Tag color="orange">no point for 2 min</Tag>}
                  </span>
                ) : (
                  <Tag color="orange">no location yet</Tag>
                ),
            },
            { title: "ETA", key: "eta", render: (_, j) => eta(j.etaMin) },
          ]}
        />
      </Card>

      {can("bookings.view") && (
        <Card size="small" title={`Alerts (${visitAlerts.length})`}>
          <Table<AlertRow>
            rowKey="id"
            size="small"
            pagination={false}
            dataSource={visitAlerts}
            locale={{ emptyText: <Empty description="No open alerts" /> }}
            scroll={{ x: true }}
            columns={[
              {
                title: "Alert",
                key: "kind",
                render: (_, a) => <Tag color={ALERT_KIND[a.kind]?.color}>{ALERT_KIND[a.kind]?.label ?? a.kind}</Tag>,
              },
              {
                title: "Booking",
                key: "code",
                render: (_, a) => <Link href={`/bookings/${a.bookingId}`}>{a.bookingCode}</Link>,
              },
              { title: "Details", key: "details", render: (_, a) => alertDetail(a) },
              { title: "When", key: "at", render: (_, a) => dateTime(a.createdAt) },
              {
                title: "",
                key: "actions",
                render: (_, a) => (
                  <Flex gap={8}>
                    {a.phone && (
                      <Button size="small" icon={<PhoneOutlined />} href={tel(a.phone)}>
                        Call partner
                      </Button>
                    )}
                    {a.alternatePhone && (
                      <Button size="small" icon={<PhoneOutlined />} href={tel(a.alternatePhone)}>
                        Alternate
                      </Button>
                    )}
                    {silence && (
                      <Button size="small" type="link" onClick={() => void ackAlert(a)}>
                        Mark as seen
                      </Button>
                    )}
                  </Flex>
                ),
              },
            ]}
          />
        </Card>
      )}

      <Modal
        open={!!resolving && !resolvingGone}
        title={`Resolve SOS ${resolving?.code ?? ""}`}
        okText="Resolve"
        okButtonProps={{ loading: saving }}
        onOk={() => form.submit()}
        onCancel={() => setResolving(null)}
        destroyOnHidden
      >
        <Typography.Paragraph type="secondary">What happened and what was done (logged).</Typography.Paragraph>
        <Form form={form} layout="vertical" onFinish={resolve} preserve={false}>
          <Form.Item
            name="notes"
            label="Notes"
            rules={[
              {
                validator: (_, value?: string) =>
                  (value ?? "").trim().length >= 3
                    ? Promise.resolve()
                    : Promise.reject(new Error("Write at least 3 characters.")),
              },
            ]}
          >
            <Input.TextArea rows={3} maxLength={300} showCount />
          </Form.Item>
        </Form>
      </Modal>
    </Page>
  );
}
