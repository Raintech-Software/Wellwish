import { useSyncExternalStore } from "react";

function subscribe(onChange: () => void) {
  window.addEventListener("resize", onChange);
  return () => window.removeEventListener("resize", onChange);
}

/** Drawer width: `preferred` px, but never wider than the screen (phones, narrow windows). */
export function useDrawerSize(preferred = 640): number {
  return useSyncExternalStore(
    subscribe,
    () => Math.min(preferred, window.innerWidth),
    () => preferred,
  );
}
