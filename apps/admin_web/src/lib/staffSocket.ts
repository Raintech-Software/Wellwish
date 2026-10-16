"use client";

import { currentAccessToken, refresh } from "@/auth/session";
import { IS_DEV } from "@/config/env";

/**
 * The admin panel's live socket (ARCHITECTURE §10.4): `queue.changed` (new, offered, declined,
 * accepted, cancelled, rescheduled), `alert` (2 minutes without an answer, declined, past the
 * deadline, new partner application, and the visit's alerts), and during visits `job.location`,
 * `job.step`, `sos.new`, `sos.updated` and `ticket.new`. The access token is sent as the FIRST message, never in
 * the URL. Reconnects with a growing delay (a refused token is refreshed first); after a
 * reconnect, listeners get `live.reconnected` so pages reload what they may have missed. Pages
 * subscribe with `onLiveMessage`; `onLiveState` says whether live updates are on.
 */
export interface LiveMessage {
  type: string;
  data: Record<string, unknown>;
}

type Listener = (message: LiveMessage) => void;
type StateListener = (online: boolean) => void;

const CLOSE_UNAUTHORIZED = 4001;
const CLOSE_SESSION_REVOKED = 4003;

const listeners = new Set<Listener>();
const stateListeners = new Set<StateListener>();
let socket: WebSocket | null = null;
let wanted = false;
let retry = 0;
let timer: ReturnType<typeof setTimeout> | null = null;
let everConnected = false;
let online = false;

function setOnline(value: boolean) {
  if (online === value) return;
  online = value;
  stateListeners.forEach((listener) => listener(value));
}

function socketUrl(): string {
  const configured = process.env.NEXT_PUBLIC_WS_BASE_URL;
  if (configured) return `${configured.replace(/\/$/, "")}/ws/staff/`;
  const { protocol, hostname, host } = window.location;
  // Local dev (IS_DEV, plain http): the panel runs on :3000 and the API on :8000 (Next.js
  // doesn't forward WebSockets). An https page, or staging/prod, uses the panel's own host
  // (Nginx forwards /ws/), so it never tries ws:// from https.
  if (IS_DEV && protocol === "http:") return `ws://${hostname}:8000/ws/staff/`;
  return `${protocol === "https:" ? "wss" : "ws"}://${host}/ws/staff/`;
}

function schedule(delayMs?: number) {
  if (!wanted || timer) return;
  retry = Math.min(retry + 1, 6);
  timer = setTimeout(
    () => {
      timer = null;
      open();
    },
    delayMs ?? 1000 * 2 ** retry, // 2 s … 64 s
  );
}

function open() {
  if (!wanted || socket) return;
  const token = currentAccessToken();
  if (!token) {
    // The access token lives in memory: get one from the refresh cookie first.
    void refresh().then((ok) => (ok ? open() : schedule()));
    return;
  }
  let ws: WebSocket;
  try {
    ws = new WebSocket(socketUrl());
  } catch {
    schedule(); // e.g. a ws:// address on an https page: retry later, never crash the panel
    return;
  }
  socket = ws;
  ws.onopen = () => {
    if (socket === ws) ws.send(JSON.stringify({ type: "auth", token }));
  };
  ws.onmessage = (event) => {
    if (socket !== ws) return;
    let message: LiveMessage;
    try {
      message = JSON.parse(String(event.data)) as LiveMessage;
    } catch {
      return;
    }
    if (message.type === "auth.ok") {
      retry = 0;
      setOnline(true);
      if (everConnected) listeners.forEach((listener) => listener({ type: "live.reconnected", data: {} }));
      everConnected = true;
      return;
    }
    listeners.forEach((listener) => listener(message));
  };
  ws.onclose = (event) => {
    if (socket !== ws) return; // an old socket closing late: not ours any more
    socket = null;
    setOnline(false);
    if (!wanted || event.code === CLOSE_SESSION_REVOKED) return;
    if (event.code === CLOSE_UNAUTHORIZED) {
      // The 15-minute access token ran out: refresh it, then reconnect.
      void refresh().then((ok) => (ok ? schedule(500) : schedule()));
      return;
    }
    schedule();
  };
}

export function startLive() {
  wanted = true;
  open();
}

export function stopLive() {
  wanted = false;
  if (timer) clearTimeout(timer);
  timer = null;
  retry = 0;
  everConnected = false;
  const ws = socket;
  socket = null;
  if (ws) {
    ws.onopen = null;
    ws.onmessage = null;
    ws.onclose = null;
    ws.close();
  }
  setOnline(false);
}

export function onLiveMessage(listener: Listener): () => void {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

export function onLiveState(listener: StateListener): () => void {
  stateListeners.add(listener);
  return () => stateListeners.delete(listener);
}

let audio: AudioContext | null = null;

/** Browsers keep sound off until the page is clicked: one shared context, resumed on the first
 * click or key press. */
function audioContext(): AudioContext | null {
  if (audio) return audio;
  const AudioCtx =
    window.AudioContext ?? (window as unknown as { webkitAudioContext?: typeof AudioContext }).webkitAudioContext;
  if (!AudioCtx) return null;
  audio = new AudioCtx();
  const unlock = () => void audio?.resume();
  window.addEventListener("pointerdown", unlock, { once: true });
  window.addEventListener("keydown", unlock, { once: true });
  return audio;
}

/** True while the browser still blocks sound (the panel shows "click to turn sound on"). */
export const soundBlocked = (): boolean => audioContext()?.state === "suspended";

/** A short two-tone chime for a new booking in the queue (no sound file needed). */
export function chime() {
  try {
    const ctx = audioContext();
    if (!ctx || ctx.state !== "running") return; // blocked until the page is clicked: the banner still shows
    [880, 1320].forEach((frequency, i) => {
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.frequency.value = frequency;
      gain.gain.setValueAtTime(0.0001, ctx.currentTime + i * 0.18);
      gain.gain.exponentialRampToValueAtTime(0.25, ctx.currentTime + i * 0.18 + 0.02);
      gain.gain.exponentialRampToValueAtTime(0.0001, ctx.currentTime + i * 0.18 + 0.16);
      osc.connect(gain).connect(ctx.destination);
      osc.start(ctx.currentTime + i * 0.18);
      osc.stop(ctx.currentTime + i * 0.18 + 0.17);
    });
  } catch {
    // no audio: the banner still shows
  }
}

/** SOS: a louder alarm, three times (§6.15). */
export function alarm() {
  try {
    const ctx = audioContext();
    if (!ctx || ctx.state !== "running") return; // blocked until the page is clicked: the banner still shows
    for (let i = 0; i < 6; i++) {
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.type = "square";
      osc.frequency.value = i % 2 === 0 ? 960 : 640;
      const at = ctx.currentTime + i * 0.25;
      gain.gain.setValueAtTime(0.0001, at);
      gain.gain.exponentialRampToValueAtTime(0.3, at + 0.02);
      gain.gain.exponentialRampToValueAtTime(0.0001, at + 0.22);
      osc.connect(gain).connect(ctx.destination);
      osc.start(at);
      osc.stop(at + 0.23);
    }
  } catch {
    // no audio: the banner still shows
  }
}
