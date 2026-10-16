"use client";

import { CheckCircleFilled, UploadOutlined } from "@ant-design/icons";
import { App, Button, Flex, Typography } from "antd";
import { useState } from "react";

import { api, API_BASE_URL } from "@/api/client";
import { errorMessage } from "@/lib/errors";
import { colors } from "@/theme";

type Purpose = "hospital_photo" | "doctor_photo" | "partner_photo" | "kyc_document" | "temp_partner_id";

const TYPES: Record<Purpose, string[]> = {
  hospital_photo: ["image/jpeg", "image/png", "image/webp"],
  doctor_photo: ["image/jpeg", "image/png", "image/webp"],
  partner_photo: ["image/jpeg", "image/png", "image/webp"],
  kyc_document: ["image/jpeg", "image/png", "image/webp", "application/pdf"],
  temp_partner_id: ["image/jpeg", "image/png", "image/webp", "application/pdf"], // §6.19
};
const MAX_MB: Record<Purpose, number> = {
  hospital_photo: 5,
  doctor_photo: 5,
  partner_photo: 5,
  kyc_document: 10,
  temp_partner_id: 10,
};

/**
 * Step 2 of every upload (ARCHITECTURE §6.8, v2.31): a form POST with the ticket's signed fields
 * first and the file last. The storage itself refuses a bigger file or another type. A path
 * (local dev storage) is on the API; a full URL is S3.
 */
export async function sendToStorage(
  ticket: { uploadUrl: string; uploadFields: Record<string, string> },
  file: File,
): Promise<void> {
  const target = ticket.uploadUrl.startsWith("/") ? `${API_BASE_URL}${ticket.uploadUrl}` : ticket.uploadUrl;
  const form = new FormData();
  for (const [name, value] of Object.entries(ticket.uploadFields)) form.append(name, value);
  form.append("file", file);
  const sent = await fetch(target, { method: "POST", body: form });
  if (!sent.ok) throw await sent.json().catch(() => undefined); // S3 answers in XML
}

/** Ask for an upload URL, send the file there, return the file key (ARCHITECTURE §6.8). */
export async function uploadFile(purpose: Purpose, file: File): Promise<string> {
  if (!TYPES[purpose].includes(file.type)) {
    const document = purpose === "kyc_document" || purpose === "temp_partner_id";
    throw { error: { message: document ? "Choose a photo (JPG, PNG) or a PDF." : "Choose a JPG, PNG or WebP photo." } };
  }
  if (file.size > MAX_MB[purpose] * 1024 * 1024) {
    throw { error: { message: `The file is too large (max ${MAX_MB[purpose]} MB).` } };
  }
  const { data, error } = await api.POST("/v1/admin/files/upload-url", {
    body: { purpose, mime: file.type, sizeBytes: file.size },
  });
  if (!data) throw error;
  await sendToStorage(data, file);
  return data.fileKey;
}

/** A form field holding a file key: pick a file, it uploads, shows its name. */
export default function FileUpload({
  purpose,
  value,
  onChange,
  label = "Upload",
}: {
  purpose: Purpose;
  value?: string;
  onChange?: (fileKey: string) => void;
  label?: string;
}) {
  const { message } = App.useApp();
  const [busy, setBusy] = useState(false);
  const [name, setName] = useState<string | null>(null);

  const pick = () => {
    const input = document.createElement("input");
    input.type = "file";
    input.accept = TYPES[purpose].join(",");
    input.onchange = async () => {
      const file = input.files?.[0];
      if (!file) return;
      setBusy(true);
      try {
        onChange?.(await uploadFile(purpose, file));
        setName(file.name);
      } catch (err) {
        message.error(errorMessage(err, "Upload failed. Please try again."));
      } finally {
        setBusy(false);
      }
    };
    input.click();
  };

  return (
    <Flex gap={8} align="center" wrap>
      <Button icon={<UploadOutlined />} onClick={pick} loading={busy}>
        {value ? "Replace" : label}
      </Button>
      {value && (
        <Typography.Text type="secondary" ellipsis style={{ maxWidth: 220 }}>
          <CheckCircleFilled style={{ color: colors.brandGreen }} /> {name ?? "Uploaded"}
        </Typography.Text>
      )}
    </Flex>
  );
}
