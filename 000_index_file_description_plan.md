# WSU Slate Branding Kit — Index & Plan

**Goal:** Brand Washington State University's Slate (Technolutions) external pages —
registration forms, confirmations, login, portals — to match wsu.edu, using the
**official WSU Web Design System 2.x** from `cdn.web.wsu.edu`, with the smallest
possible amount of instance-specific CSS.

**Single deliverable:** `build.xslt`. It is self-contained — the WSU look comes
from the CDN bundle; the only CSS in the file is a small, justified "Slate-defense"
block (explained in `002`). No separate `build.css` / `build-custom.css` /
`wsu-brand-new.css` are needed anymore.

---

## Files in this kit

| File | Role |
|---|---|
| `build.xslt` | The deployable transform. Wraps Slate's page in official WSU chrome, hands Slate its `--fw-*` colors, and defends against Slate's framework CSS. Upload to Slate `/shared/`. |
| `000_index_file_description_plan.md` | This file — overview, architecture, decision log. |
| `001_how_it_works.md` | How Slate + XSLT + the 2.x bundle fit together, and why. |
| `002_branding_mechanisms.md` | The concrete branding hooks: chrome components, Slate Custom Color Replacement, the Slate-defense CSS, and why form fields need no classes. |
| `003_deploy_and_troubleshoot.md` | Deploy steps, verification checklist, troubleshooting, and the version log. |

Read order for a newcomer: `000` → `001` → `002` → `003`.

---

## Final architecture (where we landed)

1. **Design system:** the current public `cdn.web.wsu.edu/designsystem/2.x` bundle —
   the same one admission.wsu.edu loads. The bundle also `@import`s Montserrat and
   the wsu-icons CSS itself, so those are covered by the one bundle link.

2. **Chrome (built in `build.xslt`, official classes):**
   `wsu-wrapper-global`
   › `wsu-header-global--style-system` (dark crumb bar: WSU / Pullman)
   › `wsu-header-unit` + `wsu-logo-lockup--style-unit` ("Admissions" lockup — the
     tick-free header admission.wsu.edu uses)
   › `wsu-wrapper-site` › `wsu-wrapper-content`
   › `main.wsu-wrapper-main.wsu-content.wsu-container`
   › `article.wsu-article`
   › **Slate content hand-off**
   › `wsu-footer-global`.

3. **Color:** Slate's own **Custom Color Replacement** — we set Slate's documented
   `--fw-*` variables at `:root` so Slate paints its own chrome (default button,
   datepicker, dialogs, tabs, validation, table borders) in WSU crimson. Plus
   `accent-color` for native checkbox/radio.

4. **Slate-defense CSS (small, load-bearing):** this Slate instance does **not**
   honor `--fw-link-text` for links, so links are forced crimson with
   specificity + `!important`; Slate's layout tables (`role="none"`) are stripped
   of the bundle's crimson table borders; and the required-field asterisk is
   coloured. See `002`.

5. **Form fields:** need **no** WSU classes. Slate emits real
   `<input>/<select>/<textarea>/<label>` (its `.form_*` classes don't stop the
   bundle's bare-element styling). The only class that matters is `wsu-content` on
   `<main>`, which makes bare buttons render as WSU buttons.

---

## Decision log (why the kit looks the way it does)

- **Dropped the three external CSS files.** The bundle styles bare elements; the
  chrome uses official classes; color goes through `--fw-*`. What's left is a
  handful of Slate-defense rules, kept inline in `build.xslt` so there is one file
  to deploy and no separate CSS cache to bust.
- **XSLT can't style — only place markup and add classes.** So "brand via XSLT
  alone" is impossible; CSS always does the painting. The win is that ~95% of that
  CSS is WSU's CDN, not ours.
- **`--fw-*` over specificity fights.** The sanctioned Technolutions mechanism.
  It brands Slate chrome the WSU bundle can't reach. BUT on this instance it does
  not take for links, so link color is the one place we out-specify Slate directly.
- **Header = `wsu-header-unit` lockup, not `wsu-wordmark`.** The wordmark's hover is
  a small crimson "tick" after the word (that's the real 2.x behavior — the older
  "underline sweep" is 1.x/legacy and not in 2.x). admission.wsu.edu itself hides
  the wordmark and uses the lockup, which has no tick. We matched that.
- **Stayed on 2.x.** The sweep hover only exists in the older self-hosted build
  futurecoug once used; current WSU (admission.wsu.edu) is on 2.x with the tick/
  lockup. Matching current production beats chasing a legacy effect.
- **Layout-table fix keyed on `role="none"`.** Slate marks presentational tables
  that way; one attribute selector un-brands every layout table system-wide while
  real data tables keep WSU styling.

---

## Known caveats

- **`--fw-*` links not honored on this instance** → the `!important` link overrides
  in the Slate-defense block are required, not optional.
- **Interactive unit-header extras omitted** (Quicklinks/Give/mobile-menu). They
  open slide-in panels that need full site-menu data — inappropriate on a Slate
  form. The Give CTA can be added back as a plain link if wanted.
- **Third-party social-login buttons** (Google/Facebook/LinkedIn on the login page)
  carry their own inline brand colors; left as-is by design.

**Last updated:** 2026-07-21 · build.xslt v1.5.0
