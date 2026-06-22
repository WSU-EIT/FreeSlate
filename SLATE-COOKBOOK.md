# Slate Cookbook — copy-paste examples for every surface

Practical, copy-paste examples for the Slate (Technolutions) surfaces this kit
touches. RESEARCH.md covers *CSS/HTML pattern decisions*; this file covers
*platform integration* — XSLT, the `--fw-*` variables, the Slate DOM contract,
per-form CSS, Instructions blocks, portals + Liquid, events, and deployment.

Everything here is grounded in the Slate Knowledge Base (Branding, Forms,
Portals). When a detail is undocumented or version-sensitive (the submit-button
class, the emitted DOM), the example says so — **always test-instance verify.**

---

## The one rule everything follows

Slate is a **hosted** engine. You do not own the pages — Slate renders the
fields, validation, AJAX navigation, payment, conditional display, event
registration, and portal data. You own a **decoration layer** that wraps and
restyles whatever Slate emits.

| Your kit owns | Slate owns — never rebuild |
|---|---|
| Page frame & chrome, type, brand color | Form field rendering, validation logic |
| Input / button / component styling | AJAX navigation, conditional display |
| Design tokens (`--wsu-eit-*`) | Payment, data submission |
| Opt-in CSS components | Event registration, portal data |
| a11y DOM repairs (the one JS exception) | Countdown timers, activation / closed messages, waitlist |

Every kit rule scopes under `.wsu-eit` / `.wsu-eit-zone`. If a rule doesn't,
it doesn't belong in the kit.

### Global-first: editors should never need to touch code

The branding lives in **two global files** (`build.xslt` + `build.css`) that
theme every public page automatically. The goal is that a content editor builds
forms, events, and portals with **Slate's own native tooling** — the Form
Builder, field types, Required/Internal flags, help text, conditional logic,
deadlines, merge fields — and everything comes out on-brand and accessible
**without opening a single code segment.** Reach for code only for a genuine
extra a native tool can't express (dropping in an image, a spinner, or a kit
component via an Instructions block). Concretely:

- **Styling is global, never per-form.** `build.css` + `§SLATEVARS` brand
  Slate's emitted markup *and* its framework chrome, so a brand-new form is
  already branded. Per-form *Edit Styles* (§6) is a last resort.
- **Prefer a native Slate feature over custom code every time.** Dates,
  deadlines, countdowns, conditional display, calculations, input masks,
  required marking — Slate does these natively (§9, below, and the table in
  RESEARCH.md §4). Custom CSS/JS is only for what Slate genuinely can't do.

**Contents**
1. The XSLT page template
2. Conditional branding (`fw:` namespace)
3. Slate's native `--fw-*` color variables
4. The `--wsu-eit-*` token cascade
5. The Slate DOM contract (what to hook)
6. Per-form CSS — and why you rarely need it
7. Form Instructions blocks (editor HTML)
8. Portals: Views + Methods + Queries + Liquid
9. Events
10. Application page migration
11. Deployment & caching
12. The WYSIWYG color palette (config key)
13. Favicon & rollback

---

## 1 · The XSLT page template (`build.xslt`)

Slate renders each external page to an XHTML document, then runs `build.xslt`
as an **XSLT 1.0** transform over it. A minimal, valid template:

```xml
<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xhtml">

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">

      <!-- CONTRACT 1 — pull in Slate's framework base. Required. -->
      <template path="/shared/base.xslt"
                xmlns="http://technolutions.com/framework" />

      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="/shared/build-fonts.css?v=20260618a" rel="stylesheet" />
        <link href="/shared/build.css?v=20260618a" rel="stylesheet" />

        <!-- Preserve Slate's own head: framework CSS, per-form Edit Styles, title -->
        <xsl:apply-templates select="xhtml:html/xhtml:head/node()" />
      </head>

      <body>
        <xsl:copy-of select="xhtml:html/xhtml:body/@*" />
        <div id="wsu-eit-frame" class="wsu-eit">
          <a class="wsu-eit-skip" href="#wsu-eit-main">Skip to content</a>

          <!-- ...your topbar... -->

          <main id="wsu-eit-main" class="wsu-eit-zone" tabindex="-1">
            <!-- CONTRACT 2 — the HAND-OFF: Slate's rendered body lands here -->
            <xsl:apply-templates select="xhtml:html/xhtml:body/node()" />
          </main>

          <!-- ...your footer... -->
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- Identity template: copy everything else through unchanged -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
```

The two lines marked **CONTRACT** are pure Slate framework plumbing — keep them
verbatim. The hand-off line is *why* the whole kit can scope to one container:
you own `<main class="wsu-eit-zone">`, Slate owns what lands inside it.

**Linking assets (always cache-bust):**

```xml
<link  href="/shared/build.css?v=20260618a" rel="stylesheet" />
<script src="/shared/wsu-eit-a11y.js?v=20260618a" defer="defer"><xsl:text> </xsl:text></script>
```

> `<xsl:text> </xsl:text>` keeps `<script>` from self-closing — a self-closed
> `<script/>` breaks parsing in some browsers.

---

## 2 · Conditional branding (`fw:` namespace)

To branch chrome by URL, query parameter, or application round, declare the
framework namespace on the **root** `<xsl:stylesheet>`:

```xml
<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:fw="http://technolutions.com/framework"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xhtml">
```

Framework functions:

| Function | Returns |
|---|---|
| `fw:query('utm_source')` | a query-string parameter value |
| `fw:path()` / `fw:pathAndQuery()` | the request path |
| `fw:url()` | the full request URL |
| `fw:https()` | the subdomain in use |
| `fw:config('key')` | any instance config value |
| `fw:year()` | the current year (copyright end-years) |

**Branch by path** — prefer `xsl:choose` + `contains()` over `xsl:if` (the KB
warns a bare `If` can leave branding loopholes):

```xml
<xsl:choose>
  <xsl:when test="contains(fw:path(), '/register/transfer')">
    <link href="/shared/build-transfer.css?v=20260618a" rel="stylesheet" />
  </xsl:when>
  <xsl:otherwise>
    <link href="/shared/build.css?v=20260618a" rel="stylesheet" />
  </xsl:otherwise>
</xsl:choose>
```

**Branch by query parameter:**

```xml
<xsl:if test="fw:query('campus') = 'spokane'">
  <body class="wsu-eit campus-spokane">…</body>
</xsl:if>
```

**Branch by application round** (the KB's recommended approach for
applications). Declare the round-key variable once near the top of the
transform, then branch on it. The round key only exists once an applicant has
started an application, so always include an `<xsl:otherwise>` default:

```xml
<xsl:variable name="roundKey" select="*/fw:template/@application-roundKey" />

<xsl:choose>
  <xsl:when test="contains(fw:pathAndQuery(), '/apply') and $roundKey = 'GR'">
    <img src="/images/wsu-grad.svg" alt="WSU Graduate School" class="cr" />
  </xsl:when>
  <xsl:otherwise>
    <img src="/images/wsu.svg" alt="Washington State University" class="cr" />
  </xsl:otherwise>
</xsl:choose>
```

**Dynamic copyright year:**

```xml
<div>© <xsl:value-of select="fw:year()" /> Washington State University</div>
```

> Best practice from the KB: to give *certain* forms a different look, **embed**
> the form on a page/domain that carries the desired branding rather than
> branching here — embedded forms inherit the host page and keep the instance
> on one consistent template.

---

## 3 · Slate's native `--fw-*` color variables

Slate's framework paints part of its own chrome — datepickers, the
suggest/autocomplete dropdown, dialogs, tab strips, the default submit button,
and the required/validation wash — from documented `--fw-*` custom properties,
*separate* from the `.form_*` markup you restyle. This kit maps them to brand
tokens in `build.css §SLATEVARS`. The full overridable set with Slate defaults:

```css
:root {
  --fw-body-text: #000000;                 /* most page text */
  --fw-link-text: #0000ff;                 /* hyperlinks */
  --fw-active-text: #3399ff;               /* link hover + search matches */
  --fw-success-text: #00aa00;
  --fw-success-accent: #529214;            /* success message border */
  --fw-success-background: #e6efc2;
  --fw-error-background: #ffcccc;           /* required/invalid field bg (pink) */
  --fw-warning-accent: #ffcc66;
  --fw-warning-background: #ffffcc;
  --fw-datepicker-text: #333333;
  --fw-datepicker-background-active: #666666;
  --fw-datepicker-background-hover: #f0f0f0;
  --fw-tab-text: #666666;
  --fw-muted-text: #808080;                 /* "loading…" etc. */
  --fw-input-border: #999999;
  --fw-suggest-background-hover: #efefef;
  --fw-tab-background: #f0f0f0;
  --fw-tab-background-hover: #fafafa;
  --fw-tab-text-hover: #00669e;
  --fw-table-row-border: #cccccc;
  --fw-dialog-footer-border: #eaeaea;
  --fw-dialog-header: #dadada;
  --fw-button-background: #dfdfdf;          /* non-default popup buttons */
  --fw-button-default-background: #c6c6c6;  /* the default button (Submit) */
}
```

**Brand them at the source** (what `§SLATEVARS` does — excerpt):

```css
:root {
  --fw-link-text:   var(--wsu-eit-brand-text);   /* crimson links */
  --fw-active-text: var(--wsu-eit-brand);
  --fw-input-border: var(--wsu-eit-edge);
  --fw-error-background: transparent;            /* kill the pink required wash */
  --fw-datepicker-background-active: var(--wsu-eit-brand);
  --fw-button-default-background: var(--wsu-eit-brand);  /* crimson Submit */
}
```

**Scope to forms only** (instead of `:root`) when you want the override to
apply to Slate forms in your branding but not elsewhere:

```css
form[data-fw-form] {
  --fw-error-background: transparent;
}
```

This reaches UI your `.form_*` selectors can't (the calendar popup, the
autocomplete list, dialogs) and is the *official* way to do two things this kit
used to do by override: quieting the pink required wash (`--fw-error-background`)
and painting the submit (`--fw-button-default-background`).

---

## 4 · The `--wsu-eit-*` token cascade

All brand colors and sizes live once in `build.css §TOKENS`; every rule
consumes them via `var()`. To re-skin, change the token — not the rules:

```css
:root {
  --wsu-eit-brand:      #a60f2d;   /* WSU Crimson · PMS 201C */
  --wsu-eit-brand-text: #7a0b21;   /* link/text crimson · AAA on white */
  --wsu-eit-round:      6px;
  --wsu-eit-body-size:  16px;
}

.wsu-eit-zone :is(input, select, textarea) {
  border: 1px solid var(--wsu-eit-edge);
  border-radius: var(--wsu-eit-round);
}
```

**Adopt a tuned decision** from the showcase by pasting its exported override
*after* `build.css` (or into `§TOKENS` directly):

```css
/* wsu-eit-overrides.css — only the values that differ from shipped */
:root {
  --wsu-eit-link-size: 1.125rem;
  --wsu-eit-round: 2px;
}
```

```xml
<link href="/shared/build.css?v=20260618a" rel="stylesheet" />
<link href="/shared/wsu-eit-overrides.css?v=20260618a" rel="stylesheet" />
```

---

## 5 · The Slate DOM contract (what to hook)

What Slate emits for a form, and the selectors the kit legitimately targets:

```html
<div class="form_page">
  <div class="form_question" data-required="1">   <!-- one per field: the ROW -->
    <label class="form_label" for="…">Email</label> <!-- question + asterisk -->
    <div class="form_responses">                   <!-- wraps the input(s) -->
      <div class="form_response">                  <!-- one control / choice row -->
        <input type="email" … />
      </div>
    </div>
  </div>
  <div class="form_error">This field is required.</div>  <!-- Slate-injected -->
  <button type="submit" class="default">Submit</button>  <!-- the REAL submit -->
</div>
```

```css
/* All scoped under .wsu-eit-zone */
.wsu-eit-zone .form_question { margin: 0 0 var(--wsu-eit-q-gap); }
.wsu-eit-zone .form_label    { font-weight: var(--wsu-eit-label-weight); }
.wsu-eit-zone .form_responses :is(input, select, textarea) { /* … */ }

/* GOTCHA: Slate's submit is button.default, NOT input[type=submit].
   A bare button:not([class]) selector misses it. Target .default explicitly. */
.wsu-eit-zone button.default,
.wsu-eit-zone button[type="submit"] {
  background: var(--wsu-eit-brand);
  color: #fff;
}
```

- Never force `display` on `.form_question` — Slate toggles it inline for
  conditional fields.
- The required marker (`.form_question[data-required="1"] .form_label`), the
  `.form_*` row structure, and the `form_<GUID>_container` id are all
  documented by Slate (KB ▸ Form-Specific CSS). Deeper internals can still
  shift between releases — verify against a real capture, and let
  `wsu-eit-a11y.js` repair the gaps CSS can't (nameless controls, empty
  labels, missing `aria-required`, etc.).

---

## 6 · Per-form CSS — and why you rarely need it

**Reach for per-form CSS last.** The instance-wide `build.css` already themes
every form globally, so the normal path needs *zero* code: an editor builds the
form in the Form Builder (native fields, required flags, help text) and it
comes out fully branded. Per-form CSS is only for a genuine one-off a single
form needs — and even then, scope it to that form's container so it can't leak.
The `<GUID>` is the 32-char id in the form's URL:

```css
/* Only this form — wider two-column address block */
#form_afefd9d9-c8d9-450e-bcfa-dbc88d574b7b_container .form_page {
  max-width: 60rem;
}
#form_afefd9d9-c8d9-450e-bcfa-dbc88d574b7b_container .wsu-eit-address {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--wsu-eit-gap-4);
}
```

**Target all forms from the template without a GUID.** When a rule belongs in
`build.css` (template level) and should apply to every form, Slate's official
selector matches any form container by id pattern — no GUID needed:

```css
form[id^="form_"][id$="_container"] .form_question[data-required="1"] .form_label::after {
  content: " *";
  color: var(--wsu-eit-star);
}
```

> The required-asterisk rule above is Slate's own documented pattern (KB ▸
> Form-Specific CSS) — it's exactly what `build.css §SLATE` ships, so required
> fields are marked the sanctioned way, globally, with no per-form work.

Tokens still resolve in per-form CSS — reuse `var(--wsu-eit-*)` so any one-off
stays on-brand.

### Remediation: strip per-object overrides so the global theme wins

Per-form CSS/JS is the #1 source of drift — it silently overrides the global
theme and is invisible until you open each object. The per-form panel is **Edit
Form ▸ Edit Scripts/Styles**, with a *Custom Styles* tab (CSS) and a *Scripts*
tab (JS). When auditing forms, anything in those tabs that merely duplicates
what `build.css` already provides — label styling, the required asterisk, button
color, fonts, spacing — is redundant. Recognize the KB's own example overrides:

```css
.form_label { font-weight: bold; font-style: italic; }
.form_question[data-required="1"] .form_label::after { color: red; content: " *"; }
```

The theme already does both, the sanctioned way. **Delete the local copy, Save,
preview in the test instance, and let the global theme govern.** Keep a per-form
rule only when it's genuinely form-specific layout the theme can't express — and
even then, scope it to `#form_<GUID>_container` and use `var(--wsu-eit-*)` /
`--fw-*` tokens, never hardcoded hex. Better still, promote a recurring pattern
into a reusable `.wsu-eit-*` component in `build.css` and delete every local
copy. (Also check Instructions blocks for inline `<style>`/`<script>` smuggled
into content — strip those too.)

> Runtime note: JS pasted into a form's *Custom Scripts* tab is auto-wrapped in
> `$(document).ready(...)` and runs after load (jQuery is global on Slate
> pages). So clearing that tab removes a ready-block — if a behavior is worth
> keeping, move it into the global `wsu-eit-extras.js` (also ready-wrapped) so
> it's centralized and versioned, then empty the per-form tab.

---

## 7 · Form Instructions blocks (editor HTML)

The Form Builder's **Instructions** tool drops an HTML block anywhere on a
form. This is where a content editor uses a kit component — **one wrapper class
around plain HTML**, no styles, no scripts:

```html
<!-- FAQ accordion (native <details>, no JS) -->
<div class="wsu-eit-faq">
  <details>
    <summary>When do applications open?</summary>
    <p>Priority applications open September 1.</p>
  </details>
  <details>
    <summary>Is there an application fee?</summary>
    <p>The $70 fee is waivable — see Cost &amp; Aid.</p>
  </details>
</div>
```

```html
<!-- Required-field key — the canonical top-of-form note -->
<p class="wsu-eit-fine"><span aria-hidden="true">*</span> Indicates a required field.</p>
```

```html
<!-- Status badges -->
<p>Your file: <span class="wsu-eit-badge wsu-eit-badge--done">Complete</span></p>
```

Opt-in **behaviors** activate only via `data-eit-*` — e.g. a copy button:

```html
<div data-eit-copy>
  <code>future.coug@wsu.edu</code>
</div>
```

The four editor surfaces: (1) Form **Instructions** tool, (2) a field's **help
text** (plain text), (3) an **Event Description** tab, (4) a **portal static
block**.

---

## 8 · Portals: Views + Methods + Queries + Liquid

A portal is **Views + Methods + Queries**, made dynamic by **Liquid**. The
chrome is branded by `build.xslt` / `build.css`; the body is yours to lay out —
reuse the `--wsu-eit-*` tokens and components so portals match forms.

**Query → exports.** Pick a Base population; each column becomes an *export*
(merge field). Name exports lowercase, no spaces (use underscores), or Slate
turns spaces into hyphens. Prompt exports return the short value by default;
switch to *Extended Value* if you need the long form. Keep any default GUID
filter on application-display queries.

**Parameters** pass data *into* a query (Edit Parameters):

```xml
<param id="person" type="uniqueidentifier" />
<param id="term"   type="string" />
```

**Method** binds a URL to a query + view. Use **GET** for modern portals
(POST is deprecated — use a Slate form instead). The **Output Type** decides
how branding is applied:

| Output Type | Use when |
|---|---|
| **Default Branding** | the view should be wrapped in your standard Slate branding |
| **Framework + No Branding** | the portal needs *different* branding (put it in the view) |
| **AJAX Popup / No Branding** | popups or AJAX-inserted fragments, rendered as-is |
| **JSON** | the page does its own AJAX rendering |

**Liquid** (Shopify's templating language; works anywhere merge fields do):

```liquid
{# objects #}
<h1>Welcome back, {{ first_name }}.</h1>

{# conditionals #}
{% if major == 'Philosophy' %}
  <p class="wsu-eit-banner">Ask about our Ethics in Society track.</p>
{% elsif major == '' %}
  <p>Undecided is welcome — explore on campus.</p>
{% endif %}

{# filters #}
<p>Submitted {{ submitted_date | date: '%B %-d, %Y' }}.</p>
```

**Data-table loop** — note the `result.` prefix on each row's exports:

```liquid
<table class="wsu-eit-table">
  <thead><tr><th>Date</th><th>Type</th><th>Score</th></tr></thead>
  <tbody>
    {% for result in test_scores %}
      <tr>
        <td>{{ result.test_date }}</td>
        <td>{{ result.test_type }}</td>
        <td>{{ result.test_score }}</td>
      </tr>
    {% endfor %}
  </tbody>
</table>
```

**Embed a form in a portal/page:**

```html
<div id="form_afefd9d9-c8d9-450e-bcfa-dbc88d574b7b">Loading…</div>
```

Pre-fill its fields with query-string parameters; for an application-scoped
form, the `person` parameter must be the **application GUID**. Merge fields
must exist as **exports** in the portal query with names matching exactly.

> Performance: offload heavy comparisons to the query (an "existence export"
> boolean) instead of deeply nested Liquid. Filter portal *data* with
> queries/Liquid — not client-side JS. (The kit's type-to-filter behavior is
> scoped to *static* lists only, for exactly this reason.)

### Portal CSS — theming the widgets

A portal inherits the global theme when the method's Output Type is **Default
Branding**. To style the *body*, edit the portal's top-level page → **Edit**
(per-portal CSS) or **Edit Template** (fully distinct chrome). Every view widget
renders inside `div.part`, and you can add space-separated class names in a
widget's **CSS Class Name** field, then target them — so portal styling can ride
the same token system as forms:

```css
/* a class you typed into a widget's "CSS Class Name" field */
div.part.wsu-eit-pane { margin-bottom: var(--wsu-eit-gap-5); }

/* widget ids are generated — prefix-match them. Real checklist fixes: */
div[id^="part_checklist_"] table.table > * > tr > td { white-space: normal !important; }
div[id^="part_checklist_"] table.table col:nth-child(4) { width: 15% !important; }
```

- **`!important` is normal here**, not a smell — portal rules routinely have to
  beat Slate's framework specificity, and generated widget ids force
  prefix-matching (`[id^="part_…"]`).
- **Stock branding ids** you may need to hide on a specific portal:
  `#c_footer` (global footer), `#c_header-span` (header), `c_ft_legal`
  (copyright) — from Slate's default template.
- **Building a distinct portal Template?** You MUST place the special
  `{{Content}}` merge field where the portal body should render (between your
  header/footer) — omit it and the content vanishes. A Template can also load a
  framework like Bootstrap scoped to just that portal, which is the clean escape
  hatch when one portal needs something the global `build.xslt` shouldn't carry.

### Native Slate scripting — prefer `FW.*` over hand-rolled JS

Slate ships a global jQuery-based `FW` object that its own pages use; jQuery
itself is global on every Slate page. When a portal/form genuinely needs script,
reach for these before building your own (they match Slate's native behavior):
`FW.Lazy.Popup(uri)` (modal without reload), `FW.Progress.Load()` /
`FW.Progress.Unload()` (Slate's loading overlay), `FW.Dialog.Center()`, and
`FW.escapeSelector()` (escape dots in export keys). These are
community-documented, not in the official KB — stable in practice, but verify in
the test instance. The submit button is `button.default`
(`$('button.default').text('Next')` to relabel, etc.).

---

## 9 · Events

Per-event content goes in the **Description tab** (HTML); branding wraps event
pages like any other. **Stateful behavior is native — do not rebuild it:**
registration deadlines, activation date/time with a custom pre-live message,
closed-event messages, the Share/join-page countdown timer, waitlist
auto-transfer, and event maps.

```html
<!-- Event Description tab — kit components are fine here too -->
<div class="wsu-eit-steps">
  <ol>
    <li>Register below.</li>
    <li>Watch for a confirmation email.</li>
    <li>Add the calendar invite it contains.</li>
  </ol>
</div>
```

**Dates, the native way.** To *format* a date for display — in a portal,
email, or status page — use Slate's native Liquid `date` filter, no JavaScript:

```liquid
{{ start_date | date: '%B %-d, %Y at %-I:%M %p' }}   →  October 18, 2026 at 9:00 AM
```

Slate also owns event timezones and deadline/countdown display natively (§ above).
The **one** thing server-side Liquid can't do is render a time in the
*visitor's own* timezone — the server doesn't know it. That single gap is why
`wsu-eit-extras.js` ships an opt-in client-side renderer; everything else
date-related should use the native filter or Slate's event tools:

```html
<!-- only for visitor-local time; the typed text is the no-JS fallback -->
<time data-eit-local datetime="2026-10-18T09:00-07:00">Oct 18, 9:00 a.m. Pacific</time>
```

---

## 10 · Application page migration

Historically each standard application page could carry its own `build.xslt`;
Technolutions is migrating these to **application-scoped forms**. A legacy
per-page `build.xslt` is effectively inactive if it: contains only hidden
fields, is fully commented out, is a template with no mapped fields, or lives
on an invalid path (e.g. `/apply/INACTIVE/per-build.xslt` — an old
deactivation trick).

> Inventory any legacy per-page application `build.xslt` early — an active one
> can silently override branding on specific application pages. Migration:
> recreate each page as an application-scoped form, carry custom fields from
> the Application Editor plus static content/logic, and move it to Production.

---

## 11 · Deployment & caching

Slate serves external pages from two folders, edited via **Database ▸ Branding
▸ Branding Editor**:

```
Database ▸ Files
 ├─ /dev      ← Branding Editor sandbox. "Import Current" copies /shared → /dev.
 └─ /shared   ← LIVE. Every external page is served from here.
```

- **Import Current** — `/shared` → `/dev` (overwrites dev; unsaved dev edits lost).
- **Preview** — renders a real page with dev files, in Development Mode. Try
  `/register/<FORM_URL>`; "Preview as" impersonates a record.
- **Publish Changes** — `/dev` → `/shared`. **Publish *is* the deploy.**

**Cache busting** (the #1 "why isn't my change showing"): CSS/JS are cached
server-side. After editing a file, bump the `?v=` on its `<link>`/`<script>` in
`build.xslt`:

```xml
<link href="/shared/build.css?v=20260618b" rel="stylesheet" />   <!-- was …18a -->
```

Propagation: up to ~15 min across production nodes, up to ~24 h browser cache
(incognito bypasses the latter). Config-key changes also take up to ~15 min.

**Rollback:** Database ▸ Files ▸ `/dev` ▸ select file ▸ *Version History* ▸
*Revert* ▸ Save.

**Deploy checklist**

1. Upload to `/shared/`: `build.xslt`, `build-fonts.css`, `build.css`,
   `wsu-eit-extras.css`, `wsu-eit-a11y.js`, `wsu-eit-extras.js`.
   *Do not upload* `index.html`, the `index_*.html` views, or any
   `wsu-eit-showcase/view/icons/glossary.js` — those are showcase-only.
2. **Preview a real form in the TEST instance.**
3. Publish.
4. Bump `?v=` on any file you edit afterward.
5. **Point mobile at this template too** (see below) — otherwise phones get
   Slate's default grey, not our branding.

**Mobile branding — the easy-to-miss switch.** By default Slate serves mobile
visitors a minimalist *default grey* template, **not** `build.xslt`. Until you
flip this, every phone visitor sees unbranded pages no matter how good
`build.css` is. Set it once: **Database ▸ Configuration Keys ▸ Branding,
Privacy, & Ping ▸ Mobile Template** → select `/shared/build.xslt` → Save.
(Test all pages on mobile in the test instance first — JS-dependent branding
features are stripped on mobile.) After this, the kit's responsive CSS —
`@media` breakpoints, coarse-pointer 44px targets, fluid `clamp()` type — is
what actually runs on phones.

**Two config keys worth knowing** (Database ▸ Configuration Keys):

- **External Domains for Allowed Scripts** — Slate blocks CSS/JS loaded from an
  outside domain unless it's on this comma-separated allowlist. This bites
  anything CDN-hosted — including a Google Fonts `@import`. Prefer **hosting
  fonts and scripts in `/shared/`** so there's nothing to allowlist; reach for
  this key only when a third-party asset genuinely must stay remote.
- **Embed Script on Slate Pages** — injects JS into the `<head>` of every Slate
  page *without* editing `build.xslt` (paste the JS only, no `<script>` tags).
  Fine for a true global one-off like analytics; for the kit's own JS, prefer a
  versioned `<script>` in `build.xslt` so it's reviewable and `?v=`-bustable.

**Non-negotiable safety:** a malformed `build.xslt` is a failed transform on
*every* external page at once. Technolutions does not support custom JS in
branding (hence CSS-first; the kit's only JS is a11y repairs impossible in
CSS). Side navigation bars are not supported in Slate branding, and
JS-dependent branding (menu pop-ups, jQuery widgets, embedded search boxes)
often conflicts with Slate and is stripped — both reasons the kit ships a
single-column, CSS-first frame. Logos/graphics made in test must be
re-uploaded to Production on activation.

---

## 12 · The WYSIWYG color palette (config key, not CSS)

The rich-text editor's swatches — the colors a content author can pick from in
forms, Deliver, and portals — are **not** controlled by CSS. Set them so
authored content can't reach for off-brand ink:

```
Database ▸ Configuration Keys ▸ General Settings ▸ HTML Color Palette Override
Value: a comma-separated list of up to 24 hex codes, e.g.
  A60F2D,680222,7A0B21,CA1237,262626,595959,767676,D9D9D9,FFFFFF
```

(Up to ~15 min to propagate. This is separate from both `--fw-*` and
`--wsu-eit-*`.)

---

## 13 · Favicon & rollback

**Favicon:** Database ▸ Files ▸ *Upload File* (or *Upload File by URL*) ▸ set
the **Path** to exactly `/favicon.ico` ▸ Save. (~15 min to propagate, up to
24 h browser cache.)

**When an edit misbehaves** — conditional branding loop, broken transform —
revert via the `/dev` file's *Version History* (§11) rather than hand-undoing.
Always re-Preview in the test instance before Publishing the revert.

---
© Washington State University · Built by Enrollment Information Technology
