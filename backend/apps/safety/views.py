"""The trip share link's page (§6.15): a small public page with a map that follows the
partner, for family members without the app. The link is `/t/#<token>`: the secret stays in
the browser (after "#") and goes to `/v1/public/track` in a header every 10 s, so it never
appears in a URL the server logs. `?l=hi` / `?l=or` (the sharer's language) picks the page's
language (Phase 9.1); without it, the phone's."""

from django.http import HttpRequest, HttpResponse

PAGE = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex">
<title>WellWish</title>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
  integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="">
<style>
  body { margin: 0; font-family: system-ui, "Noto Sans Oriya", "Noto Sans Devanagari", sans-serif;
    color: #10233f; background: #f4f8ff; }
  header { padding: 14px 16px; background: #fff; border-bottom: 1px solid #e3e9f3; }
  h1 { font-size: 18px; margin: 0 0 4px; color: #0a6cdf; }
  p { margin: 2px 0; font-size: 15px; }
  #map { height: calc(100vh - 110px); }
  .muted { color: #5b6b82; font-size: 13px; }
</style>
</head>
<body>
<header>
  <h1 id="title">WellWish live visit</h1>
  <p id="who"></p>
  <p class="muted" id="when"></p>
</header>
<div id="map"></div>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
  integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
<script>
  // The sharer's language (?l=hi / or, Phase 9.1), else the phone's; the step names are the
  // apps' own (ww_l10n).
  const TEXTS = {
    en: {
      title: "WellWish live visit", loading: "Loading…",
      ended: "This visit has ended or the link has expired.",
      assigned: "assigned", updated: "Updated", min: (m) => "about " + m + " min away",
      hours: (h, m) => "about " + h + " h " + m + " min away",
      steps: {
        ON_THE_WAY: "on the way", REACHED_PATIENT: "has reached",
        PICKED_UP: "picked up the patient",
        REACHED_HOSPITAL: "at the hospital", VISIT_DONE: "visit done", DROPPED_HOME: "dropped home",
        REACHED_HOME: "has reached", STARTED: "care started", CARE_DONE: "care done",
        AT_PLACE: "at the hospital / pharmacy", TASK_DONE: "task done", DELIVERED: "delivered",
      },
    },
    hi: {
      title: "WellWish लाइव विज़िट", loading: "लोड हो रहा है…",
      ended: "यह विज़िट पूरी हो गई है या लिंक की समय-सीमा ख़त्म हो गई है।",
      assigned: "नियुक्त", updated: "अपडेट", min: (m) => "लगभग " + m + " मिनट दूर",
      hours: (h, m) => "लगभग " + h + " घंटे " + m + " मिनट दूर",
      steps: {
        ON_THE_WAY: "रास्ते में", REACHED_PATIENT: "मरीज़ के पास पहुँचे", PICKED_UP: "साथ ले लिया",
        REACHED_HOSPITAL: "अस्पताल पहुँचे", VISIT_DONE: "डॉक्टर से मिल लिए", DROPPED_HOME: "घर छोड़ दिया",
        REACHED_HOME: "घर पहुँचे", STARTED: "देखभाल शुरू", CARE_DONE: "देखभाल पूरी",
        AT_PLACE: "अस्पताल / दवा की दुकान पर", TASK_DONE: "काम पूरा", DELIVERED: "पहुँचा दिया",
      },
    },
    or: {
      title: "WellWish ଲାଇଭ୍ ଭିଜିଟ୍", loading: "ଲୋଡ୍ ହେଉଛି…",
      ended: "ଏହି ଭିଜିଟ୍ ଶେଷ ହୋଇଛି କିମ୍ବା ଲିଙ୍କର ସମୟ ସମାପ୍ତ ହୋଇଛି।",
      assigned: "ନିଯୁକ୍ତ", updated: "ଅପଡେଟ୍", min: (m) => "ପ୍ରାୟ " + m + " ମିନିଟ୍ ଦୂରରେ",
      hours: (h, m) => "ପ୍ରାୟ " + h + " ଘଣ୍ଟା " + m + " ମିନିଟ୍ ଦୂରରେ",
      steps: {
        ON_THE_WAY: "ରାସ୍ତାରେ", REACHED_PATIENT: "ରୋଗୀଙ୍କ ପାଖରେ ପହଞ୍ଚିଲେ", PICKED_UP: "ସାଥିରେ ନେଲେ",
        REACHED_HOSPITAL: "ଡାକ୍ତରଖାନାରେ", VISIT_DONE: "ଡାକ୍ତର ଦେଖାଇ ସାରିଲେ", DROPPED_HOME: "ଘରେ ଛାଡ଼ିଦେଲେ",
        REACHED_HOME: "ଘରେ ପହଞ୍ଚିଲେ", STARTED: "ଯତ୍ନ ଆରମ୍ଭ", CARE_DONE: "ଯତ୍ନ ସମ୍ପୂର୍ଣ୍ଣ",
        AT_PLACE: "ଡାକ୍ତରଖାନା / ଔଷଧ ଦୋକାନରେ", TASK_DONE: "କାମ ସମ୍ପୂର୍ଣ୍ଣ", DELIVERED: "ପହଞ୍ଚାଇ ଦେଲେ",
      },
    },
  };
  const wanted = [new URLSearchParams(location.search).get("l"), ...(navigator.languages || [])]
    .map((l) => (l || "").slice(0, 2));
  const lang = wanted.find((l) => l in TEXTS) || "en";
  const t = TEXTS[lang];
  document.documentElement.lang = lang;
  document.title = t.title;
  document.getElementById("title").textContent = t.title;
  document.getElementById("who").textContent = t.loading;

  const token = decodeURIComponent(location.hash.slice(1));
  const map = L.map("map").setView([20.2961, 85.8245], 13);
  L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19, attribution: "© OpenStreetMap"
  }).addTo(map);
  let marker = null;
  async function load() {
    const r = token
      ? await fetch("/v1/public/track", { headers: { "X-Share-Token": token }, cache: "no-store" })
      : { ok: false };
    if (!r.ok) {
      document.getElementById("who").textContent = t.ended;
      return false;
    }
    const d = await r.json();
    const step = t.steps[d.step] || t.assigned;
    const service = (lang === "hi" && d.serviceNameHi) || (lang === "or" && d.serviceNameOr)
      || d.serviceName;
    document.getElementById("who").textContent = d.partnerFirstName + " (" + service + "): " + step;
    if (d.lat && d.lng) {
      const at = [parseFloat(d.lat), parseFloat(d.lng)];
      marker ? marker.setLatLng(at) : (marker = L.marker(at).addTo(map));
      map.setView(at, map.getZoom());
      const eta = !d.etaMin ? "" : " · " + (d.etaMin < 60 ? t.min(d.etaMin)
        : t.hours(Math.floor(d.etaMin / 60), d.etaMin % 60));
      document.getElementById("when").textContent =
        t.updated + " " + new Date(d.at).toLocaleTimeString(lang + "-IN") + eta;
    }
    return true;
  }
  load().then((ok) => { if (ok) setInterval(load, 10000); });
</script>
</body>
</html>
"""


def share_page(request: HttpRequest) -> HttpResponse:
    response = HttpResponse(PAGE)
    response["Referrer-Policy"] = "no-referrer"
    response["Cache-Control"] = "no-store"
    return response
