/* ════════════════════════════════════════════════════════════════════════
   WSU EIT FORMS — OPT-IN PAGE ENHANCEMENTS
   wsu-eit-extras.js · Enrollment Information Technology

   The companion to wsu-eit-extras.css: where that file is opt-in LOOKS,
   this is opt-in BEHAVIOR. Hard ceiling (dept. policy): ≤10 features,
   ≤300 lines. Current count: 5 features (E1–E5).

   NATIVE FIRST (audited against the Slate Knowledge Base):
   anything Slate can do stays in Slate — we do not rebuild their wheels.
   Deliberately not built here — Slate already covers it:
     · deadline countdowns — Slate's registration deadlines, activation
       date/time (with its own "not yet live" message), the closed-form
       message, Liquid conditional text, and the Share join page's native
       countdown timer cover deadline messaging end to end
     · print buttons — browser-native; the kit's print styles do the work
   Likewise: filtering PORTAL DATA belongs in portal queries/Liquid loops
   (E5 below is for static pasted content only), and event maps, waitlist
   auto-transfer, and pre-filled fields via query-string parameters are all
   native Slate — see the showcase cheat sheets.

   Every feature here passed two tests:
     1. IMPOSSIBLE in CSS/HTML alone AND not provided by Slate.
     2. OPT-IN by data-attribute. A page with none of these attributes is
        completely untouched; Slate's own markup never triggers anything.

     E1 [data-eit-copy="#sel"]      button copies the target's text
                                    (confirmation numbers, CEEB codes)
     E2 textarea[data-eit-count]    live "characters left" counter
                                    (needs maxlength)
     E3 time[data-eit-local]        renders its datetime in the visitor's
                                    own timezone — Slate renders the
                                    EVENT's timezone only (KB: the offset
                                    field isn't available in form comms)
     E4 [data-eit-faq-toggle]       one button expands/collapses every
                                    .wsu-eit-faq in its section
     E5 input[data-eit-filter="#sel"] type-to-filter the children of a long
                                    STATIC list (FAQ stacks, program lists)

   Editors use these by pasting snippets from the showcase — never by
   writing JS. All ES5, no dependencies, safe on every page.
   ════════════════════════════════════════════════════════════════════════ */
(function () {
  "use strict";

  /* run once per element per feature — a data flag keeps every pass
     idempotent when Slate re-renders fragments and the observer re-runs */
  function once(el, flag) {
    if (el.getAttribute("data-eit-done-" + flag)) return false;
    el.setAttribute("data-eit-done-" + flag, "1");
    return true;
  }

  function enhance() {
    var i, el;

    /* ── E1 · copy buttons ──────────────────────────────────────────────
       <button class="wsu-eit-btn" data-eit-copy="#conf-num">Copy</button>
       Copies the TEXT of the element the selector points at. The button
       label confirms ("Copied!") and restores itself. */
    var copies = document.querySelectorAll("[data-eit-copy]");
    for (i = 0; i < copies.length; i++) {
      el = copies[i];
      if (!once(el, "copy")) continue;
      el.addEventListener("click", function () {
        var btn = this;
        var target = document.querySelector(btn.getAttribute("data-eit-copy"));
        if (!target || !navigator.clipboard) return;
        navigator.clipboard.writeText(target.textContent.trim()).then(function () {
          var orig = btn.textContent;
          btn.textContent = "Copied!";
          setTimeout(function () { btn.textContent = orig; }, 1400);
        });
      });
    }


    /* ── E2 · character counter ─────────────────────────────────────────
       <textarea maxlength="500" data-eit-count></textarea>
       Adds a live "N characters left" line under the box. aria-live is
       "polite" so screen readers hear updates without being interrupted;
       updates announce only on pause (input events are debounced by the
       browser's own live-region batching). */
    var counts = document.querySelectorAll("textarea[data-eit-count][maxlength]");
    for (i = 0; i < counts.length; i++) {
      el = counts[i];
      if (!once(el, "count")) continue;
      var max = parseInt(el.getAttribute("maxlength"), 10);
      var line = document.createElement("p");
      line.className = "wsu-eit-fine";
      line.setAttribute("aria-live", "polite");
      el.insertAdjacentElement("afterend", line);
      (function (area, out, cap) {
        function update() {
          var left = cap - area.value.length;
          out.textContent = left + (left === 1 ? " character left" : " characters left");
        }
        area.addEventListener("input", update);
        update();
      })(el, line, max);
    }

    /* ── E3 · local-time rendering ──────────────────────────────────────
       <time data-eit-local datetime="2026-10-18T09:00-07:00">
         Oct 18, 9:00 a.m. Pacific</time>
       The fallback text (what's typed inside) stays for everyone without
       JS; with JS, it re-renders in the visitor's own timezone. Why JS:
       the server can't know the visitor's timezone; CSS can't format
       dates. The original text moves to title for hover reference. */
    var times = document.querySelectorAll("time[data-eit-local][datetime]");
    for (i = 0; i < times.length; i++) {
      el = times[i];
      if (!once(el, "local")) continue;
      var stamp = new Date(el.getAttribute("datetime"));
      if (isNaN(stamp)) continue;
      try {
        var text = new Intl.DateTimeFormat(undefined, {
          dateStyle: "medium", timeStyle: "short"
        }).format(stamp);
        el.setAttribute("title", el.textContent.trim());
        el.textContent = text + " (your local time)";
      } catch (e) { /* ancient browser: fallback text stands */ }
    }


    /* ── E4 · expand/collapse-all for FAQ stacks ────────────────────────
       <button class="wsu-eit-btn" data-eit-faq-toggle>Expand all</button>
       Operates on every .wsu-eit-faq inside the button's parent section —
       long policy pages become printable/searchable in one click. */
    var toggles = document.querySelectorAll("[data-eit-faq-toggle]");
    for (i = 0; i < toggles.length; i++) {
      el = toggles[i];
      if (!once(el, "faq")) continue;
      el.setAttribute("aria-expanded", "false");
      el.addEventListener("click", function () {
        var btn = this;
        var scope = btn.parentElement || document;
        var faqs = scope.querySelectorAll("details.wsu-eit-faq");
        var open = btn.getAttribute("aria-expanded") !== "true";
        for (var f = 0; f < faqs.length; f++) faqs[f].open = open;
        btn.setAttribute("aria-expanded", String(open));
        btn.textContent = open ? "Collapse all" : "Expand all";
      });
    }

    /* ── E5 · type-to-filter long STATIC lists ─────────────────────────────────
       <input type="search" data-eit-filter="#program-list"
              aria-label="Filter programs">
       Hides direct children of the target that don't contain the typed
       text. A polite count line is created underneath automatically. */
    var filters = document.querySelectorAll("input[data-eit-filter]");
    for (i = 0; i < filters.length; i++) {
      el = filters[i];
      if (!once(el, "filter")) continue;
      (function (input) {
        var list = document.querySelector(input.getAttribute("data-eit-filter"));
        if (!list) return;
        var out = document.createElement("p");
        out.className = "wsu-eit-fine";
        out.setAttribute("aria-live", "polite");
        input.insertAdjacentElement("afterend", out);
        input.addEventListener("input", function () {
          var q = input.value.trim().toLowerCase(), shown = 0;
          for (var c = 0; c < list.children.length; c++) {
            var hit = !q || list.children[c].textContent.toLowerCase().indexOf(q) !== -1;
            list.children[c].hidden = !hit;
            if (hit) shown++;
          }
          out.textContent = q ? shown + " of " + list.children.length + " shown" : "";
        });
      })(el);
    }
  }

  /* boot now, re-run when Slate swaps fragments in-place (debounced) */
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", enhance);
  else enhance();
  if (window.MutationObserver) {
    var wait = null;
    new MutationObserver(function () {
      if (wait) clearTimeout(wait);
      wait = setTimeout(enhance, 150);
    }).observe(document.documentElement, { childList: true, subtree: true });
  }
})();
