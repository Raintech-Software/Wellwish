"use client";

import { Col, DatePicker, Form, Input, Radio, Row, Select } from "antd";
import type { FormInstance } from "antd";
import dayjs from "dayjs";

import LocationFields from "@/components/map/LocationFields";
import { LANGUAGES, SKILLS } from "@/lib/partners";

/** The profile fields shared by Edit and Add partner. */
export default function PartnerFields({ form }: { form: FormInstance }) {
  return (
    <>
      <Form.Item name="fullName" label="Full name" rules={[{ required: true, min: 2, max: 80 }]}>
        <Input />
      </Form.Item>
      <Row gutter={12}>
        <Col xs={24} sm={12}>
          <Form.Item name="dob" label="Date of birth" rules={[{ required: true }]}>
            <DatePicker
              style={{ width: "100%" }}
              format="D MMM YYYY"
              disabledDate={(d) => d.isAfter(dayjs().subtract(18, "year"))}
              defaultPickerValue={dayjs().subtract(30, "year")}
            />
          </Form.Item>
        </Col>
        <Col xs={24} sm={12}>
          <Form.Item name="gender" label="Gender" rules={[{ required: true }]}>
            <Radio.Group
              optionType="button"
              options={[
                { value: "FEMALE", label: "Female" },
                { value: "MALE", label: "Male" },
                { value: "OTHER", label: "Other" },
              ]}
            />
          </Form.Item>
        </Col>
      </Row>
      <Form.Item name="address" label="Home address" rules={[{ required: true, min: 5, max: 300 }]}>
        <Input.TextArea autoSize={{ minRows: 2 }} />
      </Form.Item>
      <LocationFields form={form} />
      <Row gutter={12}>
        <Col xs={24} sm={12}>
          <Form.Item name="languages" label="Languages" rules={[{ required: true, message: "Pick at least one." }]}>
            <Select mode="tags" options={LANGUAGES.map((l) => ({ value: l, label: l }))} />
          </Form.Item>
        </Col>
        <Col xs={24} sm={12}>
          <Form.Item name="skills" label="Skills">
            <Select mode="tags" options={SKILLS.map((s) => ({ value: s, label: s }))} />
          </Form.Item>
        </Col>
      </Row>
      <Row gutter={12}>
        <Col xs={24} sm={12}>
          <Form.Item name="emergencyName" label="Emergency contact name" rules={[{ required: true, min: 2, max: 80 }]}>
            <Input />
          </Form.Item>
        </Col>
        <Col xs={24} sm={12}>
          <Form.Item name="emergencyPhone" label="Emergency contact phone" rules={[{ required: true, max: 20 }]}>
            <Input inputMode="tel" placeholder="98765 43210" />
          </Form.Item>
        </Col>
      </Row>
    </>
  );
}
