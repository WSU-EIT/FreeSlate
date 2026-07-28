# 001 — How It Works: Slate, XSLT, and the WSU 2.x Bundle

## The rendering pipeline

Slate renders every external page to XHTML on the server, then runs an XSLT 1.0
transform (`build.xslt`) over that XHTML before sending the result to the browser.
Everything is resolved server-side, in order:

1. Slate builds the form as XHTML (fields, labels, validation hooks).
2. `build.xslt` wraps that XHTML in WSU chrome and drops the form into the content
   well. Our `--fw-*` variables and Slate-defense CSS are inlined in `<head>`.
3. The browser receives one finished, styled HTML document — no flash, nothing
   waiting on JavaScript to "fix" the page.

The CDN JavaScript (`wsu-design-system.js`) runs afterward and only drives
interactive components (menus, accordions). A plain Slate form uses almost none of
it; the form's appearance is pure CSS.

## What XSLT can and cannot do

XSLT **cannot style anything** — it has no color/font/spacing powers. It can only
rearrange markup and add classes/attributes. So branding is never "done in XSLT";
CSS always paints. `build.xslt`'s job is to (a) place official WSU chrome markup and
(b) hand Slate the right hooks. The painting comes from the CDN bundle plus the
small Slate-defense block.

Two lines are framework contract and must stay:
- `<template path="/shared/base.xslt" .../>` — pulls in Slate's base template.
- `<xsl:apply-templates select="xhtml:html/xhtml:body/node()"/>` inside
  `article.wsu-article` — the hand-off where Slate's form lands. Move it and the
  form disappears.

An **identity template** (`match="@*|node()"`) must be the last template: it copies
through everything not explicitly placed, or XSLT's built-in defaults strip the form
to bare text.

> XSLT gotcha: inside an inline `<style>` wrapped in `<xsl:text>`, a literal `<` (e.g.
> writing `<table>` or `<ul><li>` in a CSS comment) is parsed as an XML tag and breaks
> the transform. Always validate with `xmllint --noout build.xslt` before publishing.

## The WSU Web Design System 2.x

The bundle at `cdn.web.wsu.edu/designsystem/2.x/dist/bundles/wsu-design-system.css`
is the same compiled file wsu.edu and admission.wsu.edu load. Two things confirmed
from its source (repo `wsuwebteam/web-design-system`, tag v2.24.0):

- The bundle's entry SCSS `@import`s **Montserrat from Google Fonts** and the
  **wsu-icons 1.x CSS** itself. So the single bundle link already provides the font
  and icons; separate `<link>`s for them are redundant (harmless).
- Form elements are styled by **bare element selector** — `input[type=text]`,
  `select`, `textarea`, `label`, `fieldset`, `table` — with **no classes**. WSU's own
  form demo (`src/elements/form/form.njk`) uses zero classes on any field. The one
  exception is buttons: `.wsu-content button { ... }` — bare buttons only get the
  crimson WSU button when inside an element with the **class** `wsu-content`.

## Why Slate needs "defense"

Slate ships its own framework CSS (`/fw/framework/base.css`) that colors links blue
via `a:link { color: var(--fw-link-text) }` etc. The sanctioned way to recolor that
is Slate **Custom Color Replacement** (set the `--fw-*` variables — see `002`). On
this WSU instance, however, the `--fw-link-text` handoff does **not** take for links
(observed live: content links stay blue, the lockup would go blue). CSS source order
can't beat Slate here because `a:link` (specificity 0,1,1) outranks the bundle's
bare `a` (0,0,1) and `.wsu-wordmark`/lockup class rules — so link color is forced
with an equal-or-higher-specificity `!important` rule. That, plus the layout-table
strip and the required asterisk, is the entire Slate-defense block.

## The header story (why the lockup, not the wordmark)

The `wsu-wordmark` component's hover is a small crimson "tick" that grows *after* the
word (`::after` with `margin-left`). That is the actual 2.x behavior — verified in
the repo at both Feb-2022 and current tags. The "underline sweep" some WSU pages
showed is from an **older, self-hosted design-system build** (e.g. futurecoug's
`/shared/web-design-system/style.css?v=20220215`), not the current CDN. Current WSU
(admission.wsu.edu) loads 2.x and **hides the wordmark header**, using
`wsu-header-unit` + `wsu-logo-lockup` instead — which has no tick. We matched that:
crumb bar for WSU identity, lockup for the unit title.

**Next:** `002_branding_mechanisms.md` for the concrete hooks and classes.
