"use strict";

// Polling cadence. 2s is tight enough to feel live without hammering
// the log tail during a 5-minute run.
const POLL_MS = 2000;

const KNOWN_FILTERS = [
  "startup cancel_all ok",
  "submit complete",
  "order_reject",
  "fill applied",
  "duration reached",
];

const $ = (id) => document.getElementById(id);

const state = {
  activeFilters: new Set(),
  pollTimer: null,
};

function highlight(line) {
  // Colour the filter tags we care about so the operator can scan
  // without reading every line.
  if (line.includes("submit complete"))      return `<span class="hit-submit">${esc(line)}</span>`;
  if (line.includes("fill applied"))         return `<span class="hit-fill">${esc(line)}</span>`;
  if (line.includes("order_reject"))         return `<span class="hit-reject">${esc(line)}</span>`;
  if (line.includes("cancel_all ok"))        return `<span class="hit-cancel">${esc(line)}</span>`;
  if (line.includes("duration reached"))     return `<span class="hit-duration">${esc(line)}</span>`;
  return esc(line);
}

function esc(s) {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function shortenLine(line, max = 240) {
  if (!line) return "—";
  return line.length > max ? line.slice(0, max) + "…" : line;
}

function renderFilters() {
  const box = $("filters");
  box.innerHTML = "";
  for (const f of KNOWN_FILTERS) {
    const id = `f-${f.replace(/\s+/g, "-")}`;
    const checked = state.activeFilters.has(f) ? "checked" : "";
    box.insertAdjacentHTML("beforeend",
      `<label><input type="checkbox" id="${id}" value="${esc(f)}" ${checked}/> ${esc(f)}</label>`);
  }
  box.querySelectorAll("input[type=checkbox]").forEach((cb) => {
    cb.addEventListener("change", () => {
      if (cb.checked) state.activeFilters.add(cb.value);
      else state.activeFilters.delete(cb.value);
      pollLogs();
    });
  });
}

async function pollStatus() {
  try {
    const r = await fetch("/api/status");
    const s = await r.json();
    $("host").textContent = `host ${s.host}`;
    $("branch").textContent = `branch ${s.git?.branch || "—"}${s.git?.dirty ? "*" : ""}`;
    $("commit").textContent = `commit ${s.git?.commit || "—"}`;
    $("server-time").textContent = s.server_time || "";
    const modeEl = $("mode");
    modeEl.className = "mode " + (s.mode || "");
    modeEl.textContent = `mode ${s.mode || "—"}`;

    const m = s.markers || {};
    setCard("ws", m.ws_connected === true ? "connected" :
                   m.ws_connected === false ? "disconnected" : "—",
            m.ws_state ? shortenLine(m.ws_state, 80) : "",
            m.ws_connected === true ? "ok" : m.ws_connected === false ? "bad" : "");
    setCard("submit",   shortenLine(m.submit));
    setCard("fill",     shortenLine(m.fill), "", m.fill ? "ok" : "");
    setCard("reject",   shortenLine(m.reject), "", m.reject ? "bad" : "");
    setCard("cancel",   shortenLine(m.cancel_all), "", m.cancel_all ? "warn" : "");
    setCard("duration", shortenLine(m.duration));

    // Disable buttons for scripts the operator host doesn't have
    // (e.g. running the GUI on a laptop for a smoke test).
    const avail = s.scripts_available || {};
    document.querySelectorAll(".btn").forEach((b) => {
      b.disabled = avail[b.dataset.slug] === false;
      b.title = b.disabled ? "script not found on this host" : "";
    });
  } catch (e) {
    // Keep quiet — transient fetch errors are common during a
    // restart; the next tick will catch up.
  }
}

function setCard(id, value, sub = "", cls = "") {
  const card = $(`card-${id}`);
  const v = $(`${id}-value`);
  if (v) v.textContent = value || "—";
  const s = $(`${id}-sub`);
  if (s) s.textContent = sub || "";
  if (card) {
    card.classList.remove("ok", "bad", "warn");
    if (cls) card.classList.add(cls);
  }
}

async function pollLogs() {
  try {
    const q = new URLSearchParams();
    if (state.activeFilters.size) {
      q.set("filter", Array.from(state.activeFilters).join(","));
    }
    const r = await fetch("/api/logs?" + q.toString());
    const data = await r.json();
    $("log-path").textContent = data.log_path || "—";
    const pre = $("log");
    if (!data.lines || !data.lines.length) {
      pre.innerHTML = "(no matching lines)";
      return;
    }
    pre.innerHTML = data.lines.map(highlight).join("\n");
    pre.scrollTop = pre.scrollHeight;
  } catch (e) {}
}

async function runScript(slug) {
  const status = $("action-status");
  status.textContent = `launching ${slug}…`;
  try {
    const r = await fetch("/api/run/" + encodeURIComponent(slug), { method: "POST" });
    const data = await r.json();
    if (data.ok) {
      status.textContent = `launched ${slug} (pid ${data.job.pid})`;
    } else {
      status.textContent = `error: ${data.error || "unknown"}`;
    }
  } catch (e) {
    status.textContent = `network error`;
  }
  await pollStatus();
  await pollLogs();
}

function wireButtons() {
  document.querySelectorAll(".btn").forEach((b) => {
    b.addEventListener("click", () => runScript(b.dataset.slug));
  });
}

function start() {
  renderFilters();
  wireButtons();
  pollStatus();
  pollLogs();
  state.pollTimer = setInterval(() => { pollStatus(); pollLogs(); }, POLL_MS);
}

document.addEventListener("DOMContentLoaded", start);
