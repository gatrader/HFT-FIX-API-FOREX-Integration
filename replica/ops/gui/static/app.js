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
  // If the operator clicks a row in the recent-jobs list we pin the
  // log viewer to that job_id; otherwise we follow the current job.
  selectedJobId: null,
  // Cache of the last status payload so the stop button knows what
  // job to target without a re-fetch.
  lastStatus: null,
};

function highlight(line) {
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

function jobState(job) {
  if (!job) return "idle";
  if (job.ended_at === null || job.ended_at === undefined) {
    return job.stop_requested_at ? "stopping" : "running";
  }
  return job.exit_code === 0 ? "exited" : "failed";
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
    state.lastStatus = s;

    $("host").textContent = `host ${s.host}`;
    $("branch").textContent = `branch ${s.git?.branch || "—"}${s.git?.dirty ? "*" : ""}`;
    $("commit").textContent = `commit ${s.git?.commit || "—"}`;
    $("server-time").textContent = s.server_time || "";

    const modeEl = $("mode");
    modeEl.className = "mode " + (s.mode || "");
    modeEl.textContent = `mode ${s.mode || "—"}`;

    const runState = jobState(s.current_job);
    const pill = $("run-state");
    pill.className = `pill ${runState}`;
    pill.textContent = runState;

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

    renderJobs(s.recent_jobs || []);

    // Stop button is enabled only when the current job is still running
    // and we aren't already pinned to a finished job.
    const stop = $("stop-btn");
    const canStop = s.running && (!state.selectedJobId ||
                                  state.selectedJobId === s.current_job?.id);
    stop.disabled = !canStop;
    stop.dataset.targetJob = canStop ? s.current_job.id : "";

    // Disable launch buttons for scripts the host doesn't have.
    const avail = s.scripts_available || {};
    document.querySelectorAll(".btn[data-slug]").forEach((b) => {
      const unavailable = avail[b.dataset.slug] === false;
      const busy = s.running;
      b.disabled = unavailable || busy;
      b.title = unavailable ? "script not found on this host"
              : busy ? "another job is running; stop it first" : "";
    });
  } catch (e) {
    // Transient fetch errors are common across GUI restarts; the next
    // tick will catch up. Swallow quietly.
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

function renderJobs(jobs) {
  const list = $("jobs-list");
  $("jobs-count").textContent = String(jobs.length);
  list.innerHTML = "";
  for (const j of jobs) {
    const st = jobState(j);
    const selected = state.selectedJobId === j.id ? "selected" : "";
    const ended = j.ended_at ? ` · ended ${j.ended_at}` : "";
    const rc = j.exit_code !== null && j.exit_code !== undefined ?
               ` · rc=${j.exit_code}` : "";
    list.insertAdjacentHTML("beforeend", `
      <li class="job-item ${selected}" data-job-id="${esc(j.id)}">
        <div class="row">
          <span class="slug">${esc(j.slug)}</span>
          <span class="state ${st}">${st}</span>
        </div>
        <div class="ts">${esc(j.started_at)}${esc(ended)}${esc(rc)}</div>
      </li>
    `);
  }
  list.querySelectorAll(".job-item").forEach((li) => {
    li.addEventListener("click", () => {
      const id = li.dataset.jobId;
      // Click the selected row again to unpin and follow "current".
      state.selectedJobId = (state.selectedJobId === id) ? null : id;
      pollStatus();
      pollLogs();
    });
  });
}

async function pollLogs() {
  try {
    const q = new URLSearchParams();
    if (state.activeFilters.size) {
      q.set("filter", Array.from(state.activeFilters).join(","));
    }
    if (state.selectedJobId) q.set("job_id", state.selectedJobId);
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

async function runScript(slug, confirmMsg) {
  if (confirmMsg && !window.confirm(confirmMsg)) return;
  const status = $("action-status");
  status.textContent = `launching ${slug}…`;
  try {
    const r = await fetch("/api/run/" + encodeURIComponent(slug), { method: "POST" });
    const data = await r.json();
    if (data.ok) {
      status.textContent = `launched ${slug} (pid ${data.job.pid})`;
      // Following current job again after a new launch feels right.
      state.selectedJobId = null;
    } else {
      status.textContent = `error: ${data.error || "unknown"}`;
    }
  } catch (e) {
    status.textContent = `network error`;
  }
  await pollStatus();
  await pollLogs();
}

async function stopJob() {
  const btn = $("stop-btn");
  const jobId = btn.dataset.targetJob;
  if (!jobId) return;
  if (!window.confirm(btn.dataset.confirm || "Stop the running job?")) return;
  const status = $("action-status");
  status.textContent = `stopping ${jobId}…`;
  btn.disabled = true;
  try {
    const r = await fetch("/api/stop/" + encodeURIComponent(jobId), { method: "POST" });
    const data = await r.json();
    if (data.ok) {
      status.textContent = `stopped ${jobId} (signal ${data.signal}${
        data.exit_code !== undefined && data.exit_code !== null ? `, rc=${data.exit_code}` : ""
      })`;
    } else {
      status.textContent = `stop error: ${data.error || "unknown"}`;
    }
  } catch (e) {
    status.textContent = `network error`;
  }
  await pollStatus();
  await pollLogs();
}

function wireButtons() {
  document.querySelectorAll(".btn[data-slug]").forEach((b) => {
    b.addEventListener("click", () => runScript(b.dataset.slug, b.dataset.confirm));
  });
  $("stop-btn").addEventListener("click", stopJob);
}

function start() {
  renderFilters();
  wireButtons();
  pollStatus();
  pollLogs();
  state.pollTimer = setInterval(() => { pollStatus(); pollLogs(); }, POLL_MS);
}

document.addEventListener("DOMContentLoaded", start);
