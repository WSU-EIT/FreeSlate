# WSU Admissions — Slate Form Kit v3.0

A consistent, accessible, on-brand styling system for every Slate-hosted form,
event, and portal page in the WSU Admissions instance. Built to score **0 errors
in WAVE / AXE** and to match `admission.wsu.edu`.

## New in v3.0 (over v2.0)
- **AAA token corrections** in `wsu-forms.css`: control-border `#767676` (fixes the
  `#b3b3b3` 2.3:1 border that *failed* WCAG 1.4.11), split error/success *ink* tokens
  for 7:1 text, `@media (forced-colors)` focus, datepicker `z-index`, and an
  `@media print` block. build.xslt: decorative cougar SVG `aria-hidden`, redundant
  link `title` removed.
- **Gotcha + accessibility callouts** threaded into the doc pages
  (`.sg-callout--gotcha` amber, `.sg-callout--a11y` green): framework policy on
  Foundations; the inline-`display` reveal trap on Conditional Logic; Date/Address/
  Signature/Translation traps on the Field Type Library; the pipeline landmines on
  the Deployment Guide.
- **Accessibility Checklist** extended with 10 advanced-AAA items (forced-colors,
  reflow, text-spacing, autocomplete, signature/video alternatives, CAPTCHA policy,
  email a11y, print, SR test matrix).
- **Section-level variant tabs** + page-level variants (registration form, status,
  email) so options can be compared live.

> v2.0 remains frozen as the meeting-stable snapshot. v3.0 is the current line.


---

## What's in this folder

```
build.xslt              ← drop-in replacement for /shared/build.xslt
wsu-forms.css           ← the form layer (tokens, components, Slate mapping, tables)
wsu-chrome.css          ← header, footer, banner, breadcrumbs, identity bar
styleguide.css          ← documentation-site presentation ONLY (do NOT ship to Slate)
assets/                 ← cougar head PNGs
index.html              ← kit home / navigation hub
*.html                  ← 11 showcase + example pages (kebab-cased for Slate URLs)
```

### The three production files (these go to Slate)
| File | Slate path | Purpose |
|---|---|---|
| `wsu-forms.css` | `/shared/wsu-forms.css` | All form styling. Scoped under `.wsu-content`. Includes the **Slate mapping layer** (§12) that themes raw `.form_question` / `#menu` markup. |
| `wsu-chrome.css` | `/shared/wsu-chrome.css` | Header, footer, EM banner, breadcrumbs. Self-contained (var fallbacks). |
| `build.xslt` | `/shared/build.xslt` | Page template — links the two CSS files and wraps every page in WSU chrome. |

`styleguide.css` powers the documentation pages only — **never upload it to Slate.**

---

## Deploy (test instance first — a broken build.xslt takes down ALL pages)

1. **Upload** `wsu-forms.css`, `wsu-chrome.css`, and `build.xslt` to the **`/dev/`** folder in Database → Files (Branding Editor).
2. **Preview** a real form in the test instance (`wst-2.test.technolutions.net`). Run WAVE. Check at 375px.
3. **Publish** (Branding Editor → Publish) to copy `/dev/` → `/shared/`.
4. **Cache-bust:** every later edit, bump the `?v=YYYYMMDD` on the `<link>` in `build.xslt`, or Slate serves the stale copy for up to 24h.
5. Hard-refresh (`Cmd/Ctrl+Shift+R`) a live form to confirm.

Full walkthrough: `deployment-guide.html`. Accessibility acceptance: `accessibility-checklist.html`.

---

## ⚠ Two selectors to verify against a real rendered form (then ship)

The Slate mapping layer (`wsu-forms.css` §12) styles the markup Slate emits. Two
hooks are best-guesses until confirmed in your instance — inspect a **required**
field and a **failed-validation** field in DevTools and correct if needed:

1. **Required marker** — assumed `.form_question[data-required="1"]` *or* `.form_required`. Confirm which (if either) Slate adds, then keep that selector.
2. **Validation** — assumed `.form_error` (message) + `.error` (wrapper). Confirm the real class names.

Everything else (`.form_question`, `.form_label`, `.form_responses`, `.form_response`, `.form_layout_stacked`, `#side`, `#menu`, `.ui-datepicker-calendar`, the `div[role="banner"]` identity bar) matches observed Slate output.

---

## What changed from v1.0

- **Buttons** → Crimson `#a60f2d` default, Dark-Crimson `#680222` hover (both AAA white-text; v1 used red `#ca1237` which was AA only).
- **Slate mapping layer** added — a raw Slate form now themes correctly with **no custom HTML** from the content editor.
- **Logged-in identity bar** — the stock gray strip is restyled to WSU crimson via `div[role="banner"]`.
- **Tables** (Widget Table) styled with crimson header rule, zebra, and mobile collapse.
- **Two CSS files unified-friendly** — chrome is self-contained (`var(--x, fallback)`), no cross-file dependency bug.
- **`build.xslt`** — links the kit, loads Montserrat, single-color wordmark, two-layer footer with the Lighty contact block, © 2026.
- Filenames **kebab-cased** so Slate File URLs don't become `%20`-encoded.
- Dead code removed; choice-card focus ring strengthened for WCAG 2.2.

Brand basis: **WSU 2025 Brand Expansion** (verified verbatim against the official
"Colors and Gradients 2025" + cheat-sheet PDFs) layered on the WSU Web Design
System. Web font: **Montserrat** (the live WDS font; switch only if Web Comm directs).

---

## Backlog (not yet built)
- Validate §12 against the live test instance (top priority).
- Event listing/search page · interview scheduler · portal widget zoo · counselor portal.
- Hosted-vs-embedded comparison · mobile torture test.
- Email templates: add MSO/Outlook conditional comments + dark-mode meta for full bulletproofing.
