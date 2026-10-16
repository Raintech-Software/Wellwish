"use client";

import { DownloadOutlined } from "@ant-design/icons";
import { App, Button, DatePicker, Flex, Typography } from "antd";
import dayjs, { type Dayjs } from "dayjs";
import { useState } from "react";

import { errorMessage } from "@/lib/errors";
import { saveFile } from "@/lib/payments";

export type Range = [Dayjs, Dayjs];

/** This month so far: what every report shows first (§9.1 Reports). */
export function thisMonth(): Range {
  return [dayjs().startOf("month"), dayjs()];
}

export function rangeQuery(range: Range): { from: string; to: string } {
  return { from: range[0].format("YYYY-MM-DD"), to: range[1].format("YYYY-MM-DD") };
}

/**
 * The reports' dates (India dates, at most a year) and "Download CSV" (Phase 9.2). The CSV is the
 * same report, for Excel or Google Sheets; every download is written to the audit log.
 */
export default function ReportToolbar({
  range,
  onRange,
  download,
  filename,
  note,
}: {
  range: Range;
  onRange: (range: Range) => void;
  /** Asks the server for the CSV (as a blob). */
  download: () => Promise<{ data?: unknown; error?: unknown }>;
  filename: string;
  note?: string;
}) {
  const { message } = App.useApp();
  const [busy, setBusy] = useState(false);

  const save = async () => {
    if (busy) return;
    setBusy(true);
    try {
      const { data, error } = await download();
      if (error || !data) {
        message.error(errorMessage(error, "Couldn't make the file. Please try again."));
        return;
      }
      saveFile(data as Blob, filename);
    } catch {
      message.error("Couldn't reach the server. Please try again.");
    } finally {
      setBusy(false);
    }
  };

  return (
    <Flex gap={12} align="center" wrap style={{ marginBottom: 16 }}>
      <DatePicker.RangePicker
        value={range}
        format="D MMM YYYY"
        allowClear={false}
        disabledDate={(day) => day.isAfter(dayjs(), "day")}
        onChange={(value) => value?.[0] && value[1] && onRange([value[0], value[1]])}
      />
      <Button icon={<DownloadOutlined />} loading={busy} onClick={() => void save()}>
        Download CSV
      </Button>
      {note && <Typography.Text type="secondary">{note}</Typography.Text>}
    </Flex>
  );
}
