"use client";

import { PhoneOutlined, WarningOutlined } from "@ant-design/icons";
import { Alert, App, Button, Card, Descriptions, Flex, Form, Input, Modal, Table, Tag, Typography } from "antd";
import { useCallback, useEffect, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import AssignDialog from "@/components/bookings/AssignDialog";
import TemporaryAssignDialog from "@/components/bookings/TemporaryAssignDialog";
import {
  ALERT_KIND,
  BOOKING_CHANGED,
  DECLINE_REASON,
  OFFER_KIND,
  OFFER_RESPONSE,
  clock,
  tel,
  useSecondsLeft,
} from "@/lib/assignments";
import { errorMessage } from "@/lib/errors";
import { dateTime } from "@/lib/format";
import { phone } from "@/lib/partners";
import { onLiveMessage } from "@/lib/staffSocket";
import { useLoad } from "@/lib/useLoad";

type State = components["schemas"]["AssignmentStateOut"];
type Offer = components["schemas"]["OfferOut"];
type AlertRow = components["schemas"]["AlertOut"];

const reasonRule = {
  validator: (_: unknown, value?: string) =>
    (value ?? "").trim().length >= 3 ? Promise.resolve() : Promise.reject(new Error("Write at least 3 characters.")),
};

/** The partner app's wording doesn't fit here: say what happened from the admin's side. */
const CHANGED = BOOKING_CHANGED;
const ADMIN_ERRORS: Record<string, string> = {
  OFFER_NOT_OPEN: CHANGED,
  NO_OPEN_OFFER: CHANGED,
  OFFER_CHANGED: CHANGED,
  NOT_ASSIGNABLE: CHANGED,
};

function adminError(error: unknown): string {
  const code = (error as { error?: { code?: string } } | undefined)?.error?.code;
  return (code && ADMIN_ERRORS[code]) || errorMessage(error);
}

function CallButtons({ primary, alternate }: { primary: string; alternate: string }) {
  return (
    <>
      {primary && (
        <Button size="small" icon={<PhoneOutlined />} href={tel(primary)}>
          Call primary {phone(primary)}
        </Button>
      )}
      {alternate && (
        <Button size="small" icon={<PhoneOutlined />} href={tel(alternate)}>
          Call alternate {phone(alternate)}
        </Button>
      )}
    </>
  );
}

/**
 * The booking page's assignment card (§6.10, §9.3, PHASES 7.12-7.13): assign by deadline,
 * the open offer with its 2-minute countdown, the banner when nobody answered ("Call primary /
 * Call alternate / Accepted by phone / Reassign"), decline reasons, the accepted partner,
 * unassign, and every offer so far. Updates live. "Temporary assign" (§6.19): nobody free, a
 * person the admin phoned and ID-checked gets this one booking.
 */
export default function AssignmentCard({
  bookingId,
  code,
  partnerType,
  temporary = false,
  onChanged,
}: {
  bookingId: string;
  code: string;
  partnerType: string;
  temporary?: boolean;
  onChanged: () => void;
}) {
  const can = useCan();
  const manage = can("bookings.manage");
  const { message } = App.useApp();
  const [dialog, setDialog] = useState<"assign" | "temporary" | "phone" | "unassign" | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<{ reason: string }>();
  const fetchState = useCallback(
    async () =>
      (await api.GET("/v1/admin/bookings/{booking_id}/assignment", { params: { path: { booking_id: bookingId } } }))
        .data,
    [bookingId],
  );
  const { data, failed, reload, setData } = useLoad<State>(fetchState, can("bookings.view"));
  const left = useSecondsLeft(data?.openOffer?.timeoutAt);

  useEffect(
    () =>
      onLiveMessage(({ type, data: msg }) => {
        if (type === "live.reconnected" || ((type === "queue.changed" || type === "alert") && msg.bookingId === bookingId)) {
          reload();
          onChanged();
        }
      }),
    [bookingId, reload, onChanged],
  );

  // What the admin saw when opening a dialog: if the booking changes meanwhile (another admin
  // assigned or reassigned, the partner answered), the dialog says so and won't act on the wrong
  // offer; the server refuses it too (§6.16). The dialogs get this copy, never the live id.
  const [seen, setSeen] = useState<{ assignmentId: string | null; status: string } | null>(null);
  const openDialog = (kind: "assign" | "temporary" | "phone" | "unassign") => {
    if (!data) return;
    setSeen({ assignmentId: data.currentAssignmentId, status: data.status });
    setDialog(kind);
  };
  const stale =
    !!seen && !!data && (data.currentAssignmentId !== seen.assignmentId || data.status !== seen.status);

  const updated = (state: State) => {
    setData(state);
    setDialog(null); // the note form is destroyed with the dialog (preserve={false})
    onChanged();
  };

  const submitNote = async ({ reason }: { reason: string }) => {
    if (saving || (dialog !== "phone" && dialog !== "unassign")) return;
    setSaving(true);
    const path =
      dialog === "phone" ? "/v1/admin/bookings/{booking_id}/accept-by-phone" : "/v1/admin/bookings/{booking_id}/unassign";
    try {
      const { data: state, error } = await api.POST(path, {
        params: { path: { booking_id: bookingId } },
        body: { reason: reason.trim(), expectedAssignmentId: seen?.assignmentId ?? null },
      });
      if (error || !state) {
        message.error(adminError(error));
        setDialog(null);
        reload();
        return;
      }
      message.success(dialog === "phone" ? "Recorded: accepted by phone." : "Back in the queue.");
      updated(state);
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setSaving(false);
    }
  };

  const acknowledge = async (alert: AlertRow) => {
    try {
      const { error } = await api.POST("/v1/admin/alerts/{alert_id}/ack", { params: { path: { alert_id: alert.id } } });
      if (error) message.error(errorMessage(error));
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    }
    reload();
  };

  if (failed) return <Alert type="error" showIcon title="Couldn't load the assignment. Reload the page." />;
  if (!data) return null;
  const offer = data.openOffer;
  const noAnswer = offer && left !== null && left < 0;

  return (
    <Card
      size="small"
      title="Partner"
      style={{ marginBottom: 16 }}
      extra={
        manage && (
          <Flex gap={8}>
            {data.canAssign && (
              <Button type={offer ? "default" : "primary"} size="small" onClick={() => openDialog("assign")}>
                {offer ? "Reassign" : "Assign"}
              </Button>
            )}
            {data.canAssign && (
              <Button size="small" onClick={() => openDialog("temporary")}>
                Temporary assign
              </Button>
            )}
            {offer && (
              <Button size="small" onClick={() => openDialog("phone")}>
                Accepted by phone
              </Button>
            )}
            {data.canUnassign && (
              <Button size="small" danger onClick={() => openDialog("unassign")}>
                {data.status === "ACCEPTED" ? "Unassign" : "Withdraw offer"}
              </Button>
            )}
          </Flex>
        )
      }
    >
      {data.late && (
        <Alert
          type="error"
          showIcon
          icon={<WarningOutlined />}
          style={{ marginBottom: 12 }}
          title={`Past the assign deadline (${dateTime(data.deadlineAt)}): still no partner.`}
        />
      )}
      {offer && noAnswer && (
        <Alert
          type="warning"
          showIcon
          style={{ marginBottom: 12 }}
          title={`${offer.partnerName} hasn't answered in 2 minutes. The offer stays open.`}
          description={
            <Flex gap={8} wrap style={{ marginTop: 8 }}>
              <CallButtons primary={offer.phone} alternate={offer.alternatePhone} />
              {manage && (
                <>
                  <Button size="small" type="primary" onClick={() => openDialog("phone")}>
                    Accepted by phone
                  </Button>
                  {data.canAssign ? (
                    <Button size="small" onClick={() => openDialog("assign")}>
                      Reassign
                    </Button>
                  ) : (
                    data.canUnassign && (
                      <Button size="small" danger onClick={() => openDialog("unassign")}>
                        Unassign
                      </Button>
                    )
                  )}
                </>
              )}
            </Flex>
          }
        />
      )}
      {data.alerts
        .filter((a) => a.kind === "DECLINED")
        .map((a) => (
          <Alert
            key={a.id}
            type="info"
            showIcon
            closable={manage}
            onClose={() => void acknowledge(a)}
            style={{ marginBottom: 12 }}
            title={`${String(a.details.partner ?? "The partner")} declined${a.details.reconfirm ? " the new time" : ""}: ${
              DECLINE_REASON[String(a.details.reason)] ?? String(a.details.reason ?? "")
            }${a.details.note ? `, "${String(a.details.note)}"` : ""}`}
          />
        ))}
      <Descriptions
        size="small"
        column={{ xs: 1, md: 2 }}
        items={[
          {
            key: "who",
            label: "Partner",
            children: data.partner ? (
              <span>
                <b>{data.partner.fullName}</b>
                {temporary && <Tag color="purple" style={{ marginLeft: 8 }}>Temporary partner</Tag>}
                {data.reconfirmNeeded && <Tag color="orange" style={{ marginLeft: 8 }}>Must confirm the new time</Tag>}
                {offer && left !== null && (
                  <Tag color={noAnswer ? "orange" : "gold"}>
                    {noAnswer ? `no answer ${clock(left)}` : `${clock(left)} left`}
                  </Tag>
                )}
              </span>
            ) : offer ? (
              <span>
                Offered to <b>{offer.partnerName}</b>{" "}
                <Tag color={noAnswer ? "orange" : "gold"}>
                  {OFFER_KIND[offer.kind] ?? offer.kind} · {left !== null && (noAnswer ? `no answer ${clock(left)}` : `${clock(left)} left`)}
                </Tag>
              </span>
            ) : (
              <Typography.Text type="secondary">Not assigned yet</Typography.Text>
            ),
          },
          {
            key: "deadline",
            label: "Assign by",
            children: dateTime(data.deadlineAt),
          },
          ...(data.partner
            ? [
                {
                  key: "phones",
                  label: "Call",
                  children: (
                    <Flex gap={8} wrap>
                      <CallButtons primary={data.partner.phone} alternate={data.partner.alternatePhone} />
                    </Flex>
                  ),
                },
              ]
            : []),
        ]}
      />
      {data.offers.length > 0 && (
        <Table<Offer>
          rowKey="id"
          size="small"
          style={{ marginTop: 12 }}
          pagination={false}
          dataSource={data.offers}
          scroll={{ x: true }}
          columns={[
            { title: "Offer", key: "kind", render: (_, o) => OFFER_KIND[o.kind] ?? o.kind },
            { title: "Partner", key: "partner", render: (_, o) => o.partnerName },
            { title: "Sent", key: "sent", render: (_, o) => dateTime(o.sentAt) },
            {
              title: "Answer",
              key: "response",
              render: (_, o) => (
                <span>
                  <Tag color={OFFER_RESPONSE[o.response]?.color}>{OFFER_RESPONSE[o.response]?.label ?? o.response}</Tag>
                  {o.declineReason && (DECLINE_REASON[o.declineReason] ?? o.declineReason)}
                  {o.respondedAt && <Typography.Text type="secondary"> {dateTime(o.respondedAt)}</Typography.Text>}
                </span>
              ),
            },
            { title: "By", key: "by", render: (_, o) => o.assignedBy || "System" },
          ]}
        />
      )}
      {data.alerts.some((a) => a.kind !== "DECLINED") && (
        <Flex vertical gap={4} style={{ marginTop: 12 }}>
          {data.alerts
            .filter((a) => a.kind !== "DECLINED")
            .map((a) => (
              <Flex key={a.id} gap={8} align="center">
                <Tag color={ALERT_KIND[a.kind]?.color}>{ALERT_KIND[a.kind]?.label ?? a.kind}</Tag>
                <Typography.Text type="secondary">{dateTime(a.createdAt)}</Typography.Text>
                {manage && (
                  <Button size="small" type="link" onClick={() => void acknowledge(a)}>
                    Mark as seen
                  </Button>
                )}
              </Flex>
            ))}
        </Flex>
      )}

      {dialog === "assign" && (
        <AssignDialog
          bookingId={bookingId}
          code={code}
          expectedAssignmentId={seen?.assignmentId ?? null}
          changed={stale}
          open
          onClose={() => {
            setDialog(null);
            reload();
          }}
          onDone={updated}
        />
      )}
      {dialog === "temporary" && (
        <TemporaryAssignDialog
          bookingId={bookingId}
          code={code}
          partnerType={partnerType}
          expectedAssignmentId={seen?.assignmentId ?? null}
          changed={stale}
          onClose={() => {
            setDialog(null);
            reload();
          }}
          onDone={updated}
        />
      )}
      <Modal
        open={dialog === "phone" || dialog === "unassign"}
        title={dialog === "phone" ? `Accepted by phone: ${offer?.partnerName ?? ""}` : `Back to the queue: ${code}`}
        okText={dialog === "phone" ? "Record acceptance" : data.status === "ACCEPTED" ? "Unassign" : "Withdraw offer"}
        okButtonProps={{ loading: saving, danger: dialog === "unassign", disabled: stale }}
        onOk={() => form.submit()}
        onCancel={() => setDialog(null)}
        destroyOnHidden
      >
        {stale && <Alert type="warning" showIcon style={{ marginBottom: 12 }} title={CHANGED} />}
        <Typography.Paragraph type="secondary">
          {dialog === "phone"
            ? "The partner agreed on a call. The job becomes theirs (logged with your note)."
            : "The partner gets a message that the booking is no longer theirs. Logged with your reason."}
        </Typography.Paragraph>
        <Form form={form} layout="vertical" onFinish={submitNote} preserve={false}>
          <Form.Item name="reason" label={dialog === "phone" ? "Note (logged)" : "Reason (logged)"} rules={[reasonRule]}>
            <Input.TextArea rows={2} maxLength={300} showCount />
          </Form.Item>
        </Form>
      </Modal>
    </Card>
  );
}
