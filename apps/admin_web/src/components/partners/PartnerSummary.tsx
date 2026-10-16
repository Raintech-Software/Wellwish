"use client";

import { EnvironmentOutlined, MailOutlined, PhoneOutlined } from "@ant-design/icons";
import { Avatar, Button, Descriptions, Flex, Space, Tag, Typography } from "antd";

import type { components } from "@/api/schema";
import { PartnerStatusTag } from "@/components/partners/StatusTag";
import { age, GENDER_LABEL, phone, ROLE_LABEL } from "@/lib/partners";

type Profile = components["schemas"]["PartnerProfileOut"];

function CallButton({ number, label }: { number: string; label: string }) {
  return (
    <Button size="small" icon={<PhoneOutlined />} href={`tel:${number}`}>
      {label}
    </Button>
  );
}

/** Who the partner is: photo, role, status, both phones (call buttons), email, address, details. */
export default function PartnerSummary({ partner }: { partner: Profile }) {
  const primary = partner.phones.find((p) => p.kind === "PRIMARY");
  const alternate = partner.phones.find((p) => p.kind === "ALTERNATE");
  const verified = (ok: boolean) => (ok ? <Tag color="success">Verified</Tag> : <Tag color="warning">Not verified</Tag>);
  return (
    <>
      <Flex gap={16} align="center" wrap style={{ marginBottom: 16 }}>
        <Avatar size={72} src={partner.photoUrl || undefined}>
          {partner.fullName.charAt(0) || "?"}
        </Avatar>
        <div>
          <Typography.Title level={4} style={{ margin: 0 }}>
            {partner.fullName || "(no name yet)"}
          </Typography.Title>
          <Space size={4} wrap style={{ marginTop: 4 }}>
            <Tag color={partner.role === "NURSE" ? "green" : "blue"}>{ROLE_LABEL[partner.role] ?? partner.role}</Tag>
            <PartnerStatusTag status={partner.status} />
            {partner.addedByAdmin && <Tag>Added by admin</Tag>}
            {partner.availableToday && <Tag color="cyan">Available today</Tag>}
          </Space>
        </div>
      </Flex>
      <Descriptions
        size="small"
        column={{ xs: 1, sm: 1, md: 2 }}
        bordered
        items={[
          {
            key: "primary",
            label: "Login phone",
            children: primary ? (
              <Space wrap>
                {phone(primary.phone)} {verified(primary.verified)}
                <CallButton number={primary.phone} label="Call" />
              </Space>
            ) : (
              "—"
            ),
          },
          {
            key: "alternate",
            label: "Alternate phone",
            children: alternate ? (
              <Space wrap>
                {phone(alternate.phone)} {verified(alternate.verified)}
                <CallButton number={alternate.phone} label="Call" />
              </Space>
            ) : (
              "—"
            ),
          },
          {
            key: "email",
            label: "Email",
            children: partner.email ? (
              <Space wrap>
                <a href={`mailto:${partner.email}`}>
                  <MailOutlined /> {partner.email}
                </a>
                {verified(partner.emailVerified)}
              </Space>
            ) : (
              "—"
            ),
          },
          { key: "dob", label: "Age / DOB", children: partner.dob ? `${age(partner.dob)} (${partner.dob})` : "—" },
          { key: "gender", label: "Gender", children: GENDER_LABEL[partner.gender] ?? "—" },
          {
            key: "address",
            label: "Home address",
            span: "filled",
            children: (
              <>
                {partner.address || "—"}{" "}
                {partner.lat && partner.lng && (
                  <Typography.Link
                    href={`https://www.openstreetmap.org/?mlat=${partner.lat}&mlon=${partner.lng}#map=16/${partner.lat}/${partner.lng}`}
                    target="_blank"
                    rel="noreferrer"
                  >
                    <EnvironmentOutlined /> map
                  </Typography.Link>
                )}
              </>
            ),
          },
          { key: "languages", label: "Languages", children: partner.languages.join(", ") || "—" },
          { key: "skills", label: "Skills", children: partner.skills.join(", ") || "—" },
          {
            key: "emergency",
            label: "Emergency contact",
            span: "filled",
            children: partner.emergencyName ? (
              <Space wrap>
                {partner.emergencyName} · {phone(partner.emergencyPhone)}
                <CallButton number={partner.emergencyPhone} label="Call" />
              </Space>
            ) : (
              "—"
            ),
          },
        ]}
      />
    </>
  );
}
