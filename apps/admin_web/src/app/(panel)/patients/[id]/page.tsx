"use client";

import { ArrowLeftOutlined, EyeOutlined } from "@ant-design/icons";
import { Alert, App, Button, Card, Descriptions, Form, Image, Input, Modal, Spin, Table, Tag, Typography } from "antd";
import Link from "next/link";
import { useParams } from "next/navigation";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import PatientActions from "@/components/patients/PatientActions";
import { BOOKING_STATUS, type BookingStatus } from "@/lib/bookings";
import { errorMessage } from "@/lib/errors";
import { date, dateTime } from "@/lib/format";
import { phone } from "@/lib/partners";
import { bytes, DOCUMENT_TYPE, GENDER, LANGUAGE, mapLink, RELATION } from "@/lib/patients";
import { useLoad } from "@/lib/useLoad";

type Member = components["schemas"]["AdminMemberOut"];
type Address = components["schemas"]["AddressOut"];
type Doc = components["schemas"]["PatientDocumentOut"];
type BookingRow = components["schemas"]["AdminBookingRowOut"];
type Shown = { title: string; url: string; mime: string };

/**
 * Patient profile (§9.1): the account, family members (no health notes: only the assigned
 * partner sees those, §6.18), addresses and documents (only for roles that may open them, §9.2).
 * Opening a document needs a reason, is written to the audit log and shows it right here (a
 * pop-up window after the request would often be blocked by the browser).
 */
export default function PatientPage() {
  const { id } = useParams<{ id: string }>();
  const can = useCan();
  const { message } = App.useApp();
  const fetchPatient = useCallback(
    async () =>
      (
        await api.GET("/v1/admin/patients/{user_id}", {
          params: { path: { user_id: id } },
        })
      ).data,
    [id],
  );
  const { data, failed, setData } = useLoad(fetchPatient, can("patients.view"));
  const [opening, setOpening] = useState<Doc | null>(null);
  const [shown, setShown] = useState<Shown | null>(null);
  const [busy, setBusy] = useState(false);
  const [form] = Form.useForm<{ reason: string }>();

  const removed = (memberId: string) => data?.members.find((m) => m.id === memberId)?.isActive === false;
  const memberName = (memberId: string) => (
    <>
      {data?.members.find((m) => m.id === memberId)?.fullName ?? "—"} {removed(memberId) && <Tag>Removed</Tag>}
    </>
  );

  const openDocument = async (reason: string) => {
    if (!opening) return;
    setBusy(true);
    const { data: link, error } = await api.POST("/v1/admin/patients/{user_id}/documents/{document_id}/view-url", {
      params: { path: { user_id: id, document_id: opening.id } },
      body: { reason },
    });
    setBusy(false);
    if (!link) {
      message.error(errorMessage(error));
      return;
    }
    setShown({ title: opening.title, url: link.url, mime: link.mime });
    setOpening(null);
  };

  return (
    <Page
      title={data ? data.patient.fullName || "Patient" : "Patient"}
      permission="patients.view"
      extra={
        <>
          {data && can("patients.manage") && <PatientActions id={id} detail={data} onChanged={setData} />}
          <Link href="/patients">
            <Button icon={<ArrowLeftOutlined />}>Patients</Button>
          </Link>
        </>
      }
    >
      {failed && <Alert type="error" showIcon title="Couldn't load this patient. Reload the page." />}
      {!data && !failed && <Spin />}
      {data && (
        <>
          {data.patient.blockedAt && (
            <Alert
              type="error"
              showIcon
              style={{ marginBottom: 16 }}
              title={`Blocked from the patient app since ${dateTime(data.patient.blockedAt)}: ${data.blockedReason}`}
            />
          )}
          {data.patient.deletionDueAt && (
            <Alert
              type="warning"
              showIcon
              style={{ marginBottom: 16 }}
              title={`The patient asked to delete their account. Their data is removed on ${dateTime(
                data.patient.deletionDueAt,
              )} unless they log in again before then.`}
            />
          )}
          <Card size="small" style={{ marginBottom: 16 }}>
            <Descriptions
              size="small"
              column={{ xs: 1, md: 2 }}
              items={[
                {
                  key: "phone",
                  label: "Phone",
                  children: <a href={`tel:${data.patient.phone}`}>{phone(data.patient.phone)}</a>,
                },
                {
                  key: "dob",
                  label: "Date of birth",
                  children: date(data.dob),
                },
                {
                  key: "gender",
                  label: "Gender",
                  children: GENDER[data.gender] ?? "—",
                },
                {
                  key: "language",
                  label: "App language",
                  children: LANGUAGE[data.language] ?? data.language,
                },
                {
                  key: "joined",
                  label: "Joined",
                  children: dateTime(data.patient.createdAt),
                },
                {
                  key: "status",
                  label: "Status",
                  children: data.patient.blockedAt ? "blocked (patient app)" : data.patient.status.toLowerCase(),
                },
              ]}
            />
          </Card>

          <Card size="small" title="Family members" style={{ marginBottom: 16 }}>
            <Table<Member>
              rowKey="id"
              size="small"
              pagination={false}
              dataSource={data.members}
              scroll={{ x: true }}
              columns={[
                {
                  title: "Relation",
                  key: "relation",
                  render: (_, m) => RELATION[m.relation] ?? m.relation,
                },
                {
                  title: "Name",
                  key: "name",
                  render: (_, m) => (
                    <>
                      {m.fullName || "—"} {!m.isActive && <Tag>Removed</Tag>}
                    </>
                  ),
                },
                { title: "Age", key: "age", render: (_, m) => m.age ?? "—" },
                {
                  title: "Gender",
                  key: "gender",
                  render: (_, m) => GENDER[m.gender] ?? "—",
                },
                {
                  title: "Phone",
                  key: "phone",
                  render: (_, m) => (m.phone ? <a href={`tel:${m.phone}`}>{phone(m.phone)}</a> : "—"),
                },
                {
                  title: "Language",
                  key: "language",
                  render: (_, m) => m.language || "—",
                },
              ]}
            />
            <Typography.Text type="secondary" style={{ fontSize: 12 }}>
              Health notes (conditions, allergies, getting around, hearing/vision) are not shown here: only the partner
              assigned to a booking sees them, during the job.
            </Typography.Text>
          </Card>

          <Card size="small" title="Addresses" style={{ marginBottom: 16 }}>
            <Table<Address>
              rowKey="id"
              size="small"
              pagination={false}
              dataSource={data.addresses}
              scroll={{ x: true }}
              columns={[
                {
                  title: "For",
                  key: "member",
                  render: (_, a) => memberName(a.memberId),
                },
                { title: "Label", dataIndex: "label", key: "label" },
                {
                  title: "Address",
                  key: "line1",
                  render: (_, a) => (
                    <>
                      <div>{a.line1}</div>
                      <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                        {[a.landmark, a.notes].filter(Boolean).join(" · ")}
                      </Typography.Text>
                    </>
                  ),
                },
                {
                  title: "Pin",
                  key: "pin",
                  render: (_, a) => (
                    <a href={mapLink(a.lat, a.lng)} target="_blank" rel="noreferrer">
                      map
                    </a>
                  ),
                },
                {
                  title: "Service area",
                  key: "area",
                  render: (_, a) =>
                    a.inServiceArea ? <Tag color="green">Inside</Tag> : <Tag color="orange">Outside</Tag>,
                },
              ]}
            />
          </Card>

          {data.bookingsVisible && (
            <Card
              size="small"
              title="Bookings"
              style={{ marginBottom: 16 }}
              extra={data.bookings.length >= 100 ? "The latest 100" : undefined}
            >
              <Table<BookingRow>
                rowKey="id"
                size="small"
                pagination={{ pageSize: 10, hideOnSinglePage: true }}
                dataSource={data.bookings}
                locale={{ emptyText: "No bookings yet" }}
                scroll={{ x: true }}
                columns={[
                  {
                    title: "Booking",
                    key: "code",
                    render: (_, b) =>
                      can("bookings.view") ? <Link href={`/bookings/${b.id}`}>{b.code}</Link> : b.code,
                  },
                  {
                    title: "Pickup",
                    key: "pickup",
                    render: (_, b) => dateTime(b.pickupAt),
                  },
                  {
                    title: "Service",
                    dataIndex: "serviceName",
                    key: "service",
                  },
                  {
                    title: "For",
                    key: "member",
                    render: (_, b) => b.memberName || "—",
                  },
                  {
                    title: "Status",
                    key: "status",
                    render: (_, b) => {
                      const st = BOOKING_STATUS[b.status as BookingStatus];
                      return <Tag color={st?.color}>{st?.label ?? b.status}</Tag>;
                    },
                  },
                ]}
              />
            </Card>
          )}

          {!data.documentsVisible && (
            <Alert
              type="info"
              showIcon
              title="Medical documents are visible only to roles that may open them (Super Admin, Operations)."
            />
          )}
          {data.documentsVisible && (
            <Card size="small" title="Documents">
              <Table<Doc>
                rowKey="id"
                size="small"
                pagination={{ pageSize: 10, hideOnSinglePage: true }}
                dataSource={data.documents}
                scroll={{ x: true }}
                columns={[
                  {
                    title: "For",
                    key: "member",
                    render: (_, d) => memberName(d.memberId),
                  },
                  {
                    title: "Type",
                    key: "type",
                    render: (_, d) => DOCUMENT_TYPE[d.type] ?? d.type,
                  },
                  { title: "Name", dataIndex: "title", key: "title" },
                  {
                    title: "Date",
                    key: "date",
                    render: (_, d) => date(d.date),
                  },
                  {
                    title: "Size",
                    key: "size",
                    render: (_, d) => bytes(d.sizeBytes),
                  },
                  {
                    title: "Uploaded",
                    key: "created",
                    render: (_, d) => dateTime(d.createdAt),
                  },
                  {
                    title: "",
                    key: "open",
                    render: (_, d) =>
                      can("patients.documents") ? (
                        <Button
                          size="small"
                          icon={<EyeOutlined />}
                          onClick={() => {
                            form.resetFields();
                            setOpening(d);
                          }}
                        >
                          Open
                        </Button>
                      ) : null,
                  },
                ]}
              />
            </Card>
          )}

          <Modal
            title="Open a patient's document"
            open={opening !== null}
            onCancel={() => setOpening(null)}
            onOk={() => form.submit()}
            okText="Open"
            okButtonProps={{ loading: busy }}
            destroyOnHidden
          >
            <Typography.Paragraph type="secondary">
              Medical documents are private. Say why you need to open this one; it is written to the audit log with your
              name.
            </Typography.Paragraph>
            <Form form={form} layout="vertical" onFinish={({ reason }) => openDocument(reason)}>
              <Form.Item
                name="reason"
                label="Reason"
                rules={[
                  {
                    required: true,
                    min: 5,
                    max: 300,
                    message: "Write why you need it (5+ letters).",
                  },
                ]}
              >
                <Input.TextArea autoSize={{ minRows: 2 }} placeholder="Checking the prescription before assigning" />
              </Form.Item>
            </Form>
          </Modal>
          <Modal
            title={shown?.title}
            open={shown !== null}
            onCancel={() => setShown(null)}
            footer={
              shown && (
                <a href={shown.url} target="_blank" rel="noopener noreferrer">
                  Open in a new tab
                </a>
              )
            }
            width={900}
            destroyOnHidden
          >
            {shown?.mime === "application/pdf" ? (
              <iframe title="Document" src={shown.url} style={{ width: "100%", height: 600, border: 0 }} />
            ) : (
              shown && <Image src={shown.url} alt={shown.title} style={{ maxHeight: 600, objectFit: "contain" }} />
            )}
            <Typography.Text type="secondary" style={{ fontSize: 12 }}>
              The link works for 5 minutes.
            </Typography.Text>
          </Modal>
        </>
      )}
    </Page>
  );
}
