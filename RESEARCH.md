# v10 RESEARCH — pattern catalog & site findings

> The deep-dive behind v10: every page and file in the kit reviewed, checked
> against the modern CSS/HTML/a11y pattern canon (MDN, WCAG 2.2, web.dev,
> GOV.UK & USWDS design systems, every-layout/defensive-css idioms).
> Verdicts: **ADOPTED** (new in v10) · **ALREADY** (kit had it) · **SKIP** (with reason).

## 0 · Responsibility Boundaries

```
 ┌─────────────────────────────────────────────────────────────────────────┐
 │                     VISITOR'S BROWSER                                   │
 │                                                                         │
 │  ┌─────────────────────────────────────┐  ┌──────────────────────────┐  │
 │  │  FreeSlate Kit (our code)           │  │  Slate Platform          │  │
 │  │  ─────────────────────────────────  │  │  (Technolutions' code)   │  │
 │  │                                     │  │  ────────────────────────│  │
 │  │  OWNS:                              │  │  OWNS:                   │  │
 │  │  • Page frame & chrome              │  │  • Form field rendering  │  │
 │  │  • Typography & brand colors        │  │  • Validation logic      │  │
 │  │  • Input/button styling             │  │  • AJAX navigation       │  │
 │  │  • 41 design tokens                 │  │  • Conditional display   │  │
 │  │  • 11 CSS components (opt-in)       │  │  • Payment processing    │  │
 │  │  • 9 a11y DOM repairs               │  │  • Data submission       │  │
 │  │  • 5 JS behaviors (opt-in)          │  │  • Event registration    │  │
 │  │                                     │  │  • Portal queries/data   │  │
 │  │  NEVER TOUCHES:                     │  │  • Countdown timers      │  │
 │  │  • Form submission                  │  │  • Activation dates      │  │
 │  │  • Field values/validation logic    │  │  • Waitlist logic        │  │
 │  │  • Slate's event/portal features    │  │  • Closed-form messages  │  │
 │  │  • Navigation between pages         │  │                          │  │
 │  │  • Overlays/dialogs                 │  │                          │  │
 │  └─────────────────────────────────────┘  └──────────────────────────┘  │
 │                                                                         │
 │              ▲ SCOPING RULE: .wsu-eit ▲                                 │
 │              │  (all kit CSS lives inside this boundary)                │
 │              │                                                          │
 └──────────────┼──────────────────────────────────────────────────────────┘
                │
                │  served by
                ▼
 ┌─────────────────────────────────────────────────────────────────────────┐
 │  Slate Instance (/shared/)                                              │
 │  build.xslt wraps every page in #wsu-eit-frame.wsu-eit                 │
 │  ───────────────────────────────────────────────────────────────────── │
 │  Technolutions hosts • we upload via Branding Editor                   │
 └─────────────────────────────────────────────────────────────────────────┘
```

## 1 · CSS patterns evaluated

| Pattern | Verdict | Notes |
|---|---|---|
| `:focus-visible` rings | ALREADY | everywhere; 3px brand ring |
| `accent-color` on radios/checkboxes | ALREADY | §SLATE |
| `aspect-ratio` media | ALREADY | reel, photo grids |
| flex/grid + `gap` everywhere | ALREADY | no margin-hack layouts |
| `text-wrap: balance` headings | ALREADY | §TYPE |
| `text-wrap: pretty` body text | **ADOPTED** | §TYPE, paragraph orphan control |
| Fluid type via `clamp()` | **ADOPTED** | h1 only — forms don't need a full fluid scale |
| `scroll-margin-top` anchor targets | **ADOPTED** | headings; anchored links no longer hide under the viewport edge |
| `:user-invalid` | **ADOPTED** | native-validation parity with the verified `aria-invalid` hook |
| `field-sizing: content` textareas | **ADOPTED** | @supports-gated; grows with input |
| `::selection` brand wash | **ADOPTED** | goldfinch behind ink — AA (11.7:1) |
| `scrollbar-gutter: stable` | **ADOPTED** | kills layout shift between short/long forms |
| `color-scheme: light` | **ADOPTED** | stops forced-dark extensions inverting form fields |
| `prefers-contrast: more` | **ADOPTED** | 2px ink borders, thicker underlines |
| Print: expose external URLs | **ADOPTED** | `a[href^="http"]::after` in §GUARDS |
| 44px targets on coarse pointers | **ADOPTED** (buttons) / ALREADY (choice rows) | WCAG 2.5.8 |
| `interpolate-size` smooth `<details>` | **ADOPTED** (extras §FAQ) | @supports-gated; snaps open elsewhere |
| `prefers-reduced-motion` | ALREADY | global kill + per-component |
| `forced-colors` | ALREADY | §GUARDS |
| sr-only utility | **ADOPTED** | `.wsu-eit-sr`, clip-path variant; also used by the a11y script |
| `@layer` cascade layers | SKIP | would *lower* kit specificity vs Slate's unlayered framework CSS |
| Container queries | SKIP | single-column form pages; media queries suffice |
| `oklch()` colors | SKIP | brand hexes are contractual; conversion adds risk, zero value |
| View transitions | SKIP | Slate owns navigation; motion budget already spent |
| `popover` / `<dialog>` | SKIP | nothing in scope needs an overlay; Slate's dialog is theirs |
| `:has()` beyond current use | ALREADY/CAPPED | required-marker fix uses it; no further need |
| Masonry / subgrid | SKIP | no layout calls for it |
| Scroll-driven animation | ALREADY | extras §REVEAL, triple-guarded |

## 2 · HTML patterns evaluated

| Pattern | Verdict | Notes |
|---|---|---|
| `<details>/<summary>` accordion | ALREADY | extras §FAQ |
| `autocomplete` tokens | ALREADY (samples) | test page demonstrates; Slate emits its own on real forms |
| `inputmode`/`enterkeyhint` | SKIP (kit) | per-field markup belongs to Slate's builder, documented in showcase |
| Skip link + `tabindex="-1"` target | ALREADY | build.xslt |
| `aria-current="page"` on nav | **ADOPTED** (JS A9) | Slate's rail marks `.selected` visually only |
| `(opens in new tab)` SR notice | **ADOPTED** (JS A6) | classic GOV.UK pattern |
| `alt` on every image | **ADOPTED** (JS A8 backstop) | missing-alt → `alt=""` so readers skip, not read filenames |
| `<iframe title>` | **ADOPTED** (JS A7 backstop) | Slate embeds ship untitled |
| `aria-required` | **ADOPTED** (JS A4) | mirrors the verified `data-required="1"` hook |
| Alert announcement on failed submit | **ADOPTED** (JS A5) | Slate's floating dialog is visual-only; SR users got silence |
| `<search>` element, `<hgroup>` | SKIP | no benefit inside Slate's emitted structure |

## 3 · Site findings (v9 review)

- **build.css** — sound architecture (ownership hook, §-index, verified mapping layer). Gaps fixed in v10: no sr-only utility, no `:user-invalid`, h1 fixed-size on small phones, anchored-heading scroll clipping, print hid link destinations.
- **build-fonts.css** — correct and minimal; unchanged.
- **wsu-eit-extras.css** — ten components all hold up; FAQ open was abrupt (now smooth where supported). Badge palette already brand-derived + AA-verified.
- **wsu-eit-aria.js** — three solid repairs, but the name undersold it and other cheap, impossible-in-CSS wins existed. v10: renamed **wsu-eit-a11y.js**, capped at 9 features / ≤300 lines (hard policy ceiling: 10 features, 300 lines).
- **build.xslt** — clean; only link updates needed.
- **test-page.html** — extended with fixtures for every new JS feature so the page proves the whole stack offline.
- **showcase** — unchanged (display tool); patterns inherit the CSS upgrades automatically.

## 4 · The 9 JS features (each impossible in CSS)

```
  Slate's Rendered DOM                    wsu-eit-a11y.js Repairs
  ──────────────────────                  ─────────────────────────
  <select> (no label)        ───A1/A2──▶  aria-label="Month" injected
  <label></label> (empty)    ───A3─────▶  element removed from DOM
  <input data-required="1">  ───A4─────▶  aria-required="true" added
  [Submit clicked, errors]   ───A5─────▶  role="alert" + focus moved
  <a target="_blank">        ───A6─────▶  "(opens in new tab)" appended
  <iframe> (no title)        ───A7─────▶  title="content from host.edu"
  <img> (no alt)             ───A8─────▶  alt="" (decorative fallback)
  .selected rail link        ───A9─────▶  aria-current="page" set
```

A1 date-part select naming (backstop) · A2 name every nameless control ·
A3 remove empty labels · A4 `aria-required` mirror · A5 announce + focus
Slate's failed-submit alert · A6 "(opens in new tab)" SR notice ·
A7 title untitled iframes · A8 `alt=""` backstop · A9 `aria-current` on the rail.
Declined (too clever / risky): duplicate-id rewriting (breaks `label[for]`),
auto table captions (invents content), focus restoration across AJAX swaps
(Slate owns it), heading-level repair (content judgment).

## 5 · Slate-native audit (Knowledge Base, 2026-06-11)

Checked every extras.js feature against knowledge.technolutions.net so we
never force Slate admins to change native workflows:

```
  Feature Decision Tree
  ═════════════════════

  "Should we build this?"
           │
           ▼
  ┌─────────────────────────────────┐
  │  Does Slate already do this     │
  │  natively (KB search)?          │
  └───────────┬───────────┬─────────┘
              │YES        │NO
              ▼           ▼
  ┌───────────────────┐  ┌──────────────────────┐
  │  CUT from kit.    │  │  Does it require      │
  │  Document Slate's │  │  field/form logic?    │
  │  native way in    │  └──────┬──────────┬────┘
  │  cheat sheets.    │         │YES       │NO
  └───────────────────┘         ▼          ▼
                       ┌────────────┐  ┌─────────────┐
                       │  SKIP.     │  │  KEEP in    │
                       │  Belongs   │  │  extras.js  │
                       │  to Slate  │  │  (data-eit) │
                       └────────────┘  └─────────────┘
```

| Feature | Slate-native? | Action |
|---|---|---|
| Deadline countdown | YES in substance — registration deadlines, activation date/time with custom pre-live message, closed-form message, Liquid conditional text, and the Share join page's countdown timer | **CUT** — use Slate's tools |
| Print button | Browser-native | **CUT** |
| Local-time rendering | NO — Slate renders the event's timezone; KB confirms the tz-offset field isn't even available in form communications (their workaround is a Liquid snippet that only renames the zone) | KEEP |
| Copy button | NO | KEEP |
| Character counter | NO live counter (field max lengths exist; feedback doesn't) | KEEP |
| FAQ expand-all | NO | KEEP |
| Type-to-filter | NO for static content; portal DATA should filter via queries/Liquid loops (noted in file) | KEEP, scoped to static lists |

Also validated against the KB: the required-asterisk key at the top of forms
is Slate's own documented recommendation (Form Instructions article); closed
and activation messages are native settings (already in our cheat sheets);
waitlist auto-transfer and event maps are native (already in our cheat
sheets); query-string parameters can pre-fill form fields (worth a future
pattern).
