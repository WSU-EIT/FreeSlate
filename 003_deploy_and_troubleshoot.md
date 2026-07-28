# 003 — Deploy, Verify, Troubleshoot

## Deploy (Database ▸ Branding ▸ Branding Editor)

1. **Import Current** — copies `/shared` → `/dev`; edit in `/dev`.
2. **Validate** locally first: `xmllint --noout build.xslt`. A malformed transform is
   a failed transform on **every** external page at once — never skip this.
3. Upload `build.xslt` to `/shared/` (replace the existing one). Deploy is one file —
   the old `build.css` / `build-custom.css` / `wsu-brand-new.css` are no longer
   referenced and can be deleted.
4. **Preview a REAL form** in the test instance before publishing.
5. **Publish** — copies `/dev` → `/shared`. Publishing IS the deploy.
6. **Point mobile at the same template:** Configuration Keys ▸ Branding, Privacy &
   Ping ▸ Mobile Template → `/shared/build.xslt`.

Because the CSS is inlined in `build.xslt`, there is no separate `.css` cache to
bust — republishing the transform updates everything. Bump `$brandVersion` each
publish so the footer badge tells you which build is live.

---

## Verify on the test instance

Open a real form, then check:

- [ ] **Footer badge** shows the version you just published (rules out a stale deploy).
- [ ] **DevTools ▸ Network:** only `cdn.web.wsu.edu/designsystem/2.x/...css` loads for
      styling; no `/shared/build*.css`.
- [ ] **Header:** dark crumb bar (WSU / Pullman) + the "Admissions" lockup (coug head
      + title). Lockup text is charcoal, not blue. No stray crimson tick.
- [ ] **Buttons** are WSU crimson (proves `wsu-content` is on `<main>`).
- [ ] **Content links** (e.g. "Forgot Your Password?") are crimson, not blue.
- [ ] **Login page:** no crimson bar / gridlines around the form (layout-table fix).
- [ ] **Required fields** show the crimson asterisk.
- [ ] No horizontal scroll; no console errors about missing CSS.

---

## Troubleshooting

**Blank / broken page on every external URL.**
Malformed XSLT. Re-run `xmllint --noout`. Most common cause: a literal `<` inside the
inline `<style>` (e.g. `<table>` or `<ul>` written in a CSS comment) — the parser
reads it as a tag. Remove the angle brackets from comment prose.

**Footer shows the new version but a fix isn't applied.**
The `$brandVersion` was bumped but the CSS body wasn't (a hand-merge). Deploy the
whole `build.xslt` wholesale rather than editing pieces; hard-refresh
(Cmd/Ctrl+Shift+R) since the browser can hold the old page.

**Links still blue.**
The `!important` link rules in the Slate-defense block aren't live — almost always a
stale/partial deploy. Confirm the `<style>` block in view-source contains
`.wsu-content a:link{color:#a60f2d !important}`. This instance ignores `--fw-link-text`
for links, so that rule is what does the work.

**Lockup / header text is blue.**
Same cause — ensure `.wsu-header-unit a:link{color:inherit !important}` is present.

**A layout region shows crimson borders / gridlines.**
It's a Slate table without `role="none"`. Confirm in view-source; if Slate emitted a
layout table without the role, extend the selector, or (rare) XSLT-tag that table.

**Buttons are gray, not crimson.**
`<main>` lost the `wsu-content` class, or the bundle CSS didn't load. Check both.

**Wordmark "tick" is back / someone wants the "sweep".**
The sweep is a legacy (pre-2.x self-hosted) effect and is not in the 2.x bundle. The
lockup header we use has no tick. Don't reintroduce `wsu-wordmark` expecting a sweep.

---

## Version log

| Version | Change |
|---|---|
| 1.0.x | Original three-file kit (build.xslt + build.css + build-custom.css). |
| 1.1–1.2 | Consolidated to one self-contained file; dropped external CSS + brand toggle. |
| 1.3.0 | Switched color to Slate `--fw-*` Custom Color Replacement; official navless wordmark header; Montserrat/icons noted as bundle-provided. |
| 1.3.1 | Hardened link color with `!important` (instance ignores `--fw-link-text`). |
| 1.4.0 | Layout-table fix for `table[role="none"]`. |
| 1.5.0 | Header switched to `wsu-header-unit` + `wsu-logo-lockup` ("Admissions"), matching admission.wsu.edu — removes the wordmark tick; extended link neutralizer to `.wsu-header-unit`. |

**Last updated:** 2026-07-21 · build.xslt v1.5.0
