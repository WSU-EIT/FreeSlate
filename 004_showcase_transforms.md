# 004 — Showcase Build (`build_showcase.xslt`)

`build_showcase.xslt` is a **demonstration** variant of the production `build.xslt`.
It exists to show off two things: (1) the *complete* Slate Custom Color Replacement
surface, and (2) the XSLT class-injection mechanic applying **real** WSU 2.x classes
to Slate's markup. Production stays lean — deploy `build.xslt`; use the showcase to
learn the moves and cherry-pick.

Both files are identical except for the color block and the transforms below.

---

## Complete `--fw-*` set (all 24 documented variables)

The showcase maps **every** variable from the Custom Color Replacement doc to the WSU
palette — the four production omits (`--fw-success-text`, `--fw-datepicker-text`,
`--fw-dialog-footer-border`, `--fw-button-background`) plus per-line comments naming
what each one paints. Slate reads these and repaints its *own* chrome (datepicker,
dialogs, tabs, validation, popups, table dividers, native checkbox/radio). This is
the sanctioned mechanism — no specificity fighting.

---

## The showcase transforms

All match Slate's **input** XHTML (hence the `xhtml:` prefix) and use classes verified
to render in the 2.x bundle.

**1 — Wrap every form in a card.** `xhtml:form` is wrapped in `<aside class="wsu-callout">`.
A bare `wsu-callout` is the real "card" (gray-5 panel, radius, soft shadow, top accent).
Note: a bare `wsu-card` is only margin — it needs `__content` + a background modifier —
so `wsu-callout` is the correct one-class card wrapper.

**2 — Section headers become real marked headings.** Any element carrying `form_h2` is
*replaced* with a real `<h2 class="wsu-heading--style-marked">` — so it gets the bundle's
heading typography **and** the crimson mark. Demonstrates XSLT changing element type, not
just adding a class.

**3 — Data tables get `wsu-table`.** Appended to real data tables; layout tables
(`role="none"`/`presentation`) are excluded so the login-page strip rule still wins.
A safe, additive transform (bare tables are already skinned; this future-proofs for
`wsu-table` variants).

**4 — Target a specific input type (the "date input" idea).** `xhtml:input[@type='date']`
gets a marker class. Illustrative only: date inputs are already styled by the bundle, and
no design-system date-field class exists to map to, so this purely demonstrates targeting
one field type. Harmless if left on.

**5 — Secondary button variant.** A button whose text is "Cancel" is tagged
`wsu-button wsu-button--style-outline` (a real 2.x variant). Matching on button text is
fragile — verify against your real forms before relying on it. Shown active as a demo.

**6 — Conditional branding via `fw:` functions.** The header lockup title is computed
server-side from the page path with `fw:path()` + `xsl:choose`: `/register/inquiry` →
"Request Information", `/apply` → "Apply", else "Admissions". This is Slate's sanctioned
conditional-branding pattern (and always includes a default). Other `fw:` helpers you can
branch on: `fw:query('param')`, `fw:url()`, `fw:https()`, `fw:config(key)`, and the
`roundKey` variable (`*/fw:template/@application-roundKey`) for per-application branding.
Note: conditional branding is explicitly outside Technolutions Support scope — keep it
simple and always default.

---

## Best-practice notes

- **Keep production minimal.** Every transform is a maintenance surface. `build.xslt`
  ships only the essentials (chrome, `--fw-*`, link/table defense, required marker).
  The showcase is where you *try* things.
- **Real classes only.** Each transform maps to a class that actually renders bare in
  2.x. Where no real class exists (date fields), the showcase says so rather than
  inventing styling.
- **Match the input, not the output.** Transforms run on Slate's XHTML (`xhtml:*`), never
  on the chrome this file emits.
- **Validate every time:** `xmllint --noout build_showcase.xslt`. Watch for literal `<`
  or `--` inside inline `<style>`/comment text — both break the XML.

**Version:** build_showcase.xslt is stamped `SHOWCASE-2.0` in the footer so you can tell
it apart from a production deploy at a glance.
