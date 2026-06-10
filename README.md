# FreeSlate — WSU Slate Form Kit

A consistent, accessible, on-brand styling system for every externally hosted page
in the WSU Admissions **Slate (Technolutions)** instance — forms, event registration,
multi-page applications, portals, and Deliver email. Built to match
`admission.wsu.edu`, follow the WSU brand, and score **0 errors in WAVE / AXE**.

The kit is plain HTML, CSS, and XSLT. No build step, no framework, no dependencies.

---

## Why this exists

Slate hosts WSU Admissions' public-facing forms and portals, but out of the box it
renders them with dated, partially inaccessible defaults that don't match the
university's web presence. Restyling happens through exactly one sanctioned
mechanism: a global XSLT template (`/shared/build.xslt`) plus CSS files uploaded to
Slate's file store. This repo is that mechanism, done once, correctly:

- **One source of truth** for how every Slate page looks, instead of per-form ad-hoc CSS.
- **Brand-accurate** — verified against the official WSU brand guidelines and the
  live WSU Web Design System (Montserrat, crimson `#a60f2d`, the signature h1 rule).
- **Accessibility first** — WCAG 2.1 AA throughout, AAA where the brand palette
  allows, forced-colors and reduced-motion support, and an interactive audit checklist.
- **Editor-proof** — a raw Slate form themes correctly with *no* custom HTML, and
  content editors get a small, documented class vocabulary plus a form-builder tool
  so they never need to touch code.

---

## Quick start

**Just looking?** Open `index.html` in a browser (or serve the repo with any static
file server). It's the kit's documentation hub — design foundations, a library of
every styled field type, worked example pages, deployment instructions, and tools.
Nothing to install.

**Content editor building a form?** Start at `start-here.html`, then
`editor-guide.html`. The drag-drop **Form Builder** (`wsu-form-builder.html`) lets
you design a form visually, see a live WSU-styled preview, and copy a step-by-step
"Slate Build Sheet" — the exact clicks to recreate it in Slate's form editor
(Slate has no form import, so the build sheet *is* the hand-off).

**Admin deploying to Slate?** See [Deploying](#deploying-to-slate) below and
`deployment-guide.html` for the full walkthrough.

---

## What's in the repo

### Production files — the only files that go to Slate

| File | Slate path | Purpose |
|---|---|---|
| `build.xslt` | `/shared/build.xslt` | Global page template. Wraps every Slate-hosted page in WSU chrome (header, footer, fonts) and links the two kit stylesheets *after* the legacy Web Design System files, so the kit wins the cascade without `!important`. |
| `wsu-forms.css` | `/shared/wsu-forms.css` | The form layer: design tokens, typography, every field type, validation states, page patterns, tables, and the **Slate mapping layer** that themes Slate's raw output (`.form_question`, `.form_label`, `#menu`, the logged-in identity bar) directly. Everything is scoped under `.wsu-content`. Also defines the editor-facing classes (below). |
| `wsu-chrome.css` | `/shared/wsu-chrome.css` | Header, footer, Enrollment Management banner, breadcrumbs. Self-contained (uses `var(--x, fallback)`), so it works with or without `wsu-forms.css`. |
| `wsu-carousel.js` | per-form scripts or `<path>/default.js` | Optional. Accessible, dependency-free carousel for `.wsuf-carousel`: keyboard support, play/pause, live-region announcements, never autoplays under `prefers-reduced-motion`. |
| `assets/` | as referenced | Cougar head logo PNGs (crimson, gray). |

> `styleguide.css`, `variants.css`/`variants.js`, and `slate-hints.css`/`slate-hints.js`
> power the documentation site only. **Never upload them to Slate.**

### Documentation & showcase site

`index.html` is the hub; every page below is self-contained and linked from it.

**Guides**
- `start-here.html` — 5-minute orientation for non-coders.
- `editor-guide.html` — task-based, plain-language how-to for content editors.
- `foundations.html` — color, typography, spacing, tokens, and how the kit reaches Slate.
- `deployment-guide.html` — which files go where, the `build.xslt` link block, cache-busting, dev→publish, rollback.
- `accessibility-checklist.html` — interactive audit checklist mapped to WAVE/AXE error codes (state persists in localStorage).
- `slate-defaults-fixed.html` — catalog of Slate's default papercuts and the exact fix for each.

**Component references**
- `field-type-library.html` — every Slate field type, styled, with copy-paste HTML and an accessibility note per field.
- `states-and-errors.html` — field states, error summary, form-closed / capacity-full / deadline-passed / thank-you pages.
- `status-badges.html` — badges, payment status, checklist states, decision card, deadline countdown.
- `conditional-logic.html` — all four Slate condition patterns (show/hide, cascade, value piping, conditional required), live and annotated.
- `media-gallery.html` — responsive photo grid + the carousel, and where each piece goes in Slate.
- `email-templates.html` / `email-library.html` — Deliver email templates and reusable inline-CSS blocks (confirmation, reminder, decision release).

**Worked examples** — realistic full pages built with the kit
- `registration-form.html` — a real production form rebuilt: validation, conditional logic, EM masthead, passing WAVE.
- `multi-page-form.html` — 4-step paged form with progress indicator, left-rail nav, per-page validation, review screen.
- `event-registration.html` — event landing page with hero, capacity bar, stat tiles, inline registration.
- `applicant-portal.html` — applicant status portal: left-rail nav, status checklist, deadline table, action-required notices.

**Tool**
- `wsu-form-builder.html` — single-file, zero-dependency form designer. Drag-drop and keyboard-operable; outputs a live preview in Slate-shaped markup plus a copyable, printable Slate Build Sheet.

### Reference documents
- `wsu-brand-reference.md` — the styling source of truth: the legacy-Spine→Web-Design-System migration map, brand tokens, the selectors Slate actually emits, and the full field palette.
- `ROADMAP.md` — planned and in-progress work.
- `docs/` — working notes and decision logs.

---

## Deploying to Slate

> ⚠ **A broken `build.xslt` takes down every external Slate page** — forms, events,
> portals, all of it. Always deploy to the test instance first.

1. **Upload** `wsu-forms.css`, `wsu-chrome.css`, and `build.xslt` to the **`/dev/`**
   folder in Database → Files (Branding Editor).
2. **Preview** a real form in the test instance. Run WAVE. Check at 375 px width.
3. **Publish** (Branding Editor → Publish) to copy `/dev/` → `/shared/`.
4. **Cache-bust:** on every subsequent edit, bump the `?v=YYYYMMDD` on the
   corresponding `<link>` in `build.xslt`, or Slate serves the stale copy for up to 24 h.
5. Hard-refresh (`Cmd/Ctrl+Shift+R`) a live form to confirm.

Full walkthrough with rollback steps: `deployment-guide.html`.

### Verify before trusting: two selectors

The Slate mapping layer styles the markup Slate emits. Two hooks are best-guesses
until confirmed against *your* instance — inspect a **required** field and a
**failed-validation** field in DevTools and correct if needed:

1. **Required marker** — assumed `.form_question[data-required="1"]` or `.form_required`.
2. **Validation** — assumed `.form_error` (message) and `.error` (wrapper).

Everything else in the mapping layer matches observed Slate output.

---

## The editor-facing class API

Content editors never need raw CSS. The full vocabulary they may type into the
Slate editor is six classes, all self-contained and safe to nest in pasted content:

`.wsu-note` · `.wsu-warn` · `.wsu-button` · `.wsu-two-col` · `.wsu-small` · `.wsu-divider`

The kit also includes a Word-paste neutralizer that strips pasted `font-family` /
size / color so WSU typography always wins. Live examples: `editor-guide.html`.

---

## Accessibility

The kit targets **WCAG 2.1 AA everywhere and AAA where the brand palette permits**:
7:1 ink tokens for error/success text, AAA-compliant button colors, visible focus
rings (including `forced-colors` mode), reduced-motion handling, print styles, and
≥16 px inputs (no iOS zoom). `accessibility-checklist.html` is the acceptance
gate — every item maps to a WAVE/AXE error code.

---

## License

MIT © WSU Enrollment IT. See `LICENSE`.
