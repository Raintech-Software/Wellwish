"use client";

import { Result } from "antd";

/** Shown when a staff member opens a page their role doesn't allow (§9.2). */
export default function Forbidden() {
  return (
    <Result
      status="403"
      title="No access"
      subTitle="Your role doesn't include this page. Ask a Super Admin if you need it."
    />
  );
}
