"use client";

import { useEffect } from "react";

import { APP_ENV } from "@/config/env";
import { SENTRY_DSN, scrubBreadcrumb, scrubEvent } from "@/lib/monitoring";

let started = false;

/** Starts Sentry once in the browser when the panel was built with a DSN (src/lib/monitoring.ts). */
export function Monitoring() {
  useEffect(() => {
    if (!SENTRY_DSN || started) return;
    started = true;
    void import("@sentry/browser").then((Sentry) =>
      Sentry.init({
        dsn: SENTRY_DSN,
        environment: APP_ENV,
        tracesSampleRate: 0,
        dataCollection: {
          userInfo: false,
          cookies: false,
          httpHeaders: false,
          httpBodies: [],
          urlQueryParams: false,
        },
        beforeSend: scrubEvent,
        beforeBreadcrumb: scrubBreadcrumb,
      }),
    );
  }, []);
  return null;
}
