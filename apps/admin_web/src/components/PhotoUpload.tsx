"use client";

import { DeleteOutlined, UploadOutlined } from "@ant-design/icons";
import { App, Button, Flex, Image, Typography } from "antd";
import { useEffect, useState } from "react";

import { api } from "@/api/client";
import { sendToStorage } from "@/components/FileUpload";
import { errorMessage } from "@/lib/errors";

const TYPES = ["image/jpeg", "image/png", "image/webp"];
const MAX_BYTES = 5 * 1024 * 1024;

/**
 * Photo field for the directory (ARCHITECTURE §6.8 upload flow): ask the API for an upload
 * URL, PUT the file there, then keep the returned file key in the form. The server checks the
 * real file type when the form is saved. Works as an antd Form field (value = file key).
 */
export default function PhotoUpload({
  purpose,
  value,
  onChange,
  currentUrl,
}: {
  purpose: "hospital_photo" | "doctor_photo" | "partner_photo";
  value?: string;
  onChange?: (fileKey: string) => void;
  /** Link to the saved photo (from the API), shown until a new one is picked. */
  currentUrl?: string | null;
}) {
  const { message } = App.useApp();
  const [preview, setPreview] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  useEffect(() => () => {
    if (preview) URL.revokeObjectURL(preview);
  }, [preview]);

  const pick = () => {
    const input = document.createElement("input");
    input.type = "file";
    input.accept = TYPES.join(",");
    input.onchange = () => {
      const file = input.files?.[0];
      if (file) void upload(file);
    };
    input.click();
  };

  const upload = async (file: File) => {
    if (!TYPES.includes(file.type)) {
      message.error("Choose a JPG, PNG or WebP photo.");
      return;
    }
    if (file.size > MAX_BYTES) {
      message.error("The photo is too large (max 5 MB).");
      return;
    }
    setBusy(true);
    try {
      const { data, error } = await api.POST("/v1/admin/files/upload-url", {
        body: { purpose, mime: file.type, sizeBytes: file.size },
      });
      if (!data) throw error;
      await sendToStorage(data, file);
      setPreview(URL.createObjectURL(file));
      onChange?.(data.fileKey);
    } catch (err) {
      message.error(errorMessage(err, "Upload failed. Please try again."));
    } finally {
      setBusy(false);
    }
  };

  const shown = preview ?? (value ? currentUrl : null);
  return (
    <Flex gap={12} align="center" wrap>
      {shown ? (
        <Image src={shown} alt="" width={96} height={72} style={{ objectFit: "cover", borderRadius: 8 }} />
      ) : (
        <Typography.Text type="secondary">No photo</Typography.Text>
      )}
      <Button icon={<UploadOutlined />} onClick={pick} loading={busy}>
        {value ? "Change photo" : "Upload photo"}
      </Button>
      {value && (
        <Button
          icon={<DeleteOutlined />}
          onClick={() => {
            setPreview(null);
            onChange?.("");
          }}
        >
          Remove
        </Button>
      )}
    </Flex>
  );
}
