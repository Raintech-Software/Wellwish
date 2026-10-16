"use client";

import { AimOutlined } from "@ant-design/icons";
import { App, Button, Col, Form, Input, Row, Skeleton, Typography } from "antd";
import type { FormInstance } from "antd";
import dynamic from "next/dynamic";

import type { MapPoint } from "./MapView";

const MapView = dynamic(() => import("./MapView"), {
  ssr: false,
  loading: () => <Skeleton.Node active style={{ width: "100%", height: 320 }} />,
});

const LAT = /^-?\d{1,2}(\.\d{1,6})?$/;
const LNG = /^-?\d{1,3}(\.\d{1,6})?$/;

function inRange(limit: number) {
  return (_: unknown, value: string) =>
    value === undefined || value === "" || Math.abs(Number(value)) <= limit
      ? Promise.resolve()
      : Promise.reject(new Error(`Must be between -${limit} and ${limit}.`));
}

/**
 * Latitude + longitude fields (text, 6 decimals), a "use my current location" button and an
 * OpenStreetMap pin picker. Typing, the button and the map all update the same two fields.
 * `radiusField` (km) draws a circle, for service areas.
 */
export default function LocationFields({
  form,
  radiusField,
}: {
  form: FormInstance;
  radiusField?: string;
}) {
  const { message } = App.useApp();
  const lat = Form.useWatch("lat", form) as string | undefined;
  const lng = Form.useWatch("lng", form) as string | undefined;
  const radius = Form.useWatch(radiusField ?? "__none", form) as number | string | undefined;

  const point: MapPoint | null =
    lat && lng && LAT.test(lat) && LNG.test(lng) ? { lat: Number(lat), lng: Number(lng) } : null;

  const setPoint = (p: MapPoint) => {
    form.setFieldsValue({ lat: p.lat.toFixed(6), lng: p.lng.toFixed(6) });
    void form.validateFields(["lat", "lng"]);
  };

  const shareLocation = () => {
    if (!navigator.geolocation) {
      message.error("This browser can't share its location. Type the numbers instead.");
      return;
    }
    navigator.geolocation.getCurrentPosition(
      (pos) => setPoint({ lat: pos.coords.latitude, lng: pos.coords.longitude }),
      () => message.error("Location not shared. Allow location access, or type the numbers."),
      { enableHighAccuracy: true, timeout: 15_000 },
    );
  };

  return (
    <>
      <Row gutter={12} align="bottom">
        <Col xs={12} md={8}>
          <Form.Item
            name="lat"
            label="Latitude"
            rules={[
              { required: true, message: "Pick a point or type the latitude." },
              { pattern: LAT, message: "A number like 20.296100" },
              { validator: inRange(90) },
            ]}
          >
            <Input placeholder="20.296100" inputMode="decimal" />
          </Form.Item>
        </Col>
        <Col xs={12} md={8}>
          <Form.Item
            name="lng"
            label="Longitude"
            rules={[
              { required: true, message: "Pick a point or type the longitude." },
              { pattern: LNG, message: "A number like 85.824500" },
              { validator: inRange(180) },
            ]}
          >
            <Input placeholder="85.824500" inputMode="decimal" />
          </Form.Item>
        </Col>
        <Col xs={24} md={8}>
          <Form.Item>
            <Button icon={<AimOutlined />} onClick={shareLocation} block>
              Use my current location
            </Button>
          </Form.Item>
        </Col>
      </Row>
      <Typography.Paragraph type="secondary" style={{ marginTop: -8 }}>
        Click the map or drag the pin to set the exact spot.
      </Typography.Paragraph>
      <div style={{ marginBottom: 24 }}>
        <MapView value={point} onChange={setPoint} radiusKm={radius ? Number(radius) : undefined} />
      </div>
    </>
  );
}
