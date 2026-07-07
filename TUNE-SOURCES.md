# TUNE-SOURCES — every Tune setting traced to an official WSU example

Doctrine (2026-07-01): **no guessed values.** Every Tune control's shipped
value cites a real example from an official WSU page or captured official
CSS. If no example exists, the kit does not set it — the value ships at the
browser default (control ships **Off**). Controls with exactly one
documented value ship **locked** (the toggle still previews Off).

Source keys:
- **FORM** — `wsu-c-form` compiled CSS, WSU Web Design System (styles admission.wsu.edu) · captured in research doc 001 §4
- **WDS** — WSU Web Design System compiled CSS / captured admission.wsu.edu homepage · doc 001 §2–5, doc 003
- **TYPO** — brand.wsu.edu/typography (via doc 001 §3)
- **CHEAT** — 2025 Brand Expansion Cheat Sheet (official PDF)
- **EM** — WSU Enrollment Management Visual Style Guide (official PDF)
- **IMG** — brand.wsu.edu/imagery
- **LIVE** — fetched admission.wsu.edu pages, 2026-07-01 (see LIVE-SITE-NOTES.md)

| # | Setting | Ships | Source | Note |
|---|---------|-------|--------|------|
| 1 | Body text size | 16px | WDS: base 16px | slider |
| 2 | Reading line-height | 1.6 (was 1.55) | WDS: body line-height 1.6 | slider |
| 3 | Body text color | #262626 · LOCKED | WDS: body/heading ink #262626 | guessed options cut |
| 4 | Link text size | 16px | WDS: body-copy links inherit 16px | slider |
| 5 | Link weight | 400 (was 600) · LOCKED | WDS: links inherit body regular | |
| 6 | Link underline | 1px | WDS: border-bottom .05em (≈1px @16px); hover .2em | slider |
| 7 | Underline offset | **OFF → auto** | none — WDS uses border-bottom, no offset spec | |
| 8 | Paragraph width | **OFF → none** | none — no documented text measure | |
| 9 | H1 crimson bar | 3px (was 4) | WDS: nearest documented crimson rule = stat-label 3px #CA1237 bottom border; h1 ::after rule exists but thickness uncaptured — stated openly | slider |
| 10 | Bar length | full / short tick | WDS: captured h1 ::after (full) · `wsu-heading--style-marked` (short mark) | both cited |
| 11 | Heading alignment | left · LOCKED | every captured WSU page | center cut |
| 12 | H1 weight | 800 · LOCKED | WDS: h1 800 | 700/900 cut |
| 13 | Heading color | #262626 · LOCKED | WDS: headings #262626 | crimson cut |
| 14 | H2 size | 2.1rem (was 1.45!) | WDS: h2 2.1rem desktop / 1.75rem ≤991px | slider bounded 1.75–2.1 — both endpoints real |
| 15 | H3 size | 1.8rem (was 1.15) | WDS: h3 1.8rem / 1.5rem responsive | slider 1.5–1.8 |
| 16 | Heading line-height | **OFF → normal** | none captured | |
| 17 | Heading letter-spacing | **OFF → normal** | none captured | |
| 18 | Body & UI typeface | Montserrat / Corbel-system | TYPO: sole web face · Office substitute table | both cited |
| 19 | Heading typeface | match body · LOCKED | web headings are Montserrat only; serif slot is print (FreightBig Pro) | serif option cut |
| 20 | Corner radius | 5px (was 6) | FORM: inputs/checkboxes/fieldsets radius 5px (WDS buttons are 8px — noted) | slider |
| 21 | Input border width | 1px | FORM: 1px solid #ccc | slider |
| 22 | Field fill | white · LOCKED | FORM: white fields | mist cut |
| 23 | Button size | 1em × 3em · LOCKED (was .75/2rem presets) | WDS: button padding `1em 3em` | compact/large presets cut |
| 24 | Button border | 0 · LOCKED (was 2px) | WDS: primary buttons borderless (secondary: 1px #b3b3b3) | |
| 25 | Button weight | 600 · LOCKED | WDS: button weight 600 | |
| 26 | Button text case | normal · LOCKED | LIVE: CTAs are title case ("Apply Now") | |
| 27 | Field density | 20px pad · 20px gap · LOCKED | FORM: input padding 20px; labels margin 20px 0 5px | 3 guessed presets cut |
| 28 | Label weight | 500 (was 600) · LOCKED | FORM: labels 14px w500 | |
| 29 | Label size | 14px (was ~15) · LOCKED | FORM: labels 14px | |
| 30 | Textarea height | **OFF → auto** | none — only select min-height 75px is documented | |
| 31 | Checkbox size | 22px (was ~18) · LOCKED | FORM: checkboxes/radios 22×22 | |
| 32 | Focus ring width | **OFF → medium (browser default)** | no documented width; FORM inputs suppress outline (an a11y fault we won't copy — audit doc 001 §6) | slider available |
| 33 | Focus ring color | #CA1237 (was #A60F2D) · LOCKED | WDS: "focus outlines" listed under #CA1237 UI accents | |
| 34 | Focus ring offset | **OFF → 0** | none | |
| 35 | Required-field edge | 2px (was 0/off) | FORM: required inputs `border-left: 2px solid #A60F2D` | kit clears it once filled — refinement, noted in css |
| 36 | Required star color | **OFF → inherit** | live forms show a plain asterisk; no colored star documented | |
| 37 | Required star size | **OFF → 1em** | none | |
| 38 | Text selection | **REMOVED** | no WSU ::selection styling exists | browser default |
| 39 | Topbar hairline | 5px (was 4) + color → #A60F2D | WDS: header top border 5px #A60F2D | was flag-red — fixed |
| 40 | Content width | 1200px (choice of 600/800/1000/1200/1400) | WDS width presets: xnarrow…xwide | slider → documented preset choice |
| 41 | Content padding | **OFF → 0**; options = WDS spacing scale 1/2/3/4/6rem | scale documented; no documented "page pad" value | |
| 42 | Content paper | white · LOCKED | WDS: content on white | warm/mist cut |
| 43 | Page backdrop | white (was #f5f5f5); alt #F7F7F7 | LIVE: pages are white edge-to-edge · `wsu-color-background--gray-5` sections | |
| 44 | Display outline | 2px (0 = solid) | EM: outlined preferred / solid acceptable; thickness matched to the guide's own artwork | slider |
| 45 | Display size | 4.5rem (was 4) | WDS: hero display titles 4.5–5rem; EM "make type large and impactful" | slider caps at 5rem |
| 46 | Display tracking | **OFF → normal** | none | |
| 47 | Display color | Crimson / Light Gray #CCC9C8 | EM artwork (crimson) · CHEAT Light Gray + EM's own gray background texture | gray/black guesses replaced |
| 48 | Pattern color | Crimson / Light Gray #CCC9C8 | EM: "approved brand colors only" · IMG: swatches render light gray | |
| 49 | Pattern strength | 10% (was 8%) | visually matched to IMG pattern swatches (light-gray-on-white) — artwork-derived | slider |
| 50 | Pattern scale | 1× (authored tile size) | neutral = the artwork's own scale | |

Net: 49 controls (Text selection removed). 11 ship Off at browser defaults.
Every build.css token carries the same citation inline (§TOKENS).
