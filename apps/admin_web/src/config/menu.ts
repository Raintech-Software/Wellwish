/**
 * Admin sidebar, from ARCHITECTURE §9.1. Each page records the phase that builds it.
 * Each page names the permission it needs: the menu only shows what the staff role allows (§9.2).
 */
import { IS_DEV } from "./env";

export type IconKey =
  | "dashboard"
  | "bookings"
  | "live"
  | "partners"
  | "services"
  | "directory"
  | "patients"
  | "payments"
  | "reports"
  | "support"
  | "settings"
  | "system";

export interface MenuPage {
  path: string;
  label: string;
  phase: number;
  description: string;
  /** Permission code from the backend (apps/staff/permissions.py). */
  permission: string;
  /** The page is built (not a placeholder). */
  built?: boolean;
  /** Shown only on a developer's PC (`IS_DEV`, config/env.ts). */
  devOnly?: boolean;
}

export interface MenuSection {
  key: string;
  label: string;
  icon: IconKey;
  pages: MenuPage[];
}

export const MENU: MenuSection[] = [
  {
    key: "dashboard",
    label: "Dashboard",
    icon: "dashboard",
    pages: [
      {
        path: "/",
        permission: "dashboard.view",
        label: "Dashboard",
        phase: 9,
        built: true,
        description:
          "Today's bookings: unassigned, waiting, in progress, completed. Booking fees collected, new partner applications and alerts.",
      },
    ],
  },
  {
    key: "bookings",
    label: "Bookings",
    icon: "bookings",
    pages: [
      {
        path: "/bookings/queue",
        permission: "bookings.view",
        label: "Unassigned queue",
        phase: 7,
        built: true,
        description:
          "Paid bookings waiting for a partner (Today, Tomorrow, Later). Assign, 2-minute countdown, call buttons, accepted by phone.",
      },
      {
        path: "/bookings",
        permission: "bookings.view",
        label: "All bookings",
        phase: 5,
        description: "Every booking with filters, details, timeline, documents, payments and refunds.",
        built: true,
      },
    ],
  },
  {
    key: "live",
    label: "Live map",
    icon: "live",
    pages: [
      {
        path: "/live",
        permission: "live.view",
        label: "Live map",
        phase: 8,
        built: true,
        description:
          "Jobs in progress on a map, SOS (acknowledge, resolve) and the visit's alerts: no location, far-away step, fake GPS, visit code locked, patient not available, not completed.",
      },
    ],
  },
  {
    key: "partners",
    label: "Partners",
    icon: "partners",
    pages: [
      {
        path: "/partners/applications", built: true,
        permission: "partners.review",
        label: "Applications",
        phase: 3,
        description: "New companion and nurse registrations. Review each document, approve or request changes.",
      },
      {
        path: "/partners", built: true,
        permission: "partners.view",
        label: "All partners",
        phase: 3,
        description: "Companions and nurses: status, availability, rating, jobs, both phone numbers.",
      },
      {
        path: "/partners/new", built: true,
        permission: "partners.add",
        label: "Add partner",
        phase: 3,
        description: "Add a companion or nurse by hand, with documents. Saved as approved.",
      },
      {
        path: "/partners/selfies", built: true,
        permission: "partners.review",
        label: "Selfie checks",
        phase: 7,
        description: "Today's selfies next to each partner's approved photo (spot checks).",
      },
      {
        path: "/partners/required-documents", built: true,
        permission: "partners.review",
        label: "Required documents",
        phase: 3,
        description: "Which documents each role must upload, which are optional and which expire.",
      },
    ],
  },
  {
    key: "services",
    label: "Services & prices",
    icon: "services",
    pages: [
      {
        path: "/services", built: true,
        permission: "services.view",
        label: "Services & prices",
        phase: 2,
        description:
          "Service catalogue: total price, booking fee (paid online), balance (paid to the partner), visit type, documents required.",
      },
    ],
  },
  {
    key: "directory",
    label: "Directory",
    icon: "directory",
    pages: [
      {
        path: "/directory/hospitals", built: true,
        permission: "directory.view",
        label: "Hospitals",
        phase: 2,
        description: "Hospitals and clinics with a map pin, OPD hours and departments.",
      },
      { path: "/directory/doctors", built: true, permission: "directory.view", label: "Doctors", phase: 2, description: "Doctor directory: speciality, hospitals, OPD days." },
      { path: "/directory/specialities", built: true, permission: "directory.view", label: "Specialities", phase: 2, description: "Specialities used to filter doctors." },
    ],
  },
  {
    key: "patients",
    label: "Patients",
    icon: "patients",
    pages: [
      {
        path: "/patients",
        permission: "patients.view",
        label: "Patients",
        phase: 4,
        description: "Patient accounts, family members, bookings and payments. Documents only with a logged reason.",
        built: true,
      },
      {
        path: "/patients/deletions",
        permission: "patients.manage",
        label: "Account deletions",
        phase: 4,
        description: "Patients who asked to delete their account: waiting (7 days by default), cancelled or deleted.",
        built: true,
      },
    ],
  },
  {
    key: "payments",
    label: "Payments",
    icon: "payments",
    pages: [
      { path: "/payments", built: true, permission: "payments.view", label: "Payments", phase: 6, description: "Booking-fee payments from Razorpay." },
      { path: "/payments/refunds", built: true, permission: "refunds.request", label: "Refunds", phase: 6, description: "Refunds with reason and approval." },
    ],
  },
  {
    key: "reports",
    label: "Reports",
    icon: "reports",
    pages: [
      { path: "/reports/bookings", built: true, permission: "bookings.view", label: "Bookings", phase: 9, description: "Paid bookings by visit date and by service: completed, cancelled, not finished (CSV)." },
      { path: "/reports/fees", built: true, permission: "payments.view", label: "Fees collected", phase: 9, description: "Booking fees collected per day, refunds and net (CSV)." },
      { path: "/reports/cancellations", built: true, permission: "payments.view", label: "Cancellations and refunds", phase: 9, description: "Cancelled bookings and refunds: who, why, how much (CSV)." },
      { path: "/reports/partners", built: true, permission: "partners.view", label: "Partner performance", phase: 9, description: "Jobs done, offers answered, acceptance and rating per partner (CSV)." },
    ],
  },
  {
    key: "support",
    label: "Support",
    icon: "support",
    pages: [
      { path: "/support/tickets", built: true, permission: "support.manage", label: "Tickets", phase: 8, description: "Problems reported by patients after a visit." },
      { path: "/support/reviews", built: true, permission: "support.manage", label: "Reviews", phase: 8, description: "Ratings and comments. Hide abusive reviews." },
    ],
  },
  {
    key: "settings",
    label: "Settings",
    icon: "settings",
    pages: [
      {
        path: "/settings", built: true,
        permission: "settings.manage",
        label: "General",
        phase: 2,
        description:
          "Refund %, cancel cut-off, 2-minute timeout, assign deadline, booking window, minimum notice, service hours, support numbers.",
      },
      { path: "/settings/service-areas", built: true, permission: "settings.manage", label: "Service areas", phase: 2, description: "Cities and radius where bookings are allowed." },
      { path: "/settings/blocked-times", built: true, permission: "settings.manage", label: "Blocked dates", phase: 2, description: "Holidays and fully booked times patients can't pick." },
      { path: "/settings/payment-keys", built: true, permission: "settings.manage", label: "Payment keys", phase: 6, description: "Razorpay key id, key secret and webhook secret (stored encrypted)." },
      {
        path: "/settings/legal",
        built: true,
        permission: "legal.manage",
        label: "Legal pages",
        phase: 9,
        description: "Terms of Use, Privacy Policy, Refund Policy and Partner Terms: versions, Hindi and Odia, asking everyone again.",
      },
      {
        path: "/settings/test-messages",
        built: true,
        devOnly: true,
        permission: "settings.manage",
        label: "Test messages",
        phase: 8,
        description: "Login and visit codes, SOS alerts and emails the app would have sent (local development only).",
      },
    ],
  },
  {
    key: "system",
    label: "System",
    icon: "system",
    pages: [
      { path: "/system/admin-users", built: true, permission: "staff.manage", label: "Admin users", phase: 2, description: "Staff accounts with password + 2FA." },
      { path: "/system/roles", permission: "staff.manage", label: "Roles", phase: 1, built: true, description: "Super Admin, Operations, Verification, Finance, Support permissions." },
      { path: "/system/audit-log", built: true, permission: "audit.view", label: "Audit log", phase: 2, description: "Every admin action. Read-only." },
    ],
  },
];


/** Sections and pages this staff member may see. */
export function visibleMenu(can: (permission: string) => boolean): MenuSection[] {
  return MENU.map((section) => ({
    ...section,
    pages: section.pages.filter((p) => can(p.permission) && (IS_DEV || !p.devOnly)),
  })).filter((section) => section.pages.length > 0);
}

export const ALL_PAGES: MenuPage[] = MENU.flatMap((s) => s.pages);

export function findPage(path: string): MenuPage | undefined {
  return ALL_PAGES.find((p) => p.path === path);
}
