"use client";

import { useCallback, useEffect, useState } from "react";

interface State<T> {
  data: T | null;
  failed: boolean;
  source: unknown;
  version: number;
}

/**
 * Loads data for a page: runs `fetcher` when `enabled`, again whenever `fetcher` changes (keep it
 * in useCallback with its inputs, e.g. filters) and on `reload()`. `fetcher` returns the data, or
 * undefined when the request failed (a thrown error counts as failed too). The last good data
 * stays shown while new data loads.
 */
export function useLoad<T>(fetcher: () => Promise<T | undefined>, enabled: boolean) {
  const [state, setState] = useState<State<T>>({ data: null, failed: false, source: null, version: -1 });
  const [version, setVersion] = useState(0);

  useEffect(() => {
    if (!enabled) return;
    let current = true;
    fetcher().then(
      (result) => {
        if (!current) return;
        setState((prev) => ({
          data: result === undefined ? prev.data : result,
          failed: result === undefined,
          source: fetcher,
          version,
        }));
      },
      () => {
        // no network (or a broken answer): say so, keep what was shown
        if (current) setState((prev) => ({ ...prev, failed: true, source: fetcher, version }));
      },
    );
    return () => {
      current = false;
    };
  }, [fetcher, enabled, version]);

  const reload = useCallback(() => setVersion((v) => v + 1), []);
  /** New data, or a function of the latest data (for live updates arriving close together). */
  const setData = useCallback(
    (data: T | ((prev: T | null) => T | null)) =>
      setState((prev) => ({
        ...prev,
        data: typeof data === "function" ? (data as (p: T | null) => T | null)(prev.data) : data,
      })),
    [],
  );

  return {
    data: state.data,
    failed: state.failed,
    loading: enabled && (state.source !== fetcher || state.version !== version),
    reload,
    setData,
  };
}
