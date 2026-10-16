import { redirect } from "next/navigation";

/** The fee report moved to Reports → Fees collected (Phase 9.2); old links still work. */
export default function FeeReportMoved() {
  redirect("/reports/fees");
}
