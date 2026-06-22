# Pattern decisions

The record behind the kit's technical choices: every relevant CSS / HTML /
accessibility pattern weighed against the modern canon (MDN, WCAG 2.2,
web.dev, the GOV.UK and USWDS design systems, the every-layout and
defensive-CSS idioms), and the audit that keeps the kit from rebuilding
anything Slate already does.

Two questions decide everything here: *does it serve a single-column,
Slate-emitted form page?* and *can CSS do it, so JavaScript doesn't have to?*

---

## 1 · CSS patterns

**Used**

| Pattern | Where / why |
|---|---|
| Custom properties / design tokens | the whole theming model — `§TOKENS` |
| `:focus-visible` rings | everywhere; 3px brand ring |
| `accent-color` on radios/checkboxes | `§SLATE` |
| `aspect-ratio` media | reel, photo grids |
| flex / grid + `gap` | all layout; no margin-hack spacing |
| `text-wrap: balance` / `pretty` | headings and body — rag and orphan control |
| `clamp()` fluid type | `h1` only; forms don't need a full fluid scale |
| `min()` + `calc()` | `h3 ≤ h2` hierarchy enforced structurally, no script |
| `color-mix()` | pressed/hover crimson derived from the brand token (`@supports`-gated, hex fallback) |
| `:has()` | the required-field marker logic, no extra classes |
| `:user-invalid` | validation styling only after interaction — parity with the verified `aria-invalid` hook |
| `field-sizing: content` | textareas grow with input (`@supports`-gated) |
| `::selection` brand wash | goldfinch behind ink, 11.7:1 |
| `scroll-margin-top` | anchored headings clear the viewport edge |
| `scrollbar-gutter: stable` | no layout shift between short and long forms |
| `color-scheme: light` | stops forced-dark extensions inverting form fields |
| `prefers-contrast: more` | 2px ink borders, thicker underlines |
| Print: expose URLs | `a[href^="http"]::after` in `§GUARDS` |
| 44px coarse-pointer targets | buttons and choice rows — WCAG 2.5.8 |
| `interpolate-size` smooth `<details>` | extras `§FAQ` (`@supports`-gated; snaps open elsewhere) |
| `prefers-reduced-motion` | global kill switch + per component |
| `forced-colors` | `§GUARDS` |
| sr-only utility | `.wsu-eit-sr` (clip-path); also used by the a11y script |
| Scroll-driven animation | extras `§REVEAL`, triple-guarded |

**Considered and skipped**

| Pattern | Why not |
|---|---|
| `@layer` cascade layers | would *lower* the kit's specificity against Slate's unlayered framework CSS |
| Container queries | single-column form pages; media queries suffice |
| `oklch()` authoring | brand hexes are contractual; conversion adds risk for no gain |
| View transitions | Slate owns navigation; the motion budget is already spent |
| `popover` / `<dialog>` | nothing in scope needs an overlay; Slate's dialog is Slate's |
| `:has()` beyond current use | the required-marker fix is enough |
| Masonry / subgrid | no layout calls for it |

---

## 2 · HTML patterns

**Used**

| Pattern | Where |
|---|---|
| `<details>` / `<summary>` accordion | extras `§FAQ` |
| `autocomplete` tokens | demonstrated in samples; Slate emits its own on real forms |
| Skip link + `tabindex="-1"` target | `build.xslt` |
| `aria-current="page"` on nav | a11y A9 — Slate marks `.selected` visually only |
| `(opens in new tab)` SR notice | a11y A6 — the classic GOV.UK pattern |
| `alt` on every image | a11y A8 backstop — missing-alt becomes `alt=""` so readers skip, not read, filenames |
| `<iframe title>` | a11y A7 backstop — Slate embeds ship untitled |
| `aria-required` | a11y A4 — mirrors the verified `data-required="1"` hook |
| Alert on failed submit | a11y A5 — Slate's floating dialog is visual-only |

**Skipped**

| Pattern | Why not |
|---|---|
| `inputmode` / `enterkeyhint` | per-field markup belongs to Slate's builder (documented in the showcase) |
| `<search>`, `<hgroup>` | no benefit inside Slate's emitted structure |

---

## 3 · The nine JavaScript repairs (each impossible in CSS)

A1 date-part select naming (backstop) · A2 name every nameless control ·
A3 remove empty labels · A4 `aria-required` mirror · A5 announce + focus
Slate's failed-submit alert · A6 "(opens in new tab)" SR notice ·
A7 title untitled iframes · A8 `alt=""` backstop · A9 `aria-current` on the rail.

Declined as too clever or risky: duplicate-id rewriting (breaks `label[for]`),
auto table captions (invents content), focus restoration across AJAX swaps
(Slate owns it), and heading-level repair (a content judgment, not a
mechanical one).

---

## 4 · Slate-native audit

Every candidate behavior is checked against the Slate Knowledge Base first, so
the kit never forces admins to abandon a native workflow. Anything Slate does
in substance stays in Slate.

| Behavior | Slate-native? | Decision |
|---|---|---|
| Deadline countdown | Yes — registration deadlines, activation date/time with a custom pre-live message, closed-form message, Liquid conditional text, and the Share join page's countdown timer | use Slate's tools |
| Print button | Browser-native | not built |
| Local-time rendering | No — Slate renders the event's timezone, and the offset field isn't available in form communications | **keep** |
| Copy button | No | **keep** |
| Character counter | No live counter (max lengths exist; feedback doesn't) | **keep** |
| FAQ expand-all | No | **keep** |
| Type-to-filter | No for static content; portal *data* should filter via queries / Liquid | **keep,** scoped to static lists |

Also confirmed native (so the showcase points editors at Slate, not JS): the
required-asterisk key (Slate's own Form Instructions recommendation), closed
and activation messages, waitlist auto-transfer, event maps, and pre-filling
form fields via query-string parameters.

---

## 5 · Slate framework color variables (`--fw-*`)

Slate's public-page framework themes part of its chrome from a documented set
of `--fw-*` CSS custom properties (KB ▸ Branding ▸ *Custom Color
Replacement*) — separate from the `.form_*` markup the §SLATE layer restyles.
`build.css §SLATEVARS` maps the ones with a real brand equivalent to our
tokens at `:root`. This is the **official** way to do two things the kit
previously did by overriding emitted markup:

| `--fw-*` variable | Set to | Replaces / reaches |
|---|---|---|
| `--fw-error-background` | `transparent` | the pink required/validation wash — official equivalent of the `.form_question.required` reset; keeps required fields clean (asterisk-only) |
| `--fw-button-default-background` | crimson | the default submit fill — native counterpart to the `button.default` paint |
| `--fw-input-border` | `--wsu-eit-edge` | native inputs the §INPUTS selectors don't reach |
| `--fw-link-text` / `--fw-active-text` | crimson | Slate-internal links (dialogs, suggest, datepicker nav) |
| `--fw-datepicker-*` | crimson active / mist hover | the calendar popup — unreachable by our selectors |
| `--fw-suggest-background-hover` | mist | the autocomplete dropdown |
| `--fw-tab-*` | quiet / crimson / mist | multi-page-form and portal tab strips |
| `--fw-success-*` / `--fw-warning-*` | brand greens / golds | native status messages |
| `--fw-table-row-border`, `--fw-dialog-*` | hairline / mist | framework tables and dialogs |

Variables without a meaningful brand mapping keep Slate's defaults. The block
is additive: it complements the §SLATE markup layer for framework-drawn UI,
and does not replace it. The variables can be container-scoped to
`form[data-fw-form]` (Slate forms only); we set them at `:root` because the
kit brands all public surfaces — forms, events, and portals — identically.

---
© Washington State University · Built by Enrollment Information Technology
