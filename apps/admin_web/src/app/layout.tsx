import type { Metadata } from "next";
import { Poppins } from "next/font/google";
import { AntdRegistry } from "@ant-design/nextjs-registry";
import { connection } from "next/server";
import { App, ConfigProvider } from "antd";

import { AuthProvider } from "@/auth/AuthProvider";
import { Monitoring } from "@/components/Monitoring";
import { theme } from "@/theme";
import "./globals.css";

const poppins = Poppins({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-poppins",
});

export const metadata: Metadata = {
  title: "WellWish Admin",
  description: "WellWish operations panel",
  robots: { index: false, follow: false },
};

export default async function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  // Rendered per request: the page's scripts carry that request's CSP nonce (src/proxy.ts).
  await connection();
  return (
    <html lang="en" className={poppins.variable}>
      <body>
        <Monitoring />
        <AntdRegistry>
          <ConfigProvider theme={theme}>
            {/* App gives pages themed message/modal hooks (App.useApp). */}
            <App>
              <AuthProvider>{children}</AuthProvider>
            </App>
          </ConfigProvider>
        </AntdRegistry>
      </body>
    </html>
  );
}
