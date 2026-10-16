"use client";

import { App, Button, Tag } from "antd";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

import { api } from "@/api/client";
import { useCan } from "@/auth/AuthProvider";
import { ALERT_KIND, DECLINE_REASON } from "@/lib/assignments";
import { alarm, chime, onLiveMessage, onLiveState, soundBlocked, startLive, stopLive } from "@/lib/staffSocket";
import { farStepNote, SOS_SIDE } from "@/lib/visit";

/** How often an open SOS sounds again (§6.15: "alarm until someone acknowledges"). */
const SOS_REPEAT_MS = 4000;

/**
 * Live queue and alerts for the whole panel (§6.10, §10.4): a chime and a note for each newly
 * paid booking, and a banner that stays for "not accepted in 2 minutes", "declined" and "past
 * the deadline" (with a button to the booking). A "not accepted in 2 minutes" banner closes by
 * itself once that offer is answered, reassigned or withdrawn; any alert's banner closes on
 * every screen once someone marks it as seen. Reviewers get new partner applications. During
 * visits (§6.15): an SOS sounds an alarm again and again, on every page, until someone
 * acknowledges it (also one raised while this page was closed or offline); the visit's alerts
 * (no location, fake GPS, visit code locked, patient not available, not completed) stay until
 * seen; support staff hear about new tickets.
 */
export default function LiveAlerts() {
  const can = useCan();
  const router = useRouter();
  const { notification } = App.useApp();
  const ops = can("bookings.view") || can("live.view");
  const live = can("live.view");
  const support = can("support.manage");
  const reviewer = can("partners.review");
  const [offline, setOffline] = useState(false);
  const [needsClick, setNeedsClick] = useState(false);

  // "Live updates offline" when the socket is down for more than 10 s (it keeps reconnecting).
  useEffect(() => {
    let timer: ReturnType<typeof setTimeout> | null = null;
    const off = onLiveState((online) => {
      if (timer) clearTimeout(timer);
      timer = null;
      if (online) setOffline(false);
      else timer = setTimeout(() => setOffline(true), 10_000);
    });
    return () => {
      off();
      if (timer) clearTimeout(timer);
    };
  }, []);

  useEffect(() => {
    if (!ops && !reviewer && !support) return;
    startLive();
    const timeouts = new Map<string, string>(); // booking id → its open "2 minutes" banner
    const openSos = new Set<string>(); // SOS ids still OPEN: the alarm repeats while any is
    const sosNotice = (id: string, code: string, side: string) =>
      notification.error({
        key: `sos-${id}`,
        title: `SOS ${code}`,
        description: `Pressed by the ${(SOS_SIDE[side] ?? "app").toLowerCase()}. Call now and acknowledge it on the Live map.`,
        duration: 0, // stays until someone acknowledges it
        actions: (
          <Button type="primary" danger size="small" onClick={() => router.push("/live")}>
            Open Live map
          </Button>
        ),
      });
    const sosClosed = (id: string) => {
      openSos.delete(id);
      notification.destroy(`sos-${id}`);
    };
    // What's open now (on load and whenever the socket connects again): an SOS raised while
    // this page was closed or offline still shows; one acknowledged meanwhile goes.
    const loadOpenSos = async () => {
      if (!live) return;
      try {
        const { data } = await api.GET("/v1/admin/sos", { params: { query: { status: "active", pageSize: 50 } } });
        if (!data) return;
        const open = data.items.filter((s) => s.status === "OPEN");
        const ids = new Set(open.map((s) => s.id));
        [...openSos].filter((id) => !ids.has(id)).forEach(sosClosed);
        open.forEach((s) => {
          openSos.add(s.id);
          sosNotice(s.id, s.code, s.side);
        });
        if (open.length > 0) alarm();
      } catch {
        // the Live map lists them too
      }
    };
    void loadOpenSos();
    const repeat = setInterval(() => {
      if (openSos.size > 0) alarm();
      setNeedsClick(openSos.size > 0 && soundBlocked());
    }, SOS_REPEAT_MS);
    const offState = onLiveState((online) => {
      if (online) void loadOpenSos();
    });
    const off = onLiveMessage(({ type, data }) => {
      const bookingId = String(data.bookingId ?? "");
      const code = String(data.code ?? "");
      if (type === "sos.new" && live) {
        openSos.add(String(data.id ?? ""));
        alarm();
        sosNotice(String(data.id ?? ""), code, String(data.side ?? ""));
        setNeedsClick(soundBlocked());
        return;
      }
      if (type === "sos.updated" && data.status !== "OPEN") {
        sosClosed(String(data.id ?? ""));
        return;
      }
      if (type === "alert.acked") {
        notification.destroy(`alert-${String(data.id ?? "")}`);
        return;
      }
      if (type === "ticket.new" && support) {
        notification.info({
          key: `ticket-${String(data.id ?? "")}`,
          title: `${code}: a problem was reported`,
          actions: (
            <Button size="small" onClick={() => router.push("/support/tickets")}>
              Open tickets
            </Button>
          ),
        });
        return;
      }
      if (!ops) return;
      if (type === "queue.changed" && data.reason !== "NEW" && timeouts.has(bookingId)) {
        notification.destroy(timeouts.get(bookingId));
        timeouts.delete(bookingId);
      }
      if (type === "queue.changed" && data.reason === "NEW") {
        chime();
        notification.info({
          key: `new-${bookingId}`,
          title: `New booking ${code} to assign`,
          description: "It's in the Unassigned queue.",
          actions: (
            <Button type="primary" size="small" onClick={() => router.push("/bookings/queue")}>
              Open queue
            </Button>
          ),
        });
        return;
      }
      if (type !== "alert") return;
      const kind = String(data.kind ?? "");
      const details = (data.details ?? {}) as Record<string, string | number | boolean | null>;
      if (kind === "NEW_APPLICATION") {
        notification.info({
          key: `app-${String(data.partnerId ?? "")}`,
          title: ALERT_KIND.NEW_APPLICATION.label,
          actions: (
            <Button size="small" onClick={() => router.push("/partners/applications")}>
              Open applications
            </Button>
          ),
        });
        return;
      }
      if (kind === "ESCALATION" || kind === "MOCK_GPS" || kind === "OTP_LOCKED") chime();
      const label = ALERT_KIND[kind]?.label ?? kind;
      const who = details.partner ? ` · ${String(details.partner)}` : "";
      const why =
        kind === "DECLINED" && details.reason
          ? `${DECLINE_REASON[String(details.reason)] ?? String(details.reason)}${details.note ? `: ${String(details.note)}` : ""}`
          : kind === "FAR_STEP"
            ? farStepNote(details)
            : undefined;
      const key = `alert-${String(data.id ?? "")}`;
      if (kind === "OFFER_TIMEOUT") timeouts.set(bookingId, key);
      // a step far from the place is a note; the rest stay until someone marks them as seen
      const sticky = kind !== "FAR_STEP";
      notification[kind === "ESCALATION" || kind === "OTP_LOCKED" ? "error" : "warning"]({
        key,
        title: `${code}: ${label}${who}`,
        description: why,
        duration: sticky ? 0 : 8,
        actions: (
          <Button type="primary" size="small" onClick={() => router.push(`/bookings/${bookingId}`)}>
            Open booking
          </Button>
        ),
      });
    });
    return () => {
      off();
      offState();
      clearInterval(repeat);
      stopLive();
      // signed out: the banners that stay until seen (SOS, visit alerts) must not stay on the
      // sign-in screen with booking codes and names
      notification.destroy();
    };
  }, [ops, live, support, reviewer, notification, router]);

  if (!ops && !reviewer && !support) return null;
  return (
    <>
      {needsClick && (
        <Tag color="red" style={{ position: "fixed", bottom: 52, right: 16, zIndex: 1000, padding: "4px 10px" }}>
          SOS open: click anywhere on the page to turn the alarm sound on.
        </Tag>
      )}
      {offline && (
        <Tag color="orange" style={{ position: "fixed", bottom: 16, right: 16, zIndex: 1000, padding: "4px 10px" }}>
          Live updates offline: reconnecting… Reload the page if this stays.
        </Tag>
      )}
    </>
  );
}
