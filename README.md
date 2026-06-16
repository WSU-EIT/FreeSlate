# FreeSlate

> A complete, accessible, brand-exact styling and component kit for externally hosted pages in WSU Admissions' **Slate (Technolutions)** instance — forms, events, and portals.

Built by **Enrollment Information Technology (EIT)** at Washington State University. Plain CSS + XSLT with two small, justified JS files. No build step, no framework, no dependencies.

[![License: MIT](https://img.shields.io/badge/License-MIT-crimson.svg)](LICENSE)

---

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [File Reference](#file-reference)
- [Design Tokens](#design-tokens)
- [Components](#components)
- [Accessibility](#accessibility)
- [Conventions for Content Editors](#conventions-for-content-editors)
- [Deployment](#deployment)
- [Showcase & Tune the Kit](#showcase--tune-the-kit)
- [Research & Patterns](#research--patterns)
- [License](#license)

---

## Overview

FreeSlate provides everything needed to brand and enhance WSU Admissions' Slate pages:

- **Brand-exact theming** — WSU Crimson, Montserrat typeface, official cougar marks, and the full brand accent palette
- **WCAG 2.2 AA accessible** — contrast, focus rings, ARIA repairs, skip links, touch targets, reduced-motion/high-contrast/forced-colors support
- **CSS-first, progressive enhancement** — JavaScript adds; it never carries
- **41 tunable design tokens** — live-configurable within brand-safe ranges
- **11 opt-in CSS components** — carousel, FAQ accordion, steps, cards, stats, banner, timeline, badges, tables, scroll-reveal animations, and more
- **5 opt-in JS behaviors** — copy buttons, character counters, local-time rendering, FAQ expand-all, static-list filter
- **9 automated a11y repairs** — fixing accessibility gaps that CSS alone cannot address

---

## Quick Start

1. **Browse the showcase** — open `index.html` in a browser to see all documented, searchable examples with live previews and copyable markup.
2. **Deploy to Slate** — upload the files marked ✅ below to your Slate instance's `/shared/` directory via the Branding Editor.
3. **Preview & Publish** — always preview on the test instance before publishing. Bump `?v=` cache stamps in `build.xslt` on any subsequent file edit.

---

## Architecture

### Deployment Flow

```
 ┌──────────────────┐        ┌──────────────────────────────────┐
 │   GitHub Repo    │        │   Slate Instance (/shared/)      │
 │   (FreeSlate)    │        │   (Technolutions-hosted)         │
 │                  │  UPLOAD│                                  │
 │  build.xslt ─────┼───────►│  build.xslt                     │
 │  build.css ──────┼───────►│  build.css                      │
 │  build-fonts.css ┼───────►│  build-fonts.css                │
 │  wsu-eit-extras. ┼───────►│  wsu-eit-extras.css             │
 │  wsu-eit-a11y.js ┼───────►│  wsu-eit-a11y.js                │
 │  wsu-eit-extras. ┼───────►│  wsu-eit-extras.js              │
 │                  │        │                                  │
 │  index.html ✗    │        │  (not deployed — local only)     │
 │  wsu-eit-show*.  │        │                                  │
 └──────────────────┘        └───────────────┬──────────────────┘
                                             │
                                             │ SERVES
                                             ▼
                              ┌──────────────────────────────────┐
                              │  Visitor's Browser               │
                              │                                  │
                              │  ┌─ build.xslt wraps the page   │
                              │  │   into #wsu-eit-frame         │
                              │  │                               │
                              │  ├─ build.css styles everything  │
                              │  │   (tokens cascade to rules)   │
                              │  │                               │
                              │  ├─ a11y.js repairs DOM a11y     │
                              │  │   gaps impossible in CSS      │
                              │  │                               │
                              │  └─ extras.js activates only     │
                              │      where data-eit-* exists     │
                              └──────────────────────────────────┘
```

### File Composition (What Loads on Every Page)

```
 ┌─────────────────────────────────────────────────────────────────────────┐
 │  build.xslt  (XSLT page template — the master wrapper)                 │
 │                                                                         │
 │   <link>  build-fonts.css ─── @import Montserrat + wsu-icons from CDN  │
 │   <link>  build.css ──────── §TOKENS → §TYPE → §INPUTS → §BUTTONS     │
 │                               → §CHROME → §SLATE → §GUARDS            │
 │   <link>  wsu-eit-extras.css ── 11 opt-in components (CSS-only)        │
 │   <script> wsu-eit-a11y.js ──── 9 automated DOM repairs                │
 │   <script> wsu-eit-extras.js ── 5 opt-in behaviors (data-eit-*)        │
 │                                                                         │
 │   <div id="wsu-eit-frame" class="wsu-eit">                             │
 │     ├── skip link                                                       │
 │     ├── .wsu-eit-topbar (logo + nav)                                   │
 │     ├── .wsu-eit-zone   (Slate's form content)                         │
 │     └── .wsu-eit-footer                                                │
 │   </div>                                                                │
 └─────────────────────────────────────────────────────────────────────────┘
```

### CSS Cascade: Tokens → Rules

```
  build.css §TOKENS (the 41 tunable knobs)
  ─────────────────────────────────────────────
  :root {
    --wsu-eit-body-size: 1rem;     ─┐
    --wsu-eit-round: 6px;           │  Change a token here…
    --wsu-eit-focus: 3px;          ─┘
  }
          │
          │  referenced by
          ▼
  build.css §TYPE / §INPUTS / §BUTTONS / §CHROME
  ─────────────────────────────────────────────
  .wsu-eit input {
    border-radius: var(--wsu-eit-round);   ◄── …and every rule follows
    font-size: var(--wsu-eit-body-size);
  }
  .wsu-eit :focus-visible {
    outline-width: var(--wsu-eit-focus);
  }
```

### Documentation Generator Pipeline

```
  ┌─────────────────────────────────────────────────────────────────┐
  │  docs-generator/Program.cs  (run: cd docs-generator && dotnet run)  │
  │                                                                 │
  │  ┌──────────────┐     ┌──────────────┐     ┌───────────────┐   │
  │  │ HttpListener │     │  Playwright  │     │  Markdown     │   │
  │  │ serves       │────►│  headless    │────►│  generator    │   │
  │  │ index.html   │     │  Chromium    │     │               │   │
  │  │ on :8799     │     │              │     │  41 settings  │   │
  │  └──────────────┘     │  clicks      │     │  + screenshots│   │
  │                       │  "Tune" tab  │     │  + a11y notes │   │
  │                       │              │     │  + CSS refs   │   │
  │                       │  screenshots │     │               │   │
  │                       │  each card   │     └───────┬───────┘   │
  │                       └──────────────┘             │           │
  └────────────────────────────────────────────────────┼───────────┘
                                                       │
                                                       ▼
                          ┌──────────────────────────────────────┐
                          │  usermanual-images/*.png (41 files)  │
                          │  usermanual.md (references them)     │
                          └──────────────────────────────────────┘
```

**Ownership hook:** `build.xslt` wraps every page in `<div id="wsu-eit-frame" class="wsu-eit">`. All kit rules scope to `.wsu-eit` (global) or `.wsu-eit-zone` (form content area). If a rule doesn't start with `.wsu-eit`, it doesn't belong in this kit.

**Naming grammar (BEM-style):**

| Pattern | Meaning | Example |
|---------|---------|---------|
| `wsu-eit-badge` | Component | The badge pill |
| `wsu-eit-mark__crest` | Piece (`__`) | The crest inside the wordmark |
| `wsu-eit-badge--done` | Variant (`--`) | Success state of a badge |

---

## File Reference

| File | Deploy to Slate? | Purpose |
|------|:---:|---------|
| `build.css` | ✅ `/shared/` | Core styling layer — design tokens, page frame, links, chrome, typography, inputs, buttons, Slate mapping layer, validation, editor utilities, guards (print/motion/contrast) |
| `build-fonts.css` | ✅ `/shared/` | Montserrat (brand typeface) + wsu-icons via `@import` |
| `wsu-eit-extras.css` | ✅ `/shared/` | 11 opt-in CSS-only components + accent utilities |
| `build.xslt` | ✅ `/shared/` | XSLT page template — links all assets, carries the page structure (header, footer, skip link). **A broken build.xslt takes down every external page.** |
| `wsu-eit-a11y.js` | ✅ `/shared/` | Accessibility repairs — 9 DOM fixes impossible in CSS (control naming, empty-label removal, ARIA-required, focus management, new-tab notices) |
| `wsu-eit-extras.js` | ✅ `/shared/` | 5 opt-in behaviors activated by `data-eit-*` attributes |
| `wsu-eit-showcase.js` | ❌ | Showcase page interactivity (search, filters, Tune-the-kit configurator) |
| `wsu-eit-glossary.js` | ❌ | Glossary tooltip system for the showcase |
| `wsu-eit-icons.js` | ❌ | Brand icon library renderer for the showcase |
| `index.html` | ❌ | Internal showcase/documentation page — never deployed to Slate |
| `RESEARCH.md` | ❌ | Pattern audit with adoption decisions for every CSS/HTML/a11y pattern evaluated |

---

## Design Tokens

All colors, spacing, and sizing values live once in `build.css` under `§TOKENS`. Change a value there and every rule follows.

> **💡 New to CSS custom properties?** See the [W3Schools CSS Variables tutorial](https://www.w3schools.com/css/css3_variables.asp) — it explains `:root`, `var()`, and fallback values in 5 minutes.

**Brand colors:**

| Token | Value | Use |
|-------|-------|-----|
| `--wsu-eit-brand` | `#a60f2d` | WSU Crimson (PMS 201C) |
| `--wsu-eit-brand-deep` | `#680222` | Pressed states, gradient terminus |
| `--wsu-eit-brand-text` | `#7a0b21` | Crimson for text & links (AAA on white) |
| `--wsu-eit-flag` | `#ca1237` | Secondary red — required stars, topbar rule |

**Tunable tokens (41 controls):**

Type, shape & density, brand cues, and page tokens are all adjustable within brand-safe bounds via the showcase's "Tune the kit" configurator. Examples:

- `--wsu-eit-body-size` (15–18px)
- `--wsu-eit-round` (0–24px corner radius)
- `--wsu-eit-focus` (2–8px focus ring)
- `--wsu-eit-col` (56–96rem content width)

---

## Components

### Core (build.css)

Automatically applied to Slate's rendered markup:

- Page frame with sticky footer
- Skip link
- Topbar with cougar wordmark + sliding-indicator nav
- Unit footer (Office of Admissions)
- Typography (fluid h1, balanced headings, pretty paragraphs)
- Form inputs, selects, textareas
- Buttons (crimson CTA with touch-target enforcement)
- Slate mapping layer (`.form_question`, `.form_label`, radios, checkboxes, page rail)
- Validation states (aria-invalid, required-empty edge hint)
- Editor utilities (`.wsu-eit-note`, `.wsu-eit-warn`, `.wsu-eit-cols`, `.wsu-eit-fine`)

### Extras (wsu-eit-extras.css)

Opt-in via one wrapper class:

| Component | Class | Description |
|-----------|-------|-------------|
| Photo Carousel | `.wsu-eit-reel` | CSS scroll-snap strip, no autoplay |
| FAQ Accordion | `.wsu-eit-faq` | Native `<details>` with smooth open |
| Numbered Steps | `.wsu-eit-steps` | CSS-countered process steps |
| Card Grid | `.wsu-eit-cards` | Auto-fit grid with hover lift |
| Stat Tiles | `.wsu-eit-stats` | Big-number hero tiles |
| Banner / Hero | `.wsu-eit-banner` | Brand gradient CTA block |
| Timeline | `.wsu-eit-timeline` | Dotted milestone line |
| Badges | `.wsu-eit-badge` | Status pills (`--done`, `--wait`, `--todo`, `--info`) |
| Tables | `.wsu-eit-table` | Zebra stripes, sticky header, safe overflow |
| Scroll Reveal | `.wsu-eit-reveal` | Fade-and-rise on scroll (CSS-only) |
| Feature Cards | `.wsu-eit-features` | Image overlay cards with crimson focus frame |

### Accent Utilities

- Edge recoloring: `.wsu-eit-edge--autumn`, `--goldfinch`, `--vineyard`, `--sky`, `--midnight`
- Highlighter: `<mark class="wsu-eit-hi">`
- Panes: `.wsu-eit-pane--midnight`, `.wsu-eit-pane--sky`

---

## Accessibility

### Automated Repairs (wsu-eit-a11y.js)

| ID | Repair | Why JS is required |
|----|--------|-------------------|
| A1 | Date-part selects get Month/Day/Year labels | DOM attribute injection |
| A2 | Nameless form controls get `aria-label` | DOM attribute injection |
| A3 | Empty `<label>` elements removed | DOM removal |
| A4 | Required controls get `aria-required` + blank-state class | DOM + live class toggle |
| A5 | Failed-submit dialog gets `role="alert"` + focus | DOM + focus management |
| A6 | External links get "(opens in new tab)" SR notice | DOM insertion |
| A7 | Untitled iframes get a `title` from source host | DOM attribute injection |
| A8 | Images without `alt` get `alt=""` (decorative default) | DOM attribute injection |
| A9 | Current page in rail gets `aria-current="page"` | DOM attribute injection |

### CSS Guards

- `prefers-reduced-motion: reduce` — kills all transitions/animations
- `forced-colors: active` — high-contrast mode support
- `prefers-contrast: more` — firmer borders and thicker underlines
- `@media print` — hides chrome, exposes link URLs

---

## Conventions for Content Editors

1. **Four Slate surfaces** — form Instructions tool (HTML blocks), field help text, event Description tab, portal static content blocks
2. **One class does the work** — components are a single wrapper class around ordinary HTML
3. **Naming grammar** — `wsu-eit-{component}` · `__{piece}` · `--{variant}` (always paired with base)
4. **Colors are tokens** — nobody types hex values into content, ever
5. **Behaviors are opt-in** — no `data-eit-*` attribute = no JS behavior

---

## Deployment

| Step | Action |
|------|--------|
| 1 | Upload files marked ✅ to `/shared/` via Slate's Branding Editor |
| 2 | Preview a real form in the **test instance** |
| 3 | Publish |
| 4 | Bump `?v=` cache stamps in `build.xslt` on any subsequent file edit |

> ⚠️ **Safety:** A malformed `build.xslt` takes down every external page. Always test-instance preview before publishing.

---

## Showcase & Tune the Kit

Open `index.html` locally to access:

- **Browse mode** — search, filter by tags/chapters, view all examples with live previews and copyable markup (pretty ⇄ minified)
- **Tune the Kit mode** — a full-width design-token configurator with 41 grouped controls, each with a live example and on/off switch
- **Export** — generates a paste-ready `:root` override block annotated with deviations from defaults
- **Randomize (brand-safe)** — explores random token combinations within brand constraints

```
  Tune-the-Kit Workflow
  ═════════════════════

  ┌──────────────────────┐         ┌──────────────────────────────┐
  │  index.html          │         │  Slate Instance              │
  │  (local showcase)    │         │                              │
  │                      │         │                              │
  │  Tune the Kit tab    │         │                              │
  │  ┌────────────────┐  │         │                              │
  │  │ Adjust sliders │  │         │                              │
  │  │ + choices      │  │         │                              │
  │  └───────┬────────┘  │         │                              │
  │          │           │         │                              │
  │          ▼           │         │                              │
  │  ┌────────────────┐  │  PASTE  │  ┌─────────────────────────┐ │
  │  │ Copy override  │──┼────────►│  │ build.css §TOKENS :root │ │
  │  │ block button   │  │         │  │                         │ │
  │  └────────────────┘  │         │  │ --wsu-eit-round: 12px;  │ │
  │                      │         │  │ --wsu-eit-focus: 4px;   │ │
  │                      │         │  └─────────────────────────┘ │
  │                      │         │              │               │
  └──────────────────────┘         │              ▼               │
                                   │  Every page picks up the     │
                                   │  new token values instantly  │
                                   └──────────────────────────────┘
```

Settings persist per-browser and affect only the showcase until exported to `build.css`.

---

## Research & Patterns

See [`RESEARCH.md`](RESEARCH.md) for the full pattern audit — every relevant CSS, HTML, and accessibility pattern evaluated with adopt/already/skip verdicts, plus the Slate-native feature audit ensuring the kit never rebuilds Technolutions' own wheels.

---

## Helpful Tutorials (W3Schools)

Quick-reference links for the CSS/HTML patterns this kit uses:

| Topic | Link | Why it matters here |
|-------|------|---------------------|
| CSS Custom Properties (Variables) | [w3schools.com/css/css3_variables.asp](https://www.w3schools.com/css/css3_variables.asp) | The 41 design tokens are CSS custom properties |
| CSS `var()` function | [w3schools.com/cssref/func_var.php](https://www.w3schools.com/cssref/func_var.php) | How rules consume token values |
| CSS `:root` selector | [w3schools.com/cssref/sel_root.php](https://www.w3schools.com/cssref/sel_root.php) | Where tokens are declared |
| CSS `border-radius` | [w3schools.com/css/css3_borders.asp](https://www.w3schools.com/css/css3_borders.asp) | The `--wsu-eit-round` token |
| CSS `font-size` | [w3schools.com/cssref/pr_font_font-size.php](https://www.w3schools.com/cssref/pr_font_font-size.php) | Body/heading size tokens |
| CSS `rem` vs `px` units | [w3schools.com/cssref/css_units.php](https://www.w3schools.com/cssref/css_units.php) | Why the kit uses rem for text |
| CSS `outline` (focus rings) | [w3schools.com/cssref/pr_outline.php](https://www.w3schools.com/cssref/pr_outline.php) | Focus ring tokens |
| CSS Flexbox | [w3schools.com/css/css3_flexbox.asp](https://www.w3schools.com/css/css3_flexbox.asp) | Layout primitives in components |
| CSS Grid | [w3schools.com/css/css_grid.asp](https://www.w3schools.com/css/css_grid.asp) | Card grids, stat tiles |
| CSS `@media` queries | [w3schools.com/css/css3_mediaqueries.asp](https://www.w3schools.com/css/css3_mediaqueries.asp) | Guards (print, motion, contrast) |
| HTML `<details>` / `<summary>` | [w3schools.com/tags/tag_details.asp](https://www.w3schools.com/tags/tag_details.asp) | FAQ accordion component |
| HTML `data-*` attributes | [w3schools.com/tags/att_data-.asp](https://www.w3schools.com/tags/att_data-.asp) | Opt-in JS behaviors |
| ARIA attributes | [w3schools.com/accessibility/accessibility_aria.php](https://www.w3schools.com/accessibility/accessibility_aria.php) | The 9 a11y repairs |
| CSS `scroll-snap` | [w3schools.com/cssref/css_pr_scroll-snap-type.php](https://www.w3schools.com/cssref/css_pr_scroll-snap-type.php) | Photo carousel component |
| XSLT Introduction | [w3schools.com/xml/xsl_intro.asp](https://www.w3schools.com/xml/xsl_intro.asp) | Understanding build.xslt |

---

## License

[MIT](LICENSE) © WSU Enrollment IT
