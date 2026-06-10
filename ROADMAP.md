# WSU Slate Form Kit — v4.0 ROADMAP

v4.0 = v3.0 (full copy) **plus** the start of the content-editor layer from docs 008–010.
v3.0 remains the stable, deploy-ready kit. This file is the precise brief for the
remaining work so the next session doesn't re-derive it.

## Done in v4.0
- **Editor-facing public CSS API** (`wsu-forms.css` §16) — the *entire* class vocabulary a
  content editor ever types: `.wsu-note` `.wsu-warn` `.wsu-button` `.wsu-two-col`
  `.wsu-small` `.wsu-divider`. Self-contained, degrade gracefully, no nesting. Plus a
  Word-paste neutralizer (strips pasted font-family/size/color so WSU type wins).
- **Editor Guide** (`editor-guide.html`) — task-based, plain language, zero jargon
  (no "CSS / class / ARIA / WCAG / XSLT / cache / selector / GUID"). Built for "Dana,"
  the program coordinator persona (doc 009 §1).

## Remaining — priority order

### 1. Form Builder (doc 008) — the headline, a multi-file app (next major build)
Single-page, **zero-dependency vanilla JS**, drag-drop + **keyboard-operable** form designer.
Output: (a) live preview in **Slate-shaped markup** (`.form_question`/`.form_label` so it proves
`wsu-forms.css` §12), and (b) a **"Slate Build Sheet"** — an ordered, copyable, printable runbook
of exact Slate editor steps with gotcha/a11y hints injected per step (Slate has *no* form import,
so a perfect human recipe is the highest-leverage tool).
- Files: `wsu-form-builder.html` + `form-builder.js` + `data/slate-field-registry.json`
  (one entry per the 28 field types — palette/slateName/inspector/previewTemplate/slateSteps/hints/lints)
  + `data/hints.json` (shared hint DB). Reuse existing CSS + a new `form-builder.css`.
- Layout: `[Palette] [Canvas pages→items] [Inspector]` + bottom drawer `[Preview][Build Sheet][JSON]`.
- Data model = the export JSON in doc 008 §2.1 (KEEP STABLE — it's the contract if this ever
  graduates to Daniel's C#/Blazor stack).
- **Editor-mode defaults** (doc 009 §5): plain-language palette ("Short answer", "Multiple choice
  (pick one)"…); start screen = **template picker** (Event RSVP / Info Request / Visit / Blank);
  condition editor reads as a sentence ("Show this when [Student type] [is] [Transfer]"); JSON,
  export keys, bindings hidden behind one "Advanced" toggle; lints in human voice with one-click
  fixes (e.g. Birthdate→Date); mobile/desktop preview toggle; restore-previous-version.
- Build phases P1–P5 in doc 008 §3. Acceptance: doc 008 §4 (AAA, keyboard-complete, round-trip JSON,
  rebuilds the real "Daniel-Copy" form, build sheet executable verbatim).

### 2. Content-editor experience, rest of doc 009
- **Quick Start** one-pager (printable / PDF): the 5-step Copy-Form flow + 6 snippet patterns +
  the "never do" list. (Editor Guide covers most; this is the print artifact.)
- **Snippet Library page**: every public snippet rendered live + Copy + a "survives the visual
  editor: ✅ tested" badge. This page *is* the public CSS API.
- **Glossary sidebar** (one-sentence defs for unavoidable Slate words: prompt, scope, period).
- **Template Form Library** convention (doc 009 §3) — documented for Daniel: maintain blessed
  `_Templates/` forms (correct scope, per-form snippets pre-installed, honeypot, confirmation page);
  editors **Copy Form → rename → edit → test → publish**.
- **Role split** (doc 009 §2): editors get form-builder access only — NOT Files, NOT Edit
  Scripts/Styles. Split the Deployment Guide into **Admin Guide** (current) + **Editor Guide** (done).
- `audience` flag on hints (`admin` vs `editor`) so admin gotchas hide from editor views.

### 3. Email hardening, doc 010 (rebuild Email Templates page)
- **Ghost tables** for Outlook (`<!--[if mso]><table width="600">…<![endif]-->`), MSO font-forcing
  style, `mso-line-height-rule:exactly`, `border-collapse` + `mso-table-lspace/rspace`.
- **Preheader** hidden div (first content), **plain-text part** guidance, **HTML width/height attrs**
  on every `<img>`, styled `alt` text, real text headings (never image text).
- **Dark mode**: near-extremes (#fffefe / #262626), `color-scheme` meta + `prefers-color-scheme`
  overrides; logos on a white plate.
- **Gmail 102KB clip** budget (~80KB), inline-only critical CSS, entity-encode specials.
- **Deliverability** (Deployment Guide "Before your first real send"): SPF/DKIM/DMARC, seed-account
  QA list (Gmail / Outlook desktop / Apple Mail / outlook.com), test-send ≠ real-send.
- Per-template "survives visual editor" badge; annotate ghost-table/preheader/plain-text parts.

### 4. Web micro-gotchas already partly handled, finish (doc 010 §8)
- iOS input zoom (inputs ≥16px — kit already 1rem ✓), `:autofill` box override, `100dvh`,
  `.ics` add-to-calendar trio, timezone-in-text, 125–150% Windows scaling border check.

### 5. New component from admission.wsu.edu interior pages (observed)
- **Link-card grid** matching the live "Planning Your Transfer" pattern: 3-up responsive cards,
  each = image (4:3) + bold caption, whole card links to a sub-page; gray feature band variant.
  Pairs with the existing `.wsuf-gallery`. Add to the kit + Field/Components showcase.

## Source docs (in uploads/)
000 Slate mechanics · 002 showcase plan · 003 site patterns (3 WSU templates) · 004/005 kit state ·
006 CSS/Slate gotchas · 007 AAA standard · 008 form-builder spec · 009 content-editor experience ·
010 email + misc gotchas · wsu-brand-reference.md (Slate-emitted selectors + 28-field palette).
