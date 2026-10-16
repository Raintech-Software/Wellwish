"use client";

import { Alert, DatePicker, Flex, Input, Segmented, Select, Table, Tag, Typography } from "antd";
import type { Dayjs } from "dayjs";
import Link from "next/link";
import { useCallback, useState } from "react";

import { api } from "@/api/client";
import type { components, paths } from "@/api/schema";
import { useCan } from "@/auth/AuthProvider";
import Page from "@/components/Page";
import { BOOKING_STATUS, type BookingStatus, PARTNER_TYPE } from "@/lib/bookings";
import { dateTime, rupees } from "@/lib/format";
import { phone } from "@/lib/partners";
import { useLoad } from "@/lib/useLoad";

type Row = components["schemas"]["AdminBookingRowOut"];
type When = "upcoming" | "today" | "tomorrow" | "later" | "past";
type Status = NonNullable<paths["/v1/admin/bookings"]["get"]["parameters"]["query"]>["status"];

const PAGE_SIZE = 20;

/**
 * All bookings (§9.1, PHASES 5.14): soonest pickup first, filters by when, status, type, date
 * and a search. Unpaid and expired bookings show only when picked in the status filter.
 * Read-only for now: assign, cancel and reschedule come in Phases 6 and 7.
 */
export default function BookingsPage() {
  const can = useCan();
  const [when, setWhen] = useState<When>("upcoming");
  const [status, setStatus] = useState<Status>(undefined);
  const [type, setType] = useState<"COMPANION" | "NURSE" | undefined>(undefined);
  const [temporary, setTemporary] = useState<boolean | undefined>(undefined); // §6.19
  const [day, setDay] = useState<Dayjs | null>(null);
  const [q, setQ] = useState("");
  const [text, setText] = useState(""); // what is typed in the search box
  const [page, setPage] = useState(1);
  const fetchPage = useCallback(
    async () =>
      (
        await api.GET("/v1/admin/bookings", {
          params: {
            query: {
              when: day || q ? undefined : when, // a picked date or a search looks at every date
              status,
              type,
              date: day ? day.format("YYYY-MM-DD") : undefined,
              q: q || undefined,
              temporary,
              page,
              pageSize: PAGE_SIZE,
            },
          },
        })
      ).data,
    [when, status, type, day, q, temporary, page],
  );
  const { data, failed, loading } = useLoad(fetchPage, can("bookings.view"));
  const reset = () => setPage(1);

  return (
    <Page
      title="All bookings"
      permission="bookings.view"
      description="Upcoming bookings first (and any unfinished one whose time has passed), or the past ones, latest first. Times are India time. Unpaid and expired bookings are hidden unless picked in the status filter or found by their code."
    >
      {failed && <Alert type="error" showIcon title="Couldn't load the bookings. Reload the page." />}
      <Flex gap={8} wrap align="center" style={{ marginBottom: 16 }}>
        <Segmented<When>
          value={day || q ? undefined : when}
          options={[
            { label: "Upcoming", value: "upcoming" },
            { label: "Today", value: "today" },
            { label: "Tomorrow", value: "tomorrow" },
            { label: "Later", value: "later" },
            { label: "Past", value: "past" },
          ]}
          onChange={(value) => {
            // A When view replaces a picked date and a search (they look at every date).
            setWhen(value);
            setDay(null);
            setQ("");
            setText("");
            reset();
          }}
        />
        <Select<Status>
          allowClear
          placeholder="Status"
          style={{ width: 200 }}
          value={status}
          options={Object.entries(BOOKING_STATUS).map(([value, s]) => ({
            value: value as Status,
            label: s.label,
          }))}
          onChange={(value) => {
            setStatus(value);
            reset();
          }}
        />
        <Select<"COMPANION" | "NURSE">
          allowClear
          placeholder="Companion or nurse"
          style={{ width: 180 }}
          value={type}
          options={[
            { value: "COMPANION", label: "Companion" },
            { value: "NURSE", label: "Nurse" },
          ]}
          onChange={(value) => {
            setType(value);
            reset();
          }}
        />
        <Select<"yes" | "no">
          allowClear
          placeholder="Any partner"
          style={{ width: 190 }}
          value={temporary === undefined ? undefined : temporary ? "yes" : "no"}
          options={[
            { value: "yes", label: "Temporary partner" },
            { value: "no", label: "No temporary partner" },
          ]}
          onChange={(value) => {
            setTemporary(value === undefined ? undefined : value === "yes");
            reset();
          }}
        />
        <DatePicker
          placeholder="Pickup date"
          value={day}
          format="D MMM YYYY"
          onChange={(value) => {
            setDay(value);
            reset();
          }}
        />
        <Input.Search
          allowClear
          maxLength={40}
          placeholder="WW-10001, phone or member name"
          style={{ width: 260 }}
          value={text}
          onChange={(event) => setText(event.target.value)}
          onSearch={(value) => {
            setQ(value.trim());
            reset();
          }}
        />
      </Flex>
      <Table<Row>
        rowKey="id"
        loading={loading}
        dataSource={data?.items ?? []}
        locale={{ emptyText: "No bookings here" }}
        scroll={{ x: true }}
        pagination={{
          current: page,
          pageSize: PAGE_SIZE,
          total: data?.count ?? 0,
          showSizeChanger: false,
          onChange: setPage,
          showTotal: (total) => (total === 1 ? "1 booking" : `${total} bookings`),
        }}
        columns={[
          {
            title: "Booking",
            key: "code",
            render: (_, r) => (
              <Link href={`/bookings/${r.id}`}>
                <div style={{ fontWeight: 500, whiteSpace: "nowrap" }}>{r.code}</div>
                {r.temporaryPartner && <Tag color="purple">Temporary partner</Tag>}
              </Link>
            ),
          },
          {
            title: "Pickup",
            key: "pickup",
            render: (_, r) => (
              <>
                <div>{dateTime(r.pickupAt)}</div>
                {r.appointmentAt && (
                  <Typography.Text type="secondary">Appointment {dateTime(r.appointmentAt)}</Typography.Text>
                )}
              </>
            ),
          },
          {
            title: "Service",
            key: "service",
            render: (_, r) => (
              <>
                <div>{r.serviceName}</div>
                <Typography.Text type="secondary">{PARTNER_TYPE[r.partnerType] ?? r.partnerType}</Typography.Text>
              </>
            ),
          },
          {
            title: "For",
            key: "member",
            render: (_, r) => r.memberName || "—",
          },
          {
            title: "Booked by",
            key: "patient",
            render: (_, r) =>
              r.patientDeleted ? (
                <Typography.Text type="secondary">Account deleted</Typography.Text>
              ) : (
                <a href={`tel:${r.patientPhone}`} style={{ whiteSpace: "nowrap" }}>
                  {phone(r.patientPhone)}
                </a>
              ),
          },
          {
            title: "Hospital",
            key: "hospital",
            render: (_, r) => r.hospitalName || "—",
          },
          {
            title: "Booking fee",
            key: "fee",
            render: (_, r) => rupees(r.bookingFeePaise),
          },
          {
            title: "Status",
            key: "status",
            render: (_, r) => {
              const s = BOOKING_STATUS[r.status as BookingStatus];
              return <Tag color={s?.color}>{s?.label ?? r.status}</Tag>;
            },
          },
        ]}
      />
    </Page>
  );
}
