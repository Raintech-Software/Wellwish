import type { ThemeConfig } from "antd";

/** Same tokens as packages/ww_ui/lib/src/tokens.dart (brand colours from the official logo). */
export const colors = {
  primary: "#0072E4",
  brandBlue: "#0062D6",
  brandGreen: "#14965E",
  brandNavy: "#0B4266",
  textPrimary: "#0F2547",
  textSecondary: "#6B7785",
  background: "#F5F9FF",
  surface: "#FFFFFF",
  border: "#E3EAF3",
  tint: "#EAF2FF",
  danger: "#E53935",
  gold: "#F4B400",
};

export const theme: ThemeConfig = {
  token: {
    colorPrimary: colors.primary,
    colorSuccess: colors.brandGreen,
    colorError: colors.danger,
    colorText: colors.textPrimary,
    colorTextSecondary: colors.textSecondary,
    colorBorder: colors.border,
    colorBorderSecondary: colors.border,
    colorBgLayout: colors.background,
    borderRadius: 10,
    fontFamily: "var(--font-poppins), system-ui, -apple-system, 'Segoe UI', sans-serif",
  },
  components: {
    Layout: { siderBg: colors.surface, headerBg: colors.surface, bodyBg: colors.background },
    Menu: { itemSelectedBg: colors.tint, itemSelectedColor: colors.primary },
  },
};
