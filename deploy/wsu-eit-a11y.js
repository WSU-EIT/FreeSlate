/* ════════════════════════════════════════════════════════════════════════
   WSU EIT FORMS — ACCESSIBILITY HELPER & FIXER
   wsu-eit-a11y.js · Enrollment Information Technology

   THE ONE JavaScript file (dept. policy: CSS-first). It exists because every
   feature below is DOM surgery — adding attributes, removing elements,
   moving focus — which CSS cannot do. Hard ceiling: ≤10 features, ≤300
   lines. Current count: 9 features (A1–A9).

     A1 date-part selects get Month/Day/Year names (backstop — Slate names
        them natively today)
     A2 every nameless form control gets an aria-label from its question's
        caption (hidden controls INCLUDED — WAVE audits those too)
     A3 text-less <label> elements are removed (after A2 names the controls)
     A4 controls in required questions get aria-required="true" + a live
        "still blank" class CSS can use for an optional required-empty cue
        (ships off by default — the asterisk marks required)
     A5 Slate's floating failed-submit dialog gets role="alert" + focus, so
        screen readers hear what sighted users see
     A6 links opening new tabs get a hidden "(opens in new tab)" notice
     A7 untitled iframes get a title from their source host
     A8 images with NO alt attribute get alt="" (decorative default — readers
        skip them instead of reading file names)
     A9 the multi-page rail's current page gets aria-current="page"

   PRIME DIRECTIVE: anything already named/marked is never touched, so this
   file cannot fight hand-authored markup or future Slate fixes. Every pass
   is idempotent; deleting this file changes nothing visual.
   Re-runs (debounced) on DOM swaps: Slate replaces form fragments in-place.
   ════════════════════════════════════════════════════════════════════════ */
(function () {
  "use strict";

  var SR_NOTE = "wsu-eit-sr"; /* visually-hidden utility, defined in build.css */

  /* month stems: matches at string START, any case ("Jan", "SEPTEMBER").
     Every English month is unique in its first three letters. */
  var MONTH_WORDS = /^(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)/i;

  /* ── helpers ─────────────────────────────────────────────────────────── */

  /* Does ctrl already have an accessible name? `skip` = a label being judged
     for deletion; it must not vouch for the control it fails to name. */
  function isNamed(ctrl, skip) {
    if (ctrl.getAttribute("aria-label") || ctrl.getAttribute("aria-labelledby") || ctrl.getAttribute("title")) return true;
    if (ctrl.id) {
      var sel = null;
      try { sel = 'label[for="' + (window.CSS && CSS.escape ? CSS.escape(ctrl.id) : ctrl.id) + '"]'; } catch (e) {}
      if (sel) {
        var ls = document.querySelectorAll(sel);
        for (var i = 0; i < ls.length; i++) if (ls[i] !== skip && ls[i].textContent.trim()) return true;
      }
    }
    var host = ctrl.closest && ctrl.closest("label");
    return !!(host && host !== skip && host.textContent.trim());
  }

  /* The question's visible caption, cleaned: collapse whitespace runs
     (/\s+/g), strip trailing stars/colons/space (/[*:\s]+$/), cap at 90. */
  function captionFor(ctrl) {
    var q = ctrl.closest && ctrl.closest(".form_question");
    var cap = q && q.querySelector(".form_label");
    if (!cap) return "";
    var node = cap.firstElementChild && cap.firstElementChild.textContent.trim() ? cap.firstElementChild : cap;
    return node.textContent.replace(/\s+/g, " ").replace(/[*:\s]+$/, "").trim().slice(0, 90);
  }

  /* Classify a date-widget <select> by its OPTION CONTENTS (position varies
     by locale). /^(19|20)\d\d$/ = whole text is a 4-digit year 1900–2099;
     /^\d{1,2}$/ + range check = a calendar day. Thresholds: 3 month names
     or 3 years can't be accidental; a real day menu has 28–31 entries
     (rating scales stay under 25). Returns "" when unsure. */
  function datePartOf(sel) {
    var months = 0, days = 0, years = 0, total = 0;
    for (var i = 0; i < sel.options.length && i < 64; i++) {
      var v = (sel.options[i].textContent || "").trim();
      if (!v) continue;
      total++;
      if (MONTH_WORDS.test(v)) months++;
      else if (/^(19|20)\d\d$/.test(v)) years++;
      else if (/^\d{1,2}$/.test(v) && +v >= 1 && +v <= 31) days++;
    }
    if (!total) return "";
    if (months > 2) return "Month";
    if (years > 2) return "Year";
    if (days > 25) return "Day";
    return "";
  }

  /* ── the repair passes ───────────────────────────────────────────────── */

  function repair() {
    var i, c;

    /* A1 — date widgets first, so they get SPECIFIC names before A2's
       generic pass would claim them */
    var packs = document.querySelectorAll(".form_responses");
    for (i = 0; i < packs.length; i++) {
      var sels = packs[i].querySelectorAll("select");
      if (sels.length < 2) continue; /* single selects are ordinary dropdowns */
      var stem = captionFor(sels[0]);
      for (var s = 0; s < sels.length; s++) {
        if (isNamed(sels[s])) continue;
        var part = datePartOf(sels[s]);
        if (part) sels[s].setAttribute("aria-label", stem ? stem + " — " + part : part);
      }
    }

    /* A2 — every remaining nameless control, hidden included. Skipped types
       are exempt (hidden) or value-named (submit/button/reset/image). */
    var ctrls = document.querySelectorAll(".form_question input, .form_question select, .form_question textarea");
    for (i = 0; i < ctrls.length; i++) {
      c = ctrls[i];
      var kind = (c.type || "").toLowerCase();
      if (kind === "hidden" || kind === "submit" || kind === "button" || kind === "reset" || kind === "image") continue;
      if (!isNamed(c)) c.setAttribute("aria-label", captionFor(c) || "Form system field");
    }

    /* A3 — drop text-less labels now that controls are named. Kept if it
       wraps its control (removal would tear the control out too). */
    var labels = document.querySelectorAll("label");
    for (i = 0; i < labels.length; i++) {
      var lab = labels[i];
      if (lab.textContent.trim() || lab.getAttribute("aria-label")) continue;
      if (lab.querySelector("img[alt], svg, [aria-label]")) continue;
      if (lab.querySelector("input, select, textarea")) continue;
      if (lab.parentNode) lab.parentNode.removeChild(lab);
    }

    /* A4 — aria-required mirrors Slate's verified data-required="1" flag.
       Second half of the job: the crimson "still blank" edge (build.css
       §SLATE). Slate omits the native required attribute, so CSS
       :required:invalid can't see emptiness on these controls — we mirror
       it with a live class instead. Radios/checkboxes skip the edge: the
       star + legend already mark the GROUP; per-box edges read as noise. */
    var reqs = document.querySelectorAll('.form_question[data-required="1"] .form_responses input, .form_question[data-required="1"] .form_responses select, .form_question[data-required="1"] .form_responses textarea');
    for (i = 0; i < reqs.length; i++) {
      c = reqs[i];
      var k2 = (c.type || "").toLowerCase();
      if (k2 === "hidden" || k2 === "submit" || k2 === "button") continue;
      if (!c.required && !c.getAttribute("aria-required")) c.setAttribute("aria-required", "true");
      if (k2 === "radio" || k2 === "checkbox") continue;
      (function (el) {
        function paint() {
          el.classList[(el.value || "").replace(/\s+/g, "") ? "remove" : "add"]("wsu-eit-blank");
        }
        paint();                            /* initial state on load */
        el.addEventListener("input", paint);  /* typing */
        el.addEventListener("change", paint); /* selects, autofill, pickers */
      })(c);
    }

    /* A6 — new-tab links announce themselves. data flag keeps it idempotent;
       skipped when the author already says so in text or aria-label. */
    var blanks = document.querySelectorAll('a[target="_blank"]:not([data-eit-newtab])');
    for (i = 0; i < blanks.length; i++) {
      var a = blanks[i];
      a.setAttribute("data-eit-newtab", "1");
      var said = (a.textContent + " " + (a.getAttribute("aria-label") || "")).toLowerCase();
      if (said.indexOf("new tab") !== -1 || said.indexOf("new window") !== -1) continue;
      var note = document.createElement("span");
      note.className = SR_NOTE;
      note.textContent = " (opens in new tab)";
      a.appendChild(note);
    }

    /* A7 — untitled iframes get a name from their source host */
    var frames = document.querySelectorAll("iframe:not([title]):not([aria-label])");
    for (i = 0; i < frames.length; i++) {
      var host = "";
      try { host = new URL(frames[i].src, location.href).hostname; } catch (e) {}
      frames[i].setAttribute("title", host ? "Embedded content from " + host : "Embedded content");
    }

    /* A8 — images with NO alt attribute default to decorative. alt="" is
       correct-by-default here: a wrong empty alt skips an image; a missing
       alt makes readers announce the file name. Authors still win: any
       existing alt (even empty) is untouched. */
    var imgs = document.querySelectorAll("img:not([alt])");
    for (i = 0; i < imgs.length; i++) imgs[i].setAttribute("alt", "");

    /* A9 — Slate's rail marks the current page with class "selected"
       (visual only); aria-current makes it semantic */
    var railLinks = document.querySelectorAll("#menu a");
    for (i = 0; i < railLinks.length; i++) {
      if (railLinks[i].classList.contains("selected")) railLinks[i].setAttribute("aria-current", "page");
      else railLinks[i].removeAttribute("aria-current");
    }
  }

  /* A5 — Slate's failed-submit dialog mounts directly on <body>, outside
     the kit frame, with no role: sighted users see it, screen readers get
     silence. When a body-level element appears carrying validation-ish
     text, mark it role="alert" and focus it. Conservative: only roleless
     direct children of body, outside our frame, matching the wording. */
  var ALERTISH = /required|not.*complete|error|invalid|missing/i;
  function announceDialogs(nodes) {
    for (var i = 0; i < nodes.length; i++) {
      var n = nodes[i];
      if (!n || n.nodeType !== 1 || n.parentElement !== document.body) continue;
      if (n.id === "wsu-eit-frame" || n.closest("#wsu-eit-frame")) continue;
      if (n.getAttribute("role") || n.tagName === "SCRIPT" || n.tagName === "STYLE") continue;
      if (!ALERTISH.test(n.textContent || "")) continue;
      n.setAttribute("role", "alert");
      if (!n.hasAttribute("tabindex")) n.setAttribute("tabindex", "-1");
      try { n.focus(); } catch (e) {}
      return; /* one per batch — the dialog, not its backdrop */
    }
  }

  /* ── boot + observe (Slate swaps fragments in-place via AJAX) ────────── */
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", repair);
  else repair();

  if (window.MutationObserver) {
    var wait = null;
    new MutationObserver(function (muts) {
      var added = [];
      for (var m = 0; m < muts.length; m++)
        for (var a = 0; a < muts[m].addedNodes.length; a++) added.push(muts[m].addedNodes[a]);
      if (added.length) announceDialogs(added);
      if (wait) clearTimeout(wait);
      wait = setTimeout(repair, 120);
    }).observe(document.documentElement, { childList: true, subtree: true });
  }
})();
