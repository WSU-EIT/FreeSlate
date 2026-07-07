# WSU EIT Forms Kit — Top-to-Bottom Review (8.1 snapshot)

> **✅ IMPLEMENTED 2026-07-01 — see the log at the bottom.** Every item below
> was executed in 8.1 except the two flagged as needing team sign-off.

Reviewed 2026-07-01 against the 8.1 snapshot (identical to 8.0 at snapshot
time). **Nothing has been changed** — every item below is a suggestion
awaiting your call. Severity key:

- 🔴 **Fix before next deploy** — real defect or deploy hazard
- 🟡 **Should fix soon** — drift, inconsistency, or a sharp edge
- 🔵 **Consider** — improvement, judgment call, or governance question

---

## 1 · Deploy hygiene

- 🔴 **`deploy/build.css` is stale.** The deploy copy is the v7.1-era file
  (39,970 chars) while the working `build.css` is 47,479 chars — it's missing
  the new §DISPLAY/§PATTERNS sections, the display/pattern tokens, and the
  `--wsu-eit-head-face` heading hook. Anyone following `UPLOAD-THESE.txt`
  today ships CSS that the showcase no longer matches. Re-sync `deploy/`
  whenever the kit files change, or add a "check the parent folder's file
  is newer" line to the txt.
- 🔴 **`?v=` stamps not bumped.** `build.xslt` still links
  `build.css?v=20260622`. The cache rule in the file's own header says any
  linked-file edit requires a bump — `build.css` changed today. Next deploy:
  `?v=20260701` (and re-sync deploy/build.xslt).
- 🟡 **`UPLOAD-THESE.txt` says "v7.1" and references "the parent 7.1/
  folder."** It lives in 8.x now. Version/date line should travel with the
  snapshot.
- 🔵 **GTM loaders are referenced but not in the deploy set.**
  `build.xslt` links `/shared/gtm-primary-container.js` and
  `/shared/google-tag-manager.js`; both exist only in `uploads/`. That's
  intentional (instance-owned), but `UPLOAD-THESE.txt` should say "these two
  must already exist in /shared/ — do not delete them" so a cleanup pass
  doesn't strand the template.

## 2 · The new §DISPLAY / §PATTERNS work (self-critique)

- 🔴 **SVG masks can't use Montserrat.** The WSU-letters and Fight-Song
  patterns are SVG data-URIs with `font-family='Montserrat,Arial,…'` — but an
  SVG loaded as a `mask-image` renders in isolation and **cannot load page
  fonts**. The letterforms actually render in each OS's default sans, so the
  pattern is not brand-exact and varies by platform. Fix options:
  (a) trace "WSU" / "GO COUGS" once and embed as `<path>` data (exact,
  self-contained — recommended), or (b) keep text and document the fallback.
- 🟡 **Stacking approach is fragile with bare text.** `.wsu-eit-pattern`
  lifts children via `> * { z-index: 1 }`, but a bare text node directly
  inside the wrapper paints *under* the positioned `::before`. Cleaner:
  parent `z-index: 0` + `::before { z-index: -1 }` — pattern stays above the
  parent's background, below ALL content, and the `> *` rule disappears.
- 🟡 **Unprefixed `text-stroke` doesn't exist.** Only `-webkit-text-stroke`
  is real (all engines support the prefixed form). The unprefixed lines in
  §DISPLAY are inert and will flag in a CSS validator — drop them, keep the
  `@supports` fallback.
- 🟡 **Display type inherits the heading serif.** `.wsu-eit-display` uses
  `--wsu-eit-head-face`, so switching "Heading typeface → Serif (formal)" in
  Tune also re-fonts the display element. The EM treatment is a bold sans;
  give it its own `--wsu-eit-display-face: var(--wsu-eit-face)` token.
- 🟡 **Tune interplay: Solid + Outline thickness fight.** Set Display type →
  Solid (stroke 0), then move Outline thickness: the stroke comes back on
  filled letters. Either disable the thickness card while style = Solid, or
  fold style + thickness into one control (Off / 1–5px / Solid).
- 🔵 **CSS patterns vs. "use as provided."** brand.wsu.edu says patterns
  "should not be altered — please use as provided." Our CSS re-creations are
  approximations (grid layout, not the official arrangement). Defensible as
  internal/preview convenience, but for public-facing use the safest posture
  is: re-host the official pattern downloads in Slate Files, keep the CSS
  versions as wireframe/preview fallback. Worth a team decision + a line on
  the card either way.
- 🔵 **Fight Song lyrics.** I deliberately substituted "GO COUGS" to avoid
  reproducing the fight-song lyrics in kit code; the official file carries
  them legitimately. If the team wants the real artwork, use the official
  download (see previous item) rather than typing lyrics into CSS.
- 🔵 **Pattern tune previews are nearly invisible at 8% default.** The
  color/scale cards' live examples barely register until strength is raised.
  Consider a preview-only floor (e.g. the example renders at
  `max(var(--wsu-eit-pattern-opacity), .15)`) — with a note that the page
  value is the token, not the preview.
- 🔵 **Forced-colors / print behavior of hollow text is unverified.** In
  forced-colors mode the transparent fill should get forced to CanvasText
  (degrading safely to solid); print engines generally honor text-stroke.
  Both worth one manual check — noting the earlier live-preview session
  died before a visual pass; **patterns/display have been verified by
  computed style, not by eye.**

## 3 · Documentation drift (counts & claims)

- 🟡 **"41 controls" is now 51.** Stale in: `README.md` (Tune section, twice),
  `wsu-eit-view.js` (header comment, `VIEWS` full-set `n: 41`, and the
  "N of 41 settings shown" banner on every curated view page).
- 🟡 **Curated views don't know the new controls.** None of the 10 new ids
  (`bodyface`, `headface`, `dispstyle`, `dispstroke`, `dispsize`, `disptrack`,
  `dispcolor`, `patcolor`, `patopacity`, `patscale`) appear in any
  `index_*.html` allow-list, so no proposed view can surface them. Either add
  a sixth curated view ("Display & patterns") or fold a couple into
  Guardrails/Essentials.
- 🟡 **Chapter-nav counts in `index.html` are hardcoded** and now off by one
  for Photography and Brand guidance (the two new cards). Either bump them or
  have showcase.js count `.pat` per chapter at load (kills this whole class
  of drift).
- 🟡 **README front-page numbers.** "108 paste-ready patterns, 27 sourced
  brand-rule cards" — the page now has 187 `.pat` sections and 69 `data-ref`
  cards. The numbers were probably right once; they're marketing copy now.
  Suggest rounding ("180+ patterns") or auto-counting in the intro line.
- 🔵 **README/docs don't mention §DISPLAY, §PATTERNS, or the new tokens.**
  The FIND-IT index at the top of `build.css` also doesn't list the two new
  §sections. Add rows so Ctrl+F keeps working as promised.

## 4 · `build.xslt`

- 🟡 **Hardcoded © 2026** in the baseline footer. The file's own comments
  document `fw:year()` — use it (or accept an annual manual edit; if so, add
  it to a "yearly checklist" note).
- 🔵 **Footer parity.** The showcase's baseline footer shows 2 policy links
  (Access, Policies); the real template ships 4 (adds MyWSU, Follow WSU).
  Harmless, but the showcase claims to preview the real chrome — align them.
- 🔵 **`<style>html{overflow-x:hidden}</style>`** — a global scroll clamp
  can hide real layout bugs and breaks `position: sticky` in some engines'
  edge cases. If it's papering over a specific overflow, worth finding the
  culprit and scoping the fix.

## 5 · `build.css` (pre-existing layers)

- 🔵 **Word-paste neutralizer is a blunt instrument.**
  `[style*="font-family"] { font-family: var(--wsu-eit-face) !important }`
  also stomps *intentional* inline faces — including any pasted content an
  editor wants in the serif slot, and (post-change) it forces body face onto
  headings that would otherwise use `--wsu-eit-head-face`. Consider excluding
  headings, or documenting "the neutralizer wins on purpose" in the cookbook.
- 🔵 **Token count keeps growing (now ~60).** The character-creator model
  holds, but consider marking which tokens are *stable API* (safe for
  per-form overrides) vs. *internal* — future-you will thank you when a
  per-form Edit Styles block depends on one you want to rename.

## 6 · Showcase (`index.html` + `wsu-eit-showcase.js`)

- 🟡 **Tune tab is now 51 cards with no in-tab navigation.** Five group
  headers scroll past quickly; add jump-links (Type · Shape · Brand cues ·
  Page · Display & patterns) at the top of the Tune takeover.
- 🔵 **`docs.html` fetches the .md files at runtime** — that fails on
  `file://` (works fine hosted). One line in README ("open via a local
  server or the hosted copy") saves the next person the confusion.
- 🔵 **`docs.html` loads marked.js from cdnjs without an integrity hash.**
  Internal-only page, but the kit is otherwise dependency-clean — pin with
  SRI or vendor the file for consistency with the kit's own standards.
- 🔵 **Fixture alert listener assumes the button exists.**
  `wsu-eit-showcase.js` line 18 binds `#fixture-alert-btn` unguarded at
  top level — if the fixtures chapter is ever pruned from a copy of the
  page, the whole script dies at line 18. Cheap null-guard.

## 7 · Deployed JS (`wsu-eit-a11y.js`, `wsu-eit-extras.js`)

- ✅ Nothing to flag. Both respect the ≤10-features/≤300-lines ceiling
  (9/227 and 5/186), are idempotent, observer-driven, ES5, and the
  prime-directive ("never touch authored markup") reads as actually enforced
  in the helpers. This is the strongest part of the kit.

## 8 · Governance / next decisions for the team

1. **Official pattern files:** get the real downloads from
   brand.wsu.edu/downloads, re-host in Slate Files, and decide the CSS
   versions' role (preview-only vs. sanctioned fallback) — item 2 above.
2. **Which new controls graduate into curated views** — and whether
   "Display & patterns" becomes a sixth proposed view.
3. **Display-type usage policy:** the EM guide says decorative, short,
   positive words. Consider a one-line rule on the card: *one display word
   per page, never as the page's actual `h1`* (screen-reader heading order
   stays clean; hollow text contrast never carries meaning).
4. **Deploy checklist automation:** items 1.1–1.3 are all "humans forget"
   problems. A tiny `CHECKLIST.md` in deploy/ (sync files → bump ?v= →
   test-instance preview → publish) would close most of them.

---

### Suggested order of attack (if you green-light changes)

1. Re-sync `deploy/` + bump `?v=` stamps + fix UPLOAD-THESE version line (🔴)
2. Convert pattern-mask text to paths; restack `::before` at `z-index: -1`;
   drop unprefixed `text-stroke`; add `--wsu-eit-display-face` (🔴/🟡)
3. Update the 41→51 counts, view allow-lists, chapter-nav counts, README
   numbers, FIND-IT index rows (🟡, one sweep)
4. Tune UX: solid/outline interplay + group jump-links + preview floor (🟡/🔵)
5. Governance items — need your/team decisions first (🔵)

---

## Implementation log — 2026-07-01, all in 8.1

**1 · Deploy hygiene**
- ✅ deploy/ re-synced from the current kit files (all six).
- ✅ `?v=20260701` bumped for build.css in build.xslt (both copies).
- ✅ UPLOAD-THESE.txt rewritten: v8.1, correct folder refs, GTM
  "already in /shared/ — do not delete" note, checklist reference.
- ✅ New `deploy/CHECKLIST.md` (sync → bump → test-instance → publish,
  plus yearly + occasional audits).

**2 · Display / patterns**
- ✅ Mask text → **embedded PNG masks rendered from the real Montserrat
  ExtraBold** (fetched the actual font, drew the tiles, verified the
  letterforms by eye). Brand-exact on every platform; color/strength still
  live tokens. (Chose PNG-mask over hand-traced paths — hand-drawing
  letterform vectors isn't something I'll do reliably.)
- ✅ Restacked: `::before` at `z-index:-1` inside the wrapper's own
  stacking context; the `> *` lift rule is gone; bare text is now safe.
- ✅ Unprefixed `text-stroke` lines removed; `@supports` guard simplified.
- ✅ New `--wsu-eit-display-face` token (defaults to body face) — display
  type no longer follows the heading-serif swap.
- ✅ Solid/outline interplay resolved by **merging into one control**:
  "Display outline" 0–5px, where 0 = solid (SPEC is now 50 controls).
- ✅ Pattern preview floor: color/scale examples floor at 15%; the Strength
  card uses a --true variant showing the real token value (hint says so).
- ✅ Forced-colors guard added: `.wsu-eit-display` drops its stroke and
  takes the forced CanvasText fill.

**3 · Documentation drift**
- ✅ Counts corrected everywhere: 50 controls (README ×2, view.js header),
  six views, and the curated-view banner now **computes** its total from
  the DOM ("N of {cards.length} settings shown").
- ✅ Chapter-nav counts now **auto-computed** at load in showcase.js —
  this whole class of drift is dead.
- ✅ README front page: real counts (145 paste patterns · 42 rule cards,
  counted from the DOM).
- ✅ README build.css row mentions §DISPLAY/§PATTERNS; FIND-IT index in
  build.css lists both new sections; §TOKENS header now marks the
  STABLE-API vs INTERNAL token split.
- ✅ **Bonus (missed in the review):** all five curated-view pages were
  stale full copies of an older index.html — regenerated all of them from
  the current page, preserving each view's config block.
- ✅ New sixth curated view: `index_display-patterns.html` (9 controls),
  added to the view switcher.

**4 · build.xslt**
- ✅ Year: kept hardcoded **by choice** — an untested `fw:year()` call in
  the one file whose failure takes down every page isn't worth one edit a
  year; documented in a comment + CHECKLIST.md yearly item.
- ✅ Baseline-footer parity: showcase footer now carries the same four
  policy links as the real template.
- ✅ `overflow-x` clamp: TODO comment with the audit procedure (behavior
  unchanged — removing it blind without a test instance would be reckless).

**5 · build.css pre-existing**
- ✅ Word-paste neutralizer split: headings neutralize to
  `--wsu-eit-head-face`, `.wsu-eit-display` excluded, bluntness
  documented as intentional.
- ✅ Stable-API token annotation added (see 3).

**6 · Showcase**
- ✅ Tune tab group jump-links (anchors, keyboard-friendly).
- ✅ docs.html note in README (`file://` limitation).
- ✅ marked.js pinned with SRI (`sha384-/TQb…`) + crossorigin.
- ✅ `#fixture-alert-btn` null-guarded.

**8 · Governance — needs the team, not code**
- ✅ Display-type house rule on the card: one word per page, never the
  page's actual h1.
- ⏳ **Open for team sign-off:** (a) obtain the official pattern downloads
  and decide the CSS versions' role (the CSS/§PATTERNS comment states the
  official files remain the gold standard); (b) whether the official Fight
  Song artwork (with lyrics) replaces the "GO COUGS" stand-in.

**Verification note:** patterns and display type were confirmed by eye this
pass (mask PNGs reviewed directly); the full page goes through the
background verifier as usual.
