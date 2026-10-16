"use client";

import { ArrowLeftOutlined, CalendarOutlined, StopOutlined } from "@ant-design/icons";
import { Alert, Button, Card, Descriptions, Spin, Table, Tag, Timeline, Typography } from "antd";
import Link from "next/link";
import { useParams } from "next/navigation";
import { useCallback, useEffect, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import AssignmentCard from "@/components/bookings/AssignmentCard";
import TemporaryPartnerCard from "@/components/bookings/TemporaryPartnerCard";
import { CancelDialog, RescheduleDialog } from "@/components/bookings/BookingActions";
import VisitCard from "@/components/bookings/VisitCard";
import { ACTOR, BOOKING_STATUS, type BookingStatus, EVENT, PARTNER_TYPE, VISIT_TYPE } from "@/lib/bookings";
import { dateTime, minutes, rupees } from "@/lib/format";
import { phone } from "@/lib/partners";
import { DOCUMENT_TYPE, GENDER, mapLink, RELATION } from "@/lib/patients";
import { failureText, METHOD, PAYMENT_STATUS, reasonText, refundStatus, REQUESTED_BY } from "@/lib/payments";
import { onLiveMessage } from "@/lib/staffSocket";
import { useLoad } from "@/lib/useLoad";
import { BALANCE_MODE, stepLabel } from "@/lib/visit";

type Doc = components["schemas"]["BookingDocumentOut"];

/** A timeline note in words: the call ("MEMBER") and the balance ("CASH 40000") are stored short. */
function eventNote(event: string, note: string): string {
  if (event === "CALL") return note === "BOOKER" ? "called the person who booked" : "called the patient";
  if (event === "BALANCE") {
    const m = /^(\w+) (\d+)(?:: ([\s\S]*))?$/.exec(note);
    return m ? `${rupees(Number(m[2]))} ${BALANCE_MODE[m[1]] ?? m[1]}${m[3] ? `: ${m[3]}` : ""}` : note;
  }
  return reasonText(note);
}
type PaymentRow = components["schemas"]["AdminPaymentOut"];
type RefundRow = components["schemas"]["AdminRefundOut"];

/**
 * Booking detail (§9.1, PHASES 5.14, 6.10): patient, member, the price snapshot, hospital and
 * doctor, address, documents, payments, refunds and timeline. Cancel with a refund and change the
 * date or time (bookings.manage); assign (Phase 7); the visit's steps, balance and route (Phase 8).
 * Documents open from the patient page (a reason is asked and logged there).
 */
export default function BookingPage() {
  const { id } = useParams<{ id: string }>();
  const can = useCan();
  const fetchBooking = useCallback(
    async () =>
      (
        await api.GET("/v1/admin/bookings/{booking_id}", {
          params: { path: { booking_id: id } },
        })
      ).data,
    [id],
  );
  const { data, failed, setData, reload } = useLoad(fetchBooking, can("bookings.view"));
  const refreshBooking = useCallback(() => reload(), [reload]);
  // a step marked by the partner (or another admin), this booking's alerts (e.g. wrong visit
  // codes) and anything missed while the socket was down show at once
  useEffect(
    () =>
      onLiveMessage(({ type, data: msg }) => {
        const mine = msg.bookingId === id;
        if (type === "live.reconnected" || (mine && ["job.step", "alert", "alert.acked"].includes(type))) {
          reload();
        }
      }),
    [id, reload],
  );
  // at the door (the next step needs the visit code): later waits (10, 20… min) raise no new
  // alert, so look again every 30 s; this also clears the wait banner when the wait is over
  const atTheDoor =
    data?.status === "IN_PROGRESS" && !!data.visit?.nextStep && data.visit.nextStep === data.visit.otpStep;
  useEffect(() => {
    if (!atTheDoor) return;
    const timer = window.setInterval(() => {
      if (!document.hidden) reload();
    }, 30_000);
    return () => window.clearInterval(timer);
  }, [atTheDoor, reload]);
  const [dialog, setDialog] = useState<"cancel" | "reschedule" | null>(null);
  const status = data ? BOOKING_STATUS[data.status as BookingStatus] : undefined;
  const manage = can("bookings.manage");

  return (
    <Page
      title={data ? `Booking ${data.code}` : "Booking"}
      permission="bookings.view"
      description="Times are India time. The price, member and address are as they were when the patient booked."
      extra={
        <>
          {data && manage && data.canReschedule && (
            <Button icon={<CalendarOutlined />} onClick={() => setDialog("reschedule")}>
              Change date or time
            </Button>
          )}
          {data && manage && data.canCancel && (
            <Button danger icon={<StopOutlined />} onClick={() => setDialog("cancel")}>
              Cancel and refund
            </Button>
          )}
          <Link href="/bookings">
            <Button icon={<ArrowLeftOutlined />}>All bookings</Button>
          </Link>
        </>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load this booking. Reload the page." />}
      {!data && !failed && <Spin />}
      {data && (
        <>
          <Card size="small" style={{ marginBottom: 16 }}>
            <Descriptions
              size="small"
              column={{ xs: 1, md: 2 }}
              items={[
                {
                  key: "status",
                  label: "Status",
                  children: (
                    <span>
                      <Tag color={status?.color}>{status?.label ?? data.status}</Tag>
                      {data.reconfirmNeeded && <Tag color="orange">Partner must confirm the new time</Tag>}
                    </span>
                  ),
                },
                {
                  key: "booked",
                  label: "Booked",
                  children: dateTime(data.createdAt),
                },
                {
                  key: "pickup",
                  label: data.visitType === "HOSPITAL_VISIT" ? "Pickup" : "Visit / start",
                  children: dateTime(data.pickupAt),
                },
                {
                  key: "appointment",
                  label: "Doctor appointment",
                  children: dateTime(data.appointmentAt),
                },
                {
                  key: "patient",
                  label: "Booked by",
                  children: data.patientDeleted ? (
                    <Typography.Text type="secondary">Account deleted (bookings and payments are kept)</Typography.Text>
                  ) : (
                    <span>
                      {can("patients.view") ? (
                        <Link href={`/patients/${data.patient.id}`}>{data.patient.fullName || "Patient"}</Link>
                      ) : (
                        data.patient.fullName || "Patient"
                      )}
                      {" · "}
                      <a href={`tel:${data.patient.phone}`}>{phone(data.patient.phone)}</a>
                    </span>
                  ),
                },
                {
                  key: "member",
                  label: "For",
                  children: data.member.fullName ? (
                    <span>
                      {data.member.fullName} ({RELATION[data.member.relation] ?? data.member.relation}
                      {data.member.age != null && `, ${data.member.age} yrs`}
                      {data.member.gender && `, ${GENDER[data.member.gender] ?? data.member.gender}`})
                      {data.member.phone && (
                        <>
                          {" · "}
                          <a href={`tel:${data.member.phone}`}>{phone(data.member.phone)}</a>
                        </>
                      )}
                      {data.member.language && ` · speaks ${data.member.language}`}
                    </span>
                  ) : (
                    <Typography.Text type="secondary">Account deleted</Typography.Text>
                  ),
                },
                {
                  key: "reschedules",
                  label: "Reschedules",
                  children: data.rescheduleCount,
                },
              ]}
            />
          </Card>

          {!["PENDING_PAYMENT", "EXPIRED"].includes(data.status) && (
            <AssignmentCard
              bookingId={data.id}
              code={data.code}
              partnerType={data.partnerType}
              temporary={data.temporaryPartner}
              onChanged={refreshBooking}
            />
          )}
          {data.temporaryPartner && (
            <TemporaryPartnerCard key={data.status} bookingId={data.id} onChanged={refreshBooking} />
          )}

          {data.visit && !["NEW", "OFFERED", "CANCELLED"].includes(data.status) && (
            <VisitCard booking={data} onChanged={setData} onStale={refreshBooking} />
          )}

          <Card size="small" title="Service and price" style={{ marginBottom: 16 }}>
            <Descriptions
              size="small"
              column={{ xs: 1, md: 2 }}
              items={[
                { key: "name", label: "Service", children: data.service.name },
                {
                  key: "type",
                  label: "Type",
                  children: `${PARTNER_TYPE[data.partnerType] ?? data.partnerType} · ${VISIT_TYPE[data.visitType] ?? data.visitType} · ${minutes(data.service.durationMin)}`,
                },
                {
                  key: "total",
                  label: "Total",
                  children: rupees(data.service.pricePaise),
                },
                {
                  key: "fee",
                  label: "Booking fee (online)",
                  children: rupees(data.service.bookingFeePaise),
                },
                {
                  key: "balance",
                  label: "Balance (to the partner)",
                  children: rupees(data.service.balancePaise),
                },
                {
                  key: "docs",
                  label: "Prescription needed",
                  children: data.service.docsRequired ? <Tag color="orange">Yes</Tag> : "No",
                },
              ]}
            />
          </Card>

          <Card size="small" title="Where" style={{ marginBottom: 16 }}>
            <Descriptions
              size="small"
              column={1}
              items={[
                {
                  key: "hospital",
                  label: "Hospital",
                  children: data.hospitalText ? (
                    <span>
                      {data.hospitalText} <Tag>Typed in by the patient</Tag>
                    </span>
                  ) : (
                    data.hospitalName || "—"
                  ),
                },
                {
                  key: "doctor",
                  label: "Doctor",
                  children: data.doctorName || "—",
                },
                {
                  key: "address",
                  label: "Address",
                  children: data.address.line1 ? (
                    <div>
                      <div>
                        <b>{data.address.label}</b>: {data.address.line1}
                      </div>
                      {data.address.landmark && <div>Near {data.address.landmark}</div>}
                      {data.address.notes && (
                        <div>
                          <Typography.Text type="secondary">{data.address.notes}</Typography.Text>
                        </div>
                      )}
                      <div>
                        <a href={mapLink(data.address.lat, data.address.lng)} target="_blank" rel="noreferrer">
                          Open map
                        </a>
                      </div>
                    </div>
                  ) : (
                    "—"
                  ),
                },
                {
                  key: "notes",
                  label: "Patient's notes",
                  children: data.notesVisible ? (
                    data.notes || "—"
                  ) : (
                    <Typography.Text type="secondary">
                      Only for roles that may see patient documents (notes can be medical)
                    </Typography.Text>
                  ),
                },
              ]}
            />
          </Card>

          <Card size="small" title="Documents" style={{ marginBottom: 16 }}>
            {!data.documentsVisible && data.documents.length > 0 && (
              <Alert
                type="info"
                showIcon
                style={{ marginBottom: 12 }}
                title="Document names are visible only to roles that may open patient documents."
              />
            )}
            <Table<Doc>
              rowKey="id"
              size="small"
              pagination={false}
              dataSource={data.documents}
              locale={{ emptyText: "No documents attached" }}
              columns={[
                {
                  title: "Type",
                  key: "type",
                  render: (_, d) => DOCUMENT_TYPE[d.type] ?? d.type,
                },
                {
                  title: "Name",
                  key: "title",
                  render: (_, d) => (d.removed ? <Tag>Deleted by the patient</Tag> : d.title || "—"),
                },
              ]}
            />
            {data.documentsVisible &&
              !data.patientDeleted &&
              can("patients.view") &&
              data.documents.some((d) => !d.removed) && (
                <Typography.Paragraph type="secondary" style={{ marginTop: 8, marginBottom: 0 }}>
                  To open one, go to the <Link href={`/patients/${data.patient.id}`}>patient page</Link> (a reason is
                  asked and logged).
                </Typography.Paragraph>
              )}
          </Card>

          <Card size="small" title="Payments" style={{ marginBottom: 16 }}>
            <Table<PaymentRow>
              rowKey="id"
              size="small"
              pagination={false}
              dataSource={data.payments}
              locale={{ emptyText: "No payment yet" }}
              scroll={{ x: true }}
              columns={[
                { title: "Amount", key: "amount", render: (_, p) => rupees(p.amountPaise) },
                {
                  title: "Status",
                  key: "status",
                  render: (_, p) => (
                    <span>
                      <Tag color={PAYMENT_STATUS[p.status]?.color}>{PAYMENT_STATUS[p.status]?.label ?? p.status}</Tag>
                      {p.mode === "TEST" && <Tag>TEST</Tag>}
                      {p.failureReason && <Typography.Text type="secondary"> {failureText(p.failureReason)}</Typography.Text>}
                    </span>
                  ),
                },
                { title: "Method", key: "method", render: (_, p) => METHOD[p.method] ?? (p.method || "—") },
                {
                  title: "Razorpay",
                  key: "ids",
                  render: (_, p) => (
                    <Typography.Text style={{ fontSize: 12 }}>{p.razorpayPaymentId || p.razorpayOrderId}</Typography.Text>
                  ),
                },
                { title: "Paid", key: "captured", render: (_, p) => dateTime(p.capturedAt) },
              ]}
            />
          </Card>

          {data.refunds.length > 0 && (
            <Card size="small" title="Refunds" style={{ marginBottom: 16 }}>
              <Table<RefundRow>
                rowKey="id"
                size="small"
                pagination={false}
                dataSource={data.refunds}
                scroll={{ x: true }}
                columns={[
                  {
                    title: "Amount",
                    key: "amount",
                    render: (_, r) => `${rupees(r.amountPaise)} (${r.percent}%)`,
                  },
                  {
                    title: "Status",
                    key: "status",
                    render: (_, r) => <Tag color={refundStatus(r).color}>{refundStatus(r).label}</Tag>,
                  },
                  {
                    title: "Reason",
                    key: "reason",
                    render: (_, r) => (
                      <span>
                        {reasonText(r.reason)}
                        <Typography.Text type="secondary">
                          {" · "}
                          {REQUESTED_BY[r.requestedByType] ?? r.requestedByType}
                          {r.requestedByName && `: ${r.requestedByName}`}
                        </Typography.Text>
                      </span>
                    ),
                  },
                  { title: "Asked", key: "created", render: (_, r) => dateTime(r.createdAt) },
                  { title: "Refunded", key: "processed", render: (_, r) => dateTime(r.processedAt) },
                ]}
              />
              {can("refunds.approve") && (
                <Typography.Paragraph type="secondary" style={{ marginTop: 8, marginBottom: 0 }}>
                  Approve or reject refunds above the limit on <Link href="/payments/refunds">Payments → Refunds</Link>.
                </Typography.Paragraph>
              )}
            </Card>
          )}

          <Card size="small" title="Timeline">
            <Timeline
              items={data.timeline.map((e, i) => ({
                key: i,
                content: (
                  <>
                    <div>{e.event === "STEP" && e.step ? stepLabel(e.step) : (EVENT[e.event] ?? e.event)}</div>
                    <Typography.Text type="secondary">
                      {dateTime(e.at)} · {ACTOR[e.actorType] ?? e.actorType}
                      {e.note && ` · ${eventNote(e.event, e.note)}`}
                    </Typography.Text>
                  </>
                ),
              }))}
            />
          </Card>

          <CancelDialog
            booking={data}
            open={dialog === "cancel"}
            onClose={() => setDialog(null)}
            onDone={(updated) => {
              setData(updated);
              setDialog(null);
            }}
            onStale={() => {
              setDialog(null);
              reload();
            }}
          />
          <RescheduleDialog
            booking={data}
            open={dialog === "reschedule"}
            onClose={() => setDialog(null)}
            onDone={(updated) => {
              setData(updated);
              setDialog(null);
            }}
            onStale={() => {
              setDialog(null);
              reload();
            }}
          />
        </>
      )}
    </Page>
  );
}
