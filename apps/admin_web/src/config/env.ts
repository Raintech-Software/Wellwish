/**
 * Which environment the panel was built for. `NEXT_PUBLIC_APP_ENV` wins; without it, `next dev`
 * is a developer's PC and any production build counts as prod, so dev-only pages (Settings →
 * Test messages) and dev socket URLs fail closed on a server whose build forgot the variable.
 */
export const APP_ENV: string =
  process.env.NEXT_PUBLIC_APP_ENV || (process.env.NODE_ENV === "development" ? "dev" : "prod");

export const IS_DEV = APP_ENV === "dev";
