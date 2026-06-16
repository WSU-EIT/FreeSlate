# WSU EIT Forms — 6.0 (expanded component library, sourced to official WSU)

A complete, accessible, brand-exact styling and content kit for every
externally hosted page in the WSU Admissions **Slate (Technolutions)**
instance — forms, events, portals — built by **Enrollment Information
Technology (EIT)**. Plain CSS + XSLT with two small, justified JS files.
No build step, no framework, no dependencies.

**New in 4.0 — Tune the kit.** The showcase rail has two modes: **Browse**
(search, tags, chapters) and **Tune the kit** — a live design-token
configurator. It opens full-width as grouped **token cards** (Type · Shape &
density · Brand cues · Page) — ~40 controls spanning type (size, line-height,
measure, link & heading treatment), shape & density (radius, borders, button
& field sizing), brand cues (focus ring, required edge/star, selection,
topbar rule) and page (width, padding, paper, backdrop), each driving a real
`build.css §TOKENS` variable bounded to a brand-safe range. Every card carries
a **live example** showing exactly what that one token changes, plus an
**On/Off switch** that previews the page with the treatment removed entirely
— the character-creator model: move any control, you still can't leave the
brand. *Randomize* explores; *Export* emits a paste-ready `:root` override
block annotating each deviation (and each disabled feature) from shipped. *Randomize (brand-safe)* explores; *Export*
emits a paste-ready `:root` override block annotated with each deviation
from shipped defaults, so a stakeholder meeting ends with a deliverable
instead of a vibe. Settings persist per-browser and affect only the
showcase until the export lands in `build.css`.

Also in 4.0: snippet whitespace is hardened against upload tools that
re-indent the hosted HTML (tabs can no longer leak into pretty/minified/
copied markup), and the copy-inspiration browser now swaps whole-paragraph
messages too — cards with no safely swappable sentence say so honestly
("ideas only — sample text stays") instead of looking broken.

## Quick start

- **See everything:** open `index.html` in a browser — 119 documented,
  searchable examples with live previews, copyable markup (pretty ⇄ minified),
  copy-inspiration variants, the 80-icon brand set, logos, photography, and
  brand rules. Every example explains *what / why / how / when / in Slate /
  learn more*, plus the framework pattern it relies on.
- **Deploy:** see the table below; the ritual is upload → Preview a real form
  in the test instance → Publish → bump `?v=` stamps on any later edit.

## The files

| File | To Slate? | What it is |
|---|---|---|
| `build.css` | ✅ `/shared/` | THE styling layer: design tokens, page frame, global links, header/footers, type, inputs, buttons, the verified Slate mapping layer, validation, editor utilities, print/contrast/motion guards. Fully commented with a Ctrl+F **FIND-IT index** (§LINKS, §INPUTS, §ERRORS…). |
| `build-fonts.css` | ✅ `/shared/` | Montserrat (the brand face) + wsu-icons, via `@import`. |
| `wsu-eit-extras.css` | ✅ `/shared/` | Ten opt-in, CSS-only components (carousel, FAQ accordion, steps, cards, stats, banner, timeline, badges, tables, scroll reveal) + §ACCENTS utilities for the approved secondary colors. |
| `build.xslt` | ✅ `/shared/` | The page template Slate wraps every external page in. Links everything; carries the deploy notes. **A broken build.xslt takes down every external page — test instance first, always.** |
| `wsu-eit-a11y.js` | ✅ `/shared/` | **Accessibility helper & fixer.** 9 repairs that are impossible in CSS, each verified against real Slate output (control naming, empty-label removal, date-part names, aria-required, failed-submit alert announcement, new-tab notices, iframe titles, alt backstop, aria-current). Ceiling: ≤10 features / ≤300 lines. |
| `wsu-eit-extras.js` | ✅ `/shared/` | **Opt-in behaviors**, `data-eit-*` activated: copy buttons, character counter, local-time rendering, FAQ expand-all, static-list filter. Trimmed from 7 to 5 after auditing the Slate Knowledge Base — anything Slate does natively stays in Slate. Same ceiling. |
| `wsu-eit-showcase.js` | with index.html only | The showcase page's own interactivity (search, filters, copy buttons, the Tune-the-kit configurator). External because Slate's static host refuses inline scripts; its styling stays inline in index.html (inline styles are served fine). Never link from build.xslt. |
| `index.html` | ❌ kit pages: never | The showcase/sample page described above. Internal tool; its search/filter script never ships. |
| `RESEARCH.md` | ❌ | The pattern audit: every relevant CSS/HTML/a11y pattern evaluated (adopt / already / skip) + the Slate-native audit. |
| `wsu-eit-icon-*.svg` (80) · `wsu-eit-img-*.png` (4) | as needed | The official brand icons and cougar-head marks. **Flat layout, no folders** — names are prefixed so a filename sort groups them: `build*` (Slate trio) · `wsu-eit-*.css/.js` (kit code) · `wsu-eit-icon-*` (icons) · `wsu-eit-img-*` (images). Re-host anything you use in Slate Files. |

## The five conventions (for content editors)

1. **Four Slate surfaces**: the form builder's *Instructions tool* (HTML blocks),
   a field's *help text* (plain text), an event's *Description tab*, a portal's
   *static content blocks*. Questions themselves are built with Slate's native
   field types — the kit themes raw builder output automatically.
2. **One class does the work** — components are a single wrapper class around
   ordinary HTML.
3. **Naming grammar** — `wsu-eit-badge` component · `__piece` · `--variant`
   (always paired with its base).
4. **Colors are tokens** — nobody types hex values into content, ever.
5. **Behaviors are opt-in** — no `data-eit-*` attribute, no JS behavior.

## Index & legend — the concepts this kit implements

Each entry: the concept, why it's here, a Wikipedia primer, and a suggested
search to go deeper.

| Concept | Used for | Primer | Go deeper |
|---|---|---|---|
| Design tokens / single source of truth | all colors & spacing live once in `build.css` §TOKENS | [Wikipedia — Single source of truth](https://en.wikipedia.org/wiki/Single_source_of_truth) | [search: "design tokens css custom properties"](https://www.google.com/search?q=design+tokens+css+custom+properties) |
| BEM-style naming | `component__piece--variant` grammar | [Wikipedia — Naming convention (programming)](https://en.wikipedia.org/wiki/Naming_convention_(programming)) | [search: "BEM CSS naming methodology"](https://www.google.com/search?q=BEM+CSS+naming+methodology) |
| Progressive enhancement | CSS-first; JS adds, never carries | [Wikipedia — Progressive enhancement](https://en.wikipedia.org/wiki/Progressive_enhancement) | [search: "progressive enhancement vs graceful degradation"](https://www.google.com/search?q=progressive+enhancement+vs+graceful+degradation) |
| WCAG accessibility | contrast, targets, focus, labels throughout | [Wikipedia — WCAG](https://en.wikipedia.org/wiki/Web_Content_Accessibility_Guidelines) | [search: "WCAG 2.2 AA checklist forms"](https://www.google.com/search?q=WCAG+2.2+AA+checklist+forms) |
| ARIA | the a11y file's repairs (labels, alerts, current) | [Wikipedia — WAI-ARIA](https://en.wikipedia.org/wiki/WAI-ARIA) | [search: "aria-label aria-required form controls"](https://www.google.com/search?q=aria-label+aria-required+form+controls) |
| Screen readers | why empty labels & nameless fields matter | [Wikipedia — Screen reader](https://en.wikipedia.org/wiki/Screen_reader) | [search: "test form with NVDA VoiceOver"](https://www.google.com/search?q=test+form+with+NVDA+VoiceOver) |
| Skip links | first element of every page | [Wikipedia — Skip link](https://en.wikipedia.org/wiki/Skip_link) | [search: "skip to content link accessibility"](https://www.google.com/search?q=skip+to+content+link+accessibility) |
| Responsive design | auto-fit grids, fluid type, coarse-pointer targets | [Wikipedia — Responsive web design](https://en.wikipedia.org/wiki/Responsive_web_design) | [search: "css auto-fit minmax grid"](https://www.google.com/search?q=css+auto-fit+minmax+grid) |
| Native disclosure widgets | `<details>` FAQ accordion | [Wikipedia — Progressive disclosure](https://en.wikipedia.org/wiki/Progressive_disclosure) | [search: "details summary accordion accessibility"](https://www.google.com/search?q=details+summary+accordion+accessibility) |
| CSS scroll snap | the no-JS photo carousel | [Wikipedia — CSS](https://en.wikipedia.org/wiki/CSS) | [search: "css scroll snap carousel no javascript"](https://www.google.com/search?q=css+scroll+snap+carousel+no+javascript) |
| Separation of concerns | content (Slate) vs style (kit) vs behavior (opt-in JS) | [Wikipedia — Separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns) | [search: "separation of concerns html css js"](https://www.google.com/search?q=separation+of+concerns+html+css+js) |
| XSLT templating | how `build.xslt` wraps every Slate page | [Wikipedia — XSLT](https://en.wikipedia.org/wiki/XSLT) | [search: "Slate Technolutions build.xslt branding"](https://www.google.com/search?q=Slate+Technolutions+build.xslt+branding) |
| Liquid markup | Slate-native conditional content (use before JS!) | [Wikipedia — Template processor](https://en.wikipedia.org/wiki/Template_processor) | [search: "Slate Liquid markup merge fields"](https://www.google.com/search?q=Slate+Liquid+markup+merge+fields) |
| Brand management | exact colors, the one gradient, accent rules | [Wikipedia — Brand management](https://en.wikipedia.org/wiki/Brand_management) | [search: "WSU brand colors crimson guidelines"](https://www.google.com/search?q=WSU+brand+colors+crimson+guidelines) |

## History

`6.0` = `5.0` snapshot + a full deep-dive review/test pass. `5.0` = `4.0` + an **About & brand sources** chapter (every requirement/suggestion cited to an exact quote on brand.wsu.edu or a named uploaded doc), per-pattern **“Seen on WSU”** reference links to live official pages, an H3≤H2 clamp + callout-bar/heading-alignment controls in the tuner, a real DOM pretty-printer, and a batch of Storybook/wsu.edu-derived components (blockquote, columns, byline, person/news cards, cougar loading spinner, fullscreen modal, separators, dark stat, image feature cards, hatched stat, framed photo, highlight link-list, two-up news carousel, contact form, staff grid) — all in wsu-eit styling, never the WDS `wsu-c-*` classes.
`1.0`–`1.8` = prior generations, oldest first (1.7 is the clean-room rewrite
that makes this work provably EIT's own). This folder supersedes all of them.

---
© Washington State University · Built by Enrollment Information Technology
