"use client";

import { FileSearchOutlined } from "@ant-design/icons";
import { Alert, Empty, Image, Spin, Typography } from "antd";
import { useEffect, useState } from "react";

import { api } from "@/api/client";
import { colors } from "@/theme";

interface Shown {
  id: string;
  url: string;
  mime: string;
}

/**
 * Shows one partner document (image or PDF) from a 5-minute link. Opening it is written to the
 * audit log by the server (§12), so it only loads when an admin picks a document.
 */
export default function DocumentViewer({ documentId, height = 560 }: { documentId: string | null; height?: number }) {
  const [shown, setShown] = useState<Shown | null>(null);
  const [failedFor, setFailedFor] = useState<string | null>(null);

  useEffect(() => {
    if (!documentId) return;
    let current = true;
    void api
      .GET("/v1/admin/partner-documents/{document_id}/view-url", { params: { path: { document_id: documentId } } })
      .then(({ data }) => {
        if (!current) return;
        if (data) setShown({ id: documentId, ...data });
        else setFailedFor(documentId);
      });
    return () => {
      current = false;
    };
  }, [documentId]);

  const box = {
    height,
    border: `1px solid ${colors.border}`,
    borderRadius: 10,
    background: colors.background,
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    overflow: "hidden",
    position: "relative",
  } as const;

  if (!documentId) {
    return (
      <div style={box}>
        <Empty image={<FileSearchOutlined style={{ fontSize: 48, color: colors.textSecondary }} />} description="Pick a document to see it here" />
      </div>
    );
  }
  if (failedFor === documentId) {
    return <Alert type="error" showIcon title="Couldn't open this document. Try again." />;
  }
  if (!shown || shown.id !== documentId) {
    return (
      <div style={box}>
        <Spin />
      </div>
    );
  }
  if (shown.mime === "application/pdf") {
    return (
      <div style={{ ...box, display: "block" }}>
        <iframe title="Document" src={shown.url} style={{ width: "100%", height: "100%", border: 0 }} />
      </div>
    );
  }
  return (
    <div style={box}>
      <Image src={shown.url} alt="Document" style={{ maxHeight: height - 16, objectFit: "contain" }} />
      <Typography.Text type="secondary" style={{ position: "absolute", bottom: 8, fontSize: 12 }}>
        Click the image to zoom
      </Typography.Text>
    </div>
  );
}
