# WSU EIT Forms — brand, styling & accessibility kit

A complete, accessible, brand-exact styling and content kit for every
externally hosted page in the WSU Admissions **Slate (Technolutions)**
instance — forms, events, and portals — built by **Enrollment Information
Technology (EIT)**.

Plain CSS + an XSLT page template, with two small, justified JavaScript
files. No build step, no framework, no dependencies. Everything a visitor
sees is styled by CSS that reads from one set of design tokens; the brand
lives in one place and every page follows.

---

## Design principles

1. **CSS-first.** If a stylesheet can do it, a stylesheet does it. JavaScript
   is reserved for the few jobs CSS genuinely cannot perform (DOM repairs,
   opt-in behaviors), and each JS file is capped at ≤10 features / ≤300 lines.
2. **Progressive enhancement.** Every page works with no JavaScript at all.
   Scripts add convenience and repair accessibility; they never carry the
   experience.
3. **Single source of truth.** All colors, sizes, and spacing live once as
   design tokens (`--wsu-eit-*` CSS custom properties) in `build.css §TOKENS`.
   Content never hard-codes a hex value or a pixel size.
4. **Brand-exact.** Crimson is `#A60F2D` (PMS 201 C); Montserrat is the web
   face; the 70/20/10 color ratio and accent rules come straight from
   brand.wsu.edu. The kit cannot drift off-brand because there is nowhere to
   type an off-brand value.
5. **Accessible by construction.** WCAG 2.2 AA throughout (much of it AAA):
   visible focus, 44px targets on touch, contrast floors, native semantics,
   and a JavaScript layer that repairs what Slate's own markup leaves behind.
6. **Theme Slate, don't fight it.** The kit restyles the markup Slate emits
   (`.form_question`, `.form_label`, `#menu`, …), sets Slate's own official
   `--fw-*` framework color variables to brand values where they exist (see
   below), and stays out of the way of anything Slate or a content author
   already did correctly.

---

## Working with Slate's framework variables (`--fw-*`)

Slate's public-page framework paints some of its chrome — datepickers, the
suggest/autocomplete dropdown, dialogs, tab strips, the default submit button,
and the required/validation wash — from a documented set of `--fw-*` CSS
custom properties, *not* from the `.form_*` markup the §SLATE layer restyles.
`build.css §SLATEVARS` maps those variables to our `--wsu-eit-*` tokens at
`:root`, so that chrome is themed **at the source**:

- It reaches UI our own selectors can't (e.g. the calendar popup's active day
  becomes crimson, the autocomplete hover becomes mist).
- It replaces two override hacks with Slate's sanctioned mechanism: the pink
  required/error wash is switched off via `--fw-error-background` (the official
  equivalent of resetting `.form_question.required`), and the default submit is
  painted via `--fw-button-default-background`.
- Only variables with a real brand mapping are set; the rest keep Slate's
  defaults. Reference: Slate Knowledge Base ▸ Branding ▸ *Custom Color
  Replacement*.

This is additive — it does not replace the §SLATE markup layer, it
complements it for the framework-drawn UI that markup styling can't reach.
The `--fw-*` variables can also be scoped to `form[data-fw-form]` to theme
Slate forms only; we set them at `:root` on purpose, since the kit brands all
public pages (forms, events, portals) alike.

**Separate from this:** the WYSIWYG editor's own color swatches (the palette
content authors pick from in forms, Deliver, and portals) are *not* CSS — they
come from a config key, **Database ▸ Configuration Keys ▸ General Settings ▸
HTML Color Palette Override** (a comma-separated list of up to 24 hex codes).
Set it to the brand palette so authored content can't reach for off-brand ink.

---

## Quick start

- **See everything:** open `index.html` in a browser. It's a searchable
  catalog of 108 paste-ready patterns, 27 sourced brand-rule cards, the 80-icon
  brand set, logos, and photography — each with a live preview and copy-paste
  markup, and each annotated with *what / why / how / when / in Slate / learn
  more*. A **Tune the kit** tab lets you try design-token changes live and
  export them.
- **Deploy:** upload the deploy set to Slate's `/shared/` → preview a real
  form in the **test instance** → Publish → bump the `?v=` cache stamp on any
  file you later edit. Full workflow under *Deploying to Slate* below. A
  malformed `build.xslt` takes down every external page, so the test-instance
  preview is not optional.
- **Go deeper:** `SLATE-COOKBOOK.md` has copy-paste examples for every Slate
  surface this kit touches — the XSLT page template, conditional branding,
  the `--fw-*` overrides, the Slate DOM contract, per-form CSS, Instructions
  blocks, portals + Liquid, events, deployment, and caching.

---

## Deploying to Slate

Slate serves external pages from two folders, edited through **Database ▸
Branding ▸ Branding Editor**:

- **`/dev`** — the Branding Editor's sandbox. *Import Current* copies `/shared`
  → `/dev`; *Preview* renders a real page with the dev files applied without
  touching anything live.
- **`/shared`** — live. Every external page is served from here. **Publish
  copies `/dev` → `/shared`, so Publish *is* the deploy.**

Workflow: edit in `/dev` → **Preview** a real form **in the test instance** →
**Publish** → **bump the `?v=` stamp** in `build.xslt` for any file you changed.

- **Cache busting is manual and non-obvious.** Editing `build.css` alone shows
  nothing — Slate caches CSS/JS server-side. Bump the `?v=` query on that
  file's `<link>`/`<script>` in `build.xslt`. Propagation: up to ~15 min across
  production nodes, up to ~24 h for browser cache (incognito bypasses the
  latter for spot checks).
- **Rollback:** Database ▸ Files ▸ `/dev` ▸ select file ▸ *Version History* ▸
  *Revert* — the safety net when an edit misbehaves.
- **Mobile uses a different switch.** Slate serves phones a minimalist "default
  grey" template unless you point mobile at ours: Database ▸ Configuration Keys
  ▸ Branding, Privacy, & Ping ▸ **Mobile Template** → `/shared/build.xslt`.
  Without this, `build.css` never runs on mobile. (Details in
  `SLATE-COOKBOOK.md` ▸ Deployment.)
- **Never skip the test instance.** A malformed `build.xslt` is a failed
  transform on *every* external page at once — all public forms, events, and
  portals down together. Logos/graphics made in test must be re-uploaded to
  Production on activation.

**Deploy set** (upload all to `/shared/`): `build.xslt`, `build-fonts.css`,
`build.css`, `wsu-eit-extras.css`, `wsu-eit-a11y.js`, `wsu-eit-extras.js`.
**Never deploy** the showcase files: `index.html`, the `index_*.html` views,
`wsu-eit-showcase.js`, `wsu-eit-view.js`, `wsu-eit-icons.js`,
`wsu-eit-glossary.js`, and the docs.

---

## The files

### Deployed to Slate (`/shared/`)

| File | What it is |
|---|---|
| `build.xslt` | The page template Slate wraps every external page in: topbar, footer, the `wsu-eit` ownership hook, skip link, and the links to everything below. **A broken `build.xslt` breaks every external page — test instance first, always.** |
| `build-fonts.css` | Montserrat (the brand web face) + the WSU icon font, via `@import`. |
| `build.css` | The whole styling layer: design tokens, page frame, global links, type, inputs, buttons, the verified Slate mapping layer, validation, and print / contrast / motion guards. Fully commented with a Ctrl+F **FIND-IT index** (`§TOKENS`, `§LINKS`, `§INPUTS`, `§ERRORS`, …). |
| `wsu-eit-extras.css` | Eleven opt-in, CSS-only components an editor adds with one wrapper class — carousel, FAQ accordion, steps, cards, stats, banner, timeline, badges, feature cards, tables, scroll-reveal — plus `§ACCENTS` utilities for the approved secondary colors. Its own FIND-IT index inside. |
| `wsu-eit-a11y.js` | **Accessibility helper & fixer.** Nine repairs that are impossible in CSS, each verified against real Slate output (control naming, empty-label removal, date-part names, `aria-required`, failed-submit alert, new-tab notices, iframe titles, `alt` backstop, `aria-current`). Idempotent; re-runs on Slate's AJAX fragment swaps. Deleting it restores some WAVE errors but changes nothing visual. |
| `wsu-eit-extras.js` | **Opt-in behaviors,** activated only by `data-eit-*` attributes: copy buttons, character counter, local-time rendering, FAQ expand-all, static-list filter. A page with none of those attributes is untouched. Anything Slate does natively was deliberately left out (see RESEARCH.md). |

### Showcase only (never linked from `build.xslt`)

| File | What it is |
|---|---|
| `index.html` | The showcase / sample page above. Internal tool; its scripts never ship to Slate. |
| `index_essentials.html`, `index_readability.html`, `index_form-feel.html`, `index_brand-guardrails.html`, `index_presets.html` | Five **curated views** of the Tune tab — each shows only the handful of settings a given audience actually wants, so the team can decide which subset to expose instead of debating all of them at once. `…_presets.html` swaps the knobs for a three-way personality picker. |
| `wsu-eit-showcase.js` | The showcase page's interactivity: search, tag/chapter/class filtering, pretty⇄minified snippet toggle, copy-to-clipboard, the vision simulator, per-example docs, and the Tune-the-kit configurator. External because Slate's static host blocks inline scripts; the showcase's own styling stays inline in `index.html`. |
| `wsu-eit-view.js` | The curated-view layer the five `index_*.html` files load. Reads a small `window.WSU_VIEW` config and hides every Tune card except its allow-list (or renders the preset picker). Touches nothing in the kit. |
| `wsu-eit-icons.js` | The 80 official brand icons baked in as inline-SVG data, so the showcase needs zero separate icon uploads. |
| `wsu-eit-glossary.js` | Plain-English tooltips: jargon in the explanatory copy gets a dotted underline + a tap/keyboard popover, and a full glossary collapses into the About chapter. |
| `README.md`, `RESEARCH.md` | This file, and the pattern-decision record (what the kit uses, and what it deliberately skips, with reasons). |
| `SLATE-COOKBOOK.md` | Copy-paste examples for every Slate surface this kit touches — XSLT page template, conditional branding, `--fw-*` overrides, the Slate DOM contract, per-form CSS, Instructions blocks, portals + Liquid, events, deployment, and caching. The platform-integration companion to RESEARCH.md (which covers CSS/HTML pattern decisions). |

Brand **icons** (`wsu-eit-icon-*.svg`) and **images** (`wsu-eit-img-*.png`)
re-host into Slate Files as needed. Names are prefixed so a filename sort
groups them: `build*` (Slate template trio) · `wsu-eit-*.css/.js` (kit code)
· `wsu-eit-icon-*` · `wsu-eit-img-*`.

---

## Tune the kit

The showcase's **Tune the kit** tab is a live design-token configurator. It
opens full-width as grouped cards — **Type**, **Shape & density**, **Brand
cues**, **Page** — with 41 controls, each driving a real `build.css §TOKENS`
variable bounded to a brand-safe range (the character-creator model: move any
control, you still can't leave the brand).

- Every card carries a **live example** consuming the exact token it changes,
  plus an **On / Off** switch that previews the page with that treatment
  removed.
- **Randomize (brand-safe)** explores; **Reset** returns to shipped defaults.
- **Export** emits a paste-ready `:root` override block listing only the
  values that differ from shipped — so a stakeholder meeting ends with a
  deliverable, not a vibe. Drop it into a `wsu-eit-overrides.css` loaded after
  `build.css`, or paste it into `build.css §TOKENS` directly.
- Settings persist per-browser and affect only the showcase; no real form
  changes until the override lands in `build.css`.

Because 41 controls is a lot to hand a stakeholder, the five `index_*.html`
views each expose a different curated subset — a way to find the settings
people actually care about and get down to those.

---

## Modern CSS used (and why)

The kit leans on modern CSS where it earns its place, and skips the rest on
purpose (the full rationale is in `RESEARCH.md`):

- **Custom properties / design tokens** — the whole theming model.
- **`min()` / `calc()`** — the heading scale enforces `h3 ≤ h2` structurally
  (`min(var(--h3-size), calc(var(--h2-size) - .05rem))`), no script needed.
- **`color-mix()`** — the pressed/hover crimson is derived from the brand
  token (`@supports`-gated, with a hex fallback), so a one-line brand change
  carries its interaction states with it.
- **`clamp()`** — fluid `h1` sizing for small screens.
- **`:has()`** — the required-field marker logic, with no extra classes.
- **`:user-invalid`** — validation styling that appears only after the visitor
  has interacted, mirroring Slate's `aria-invalid` hook.
- **`field-sizing: content`** — textareas grow with their content
  (`@supports`-gated).
- **`text-wrap: balance` / `pretty`** — headline and paragraph rag control.
- **`accent-color`, `scroll-snap`, `:focus-visible`, `scrollbar-gutter`,
  `color-scheme`** — native controls, the no-JS carousel, keyboard focus, and
  layout-shift / forced-dark defenses.
- **`forced-colors`, `prefers-contrast`, `prefers-reduced-motion`** — honored
  globally and per component.

Deliberately skipped: cascade layers (would lower the kit's specificity
against Slate's unlayered framework CSS), container queries (single-column
form pages), `oklch()` authoring (brand hexes are contractual), view
transitions and `popover`/`<dialog>` (out of scope).

---

## JavaScript (kept minimal on purpose)

Only **two** JS files ship to Slate, and both exist only because CSS cannot do
their job:

- `wsu-eit-a11y.js` — DOM repairs (adding ARIA, removing empty labels, moving
  focus). Nine features, each impossible in CSS and each verified against real
  Slate output. Idempotent and observer-driven, because Slate replaces form
  fragments in place.
- `wsu-eit-extras.js` — five opt-in behaviors that only activate on
  `data-eit-*` attributes an author adds deliberately.

Both are ES5, dependency-free, and capped at ≤10 features / ≤300 lines.
Everything else with `.js` in its name (`showcase`, `view`, `icons`,
`glossary`) belongs to the showcase page and never reaches a Slate form.

---

## Accessibility

- **Targets:** WCAG 2.2 AA across the kit, AAA where practical (7:1 body
  contrast, 3px visible focus ring, 44px touch targets).
- **Native first:** real `<button>`, `<details>`, `<table>`, `<ol>` doing
  their own jobs; `accent-color` on real checkboxes/radios.
- **The repair layer** (`wsu-eit-a11y.js`) names every control Slate leaves
  nameless, removes empty labels, mirrors `aria-required`, announces Slate's
  otherwise-silent failed-submit dialog, flags new-tab links and untitled
  iframes, and marks the current page in the rail — all without touching
  anything already authored correctly.
- **Honored preferences:** reduced motion, increased contrast, forced colors,
  and the visitor's own text-size and timezone.

---

## For content editors — the global-first promise

**You should almost never touch code.** Branding lives in two global files
(`build.xslt` + `build.css`) that theme every public page automatically, so the
normal workflow is entirely native Slate: build the form/event/portal with the
Form Builder (fields, Required flags, help text, conditional logic, deadlines,
merge fields) and it comes out on-brand and accessible with zero markup. Open a
code segment only for an extra a native tool can't express — dropping in an
image, a spinner, or a kit component via an Instructions block. Five
conventions for those moments:

1. **Four Slate surfaces:** the form builder's *Instructions tool* (HTML
   blocks), a field's *help text* (plain text), an event's *Description tab*,
   and a portal's *static content blocks*. Questions are built with Slate's
   native field types — the kit themes the raw builder output automatically.
2. **One class does the work** — a component is a single wrapper class around
   ordinary HTML.
3. **Naming grammar** — `wsu-eit-badge` (component) · `__piece` · `--variant`
   (always paired with its base).
4. **Colors are tokens** — nobody types a hex value into content, ever.
5. **Behaviors are opt-in** — no `data-eit-*` attribute, no JS behavior.

**Prefer native over custom, always.** Date formatting (Liquid `date` filter),
deadlines, countdowns, conditional display, calculations, and input masks are
all native Slate features — use them instead of custom code. The kit's own JS
is a deliberately tiny floor: a11y repairs Slate's markup needs, plus a handful
of opt-in behaviors (the only one with no native equivalent being a
visitor-local-timezone `<time>` renderer, since the server can't know the
viewer's timezone).

For a genuine one-off a form needs that the instance-wide kit shouldn't carry,
use Slate's per-form **Edit Styles**, scoped to `#form_<GUID>_container …` (the
`<GUID>` is the 32-char id in the form's URL) so the rule can't leak to other
forms. `SLATE-COOKBOOK.md` has the pattern.

---

## Concept index — what this kit implements

| Concept | Used for | Learn more |
|---|---|---|
| Design tokens / single source of truth | all colors & sizes live once in `build.css §TOKENS` | [Single source of truth](https://en.wikipedia.org/wiki/Single_source_of_truth) |
| BEM-style naming | the `component__piece--variant` grammar | [Naming conventions](https://en.wikipedia.org/wiki/Naming_convention_(programming)) |
| Progressive enhancement | CSS-first; JS adds, never carries | [Progressive enhancement](https://en.wikipedia.org/wiki/Progressive_enhancement) |
| WCAG accessibility | contrast, targets, focus, labels throughout | [WCAG](https://en.wikipedia.org/wiki/Web_Content_Accessibility_Guidelines) |
| WAI-ARIA | the a11y file's repairs (labels, alerts, current) | [WAI-ARIA](https://en.wikipedia.org/wiki/WAI-ARIA) |
| Screen readers | why empty labels & nameless fields matter | [Screen reader](https://en.wikipedia.org/wiki/Screen_reader) |
| Skip links | first element of every page | [Skip link](https://en.wikipedia.org/wiki/Skip_link) |
| Responsive design | auto-fit grids, fluid type, coarse-pointer targets | [Responsive web design](https://en.wikipedia.org/wiki/Responsive_web_design) |
| Native disclosure widgets | the `<details>` FAQ accordion | [Progressive disclosure](https://en.wikipedia.org/wiki/Progressive_disclosure) |
| CSS scroll snap | the no-JS photo carousel | [CSS](https://en.wikipedia.org/wiki/CSS) |
| Separation of concerns | content (Slate) vs style (kit) vs behavior (opt-in JS) | [Separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns) |
| XSLT templating | how `build.xslt` wraps every Slate page | [XSLT](https://en.wikipedia.org/wiki/XSLT) |
| Liquid markup | Slate-native conditional content (reach for it before JS) | [Template processor](https://en.wikipedia.org/wiki/Template_processor) |
| Brand management | exact colors, the one gradient, accent rules | [Brand management](https://en.wikipedia.org/wiki/Brand_management) |

---

## Where the Slate community actually is

There is no public GitHub theming kit for Technolutions Slate other than this
one — every other "slate" repo is an unrelated project that shares the name. So
the community knowledge the KB keeps gesturing at lives off GitHub:

- **ReWorkflow ReSource** (`resource.reworkflow.com/books/slate`) — the largest
  public Slate wiki; real CSS/JS selectors, the undocumented `Form.*` and `FW.*`
  JS APIs, and form/portal recipes. The single most useful outside source.
- **Technolutions Community Forums** (`community.technolutions.net`) and the
  **Slate Users Slack** — live Q&A the KB points to for branding help.
- **Clean Slate / Showcase environments** — Technolutions-provisioned demo
  databases with example portals/dashboards to copy patterns from.

`SLATE-COOKBOOK.md` folds the concrete selectors and APIs from these into
copy-paste form.

---
© Washington State University · Built by Enrollment Information Technology
