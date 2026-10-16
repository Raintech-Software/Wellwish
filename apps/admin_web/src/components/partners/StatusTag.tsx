import { Tag } from "antd";

import { DOC_STATUS, STATUS } from "@/lib/partners";

export function PartnerStatusTag({ status }: { status: string }) {
  const s = STATUS[status] ?? { label: status, color: "default" };
  return <Tag color={s.color}>{s.label}</Tag>;
}

export function DocStatusTag({ status }: { status: string }) {
  const s = DOC_STATUS[status] ?? { label: status, color: "default" };
  return <Tag color={s.color}>{s.label}</Tag>;
}
