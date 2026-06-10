# WSU Slate Forms — Design System Reference

Captured 2026-06-09 from WSU Slate files + brand.wsu.edu. This is the source of truth for styling Slate forms in the WSU Admissions instance.

## The big picture (two eras)
WSU migrated its Slate branding from the **legacy "Spine" framework** → the modern **WSU Web Design System (WDS)**.

| | Legacy "Spine" (stock, what Slate sold you) | **WDS (current — what forms use now)** |
|---|---|---|
| XSLT | `build_initial_...xslt` | **`build.xslt`** |
| CSS | `build.css`, `build-fonts.css` | **`web-design-system/style.css`** + `web-design-system-overrides.css` |
| Class prefix | `.cr` (`c_binder`, `c_spine`…) | **`wsu-`** (`wsu-content`, `wsu-header-global`…) |
| Font | Proxima Nova (Typekit) | **Montserrat** (Google Fonts) |
| Crimson | `#981e32` (old) | **`#a60f2d`** (new brand) |
| Red accent | `#c60c30` | **`#ca1237`** |

→ **Build everything against the WDS.** The legacy `.cr` system is dead weight; only `build.xslt` matters for forms.
`wsu-global-footer.xslt` is a lorem-ipsum stub/experiment — ignore.

## Typography
- **Font:** `Montserrat, sans-serif` — imported from Google Fonts (weights 100–900 + italics).
- **Base:** `16px` / `line-height: 1.5` / color `#262626`.
- **Labels/legends (WDS):** `.875rem`, weight 600, line-height 1.5, display block, margin-bottom .1em.
- **Slate form labels (override):** `.form_label`, `.wsu-copy legend` → `.75rem`, weight 600, margin `0 0 8px`. (Slate's override wins over WDS for actual form fields.)
- **Signature heading mark:** `.wsu-content h1::after` → crimson bar: `height .375rem; background #a60f2d; width 6.87rem; margin-top 1.125rem`. THE iconic WDS h1 treatment.

## Color tokens
| Token | HEX | Use |
|---|---|---|
| Crimson (primary) | `#a60f2d` | h1 bar, links, button hover, radio/checkbox accent |
| Red (accent) | `#ca1237` | button bg (default), link underline, list markers, nav selected border, coug-head box, utility-nav underline |
| Body text | `#262626` | default text |
| Border gray | `#b3b3b3` | input/select/textarea border |
| Light border | `#ccc` | fieldset border |
| Focus border | `#333` | input focus border |
| Muted text | `#666` | secondary/tertiary button text |
| UI muted | `#737373` | close button, menu text |
| Dark UI | `#404040` | nav link text, icons |
| Header bg | `#f7f7f7` | global header |
| Hover/selected bg | `#f2f2f2` | nav hover & selected |
| White | `#fff` | input bg, page bg |

Brand ratio rule (brand.wsu.edu): 70% crimson/gray · 20% secondary · ≤10% accent (Autumn `#ff6727`, Goldfinch `#f3e700`, Pacific Sky `#5bc3f5`, Midnight `#002d61`, Vineyard `#aadc24`) — accents never primary.

## Form controls (all scoped under `.wsu-content`)
**Text inputs** (`text, email, tel, url, number, password, search, date, time, …`):
`border-radius:4px; background:#fff; border:1px solid #b3b3b3; padding:1.125rem 1.125rem; font-size:inherit; box-sizing:border-box; outline:0; transition:box-shadow .3s cubic-bezier(0,0,.03,1);`
**:focus** → `box-shadow:0 0 7px rgba(0,0,0,.4); border-color:#333;`

**Select:** same as inputs + `cursor:pointer`; non-multiple gets custom CSS arrow (layered gradients), `padding-right:50px`.

**Textarea:** `width:100%` + same input styling.

**Checkbox / radio:** `color:#a60f2d` (accent). `+ label` → `display:inline; vertical-align:middle; margin-left:.3em; margin-right:1.5em; cursor:pointer;` (override forces `margin-bottom:0`).

**Fieldset:** `border:1px solid #ccc; border-radius:4px; padding:1.125rem 1.5rem; margin-bottom:1.5rem;` · legend padded `.6875rem` L/R.

**Buttons** (`button, input[submit|reset|button]`):
`font-family:Montserrat; background:#ca1237; color:#fff; border:none; border-radius:6px; padding:1em 3em; font-size:1rem; font-weight:600; line-height:1.5; cursor:pointer; margin-bottom:1.5rem; margin-right:1.75rem; transition:box-shadow .2s;`
**:hover/:focus** → `box-shadow:0 5px 14px rgba(0,0,0,.4); background:#a60f2d;`
Variants: `.wsu-button--small` (.75rem) · `--large` (1.25rem) · `--round` (radius 2em) · `--secondary` (color #666, border 1px #b3b3b3, white bg; hover → #ca1237 text+border) · `--tertiary` (transparent, underlined text link, #666).

**Links:** `color:#a60f2d; text-decoration-color:#ca1237; text-decoration-thickness:.1em;` · list markers `#ca1237`.

## Slate-generated form structure (classes Slate emits — style these)
- `.form_page` (margin-bottom 2rem) → `.form_section` → `.form_question` (padding-right 1rem) → `.form_label` + `.form_responses` (margin-bottom 2rem) → `.form_response` (margin 4px 0).
- Layouts: `.form_layout_stacked` (label above; inputs width 100% max-width 400px), `.form_layout_inline`.
- Left-rail nav (multi-page): `#side` (width 200px) + `#main` (padding-left 2rem); `div#menu ul li a` → block, padding 10px 20px, color #404040, weight 600, `border-left:5px solid transparent`; `.selected` → border-left 5px `#ca1237` + bg #f2f2f2; `:hover` → border-left 5px #b3b3b3 + bg #f2f2f2.
- Validation/error classes from Slate: `.form_error`, `.error` (confirm exact markup against a real rendered form).
- Datepicker: `.ui-datepicker-calendar .available` → crimson; `.unavailable` → #ccc.

## Page chrome (build.xslt wraps every hosted form)
```
#page.wsu-document-wrapper.wsu-wrapper-global
  header.wsu-header-global.wsu-header-global--dark.wsu-header-global--navless   (h64, border-top 4px #a60f2d, bg #f7f7f7)
    a.wsu-wordmark → span.wsu-coug-head-boxed (60px, bg #ca1237, cougar SVG) + wordmark "Washington State University"
    nav → utility menu: Give · Apply · Locations · My WSU · search · menu
  div.wsu-wrapper-site
    main.wsu-wrapper-content.wsu-content.wsu-copy   ← FORM CONTENT INJECTED HERE
  footer.wsu-footer-global → © + Access · Policies · MyWSU · Follow WSU
```
Cougar head is an inline `<svg>` (path in build.xslt). Also have raster `cougar-head-temp.png` (crimson) + `cougar-head-light-gray.png`.

## Slate mechanics (from handoff doc — keep in mind for deliverables)
- Forms get chrome by filename convention: every hosted page transforms through `/shared/build.xslt`. No per-form binding.
- CSS cache-busts on the `?v=YYYYMMDD` query param in build.xslt `<link>`s — bump on every edit (~15 min propagation, browser cache to 24h).
- Per-form CSS lives in form editor → **Edit Scripts / Styles**, scoped `#form_GUID_container`.
- Per-path auto CSS: `/<path>/default.css`, `/<path>/embed.css`.
- Do redesign in `/dev/`, publish copies `/dev/`→`/shared/`. Breaking build.xslt breaks ALL external pages — test instance only.
- Accessibility is an active workstream (see Accessibility Updates.txt) — labels bound to inputs, no empty `<th>`, fieldset+legend for groups, aria-labels.

## Current-system WAVE baseline (the problem we're fixing)
Their live `/register/` form scored **AIM 5.8/10**: 25 errors (1 missing + **24 EMPTY form labels**), 4 contrast errors (gray session bar text, footer), 15 alerts (3 redundant links, 7 noscript, 5 underlined text). Root cause of the empty labels: Slate's 3-part Birthdate/Date selects and Street Address composite emit unlabeled/empty `<label>`s. **Our fix:** native single `type=date`/`type=month` controls, a real non-empty `<label>` on every control, fieldset+legend per group, no empty labels, AA+ contrast. Goal = 0 errors.

## Complete Slate field-type palette (the "every field type" checklist)
From the form builder right rail — the definitive list the showcase must style:
Heading 1 · Heading 2 · Header Row · Instructions · Text Box · Paragraph Text · Check Boxes · Selectable · Option Buttons · Rating Scale · Select List · Multi-select List (tag chips) · Street Address · Location · Birthdate · Date · Calendar · Section Break · Related Event · Material Upload (file) · Interaction Selection · Widget Table · Translation · Payment Amount · Payment Form · Video Capture · Signature · Secret.

## Full "Daniel Copy" registration form inventory (the flagship example, full fidelity)
A campus-visit / event registration. Sections + notable patterns:
1. **Tell us about yourself** (more info) — first*, preferred, last*, birthdate*, pronouns (+self-describe).
2. **How can WSU reach you?** (more info) — email*, mobile phone, text opt-in consent + Yes checkbox, mailing address* (Street Address composite).
3. **Education experience** (more info) — HS grad date*, current/recent school name*, CEEB code* + "Search for CEEB code" lookup.
4. **Your future at WSU** (more info) — instructions, campus interest(s) (checkbox multi), student type* (first-year/transfer radios), conditional "transfer credit AP/IB/Running Start" Yes/No, anticipated entry term* (select), instructions w/ bullets, academic interest* (multi-select tag chips), primary/secondary instrument (conditional on music interest), Honors College interest (Yes checkbox).
5. **Who is visiting WSU with you?** (more info) — Student + guests* (1–5 radio), **repeating Guest blocks ×4** (guest type*, first*, last*, email, phone, WSU alumnus, sibling note), emergency contact (conditional when visiting independently: first*/last*/phone*).
6. **Accommodations** — ADA Yes/No*, which accommodations (checkboxes), other details, conditional "specify accommodation/voltage/device", dietary restriction*.
Conditional/branching + repeating-group + multi-select-chips are the three hardest patterns to nail accessibly.

## WSU 2025 Brand Expansion (newer than brand.wsu.edu base — from official cheat sheets)
- **New depth color: Dark Crimson `#680222`** — button hover/pressed, gradient end. AAA on white.
- **Gradients now official:** Crimson→Dark Crimson (and Bright Red→Crimson→Dark Crimson). Use at 100% opacity, crimson takes the majority. Token: `--wsu-gradient`.
- **Bright Red `#ff0843`** — DISPLAY accent only; white text on it ~3.3:1 FAILS AA. Never on buttons/text UI.
- **Warm neutrals:** Light Gray `#ccc9c8`, Warm Gray `#efebe5`. **Nature accents** (≤10%, garnish): Evergreen `#67a272`, Alpine Lake `#6ac9ce`, River `#056872`, Sunset `#fc4a32`, Wheat Field `#e9c576`.
- **Fonts:** cheat sheet lists Proxima Nova + Proxima Sera = the PRINT/Adobe brand. WEB stays **Montserrat** (brand.wsu.edu/typography + live WDS). Our Slate already loads a Proxima Nova Typekit kit, so a web switch is *possible* but Montserrat is correct unless Web Comm says otherwise.
- **DECISION APPLIED:** buttons now Crimson `#a60f2d` → Dark Crimson `#680222` hover (both AAA), replacing the old red `#ca1237` default (AA only). accent-color → crimson.

## Enrollment Management Visual Style Guide (2021 — OUR department, EM + UMC)
Optional supporting design elements (not core form UI — forms stay legible-first):
- **45° angle cut** — forward energy, always angling UP left→right; on color blocks/photography, NEVER buttons/logos. → built into `.wsuf-banner` masthead (chrome).
- **Lines & pipes** — crimson vertical/horizontal separators (our section H2 crimson "pipe" ::before matches this).
- **Patterns** — diagonal lines / arrows / pluses; subtle texture, brand colors, careful behind text. → `.wsuf-banner--pattern` uses subtle diagonal lines.
- **Quotes** — oversized crimson quote marks (Bookmania italic in print).
- Contact: Eric Limburg elimburg@wsu.edu (EM creative).

## Showcase plan (from parallel work — doc 002): 20-page kitchen-sink
Groups: A. Field anatomy (01 text, 02 choice, 03 dates/structured, 04 rating/grids, 05 rich/exotic, 06 payments) · B. Structure & logic (07 layout/type, 08 conditional logic, 09 multi-page/progress, 10 states/errors/edge incl. restyle the gray logged-in identity bar) · C. Events (11 event reg, 12 event search/listing, 13 scheduler) · D. Portals (14 applicant status — flagship, 15 portal widgets, 16 counselor/3rd-party) · E. Delivery (17 hosted vs embedded, 18 mobile torture test, 19 email/Deliver templates, 20 living token reference).
Built so far: index.html (hub) · WSU Slate Form Kit (foundations≈20) · WSU Field Type Library (≈01–07) · WSU Registration Form (real example, ≈08/09 partial).
Cross-cutting: logged-out + logged-in states, keyboard pass, targets ≥24×24, self-documenting "what this demonstrates" annotations, `/showcase/default.css` + `?v=` cache-bust.
