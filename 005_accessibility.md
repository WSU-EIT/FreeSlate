# 005 — Accessibility (AAA-oriented)

`build.xslt` v2.0.0 targets WCAG 2.1 AAA at the template level. The work is
**structural** — semantics, labels, ARIA, focus, language, motion. Per WSU standard,
**no WDS colors are overridden to chase contrast**; the design-system palette ships
as-is. (It happens to clear AAA anyway — see contrast table.)

Every transform was verified by running the stylesheet through `xsltproc` against a
mock Slate form and inspecting the output (ARIA ids matched, no duplicate attributes,
correct scoping).

---

## What the template guarantees

**Language** — `<html lang="en">` (WCAG 3.1.1).

**Landmarks, uniquely named** — the crumb strip is exposed as a labeled
`navigation` (not a duplicate banner); the unit header is a named banner; `main` and
the global footer (`contentinfo`) round out the set (1.3.1, 2.4.1). The skip link
jumps to `#wsu-content-main`.

**Required fields — spelled out, automatically, and announced.**
Slate marks required questions with `data-required="1"` (editors tick "required"
once; they never type helper text). The template:
- appends a visible line **"This field is required."** under every required field —
  required conveyed in *words*, not asterisk/colour alone (1.4.1, 3.3.2);
- gives that line an `id` and points the field's `aria-describedby` at it, so a
  screen reader announces it *on the control* — once, cleanly (verified: the text
  input and all three date selects reference the matching hint id);
- fires **only** on fields Slate itself flags (a non-required field gets nothing).
Reword the sentence in one place in the template to change it site-wide.

**Multi-part date fields get real labels.** Slate renders Birthdate as three
`select`s with an `aria-label` only. The template converts each into a proper visible
`label` (both visible *and* programmatic), keyed to the select's id, and **drops the
now-redundant `aria-label`** so there's no double naming (1.3.1, 3.3.2, 4.1.2). With
the fieldset `legend` ("Student Birthdate") a screen reader reads
"Student Birthdate, Month, required."

**Visible keyboard focus** — a 3px crimson (WDS token) `:focus-visible` outline with
offset, as an additive safety net over the bundle (2.4.7, and the AAA focus-appearance
criteria).

**Reduced motion** — `@media (prefers-reduced-motion: reduce)` neutralises animations
and transitions for users who ask for it; no change for anyone else (2.3.3).

---

## Contrast (WDS palette, unchanged, AAA target = 7:1 for text)

| Foreground on background | Ratio | AAA |
|---|---|---|
| body `#4d4d4d` on white | 8.45:1 | ✓ |
| link crimson `#a60f2d` on white | 7.70:1 | ✓ |
| required hint / sublabels `#4d4d4d` on white | 8.45:1 | ✓ |
| crumb-bar text `#f2f2f2` on `#4d4d4d` | 7.55:1 | ✓ |

All our added text uses WDS tokens and clears 7:1. If a *shipped WDS component* color
ever fails a spec, it is left as-is by policy — we do not restyle the design system.

---

## Outside template scope (content-dependent — owners must uphold)

AAA is not fully achievable from branding alone; these depend on what editors and
Slate produce, not on `build.xslt`:

- **1.4.6 contrast on author content** — colors editors pick in the WYSIWYG.
- **2.4.9 Link Purpose (Link Only) / 2.4.10 Section Headings** — link text and heading
  structure inside form content.
- **3.1.5 Reading Level / 3.1.3 Unusual Words** — the prose editors write.
- **3.3.x error suggestion / prevention** — Slate's own validation messaging.
- **1.2.x media (captions, audio description, sign language)** — any embedded media.
- **2.2.x timing, 2.3.x flashing** — anything time-based or animated an editor adds.
- **Manual verification** — automated checks don't equal conformance; test with a real
  screen reader (VoiceOver/NVDA/JAWS), keyboard-only, and 200%–400% zoom, and have your
  a11y reviewer sign off.

---

## Verification recipe

```
xmllint --noout build.xslt          # well-formed
# stub fw:year() then transform a mock Slate form:
sed "s/select=\"fw:year()\"/select=\"'2026'\"/" build.xslt > /tmp/t.xslt
xsltproc /tmp/t.xslt mock_form.xml   # inspect aria-describedby ids, labels, no dup attrs
```

**Version:** build.xslt v2.0.0 (AAA milestone). Showcase mirrors the same a11y layer.
