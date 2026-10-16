"use client";

import "leaflet/dist/leaflet.css";

import L from "leaflet";
import { useEffect } from "react";
import { Circle, MapContainer, Marker, TileLayer, useMap, useMapEvents } from "react-leaflet";

import { colors } from "@/theme";

/**
 * Free OpenStreetMap map (ARCHITECTURE §3.2, v2.8: no Google Maps key yet). Click the map or
 * drag the pin to choose a point; an optional circle shows a service-area radius.
 * Loaded only in the browser (Leaflet needs `window`): import it through `next/dynamic`.
 */
export interface MapPoint {
  lat: number;
  lng: number;
}

export const BHUBANESWAR: MapPoint = { lat: 20.2961, lng: 85.8245 };

// A drawn pin (Leaflet's default marker images don't survive bundling).
const PIN = L.divIcon({
  className: "ww-map-pin",
  html: `<svg width="28" height="40" viewBox="0 0 28 40" xmlns="http://www.w3.org/2000/svg">
    <path d="M14 0C6.3 0 0 6.2 0 13.9 0 24.3 14 40 14 40s14-15.7 14-26.1C28 6.2 21.7 0 14 0z" fill="${colors.primary}"/>
    <circle cx="14" cy="14" r="5.5" fill="#fff"/></svg>`,
  iconSize: [28, 40],
  iconAnchor: [14, 40],
});

function ClickToPick({ onPick }: { onPick?: (p: MapPoint) => void }) {
  useMapEvents({
    click(event) {
      onPick?.({ lat: event.latlng.lat, lng: event.latlng.lng });
    },
  });
  return null;
}

/** Keeps the chosen point (and circle) in view when it changes from the form. */
function FollowPoint({ point, radiusKm }: { point: MapPoint | null; radiusKm?: number }) {
  const map = useMap();
  useEffect(() => {
    if (!point) return;
    if (radiusKm && radiusKm > 0) {
      map.fitBounds(L.latLng(point.lat, point.lng).toBounds(radiusKm * 2000), { maxZoom: 14 });
    } else if (!map.getBounds().pad(-0.2).contains([point.lat, point.lng])) {
      map.setView([point.lat, point.lng], Math.max(map.getZoom(), 14));
    }
  }, [map, point, radiusKm]);
  return null;
}

export default function MapView({
  value,
  onChange,
  radiusKm,
  height = 320,
}: {
  value: MapPoint | null;
  onChange?: (point: MapPoint) => void;
  radiusKm?: number;
  height?: number;
}) {
  const centre = value ?? BHUBANESWAR;
  return (
    <MapContainer
      center={[centre.lat, centre.lng]}
      zoom={value ? 14 : 12}
      style={{ height, width: "100%", borderRadius: 10, border: `1px solid ${colors.border}` }}
      scrollWheelZoom
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://tile.openstreetmap.org/{z}/{x}/{y}.png"
        maxZoom={19}
      />
      <ClickToPick onPick={onChange} />
      <FollowPoint point={value} radiusKm={radiusKm} />
      {value && (
        <>
          <Marker
            position={[value.lat, value.lng]}
            icon={PIN}
            draggable={Boolean(onChange)}
            eventHandlers={{
              dragend(event) {
                const at = (event.target as L.Marker).getLatLng();
                onChange?.({ lat: at.lat, lng: at.lng });
              },
            }}
          />
          {radiusKm && radiusKm > 0 ? (
            <Circle
              center={[value.lat, value.lng]}
              radius={radiusKm * 1000}
              pathOptions={{ color: colors.primary, fillColor: colors.primary, fillOpacity: 0.12 }}
            />
          ) : null}
        </>
      )}
    </MapContainer>
  );
}
