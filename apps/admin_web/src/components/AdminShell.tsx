"use client";

import {
  AppstoreOutlined,
  BarChartOutlined,
  BankOutlined,
  CalendarOutlined,
  CustomerServiceOutlined,
  DashboardOutlined,
  EnvironmentOutlined,
  KeyOutlined,
  LogoutOutlined,
  SafetyCertificateOutlined,
  SettingOutlined,
  TeamOutlined,
  UserOutlined,
  WalletOutlined,
} from "@ant-design/icons";
import { Alert, Avatar, Button, Dropdown, Layout, Menu, Space, Tag, Typography } from "antd";
import type { MenuProps } from "antd";
import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useMemo, useState, type ReactNode } from "react";

import { useCan, useSession } from "@/auth/AuthProvider";
import { logout } from "@/auth/session";
import { APP_ENV } from "@/config/env";
import { visibleMenu, type IconKey } from "@/config/menu";
import LiveAlerts from "@/components/LiveAlerts";
import { RecoveryCodesModal } from "@/components/RecoveryCodes";
import { colors } from "@/theme";

const ICONS: Record<IconKey, ReactNode> = {
  dashboard: <DashboardOutlined />,
  reports: <BarChartOutlined />,
  bookings: <CalendarOutlined />,
  live: <EnvironmentOutlined />,
  partners: <TeamOutlined />,
  services: <AppstoreOutlined />,
  directory: <BankOutlined />,
  patients: <UserOutlined />,
  payments: <WalletOutlined />,
  support: <CustomerServiceOutlined />,
  settings: <SettingOutlined />,
  system: <SafetyCertificateOutlined />,
};

const ENV = APP_ENV;

/** Sidebar (only the pages this role may see, §9.2) + header with the signed-in staff member. */
export default function AdminShell({ children }: { children: ReactNode }) {
  const pathname = usePathname() || "/";
  const { staff } = useSession();
  const can = useCan();
  const menu = useMemo(() => visibleMenu(can), [can]);
  const [collapsed, setCollapsed] = useState(false);
  const [codesOpen, setCodesOpen] = useState(false);

  const items: MenuProps["items"] = menu.map((section) =>
    section.pages.length === 1
      ? {
          key: section.pages[0].path,
          icon: ICONS[section.icon],
          label: <Link href={section.pages[0].path}>{section.label}</Link>,
        }
      : {
          key: section.key,
          icon: ICONS[section.icon],
          label: section.label,
          children: section.pages.map((page) => ({
            key: page.path,
            label: <Link href={page.path}>{page.label}</Link>,
          })),
        },
  );
  const openSection = menu.find((s) => s.pages.length > 1 && s.pages.some((p) => p.path === pathname));

  const userMenu: MenuProps["items"] = [
    {
      key: "recovery-codes",
      icon: <KeyOutlined />,
      label: `Recovery codes (${staff?.recoveryCodesLeft ?? 0} left)`,
      onClick: () => setCodesOpen(true),
    },
    {
      key: "logout",
      icon: <LogoutOutlined />,
      label: "Sign out",
      danger: true,
      onClick: () => void logout("logout"),
    },
  ];

  return (
    <Layout style={{ minHeight: "100vh" }}>
      <Layout.Sider
        width={248}
        breakpoint="lg"
        collapsedWidth={64}
        collapsed={collapsed}
        onBreakpoint={setCollapsed}
        trigger={null}
        style={{ borderRight: `1px solid ${colors.border}` }}
      >
        <Link
          href="/"
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: collapsed ? "center" : "flex-start",
            gap: 10,
            padding: collapsed ? "18px 0" : "18px 20px",
          }}
        >
          <Image src="/logo_mark.png" alt="WellWish" width={36} height={30} priority />
          {!collapsed && (
            <span style={{ fontWeight: 700, fontSize: 20, letterSpacing: -0.3 }}>
              <span style={{ color: colors.brandBlue }}>Well</span>
              <span style={{ color: colors.brandGreen }}>Wish</span>
            </span>
          )}
        </Link>
        <Menu
          mode="inline"
          items={items}
          selectedKeys={[pathname]}
          defaultOpenKeys={openSection ? [openSection.key] : []}
          style={{ borderInlineEnd: "none" }}
        />
      </Layout.Sider>
      <Layout>
        <Layout.Header
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            borderBottom: `1px solid ${colors.border}`,
            paddingInline: 24,
          }}
        >
          <Space>
            <Typography.Text strong>WellWish Admin</Typography.Text>
            <Tag color={ENV === "prod" ? "red" : "blue"}>{ENV}</Tag>
          </Space>
          <Dropdown menu={{ items: userMenu }} trigger={["click"]}>
            <Space style={{ cursor: "pointer" }} data-testid="user-menu">
              <span style={{ display: "flex", flexDirection: "column", textAlign: "right", lineHeight: 1.3 }}>
                <Typography.Text strong>
                  {staff?.name}
                </Typography.Text>
                <Typography.Text type="secondary" style={{ fontSize: 12 }}>
                  {staff?.role.name}
                </Typography.Text>
              </span>
              <Avatar style={{ background: colors.primary }}>
                {staff?.name?.charAt(0).toUpperCase() ?? <UserOutlined />}
              </Avatar>
            </Space>
          </Dropdown>
        </Layout.Header>
        <Layout.Content style={{ padding: 24 }}>
          {/* sign-in recovery (§6.4, v2.16): never a dead end if the phone is lost */}
          {staff && staff.recoveryCodesLeft === 0 && (
            <Alert
              type="warning"
              showIcon
              style={{ marginBottom: 16 }}
              title="You have no recovery codes. If you lose your phone, you couldn't sign in."
              action={
                <Button size="small" onClick={() => setCodesOpen(true)}>
                  Make codes
                </Button>
              }
            />
          )}
          {staff && staff.recoveryCodesLeft > 0 && !staff.recoveryCodesSaved && (
            <Alert
              type="warning"
              showIcon
              style={{ marginBottom: 16 }}
              title="Your recovery codes were shown but you didn't confirm saving them. Make new ones and save them."
              action={
                <Button size="small" onClick={() => setCodesOpen(true)}>
                  Make new codes
                </Button>
              }
            />
          )}
          {staff?.onlySuperAdmin && (
            <Alert
              type="warning"
              showIcon
              style={{ marginBottom: 16 }}
              title="You're the only Super Admin. Add a second one (System → Admin users), so someone can reset your 2FA if you lose your phone."
            />
          )}
          <RecoveryCodesModal open={codesOpen} onClose={() => setCodesOpen(false)} />
          <LiveAlerts />
          {children}
        </Layout.Content>
      </Layout>
    </Layout>
  );
}
