"use client";

import "leaflet/dist/leaflet.css";

import L from "leaflet";
import Link from "next/link";
import { useEffect, useMemo, useRef } from "react";
import { MapContainer, Marker, Polyline, Popup, TileLayer, useMap } from "react-leaflet";

import type { components } from "@/api/schema";
import { BHUBANESWAR } from "@/components/map/MapView";
import { tel } from "@/lib/assignments";
import { dateTime } from "@/lib/format";
import { phone } from "@/lib/partners";
import { eta, stepLabel } from "@/lib/visit";
import { colors } from "@/theme";

/**
 * Leaflet maps for the visit (§9.1 Live): every job in progress with the partner's latest point
 * (grey when no point for 2 minutes) and SOS points in red; or one finished job's route.
 * Loaded only in the browser (Leaflet needs `window`): import through `next/dynamic`.
 */
type Job = components["schemas"]["LiveJobOut"];
type Sos = components["schemas"]["AdminSosOut"];

const icons = new Map<string, L.DivIcon>();

/** A coloured dot with a label (made once per colour and label, so markers aren't redrawn on
 * every point). */
function dot(color: string, label: string): L.DivIcon {
  const key = `${color}|${label}`;
  const known = icons.get(key);
  if (known) return known;
  const icon = L.divIcon({
    className: "ww-live-dot",
    html: `<div style="display:flex;flex-direction:column;align-items:center">
      <div style="width:18px;height:18px;border-radius:50%;background:${color};border:3px solid #fff;box-shadow:0 0 4px rgba(0,0,0,.4)"></div>
      <div style="margin-top:2px;padding:0 4px;border-radius:4px;background:#fff;font-size:11px;font-weight:600;white-space:nowrap;box-shadow:0 0 2px rgba(0,0,0,.3)">${label}</div>
    </div>`,
    iconSize: [80, 40],
    iconAnchor: [40, 9],
  });
  icons.set(key, icon);
  return icon;
}

/** Fits all points once, and again whenever something new appears (a job or SOS not seen
 * before); otherwise leaves the view to the admin. */
function FitOnce({ points, ids }: { points: [number, number][]; ids: string[] }) {
  const map = useMap();
  const seen = useRef<Set<string>>(new Set());
  useEffect(() => {
    const fresh = ids.some((id) => !seen.current.has(id));
    ids.forEach((id) => seen.current.add(id));
    if (points.length === 0 || !fresh) return;
    if (points.length === 1) map.setView(points[0], Math.max(map.getZoom(), 14));
    else map.fitBounds(L.latLngBounds(points), { padding: [40, 40], maxZoom: 15 });
  }, [map, points, ids]);
  return null;
}

const tiles = (
  <TileLayer
    attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    url="https://tile.openstreetmap.org/{z}/{x}/{y}.png"
    maxZoom={19}
  />
);

export default function LiveMap({ jobs, sos, height = 460 }: { jobs: Job[]; sos: Sos[]; height?: number }) {
  const located = jobs.filter((j) => j.lat && j.lng);
  const sosPoints = sos.filter((s) => s.lat && s.lng && s.status !== "RESOLVED");
  const points = useMemo<[number, number][]>(
    () => [
      ...located.map((j) => [Number(j.lat), Number(j.lng)] as [number, number]),
      ...sosPoints.map((s) => [Number(s.lat), Number(s.lng)] as [number, number]),
    ],
    [located, sosPoints],
  );
  const ids = useMemo(
    () => [...located.map((j) => j.bookingId), ...sosPoints.map((s) => `sos-${s.id}`)],
    [located, sosPoints],
  );
  return (
    <MapContainer
      center={[BHUBANESWAR.lat, BHUBANESWAR.lng]}
      zoom={12}
      style={{ height, width: "100%", borderRadius: 10, border: `1px solid ${colors.border}` }}
      scrollWheelZoom
    >
      {tiles}
      <FitOnce points={points} ids={ids} />
      {located.map((j) => (
        <Marker
          key={j.bookingId}
          position={[Number(j.lat), Number(j.lng)]}
          icon={dot(j.stale ? colors.textSecondary : colors.primary, j.code)}
        >
          <Popup>
            <div>
              <b>{j.code}</b> · {stepLabel(j.step)}
            </div>
            <div>
              {j.partnerName}
              {j.partnerPhone && (
                <>
                  {" · "}
                  <a href={tel(j.partnerPhone)}>{phone(j.partnerPhone)}</a>
                </>
              )}
            </div>
            <div>
              For {j.memberName} · {j.serviceName}
            </div>
            <div>
              Last point {dateTime(j.at)}
              {j.etaMin != null && ` · about ${eta(j.etaMin)} away`}
            </div>
            <Link href={`/bookings/${j.bookingId}`}>Open booking</Link>
          </Popup>
        </Marker>
      ))}
      {sosPoints.map((s) => (
        <Marker key={s.id} position={[Number(s.lat), Number(s.lng)]} icon={dot(colors.danger, `SOS ${s.code}`)}>
          <Popup>
            <b>SOS {s.code}</b> · {dateTime(s.raisedAt)}
            <div>
              <Link href={`/bookings/${s.bookingId}`}>Open booking</Link>
            </div>
          </Popup>
        </Marker>
      ))}
    </MapContainer>
  );
}

const ROUTE = ["route"];

/** A finished job's route (from the saved track) with start and end. */
export function TrackMap({ points, height = 320 }: { points: number[][]; height?: number }) {
  const line = points.map((p) => [p[0], p[1]] as [number, number]);
  return (
    <MapContainer
      center={line[0] ?? [BHUBANESWAR.lat, BHUBANESWAR.lng]}
      zoom={13}
      style={{ height, width: "100%", borderRadius: 10, border: `1px solid ${colors.border}` }}
      scrollWheelZoom
    >
      {tiles}
      <FitOnce points={line} ids={ROUTE} />
      {line.length > 0 && <Polyline positions={line} pathOptions={{ color: colors.primary, weight: 4 }} />}
      {line.length > 0 && <Marker position={line[0]} icon={dot(colors.brandGreen, "Start")} />}
      {line.length > 1 && <Marker position={line[line.length - 1]} icon={dot(colors.brandNavy, "End")} />}
    </MapContainer>
  );
}
