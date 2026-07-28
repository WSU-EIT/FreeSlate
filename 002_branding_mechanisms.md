# 002 — Branding Mechanisms: The Concrete Hooks

Three layers do all the branding. None of them fight Slate blindly with specificity
except the one place Slate forces our hand (links).

---

## Layer 1 — Official WSU chrome (markup in `build.xslt`)

Match admission.wsu.edu's nesting, all official 2.x classes:

```
div.wsu-wrapper-global
 ├─ a.wsu-skip-to-main                              (skip link → #wsu-content-main)
 ├─ header.wsu-header-global--style-system          (dark crumb bar: WSU / Pullman)
 ├─ header.wsu-header-unit                           (brand header — the tick-free one)
 │   └─ .wsu-header-unit__banner
 │       └─ a.wsu-logo-lockup.wsu-logo-lockup--style-unit
 │           ├─ .wsu-logo-lockup__icon-wrapper > svg.wsu-coug-head
 │           └─ .wsu-logo-lockup__title-wrapper
 │               ├─ .wsu-logo-lockup__subtitle (empty)
 │               └─ .wsu-logo-lockup__title    ($bandTitle = "Admissions")
 ├─ div.wsu-wrapper-site > div.wsu-wrapper-content
 │   └─ main#wsu-content-main.wsu-wrapper-main.wsu-content.wsu-container
 │       └─ article.wsu-article
 │           └─ [Slate content hand-off]
 └─ footer.wsu-footer-global                         (copyright + Access/Policies/…)
```

Key class notes:
- **`wsu-content` on `<main>`** is the one load-bearing class for content: it's what
  makes bare Slate `<button>`s render as WSU crimson buttons (`.wsu-content button`).
- **`wsu-container` / `wsu-wrapper-main`** give the content measure and rhythm.
- **`article.wsu-article`** gives article typography.
- The unit-header **utility bar / mobile menu are omitted** — they open slide-in
  panels that need site-menu data. Add the Give CTA back as a plain link if wanted.

Components verified present in the 2.x bundle manifest (not WordPress-only):
`wsu-header-global`, `wsu-header-unit`, `wsu-logo-lockup`, `wsu-coug-head(-boxed)`,
`wsu-footer-global`.

---

## Layer 2 — Slate Custom Color Replacement (`--fw-*`)

Slate's own CSS reads documented `--fw-*` variables. Set them at `:root` and Slate
repaints its own chrome on-brand — no override needed for the parts that honor them
(default button, datepicker, dialogs, tabs, validation wash, table row borders).
Names are Slate's (Technolutions KB ▸ Branding ▸ Custom Color Replacement); values
are the 2025 WSU palette:

```css
:root{
  --wsu-crimson:#a60f2d; --wsu-crimson-hover:#ca1237; --wsu-crimson-deep:#680222;
  --wsu-dark-gray:#4d4d4d; --wsu-white:#fff; --wsu-input-border:#b2b2b2;

  --fw-body-text:var(--wsu-dark-gray);
  --fw-link-text:var(--wsu-crimson);            /* intended blue-link fix (see caveat) */
  --fw-active-text:var(--wsu-crimson-hover);
  --fw-muted-text:#595959;
  --fw-input-border:var(--wsu-input-border);
  --fw-button-default-background:var(--wsu-crimson);
  --fw-error-background:transparent;            /* kills Slate's pink required wash */
  --fw-success-accent:#529214; --fw-success-background:#e6efc2;
  --fw-warning-accent:#c69214; --fw-warning-background:#fffbe6;
  --fw-datepicker-background-active:var(--wsu-crimson);
  --fw-datepicker-background-hover:#f2f2f2;
  --fw-tab-text:#595959; --fw-tab-text-hover:var(--wsu-crimson);
  --fw-tab-background:#f2f2f2; --fw-tab-background-hover:#fafafa;
  --fw-suggest-background-hover:#f2f2f2;
  --fw-table-row-border:#d9d9d9; --fw-dialog-header:#f2f2f2;
  accent-color:var(--wsu-crimson);              /* native checkbox / radio */
}
```

> **Variable name:** use `--fw-link-text` (confirmed in the `slate.html` hook catalog
> and by usage frequency). An earlier kit used `--fw-color-link`; that appears to be
> wrong for this framework version.

---

## Layer 3 — Slate-defense CSS (small, load-bearing)

Only what the bundle + `--fw-*` cannot cover on this instance:

```css
/* Chrome links stay charcoal — Slate's a:link (0,1,1) reaches into our headers.
   !important + scope out-specifies it (the --fw handoff doesn't take here). */
.wsu-header-global a:link,.wsu-header-global a:visited,
.wsu-header-unit a:link,.wsu-header-unit a:visited{color:inherit !important;}

/* Content links forced WSU crimson (belt-and-suspenders next to --fw-link-text). */
.wsu-content a:link,.wsu-content a:visited{color:#a60f2d !important;}
.wsu-content a:hover,.wsu-content a:focus{color:#a60f2d !important;}

/* Required-field asterisk — Slate stamps data-required="1"; WSU DS has no marker. */
.wsu-content .form_question[data-required="1"] .form_label::after{
  content:" *";color:var(--wsu-crimson);
}

/* Layout-table fix. Slate positions forms/login with tables it marks role="none"
   (or "presentation"). The bundle styles every bare table (crimson top border +
   cell gridlines), which bleeds onto layout tables. Strip it from presentational
   tables only; real data tables (no such role) keep WSU styling. Blanket, keyed on
   Slate's own marker. */
.wsu-content table[role="none"],.wsu-content table[role="presentation"],
.wsu-content table[role="none"] > *,.wsu-content table[role="presentation"] > *,
.wsu-content table[role="none"] th,.wsu-content table[role="none"] td,
.wsu-content table[role="presentation"] th,.wsu-content table[role="presentation"] td{
  border:0 !important;background:transparent !important;
}
```

Why each is unavoidable:
- **Links** — Slate's `a:link` outranks the bundle by specificity, and this instance
  ignores `--fw-link-text`. Only an equal/higher-specificity `!important` rule wins.
- **Required asterisk** — the WSU 2.x system defines no required-field marker at all.
- **Layout tables** — the bundle has no "this table is layout" opt-out; `role="none"`
  is Slate's signal and the cleanest blanket hook (one rule, every page).

---

## Form fields: what classes to add

**None.** Slate emits `.form_input` / `.form_label` / `.form_button` /
`.form_question`, but those are still real `<input>/<label>/<button>` elements, so the
bundle's bare-element rules skin them, and `--fw-*` colors Slate's own framework
styling. Adding WSU classes to fields would match nothing useful. The only field-
adjacent class that matters is `wsu-content` on the container (buttons).

| Slate element | WSU class needed | Styled by |
|---|---|---|
| text/email/tel/date/number/etc. `input` | none | bare `input[type=…]` |
| `select`, `textarea` | none | bare element |
| `label`, `legend`, `fieldset` | none | bare element |
| checkbox / radio | none | bare element + `accent-color` |
| data `table` | none | bare `%table` (crimson top border) |
| **button** / `input[submit\|button\|reset]` | ancestor `.wsu-content` | `.wsu-content button` |
| required field marker | (XSLT + `.wsu-required`/asterisk rule) | Slate-defense CSS |
| layout `table[role=none]` | (strip borders) | Slate-defense CSS |

**Next:** `003_deploy_and_troubleshoot.md`.
