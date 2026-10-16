import createClient from "openapi-fetch";

import { authFetch } from "@/auth/session";
import type { paths } from "./schema";

/**
 * Typed API client generated from docs/api/openapi.json (.\ww.ps1 gen-clients).
 * Field names can't drift from the backend: a renamed field is a TypeScript error.
 *
 * The panel calls the API on its own origin: Next.js forwards /v1/* to the backend
 * (next.config.ts), so the httpOnly refresh cookie is first-party. Leave
 * NEXT_PUBLIC_API_BASE_URL empty unless the API is served elsewhere.
 */
export const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? "";

export const api = createClient<paths>({ baseUrl: API_BASE_URL, fetch: authFetch });
