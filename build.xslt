<?xml version="1.0" encoding="utf-8"?>
<!--
  ============================================================================
  WSU Slate branding — SANDBOX BUILD
  ============================================================================

  This is the production branding stylesheet PLUS a temporary on-screen
  settings overlay, so we can compare every option against a real Slate form
  and lock in defaults before we commit.

  Everything temporary is fenced between XML comments reading
  "SANDBOX:BEGIN x" and "SANDBOX:END x".

  ===========================================================================
  HOW TO REMOVE THE SANDBOX ONCE DEFAULTS ARE CHOSEN
  ===========================================================================
  1. Load the form, set the overlay the way you want it, copy the query
     string it shows at the bottom of the panel.
  2. Paste those values into the $default-* parameters at the top of this
     file. They are the single source of truth: with the overlay gone, the
     parameters are what renders.
  3. Delete every SANDBOX:BEGIN…SANDBOX:END block. There are 4:
       A. sandbox parameters + $cfg resolution helper
       B. the overlay CSS + JS injected into xhtml:head
       C. the overlay markup injected at the top of xhtml:body
       D. the multi-variant header block (keep only the variant you chose)
  4. In the required-field template, delete the branch you are not using
     (the per-field hint OR the asterisk + top note) and drop the
     data-wsu-req attribute plumbing.
  5. Nothing else references the sandbox. No external JS or CSS files were
     added — the overlay is inline in this file on purpose so removing it is
     a delete, not a deployment.

  Two categories are deliberately separated in the overlay, because they are
  different kinds of decision:

    CONFIGURATION   choices among options the official WSU Web Design System
                    already ships. Nothing custom — we are picking a class.
                    (which header, gray vs crimson, cougar head treatment)

    XSLT TRANSFORMS markup this stylesheet generates or rewrites that Slate
                    does not emit on its own. This is code we own and have to
                    maintain.
                    (required-field treatment, Month/Day/Year sublabels,
                     link size, form card, marked headings, table stripping)

  Vendored: WSU Web Design System 3.4.2, WSU Icons 2.0.5.
  ============================================================================
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml">

  <xsl:output method="html" indent="no" omit-xml-declaration="yes" encoding="utf-8" />

  <!-- ==========================================================
       DEFAULTS — the values that survive the sandbox
       ========================================================== -->

  <!-- CONFIGURATION: which shipped design-system pieces we use. -->
  <xsl:param name="default-global-header">full</xsl:param>   <!-- crumb | full | system | off -->
  <xsl:param name="default-global-dark">0</xsl:param>         <!-- full bar only -->
  <xsl:param name="default-global-navless">1</xsl:param>      <!-- full bar only -->
  <xsl:param name="default-dept-header">off</xsl:param>      <!-- off | unit | campus -->
  <xsl:param name="default-dept-dark">0</xsl:param>
  <xsl:param name="default-coug">crimson</xsl:param>          <!-- crimson | light | white | boxed -->
  <xsl:param name="default-subtitle">0</xsl:param>
  <xsl:param name="default-utility">0</xsl:param>
  <xsl:param name="default-site-header">off</xsl:param>       <!-- off | light | dark | nested -->

  <!-- XSLT TRANSFORMS: markup we generate. -->
  <xsl:param name="default-required">both</xsl:param>         <!-- hint | both | star | note | off -->
  <xsl:param name="default-link-size">default</xsl:param>     <!-- default | large | small -->
  <xsl:param name="default-form-card">0</xsl:param>
  <xsl:param name="default-marked-h2">1</xsl:param>
  <xsl:param name="default-strip-tables">1</xsl:param>
  <xsl:param name="default-sublabels">1</xsl:param>
  <xsl:param name="default-crimson-links">1</xsl:param>
  <xsl:param name="default-outline-cancel">1</xsl:param>

  <xsl:param name="unit-name">Admissions</xsl:param>

  <!--
    System-header nav items. Placeholders for the demo — the tall header
    ships with a site navigation, and Slate has nothing to populate it from.
    Set a label to empty to drop that item; blank all three and the nav row
    renders empty. Replace with real links, or delete the __nav block in the
    system header if Slate pages should not carry site navigation.
  -->
  <xsl:param name="nav-1-label">Admissions</xsl:param>
  <xsl:param name="nav-1-href">https://admission.wsu.edu/</xsl:param>
  <xsl:param name="nav-2-label">Academics</xsl:param>
  <xsl:param name="nav-2-href">https://www.wsu.edu/academics/</xsl:param>
  <xsl:param name="nav-3-label">Campuses</xsl:param>
  <xsl:param name="nav-3-href">https://wsu.edu/about/campuses/</xsl:param>
  <!--
    The official hosted bundle. It @imports Montserrat, the icon font and
    Swiper itself, so this one stylesheet is all the branding needs.
    Swap to a Slate-hosted copy of the 3.4.2 dist if you would rather not
    depend on the CDN during the demo.
  -->
  <xsl:param name="wds-css">https://cdn.web.wsu.edu/designsystem/2.x/dist/bundles/wsu-design-system.css</xsl:param>

  <!-- SANDBOX:BEGIN A — parameters + overlay switch -->
  <!--
    Set sandbox to 0 (or delete this param and every use of $sandbox) to ship.
    While it is 1, the inline JS reads the query string and overrides the
    defaults above at runtime by writing data-wsu-* attributes onto <html>.
  -->
  <xsl:param name="sandbox">1</xsl:param>
  <!-- SANDBOX:END A -->

  <!-- ==========================================================
       Document shell
       ========================================================== -->

  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xhtml:head">
    <head>
      <xsl:apply-templates select="@*" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <link rel="stylesheet" href="{$wds-css}" />
      <xsl:apply-templates select="node()" />

      <!--
        Defaults are written onto <html> here, in the head, so the page paints
        with the right settings on the first frame instead of flashing.
      -->
      <script type="text/javascript">
        <xsl:text>window.__wsuBrandingDefaults = {</xsl:text>
        <xsl:text>"bar":"</xsl:text><xsl:value-of select="$default-global-header" /><xsl:text>",</xsl:text>
        <xsl:text>"gdark":"</xsl:text><xsl:value-of select="$default-global-dark" /><xsl:text>",</xsl:text>
        <xsl:text>"gnavless":"</xsl:text><xsl:value-of select="$default-global-navless" /><xsl:text>",</xsl:text>
        <xsl:text>"dept":"</xsl:text><xsl:value-of select="$default-dept-header" /><xsl:text>",</xsl:text>
        <xsl:text>"deptdark":"</xsl:text><xsl:value-of select="$default-dept-dark" /><xsl:text>",</xsl:text>
        <xsl:text>"coug":"</xsl:text><xsl:value-of select="$default-coug" /><xsl:text>",</xsl:text>
        <xsl:text>"subtitle":"</xsl:text><xsl:value-of select="$default-subtitle" /><xsl:text>",</xsl:text>
        <xsl:text>"util":"</xsl:text><xsl:value-of select="$default-utility" /><xsl:text>",</xsl:text>
        <xsl:text>"site":"</xsl:text><xsl:value-of select="$default-site-header" /><xsl:text>",</xsl:text>
        <xsl:text>"req":"</xsl:text><xsl:value-of select="$default-required" /><xsl:text>",</xsl:text>
        <xsl:text>"linksize":"</xsl:text><xsl:value-of select="$default-link-size" /><xsl:text>",</xsl:text>
        <xsl:text>"card":"</xsl:text><xsl:value-of select="$default-form-card" /><xsl:text>",</xsl:text>
        <xsl:text>"h2":"</xsl:text><xsl:value-of select="$default-marked-h2" /><xsl:text>",</xsl:text>
        <xsl:text>"striptables":"</xsl:text><xsl:value-of select="$default-strip-tables" /><xsl:text>",</xsl:text>
        <xsl:text>"sublabels":"</xsl:text><xsl:value-of select="$default-sublabels" /><xsl:text>",</xsl:text>
        <xsl:text>"links":"</xsl:text><xsl:value-of select="$default-crimson-links" /><xsl:text>",</xsl:text>
        <xsl:text>"cancel":"</xsl:text><xsl:value-of select="$default-outline-cancel" /><xsl:text>",</xsl:text>
        <xsl:text>"corner":"br"};</xsl:text>
        <xsl:text disable-output-escaping="yes">
          (function () {
            var d = window.__wsuBrandingDefaults, h = document.documentElement, k;
            for (k in d) h.setAttribute('data-wsu-' + k, d[k]);
          }());
        </xsl:text>
      </script>

      <!--
        Production branding CSS. These rules implement the XSLT-transform
        options; each is scoped to a data-wsu-* attribute on <html> so the
        same stylesheet can render any of the combinations. With the sandbox
        removed, the attributes are written once (server side, from the
        parameters above) and never change.
      -->
      <style type="text/css">
        <xsl:text disable-output-escaping="yes">
/* --- required fields ------------------------------------------------- */
html[data-wsu-req="hint"] .wsu-required-star { display: none; }
html[data-wsu-req="hint"] .wsu-required-note { display: none; }
html[data-wsu-req="both"] .wsu-required-hint { display: none; }
html[data-wsu-req="star"] .wsu-required-hint,
html[data-wsu-req="star"] .wsu-required-note { display: none; }
html[data-wsu-req="note"] .wsu-required-hint,
html[data-wsu-req="note"] .wsu-required-star { display: none; }
html[data-wsu-req="off"] .wsu-required-hint,
html[data-wsu-req="off"] .wsu-required-star,
html[data-wsu-req="off"] .wsu-required-note { display: none; }

.wsu-required-star { color: #a60f2d; font-weight: 600; margin-left: .15em; }
.wsu-required-hint { display: block; font-size: .8rem; color: #4d4d4d; margin-top: .3em; }
.wsu-required-note { margin-bottom: 2.25rem; }
/* The design system pulls .wsu-note up 14px, which assumes a preceding
   element with a matching bottom margin. This note is emitted directly above
   the first form question, so whatever Slate puts before it collides. */
.wsu-required-note { margin-top: 0; }

/* --- system header ---------------------------------------------------- */
/*
  Nothing to override. The tall header's crimson box holds two official
  assets and the vendor's own breakpoints swap between them: the plain cougar
  above 1650px (with the horizontal wordmark in __wordmark) and the official
  stacked lockup — cougar and wordmark in one SVG, with the brand's clear
  space baked into its 400x400 viewBox — from 1650px down. Both live in the
  sprite at the foot of the page, and the vendor sizes them (90px, 130px,
  100px, 50px by breakpoint), so we set no widths or padding of our own.

  Still missing: the horizontal 275px SVG wordmark the __wordmark slot expects
  above 1650px. Until we have that file, the slot carries the unit name in the
  shipped wsu-logo-lockup treatment. The vendor hides that slot between 993px
  and 1650px because a 275px SVG stops fitting; our text does fit, so keep it
  visible — with no mid-word breaking. Delete both rules when the real SVG
  lands.
*/
.wsu-header-system__wordmark { display: flex; }
.wsu-header-system__wordmark .wsu-logo-lockup__title { overflow-wrap: normal; }

/*
  Two rows in the top bar, as wsu.edu has: the utility bar (Quick Links +
  CTA, absolutely positioned top-right by the vendor) and the shipped
  wsu-menu-audience row beneath it. The vendor sizes __top-bar for one row
  only (56px fixed), so release the height and clear the absolute bar with
  its own 56px. Below 1400px the vendor's column-reverse stacks the two
  rows; below 1260px it hides the utility bar, exactly as wsu.edu does — at
  that width prod hands both to the mobile menu panel, which needs the
  design system's own script.
*/
.wsu-header-system__top-bar { height: auto; max-height: none; flex-direction: column; align-items: flex-end; }
.wsu-header-system__top-bar .wsu-menu-audience { margin-top: 56px; }
/* The vendor hides the utility bar at 1260px and hands everything to the
   mobile menu. The audience row belongs to the same step — without this it
   lingers after the nav has dropped below the cougar, an intermediate state
   wsu.edu does not have. */
@media screen and (max-width: 1260px) {
  .wsu-header-system__top-bar { display: none; }
}

/* --- Slate's own modal host ------------------------------------------- */
/* dialog_host carries inline left/top but takes its position from Slate's
   stylesheet. Under the design system reset it falls back to static, so the
   hidden ~500px dialog sits in normal flow and reserves a blank block in the
   middle of the form (visibility:hidden still occupies space). Restoring
   absolute positioning collapses it and leaves the modal working. */
.dialog_host { position: absolute; }
.progress_box { position: relative; }

/* --- link size ------------------------------------------------------- */
/* The 2.x bundle sets wsu-content paragraphs to 1.125rem, so links in body
   copy are already 18px. These options step off that baseline; the old
   design system's forced 14px is gone. */
html[data-wsu-linksize="large"] .wsu-content a:not(.wsu-button) { font-size: 1.25rem; line-height: 1.4; }
html[data-wsu-linksize="small"] .wsu-content a:not(.wsu-button) { font-size: 1rem; line-height: 1.5; }

/* --- crimson links --------------------------------------------------- */
html[data-wsu-links="0"] .wsu-content a:not(.wsu-button) { color: #0b6ec0; }

/* --- form card ------------------------------------------------------- */
html[data-wsu-card="0"] #wsu-slate-form-card {
  padding: 0; background: transparent; box-shadow: none; border: 0;
}

/* --- marked headings ------------------------------------------------- */
html[data-wsu-h2="0"] .form_h2 .wsu-heading--style-marked::after,
html[data-wsu-h2="0"] h2.wsu-heading--style-marked::after { display: none; }

/* --- layout tables --------------------------------------------------- */
html[data-wsu-striptables="1"] table[role="presentation"],
html[data-wsu-striptables="1"] table.form_layout {
  width: 100%; border: 0; background: transparent;
  border-collapse: separate; border-spacing: 0; margin-bottom: 2.25rem;
}
html[data-wsu-striptables="1"] table[role="presentation"] > tbody > tr > td,
html[data-wsu-striptables="1"] table.form_layout > tbody > tr > td {
  border: 0; background: transparent;
  padding: 0 1.75rem .875rem 0; vertical-align: bottom;
}

/* --- Month / Day / Year sublabels ------------------------------------ */
.wsu-subfield { display: inline-flex; flex-direction: column; }
.wsu-subfield__label { font-size: .8rem; font-weight: 600; color: #4d4d4d; margin-bottom: .2em; }
html[data-wsu-sublabels="0"] .wsu-subfield__label {
  position: absolute; width: 1px; height: 1px; overflow: hidden;
  clip: rect(0 0 0 0); clip-path: inset(50%); white-space: nowrap;
}

/* --- header variants -------------------------------------------------- */
html[data-wsu-bar="crumb"]  .wsu-sandbox-bar-full,
html[data-wsu-bar="crumb"]  .wsu-sandbox-bar-system,
html[data-wsu-bar="full"]   .wsu-sandbox-bar-crumb,
html[data-wsu-bar="full"]   .wsu-sandbox-bar-system,
html[data-wsu-bar="system"] .wsu-sandbox-bar-crumb,
html[data-wsu-bar="system"] .wsu-sandbox-bar-full,
html[data-wsu-bar="off"]    .wsu-sandbox-bar-crumb,
html[data-wsu-bar="off"]    .wsu-sandbox-bar-full,
html[data-wsu-bar="off"]    .wsu-sandbox-bar-system { display: none; }

html[data-wsu-dept="off"]  .wsu-sandbox-dept { display: none; }
html[data-wsu-site="off"]  .wsu-sandbox-site { display: none; }
html[data-wsu-subtitle="0"] .wsu-logo-lockup__subtitle { display: none; }

/* Navless. The --navless modifier only zeroes the bar's right padding; the
   design system expects the navigation block simply not to be rendered.
   In production, drop the block from the markup instead of hiding it. */
html[data-wsu-gnavless="1"] .wsu-sandbox-bar-full .wsu-header-global__navigation { display: none; }
html[data-wsu-util="0"] .wsu-sandbox-utility { display: none !important; }
        </xsl:text>
      </style>

      <!-- SANDBOX:BEGIN B — overlay styles + logic (delete to ship) -->
      <xsl:if test="$sandbox = '1'">
        <style type="text/css">
          <xsl:text disable-output-escaping="yes">
#wsu-sandbox-panel {
  position: fixed; z-index: 9999; width: 326px; right: 20px; bottom: 20px;
  font-family: Montserrat, Helvetica, sans-serif; color: #f2f2f2;
  background: rgba(20,20,22,.95); border: 1px solid rgba(255,255,255,.14);
  border-radius: 6px; box-shadow: 0 0 17px rgba(0,0,0,.5); overflow: hidden;
}
#wsu-sandbox-panel[data-corner="tl"] { top: 20px; left: 20px; right: auto; bottom: auto; }
#wsu-sandbox-panel[data-corner="tr"] { top: 20px; right: 20px; left: auto; bottom: auto; }
#wsu-sandbox-panel[data-corner="bl"] { bottom: 20px; left: 20px; right: auto; top: auto; }
#wsu-sandbox-panel[data-corner="br"] { bottom: 20px; right: 20px; left: auto; top: auto; }
#wsu-sandbox-panel[data-dragging="1"] { transition: none; }
#wsu-sandbox-grip {
  display: flex; align-items: center; gap: .5rem; padding: 9px 10px;
  background: rgba(255,255,255,.06); cursor: grab; user-select: none;
}
#wsu-sandbox-grip span.t {
  flex: 1; font-size: 11px; font-weight: 600; letter-spacing: .09em; text-transform: uppercase;
}
#wsu-sandbox-grip button {
  background: none; border: 0; color: #f2f2f2; font-size: 12px; line-height: 1;
  cursor: pointer; padding: 4px 6px; border-radius: 3px;
}
#wsu-sandbox-grip button:hover { background: rgba(255,255,255,.12); }
#wsu-sandbox-body { padding: 12px 12px 14px; max-height: 70vh; overflow-y: auto; }
#wsu-sandbox-panel[data-collapsed="1"] #wsu-sandbox-body { display: none; }
.wsu-sb-sect {
  display: flex; align-items: baseline; gap: 6px; margin-top: 4px;
  padding-bottom: 6px; border-bottom: 1px solid rgba(255,255,255,.12);
}
.wsu-sb-sect b {
  font-size: 10px; font-weight: 700; letter-spacing: .1em; text-transform: uppercase;
}
.wsu-sb-sect .cfg { color: #8fd0ff; }
.wsu-sb-sect .xsl { color: #ff8ba3; }
.wsu-sb-sect i { font-style: normal; font-size: 9.5px; color: rgba(242,242,242,.4); }
.wsu-sb-fields { display: grid; gap: 9px; padding: 10px 0 16px; }
.wsu-sb-fields label { display: block; }
.wsu-sb-fields label > span {
  display: block; font-size: 10px; letter-spacing: .06em; text-transform: uppercase;
  color: rgba(242,242,242,.5); margin-bottom: 3px;
}
.wsu-sb-fields select {
  width: 100%; font: inherit; font-size: 11.5px; padding: 6px 7px; border-radius: 3px;
  border: 1px solid rgba(255,255,255,.2); background: rgba(0,0,0,.35);
  color: #f2f2f2; cursor: pointer;
}
.wsu-sb-fields em {
  display: block; font-style: normal; font-size: 9.5px;
  font-family: ui-monospace, monospace; color: rgba(242,242,242,.35); margin-top: 3px;
}
.wsu-sb-note { font-size: 10px; line-height: 1.5; color: rgba(242,242,242,.5); margin: 0; }
.wsu-sb-warn {
  font-size: 10px; line-height: 1.5; color: #ffc4d1; margin: 0; padding: 6px 8px;
  border-left: 2px solid #ca1237; background: rgba(202,18,55,.14);
}
.wsu-sb-hidden { display: none !important; }

/*
  Sandbox only: every header variant stays in the DOM so the overlay can swap
  between them, which means the vendor's
  ".wsu-header-global ~ header .wsu-header-utility-bar { top: -35px }" fires
  even when the crumb bar is hidden — pushing the utility bar up out of view.
  Restore it unless the crumb bar is actually showing. In production only one
  variant is rendered, so this rule goes with the rest of the sandbox.
*/
html:not([data-wsu-bar="crumb"]) .wsu-header-utility-bar { top: 0; }
#wsu-sandbox-foot { margin-top: 4px; padding-top: 10px; border-top: 1px solid rgba(255,255,255,.12); }
#wsu-sandbox-foot .row { display: flex; gap: 6px; align-items: center; }
#wsu-sandbox-qs {
  flex: 1; min-width: 0; font-family: ui-monospace, monospace; font-size: 10px;
  padding: 5px 6px; border-radius: 3px; border: 1px solid rgba(255,255,255,.18);
  background: rgba(0,0,0,.35); color: #f2f2f2;
}
#wsu-sandbox-reset {
  background: none; border: 1px solid rgba(255,255,255,.22); color: #f2f2f2;
  font-size: 10px; letter-spacing: .06em; text-transform: uppercase;
  padding: 5px 9px; border-radius: 3px; cursor: pointer;
}
#wsu-sandbox-reset:hover { border-color: #ca1237; color: #fff; }
#wsu-sandbox-dock { display: grid; grid-template-columns: repeat(2, 16px); gap: 3px; }
#wsu-sandbox-dock button {
  width: 16px; height: 16px; padding: 0; cursor: pointer; border-radius: 2px;
  border: 1px solid rgba(255,255,255,.22); background: rgba(255,255,255,.06);
}
#wsu-sandbox-dock button[aria-pressed="true"] { border-color: #ca1237; background: #ca1237; }
@media print { #wsu-sandbox-panel { display: none; } }
          </xsl:text>
        </style>
      </xsl:if>
      <!-- SANDBOX:END B -->
    </head>
  </xsl:template>

  <!-- ==========================================================
       Body — headers, then Slate's content
       ========================================================== -->

  <xsl:template match="xhtml:body">
    <body>
      <xsl:apply-templates select="@*" />

      <div class="wsu-wrapper-global">

        <!-- SANDBOX:BEGIN D — all header variants rendered, CSS shows one.
             To ship: keep only the variant named in $default-global-header
             (and $default-dept-header / $default-site-header), delete the
             other blocks and their wsu-sandbox-* classes. -->

        <!-- Crumb bar: 35px charcoal strip, crimson underline. -->
        <header class="wsu-header-global wsu-header-global--style-system wsu-sandbox-bar-crumb" aria-label="Washington State University system">
          <ul class="wsu-header-global__menu">
            <li><a href="https://wsu.edu">Washington State University</a></li>
            <li><a href="https://pullman.wsu.edu">Pullman</a></li>
          </ul>
        </header>

        <!-- Full bar: 64px wordmark bar. ==dark / ==navless apply here only. -->
        <header aria-label="Washington State University">
          <xsl:attribute name="class">
            <xsl:text>wsu-header-global wsu-sandbox-bar-full</xsl:text>
            <xsl:if test="$default-global-dark = '1'"> wsu-header-global--dark</xsl:if>
            <xsl:if test="$default-global-navless = '1'"> wsu-header-global--navless</xsl:if>
          </xsl:attribute>
          <div class="wsu-header-global__content">
            <a href="https://wsu.edu" class="wsu-wordmark">
              <span class="wsu-coug-head-boxed">
                <svg class="wsu-coug-head-boxed__icon" role="img" aria-label="WSU Cougar Head"><use href="#wsu-coug" /></svg>
              </span>
              <span class="wsu-wordmark__title">Washington State University</span>
            </a>
            <div class="wsu-header-global__navigation">
              <ul class="wsu-menu-tertiary wsu-header-global__menu-items">
                <li><a href="https://wsu.edu">wsu.edu</a></li>
                <li><a href="https://portal.wsu.edu">MyWSU</a></li>
              </ul>
            </div>
          </div>
        </header>

        <!-- System header: tall grid, 400px logo column, 190px crimson box.
             Carries the identity itself — pair with dept header off. -->
        <header class="wsu-header-system wsu-sandbox-bar-system" aria-label="Washington State University">
          <div class="wsu-header-system__logo">
            <span class="wsu-header-system__coug-head-box">
              <svg class="wsu-coug-head wsu-coug-head--white" role="img" aria-label="WSU Cougar Head" viewBox="0 0 70.2 69.6"><use href="#wsu-coug" /></svg>
              <div class="wsu-header-system__coug-head-stacked">
                <svg viewBox="0 0 400 400" width="100" role="img" aria-label="Washington State University"><use href="#wsu-wordmark-stacked" /></svg>
              </div>
            </span>
            <span class="wsu-header-system__coug-head-stacked-unused" hidden="hidden"></span>

            <span class="wsu-header-system__wordmark">
              <a class="wsu-logo-lockup wsu-logo-lockup--style-unit" href="https://wsu.edu">
                <span class="wsu-logo-lockup__title-wrapper">
                  <span class="wsu-logo-lockup__title"><xsl:value-of select="$unit-name" /></span>
                </span>
              </a>
            </span>
          </div>
          <div class="wsu-header-system__mobile-wrapper">
            <button class="wsu-button-menu" type="button" aria-label="Open menu">Menu</button>
          </div>
          <div class="wsu-header-system__top-bar">
            <div class="wsu-header-utility-bar">
              <button class="wsu-header-utility-bar__quicklinks" type="button">Quick Links</button>
              <a class="wsu-header-utility-bar__cta" href="#">Apply Now</a>
            </div>
            <nav class="wsu-menu-audience" aria-label="Audience menu">
              <a class="wsu-menu-audience__link" href="https://wsu.edu/campuses/">Visit WSU</a>
              <a class="wsu-menu-audience__link" href="https://wsu.edu/request-info/">Request Info</a>
              <a class="wsu-menu-audience__link" href="https://wsu.edu/admissions/#apply">Apply</a>
            </nav>
          </div>
          <div class="wsu-header-system__nav">
            <ul class="wsu-menu wsu-menu--style-header-system">
              <xsl:if test="$nav-1-label != ''">
                <li class="wsu-menu-item wsu-menu-item--current"><a href="{$nav-1-href}"><xsl:value-of select="$nav-1-label" /></a></li>
              </xsl:if>
              <xsl:if test="$nav-2-label != ''">
                <li class="wsu-menu-item"><a href="{$nav-2-href}"><xsl:value-of select="$nav-2-label" /></a></li>
              </xsl:if>
              <xsl:if test="$nav-3-label != ''">
                <li class="wsu-menu-item"><a href="{$nav-3-href}"><xsl:value-of select="$nav-3-label" /></a></li>
              </xsl:if>
            </ul>
          </div>
        </header>
        <!-- SANDBOX:END D -->

        <!-- Department header. Production keeps this block. -->
        <header class="wsu-sandbox-dept" aria-label="Washington State University {$unit-name}">
          <xsl:attribute name="class">
            <xsl:text>wsu-header-unit wsu-sandbox-dept</xsl:text>
            <xsl:if test="$default-dept-dark = '1'"> wsu-color-scheme--dark</xsl:if>
          </xsl:attribute>
          <div class="wsu-header-unit__banner">
            <a href="https://wsu.edu">
              <xsl:attribute name="class">
                <xsl:text>wsu-logo-lockup </xsl:text>
                <xsl:choose>
                  <xsl:when test="$default-dept-header = 'campus'">wsu-logo-lockup--style-campus</xsl:when>
                  <xsl:otherwise>wsu-logo-lockup--style-unit</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <span class="wsu-logo-lockup__icon-wrapper">
                <svg role="img" aria-label="WSU Cougar Head" viewBox="0 0 70.2 69.6">
                  <xsl:attribute name="class">
                    <xsl:text>wsu-coug-head</xsl:text>
                    <xsl:choose>
                      <xsl:when test="$default-coug = 'light'"> wsu-coug-head--crimson-light</xsl:when>
                      <xsl:when test="$default-coug = 'white'"> wsu-coug-head--white</xsl:when>
                      <xsl:when test="$default-coug = 'boxed'"> wsu-coug-head--boxed-crimson</xsl:when>
                    </xsl:choose>
                  </xsl:attribute>
                  <use href="#wsu-coug" />
                </svg>
              </span>
              <span class="wsu-logo-lockup__title-wrapper">
                <span class="wsu-logo-lockup__subtitle">Washington State University</span>
                <span class="wsu-logo-lockup__title"><xsl:value-of select="$unit-name" /></span>
              </span>
            </a>
            <div class="wsu-header-utility-bar wsu-sandbox-utility">
              <button class="wsu-header-utility-bar__quicklinks" type="button">Quick Links</button>
              <a class="wsu-header-utility-bar__cta" href="#">Apply Now</a>
            </div>
          </div>
        </header>

        <!-- Site header. -->
        <header class="wsu-sandbox-site">
          <xsl:attribute name="class">
            <xsl:text>wsu-header-site wsu-sandbox-site</xsl:text>
            <xsl:choose>
              <xsl:when test="$default-site-header = 'dark'"> wsu-header-site--dark</xsl:when>
              <xsl:when test="$default-site-header = 'nested'"> wsu-header-site--nested</xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <div class="wsu-header-site__label">
            <span class="wsu-header-site__subtitle">Washington State University</span>
            <span class="wsu-header-site__title"><xsl:value-of select="$unit-name" /></span>
          </div>
        </header>

        <div class="wsu-wrapper-site">
          <div class="wsu-wrapper-content">
            <main role="main" id="wsu-content-main" class="wsu-wrapper-main wsu-content wsu-container">
              <article class="wsu-article">
                <xsl:apply-templates select="node()" />
              </article>
            </main>
          </div>
        </div>

        <footer class="wsu-footer-global">
          <div class="wsu-footer-global__copyright">&#169; Washington State University</div>
          <nav class="wsu-footer-global__navigation" aria-label="WSU footer menu">
            <ul class="wsu-menu-tertiary">
              <li><a href="https://access.wsu.edu/">Access</a></li>
              <li><a href="https://policies.wsu.edu/">Policies</a></li>
              <li><a href="https://portal.wsu.edu/">MyWSU</a></li>
              <li><a href="https://socialmedia.wsu.edu/">Follow WSU</a></li>
            </ul>
          </nav>
        </footer>
      </div>

      <!-- The cougar head is one sprite, referenced by every header above. -->
      <svg width="0" height="0" style="position:absolute;overflow:hidden" aria-hidden="true" focusable="false">
        <symbol id="wsu-coug" viewBox="0 0 70.2 69.6">
          <path d="m42.8 69.6s3.6-1.5 5.5-7.4c1 2.3 1.5 4.8 1.3 7.3-2.3 0.1-4.5 0.2-6.8 0.1zm14.9-11.8c-10.4 1.4-12.2-20.3-12.2-20.3s3.5 11.1 10.9 10.7c7.7-0.4 5.5-12.2 5.5-12.2s7.5 20.2-4.2 21.8zm-47.7-5c-3.3 1-6.6 1.8-10 2.4 0 0 5.9-4.5 10.3-18.3l4.3 3.9-0.8 2.6c1.1 1.5 1.9 3.1 2.5 4.9 1.6-3.6 1.5-7.7-0.3-11.2l-0.5 1.6-1.7-1.5-2.8-2.7c1.2-3.6 3-7 5.3-10.1l0.4 0.4 3.3 3.8-1 1.7c1.5 1.7 2.9 3.4 4.2 5.3 0.6-3.4 0.4-6.8-0.4-10.1l-1.5 1.4-3.6-4.2c4.5-4.7 10-8.2 16.2-10.3-0.4 0.4-0.7 0.8-1 1.3-2 2.9-4.1 8.1-2.4 16.4 0.3 1.3 0.7 3.2 1.1 5.1 0.9 3.8 1.9 8.2 2.2 10.9 0.7 5.7 0.1 9.4-1.8 11.4-1.3 1.4-3.5 2-6.4 1.9v-1.4c0-2.4-0.3-4.8-0.8-7.2l-0.8-2.7-1.2 2.6c-1.9 4.1-8.6 14.1-17.2 16.1 2.6-4.2 4.1-9 4.4-14zm25.4 16.4h-0.5-0.1-0.3c-0.5 0-0.8-0.1-1.2-0.1-0.7-0.1-1.6-0.2-2.6-0.4-6.4-1.1-12.9-1.7-19.4-2 6.2-3.6 10.4-9.9 12-12.5 0.2 1.3 0.3 2.5 0.3 3.8 0 0.8 0 1.6-0.1 2.2l-0.1 1.1 1.1 0.1c0.7 0.1 1.3 0.1 1.9 0.1 3.3 0 5.7-0.8 7.3-2.5 2.4-2.5 3.1-6.7 2.3-13.1-0.4-2.9-1.4-7.4-2.3-11.1-0.5-2-0.9-3.8-1.1-5-1.5-7.6 0.3-12.3 2.1-14.8 1.3-1.9 3.2-3.4 5.5-4.2h0.1l3.3-10.8h1.1l-2.3 10.3c0.7-0.1 1.2-0.2 1.7-0.3l3-9.5h1.1l-2 9.2c2.9-0.4 6.1-0.7 10.3-1 0.8 0.4 1.4 1.1 1.8 1.9l9.8-3 0.4 1.1-9.5 3.7c0.1 0.2 0.2 0.4 0.2 0.6l10.3-1.3 0.2 1.1-10 2c0 0.2 0.1 0.4 0.1 0.6l10.4 0.3v1.1l-10.2 0.4c0 1.2-0.2 2.4-0.5 3.6 0.6 2.1 0.7 4.3 0.3 6.5-1.7-3.9-3-5.1-3-5.1-1.4-0.7-2.9-1-4.5-1-2.5 0-4.8 1.1-6.4 2.9-2.3 2.6-3.5 6-3.3 9.5 0.2 2.4 0.7 5.1 1.4 8.6 0.7 3.6 1.6 8.1 2.3 13.5 0.6 4.1-0.1 7.3-1.8 9.7-1.6 2.1-4 3.4-6.5 3.8h-0.1-0.2-0.1-2.2zm10.4-51.5c-2.1-0.1-4.2 0.4-6 1.3-1.5 1-2.5 2.7-2.6 4.5-0.1 0.6-0.1 1.2 0 1.8 0.8-1.5 2-2.8 3.3-3.9 2.4-1.5 5.1-2.3 7.9-2.4h0.9 0.3c0.4 0 0.7-0.1 0.8-0.2 0-0.1-0.1-0.3-0.4-0.4-1.3-0.5-2.7-0.8-4.2-0.7z" />
        </symbol>
        <symbol id="wsu-wordmark-stacked" viewBox="0 0 400 400" fill="#ffffff">
          <path d="M55.63,384.31c0,2.67-1.48,4.4-4.28,4.4s-4.3-1.74-4.3-4.4v-10.07h-2.97v10.17c0,4.13,2.39,6.92,7.27,6.92s7.25-2.77,7.25-6.95v-10.14h-2.97v10.07Z" />
          <polygon points="90.26 385.9 81.67 374.25 78.65 374.25 78.65 391.03 81.6 391.03 81.6 379.05 90.36 391.03 93.2 391.03 93.2 374.25 90.26 374.25 90.26 385.9" />
          <rect x="116.76" y="374.25" width="2.94" height="16.79" />
          <polygon points="150.54 387.84 145.45 374.25 142.11 374.25 148.7 391.03 152.37 391.03 158.97 374.25 155.62 374.25 150.54 387.84" />
          <polygon points="179.38 391.03 190.88 391.03 190.88 388.44 182.32 388.44 182.32 383.78 189.56 383.78 189.56 381.19 182.32 381.19 182.32 376.84 190.88 376.84 190.88 374.25 179.38 374.25 179.38 391.03" />
          <path d="M251.21,378.7c0-1.26,1.11-2.09,2.84-2.09s3.55,.6,4.86,1.91l1.69-2.19c-1.56-1.51-3.67-2.34-6.29-2.34-3.67,0-6.11,2.14-6.11,4.91,0,6.19,9.79,4,9.79,7.52,0,1.11-.96,2.29-3.37,2.29s-4.15-1.08-5.31-2.31l-1.64,2.26c1.48,1.59,3.72,2.67,6.82,2.67,4.53,0,6.49-2.39,6.49-5.18,0-6.27-9.76-4.33-9.76-7.45Z" />
          <rect x="285.15" y="374.25" width="2.94" height="16.79" />
          <polygon points="312.37 376.84 317.45 376.84 317.45 391.03 320.4 391.03 320.4 376.84 325.48 376.84 325.48 374.25 312.37 374.25 312.37 376.84" />
          <polygon points="352.4 381.44 347.77 374.25 344.4 374.25 350.91 384.06 350.91 391.03 353.86 391.03 353.86 384.06 360.35 374.25 356.98 374.25 352.4 381.44" />
          <path d="M227.66,391.03l-4.18-6.72c1.82-.5,3.46-2.07,3.46-4.81,0-3.09-2.16-5.26-5.49-5.26h-7.37v16.79h2.94v-6.27h3.52l3.72,6.27h3.4Zm-10.64-8.86v-5.33h4.03c1.66,0,2.87,1.06,2.87,2.67s-1.21,2.67-2.87,2.67h-4.03Z" />
          <path d="M72.77,342.52c0-1.65,1.4-2.76,3.91-2.76,2.8,0,5.76,.95,7.99,3l3.25-4.28c-2.72-2.51-6.34-3.83-10.7-3.83-6.46,0-10.42,3.79-10.42,8.36,0,10.33,15.81,7,15.81,11.86,0,1.56-1.56,3.05-4.78,3.05-3.79,0-6.79-1.69-8.73-3.71l-3.17,4.45c2.55,2.59,6.34,4.36,11.61,4.36,7.41,0,10.99-3.79,10.99-8.81,0-10.25-15.77-7.33-15.77-11.69Z" />
          <polygon points="111.11 345.85 98.14 345.85 98.14 335.06 92.3 335.06 92.3 362.52 98.14 362.52 98.14 351 111.11 351 111.11 362.52 117 362.52 117 335.06 111.11 335.06 111.11 345.85" />
          <rect x="122.29" y="335.06" width="5.85" height="27.46" />
          <polygon points="152.56 352.31 139.84 335.06 133.83 335.06 133.83 362.52 139.67 362.52 139.67 344.61 152.77 362.52 158.41 362.52 158.41 335.06 152.56 335.06 152.56 352.31" />
          <polygon points="190.73 340.21 198.76 340.21 198.76 362.52 204.64 362.52 204.64 340.21 212.63 340.21 212.63 335.06 190.73 335.06 190.73 340.21" />
          <path d="M226.72,334.61c-8.27,0-14.33,5.93-14.33,14.2s6.05,14.2,14.33,14.2,14.37-5.93,14.37-14.2-6.05-14.2-14.37-14.2Zm0,23.22c-5.06,0-8.32-3.91-8.32-9.02s3.25-9.02,8.32-9.02,8.36,3.87,8.36,9.02-3.29,9.02-8.36,9.02Z" />
          <polygon points="268.85 362.52 268.85 335.06 263.01 335.06 263.01 352.31 250.28 335.06 244.27 335.06 244.27 362.52 250.12 362.52 250.12 344.61 263.21 362.52 268.85 362.52" />
          <path d="M296.21,342.52c0-1.65,1.4-2.76,3.91-2.76,2.8,0,5.76,.95,7.99,3l3.25-4.28c-2.72-2.51-6.34-3.83-10.7-3.83-6.46,0-10.42,3.79-10.42,8.36,0,10.33,15.81,7,15.81,11.86,0,1.56-1.56,3.05-4.78,3.05-3.79,0-6.79-1.69-8.73-3.71l-3.17,4.45c2.55,2.59,6.34,4.36,11.61,4.36,7.41,0,10.99-3.79,10.99-8.81,0-10.25-15.77-7.33-15.77-11.69Z" />
          <polygon points="335.09 335.06 313.19 335.06 313.19 340.21 321.22 340.21 321.22 362.52 327.1 362.52 327.1 340.21 335.09 340.21 335.09 335.06" />
          <polygon points="368.93 362.52 368.93 340.21 376.91 340.21 376.91 335.06 355.01 335.06 355.01 340.21 363.04 340.21 363.04 362.52 368.93 362.52" />
          <polygon points="398.9 340.21 398.9 335.06 379.47 335.06 379.47 362.52 398.9 362.52 398.9 357.38 385.31 357.38 385.31 351.16 397.46 351.16 397.46 346.01 385.31 346.01 385.31 340.21 398.9 340.21" />
          <path d="M55.73,335.1h-7.01l-9.78,27.46h6.61l1.94-5.68h9.46l1.9,5.68h6.62l-9.75-27.46Zm-6.61,16.18l3.1-9.29,3.1,9.29h-6.2Z" />
          <path d="M348.55,335.11h-7.01l-9.78,27.46h6.61l1.94-5.68h9.46l1.9,5.68h6.62l-9.75-27.46Zm-6.61,16.18l3.1-9.29,3.1,9.29h-6.2Z" />
          <path d="M190.73,346.19h-13.74v5.12h7.67c-.9,3.83-3.87,6.52-8.07,6.52-5.06,0-8.32-3.91-8.32-9.02s3.25-9.02,8.32-9.02c3,0,5.36,1.36,6.81,3.53l5.11-2.77c-2.52-3.68-6.78-5.95-11.92-5.95-8.27,0-14.33,5.93-14.33,14.2s6.05,14.2,14.33,14.2c7.45,0,13.07-4.77,14.16-11.71,.13-.81,.21-1.63,.21-2.49,0-.91-.08-1.78-.23-2.63Z" />
          <polygon points="36.61 335.1 30.22 353.04 24.46 335.1 19.49 335.1 13.71 353.06 7.37 335.29 7.31 335.1 1.1 335.1 10.88 362.56 16.88 362.56 21.96 346.7 27.07 362.56 33.04 362.56 42.84 335.1 36.61 335.1" />
          <path d="M243.89,266.15s13.08-5.58,20.25-27.21c6.32,13.18,4.67,26.73,4.67,26.73-5.79,1.3-24.91,.48-24.91,.48" />
          <path d="M314.14,142.48s7.98,43.47-20.28,44.95c-27.26,1.42-40.1-39.58-40.1-39.58,0,0,6.59,80.11,44.81,74.84,43.03-5.93,15.57-80.21,15.57-80.21" />
          <path d="M106.58,255.81s.04-.01,.04-.01c31.86-7.26,56.28-44.44,63.44-59.36l4.56-9.45,2.74,10.12c.13,.55,3.1,11.71,3.1,26.44,0,1.64-.04,3.31-.13,5,10.99,.42,18.84-1.81,23.72-6.88,7-7.23,9.1-20.95,6.5-41.9-1.29-10.03-4.99-25.98-8.28-40.07-1.68-7.2-3.27-14.01-4.23-18.83-6.14-30.79,1.49-49.91,8.96-60.52,1.19-1.67,2.47-3.26,3.82-4.74-22.06,7.41-40.55,18.95-59.63,38l13.42,15.56,5.49-5.14c5.2,19.33,1.46,37.13,1.46,37.13-7.06-10.75-15.38-19.47-15.38-19.47l3.64-6.12-12.1-14.05-1.4-1.57c-14.87,20.42-19.68,37.13-19.68,37.13l10.54,9.66,6.14,5.56,2.07-5.92c11.35,21.23,.98,41.07,.98,41.07-1.86-7.23-9.33-17.93-9.33-17.93l2.95-9.74-15.7-14.2c-16.32,50.99-38.13,67.52-38.13,67.52,0,0,23.59-4.25,36.74-8.66,0,0-.36,26.88-16.32,51.39" />
          <path d="M344.79,71.83l-37.7,1.6c.02,4.44-.57,8.94-2.01,13.19,3.52,15.38,1.07,23.73,1.07,23.73-6.3-14.67-11.1-18.75-11.1-18.75-34.63-15.37-54.08,19.39-51.99,41.83,1.69,18.43,8.39,42.9,13.6,81.28,4.39,32.3-11.96,46.26-30.78,49.46-.4,.05-.82,.13-1.23,.22-.11,0-.2,0-.3,.02-3.06,.39-6.29,.56-9.71,.48-.11-.03-.25-.03-.36-.03-.38,0-.74-.05-1.13-.05-1.46-.09-2.91-.24-4.34-.42-14.64-2.02-47.42-7.98-81.28-8.8,19.92-11.63,35.5-31.76,44.2-46.02,.5,3.96,.91,8.77,.91,14.08,0,2.64-.09,5.43-.36,8.27l-.33,3.89,3.9,.33c15.58,1.35,26.63-1.62,33.85-9.06,8.83-9.2,11.55-24.53,8.56-48.31-1.29-10.42-5.08-26.6-8.39-40.85-1.65-7.14-3.21-13.91-4.16-18.59-5.61-28.09,1.09-45.15,7.7-54.5,5.15-7.32,12.28-12.7,20.1-15.28,.13-.02,.26-.05,.4-.08l12.87-39.49h4.04l-8.64,37.95c2-.35,4.03-.67,6.09-.98l11.11-34.99h4l-7.28,33.88c11.51-1.48,23.98-2.62,37.82-3.64,2.24,.9,4.67,3.49,6.8,7.09l36.28-11.16,1.34,3.91-34.68,13.45c.27,.71,.55,1.45,.76,2.21l37.92-4.71,.63,4.06-36.79,7.34c.13,.69,.24,1.38,.36,2.07l38.27,1.23-.02,4.11Zm-109.22,16.95c7.6-5.33,20.54-9.43,32.68-8.5,3.07,.23,5.67-.58,2.36-2.33-9.08-4.79-30.24-3.16-37.73,1.94-11.99,8.17-9.95,22.74-9.68,23.09,2.39-4.17,6.45-10.06,12.37-14.2" />
        </symbol>
      </svg>

      <!-- SANDBOX:BEGIN C — overlay markup + logic (delete to ship) -->
      <xsl:if test="$sandbox = '1'">
        <div id="wsu-sandbox-panel" data-corner="br" role="dialog" aria-label="Branding settings">
          <div id="wsu-sandbox-grip">
            <span class="t">Branding settings</span>
            <button type="button" id="wsu-sandbox-collapse" aria-label="Collapse settings">&#8211;</button>
          </div>
          <div id="wsu-sandbox-body">
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:14px">
              <span style="flex:1;font-size:10px;letter-spacing:.08em;text-transform:uppercase;color:rgba(242,242,242,.55)">Dock</span>
              <div id="wsu-sandbox-dock">
                <button type="button" data-corner="tl" aria-label="Dock top left"></button>
                <button type="button" data-corner="tr" aria-label="Dock top right"></button>
                <button type="button" data-corner="bl" aria-label="Dock bottom left"></button>
                <button type="button" data-corner="br" aria-label="Dock bottom right"></button>
              </div>
            </div>

            <div class="wsu-sb-sect"><b class="cfg">Configuration</b><i>official classes &#8212; pick one</i></div>
            <div class="wsu-sb-fields">
              <label>
                <span>Global header</span>
                <select data-key="bar">
                  <option value="crumb">Crumb bar &#8212; 35px system strip</option>
                  <option value="full">Full bar &#8212; 64px wordmark bar</option>
                  <option value="system">System header &#8212; tall grid</option>
                  <option value="off">Off</option>
                </select>
                <em>wsu-header-global / wsu-header-system</em>
              </label>
              <label data-when="bar=full">
                <span>Full bar treatment</span>
                <select data-key="gdark">
                  <option value="0">Light &#8212; gray-0, crimson top rule</option>
                  <option value="1">Dark &#8212; #333</option>
                </select>
                <em>wsu-header-global--dark</em>
              </label>
              <label data-when="bar=full">
                <span>Full bar navigation</span>
                <select data-key="gnavless">
                  <option value="0">With quick links</option>
                  <option value="1">Navless</option>
                </select>
                <em>wsu-header-global--navless</em>
              </label>
              <label>
                <span>Department header</span>
                <select data-key="dept">
                  <option value="off">Off</option>
                  <option value="unit">Unit lockup</option>
                  <option value="campus">Campus lockup &#8212; boxed, uppercase</option>
                </select>
                <em>wsu-header-unit + wsu-logo-lockup--style-*</em>
              </label>
              <label data-when="dept=unit,campus">
                <span>Department banner</span>
                <select data-key="deptdark">
                  <option value="0">Light &#8212; white</option>
                  <option value="1">Dark &#8212; gray-85, white lockup</option>
                </select>
                <em>wsu-color-scheme--dark</em>
              </label>
              <label data-when="dept=unit,campus">
                <span>Cougar head</span>
                <select data-key="coug">
                  <option value="crimson">Crimson &#8212; #a60f2d</option>
                  <option value="light">Crimson light &#8212; #ca1237</option>
                  <option value="white">White</option>
                  <option value="boxed">Boxed crimson &#8212; white on crimson</option>
                </select>
                <em>wsu-coug-head--*</em>
              </label>
              <label data-when="dept=unit,campus">
                <span>Lockup subtitle</span>
                <select data-key="subtitle">
                  <option value="0">Hidden</option>
                  <option value="1">Shown &#8212; Washington State University</option>
                </select>
                <em>wsu-logo-lockup__subtitle</em>
              </label>
              <label data-when="dept=unit,campus;bar=crumb,full,off">
                <span>Utility bar</span>
                <select data-key="util">
                  <option value="0">Off</option>
                  <option value="1">Quick links + Apply CTA</option>
                </select>
                <em>wsu-header-utility-bar + __cta — hidden below 1260px</em>
              </label>
              <label>
                <span>Site header</span>
                <select data-key="site">
                  <option value="off">Off</option>
                  <option value="light">Light</option>
                  <option value="dark">Dark</option>
                  <option value="nested">Nested &#8212; smaller title</option>
                </select>
                <em>wsu-header-site--*</em>
              </label>
              <p class="wsu-sb-note" id="wsu-sandbox-barnote"></p>
              <p class="wsu-sb-warn wsu-sb-hidden" id="wsu-sandbox-warn">The system header already carries the wordmark and cougar. Two identity blocks stacked &#8212; turn the department header off.</p>
            </div>

            <div class="wsu-sb-sect"><b class="xsl">XSLT transforms</b><i>markup we generate or rewrite</i></div>
            <div class="wsu-sb-fields">
              <label>
                <span>Required-field treatment</span>
                <select data-key="req">
                  <option value="hint">Per-field hint sentence</option>
                  <option value="both">Top note + red asterisks</option>
                  <option value="star">Red asterisks only</option>
                  <option value="note">Top note only</option>
                  <option value="off">Off &#8212; Slate default</option>
                </select>
                <em>div.form_question[@data-required='1']</em>
              </label>
              <p class="wsu-sb-note" id="wsu-sandbox-reqnote"></p>
              <label>
                <span>Content link size</span>
                <select data-key="linksize">
                  <option value="default">Inherit paragraph &#8212; already 18px</option>
                  <option value="large">Step up &#8212; 20px</option>
                  <option value="small">Step down &#8212; 16px</option>
                </select>
                <em>match="xhtml:a" &#8594; size override</em>
              </label>
              <p class="wsu-sb-note" id="wsu-sandbox-linknote"></p>
              <label>
                <span>Form card background</span>
                <select data-key="card">
                  <option value="1">On &#8212; wsu-callout</option>
                  <option value="0">Off &#8212; plain page</option>
                </select>
                <em>match="xhtml:form" &#8594; wsu-callout</em>
              </label>
              <label>
                <span>Section headings</span>
                <select data-key="h2">
                  <option value="1">Marked &#8212; crimson rule</option>
                  <option value="0">Plain</option>
                </select>
                <em>form_h2 &#8594; wsu-heading--style-marked</em>
              </label>
              <label>
                <span>Slate layout tables</span>
                <select data-key="striptables">
                  <option value="1">Strip chrome</option>
                  <option value="0">Leave as Slate emits</option>
                </select>
                <em>table[role="presentation"]</em>
              </label>
              <label>
                <span>Month / Day / Year labels</span>
                <select data-key="sublabels">
                  <option value="1">Visible sublabels</option>
                  <option value="0">Screen-reader only</option>
                </select>
                <em>select[@aria-label] &#8594; wsu-subfield</em>
              </label>
              <label>
                <span>Content links</span>
                <select data-key="links">
                  <option value="1">Crimson</option>
                  <option value="0">Blue &#8212; browser default family</option>
                </select>
                <em>--fw-link-text override</em>
              </label>
              <label>
                <span>Cancel button</span>
                <select data-key="cancel">
                  <option value="1">Outline</option>
                  <option value="0">Solid crimson</option>
                </select>
                <em>button[.='Cancel'] &#8594; --style-outline</em>
              </label>
            </div>

            <div id="wsu-sandbox-foot">
              <p class="wsu-sb-note" style="margin-bottom:6px">Every setting is in the URL. Copy it, then paste the values into the <code>$default-*</code> parameters at the top of the XSLT to make them permanent.</p>
              <div class="row">
                <input id="wsu-sandbox-qs" readonly="readonly" aria-label="Query string" />
                <button type="button" id="wsu-sandbox-reset">Reset</button>
              </div>
            </div>
          </div>
        </div>

        <script type="text/javascript">
          <xsl:text disable-output-escaping="yes">
/* ------------------------------------------------------------------------
   SANDBOX overlay logic. Self-contained on purpose — no external file, so
   removing the sandbox is a delete of this block and nothing else.

   How it works: each setting is a data-wsu-* attribute on the root html
   element. The
   production CSS above keys off those attributes, so the overlay only ever
   writes attributes; it never touches Slate's markup. Query string wins
   over localStorage, localStorage over the XSLT defaults.
   ------------------------------------------------------------------------ */
(function () {
  var KEY = 'wsu-slate-branding-settings';

  /* Defaults come from the XSLT parameters, injected below. */
  var DEFAULTS = window.__wsuBrandingDefaults;

  var TEXT_KEYS = ['bar', 'dept', 'coug', 'site', 'req', 'linksize'];

  var BAR_NOTES = {
    crumb: '35px charcoal strip, 2px crimson underline. Carries the WSU/campus crumb only, so a department header below it is doing the identity work.',
    full: '64px light bar with a 4px crimson top rule, boxed cougar wordmark and quick links. Dark and navless apply to this one.',
    system: 'The tall grid header: 400px logo column, 190px crimson cougar box, utility bar and nav. It carries the identity itself, so turn the department header off. Needs a wide viewport — below 1024px it hands off to the mobile menu button.',
    off: 'No global header. The department header is then the top of the page.'
  };

  var REQ_NOTES = {
    hint: 'Every required field carries the sentence in words, wired to the control with aria-describedby. Unambiguous, but heavy on a long form.',
    both: 'One note at the top of the form plus a crimson asterisk in each required label. The asterisks are aria-hidden; the note carries the meaning.',
    star: 'Asterisks with nothing explaining them. Shown for comparison — this alone does not meet WCAG 3.3.2.',
    note: 'The note explains the convention, but nothing marks the individual fields.',
    off: 'No WSU treatment. Slate still flags the fields itself with data-required="1".'
  };

  var LINK_NOTES = {
    'default': 'No transform. The 2.x bundle already sets wsu-content paragraphs to 1.125rem, so links in body copy are 18px — the 14px the old system forced is gone.',
    large: 'Links step up to 1.25rem (20px), one size above the paragraph they sit in.',
    small: 'Links pulled down to 1rem (16px), smaller than the paragraph around them. Shown for comparison.'
  };

  var state = {};
  Object.keys(DEFAULTS).forEach(function (k) { state[k] = DEFAULTS[k]; });

  try {
    var saved = JSON.parse(localStorage.getItem(KEY) || 'null');
    if (saved) Object.keys(saved).forEach(function (k) {
      if (k in DEFAULTS) state[k] = saved[k];
    });
  } catch (e) {}

  try {
    var q = new URLSearchParams(window.location.search);
    Object.keys(DEFAULTS).forEach(function (k) {
      var v = q.get(k);
      if (v !== null) state[k] = v;
    });
  } catch (e) {}

  var panel = document.getElementById('wsu-sandbox-panel');
  var qsField = document.getElementById('wsu-sandbox-qs');

  function queryString() {
    var parts = [];
    Object.keys(DEFAULTS).forEach(function (k) {
      if (state[k] !== DEFAULTS[k]) parts.push(k + '=' + encodeURIComponent(state[k]));
    });
    return parts.length ? '?' + parts.join('&amp;') : '';
  }

  function apply() {
    var html = document.documentElement;
    Object.keys(DEFAULTS).forEach(function (k) {
      html.setAttribute('data-wsu-' + k, state[k]);
    });

    /* Class modifiers the CSS attribute selectors can't express. */
    var full = document.querySelector('.wsu-sandbox-bar-full');
    if (full) {
      full.classList.toggle('wsu-header-global--dark', state.gdark === '1');
      full.classList.toggle('wsu-header-global--navless', state.gnavless === '1');
      /*
        --navless only zeroes the bar's right padding; the design system
        expects the navigation block simply not to be rendered. Inline style
        so nothing in the vendor bundle can outrank it. In production, drop
        the block from the markup instead of hiding it.
      */
      var nav = full.querySelector('.wsu-header-global__navigation');
      if (nav) {
        nav.hidden = state.gnavless === '1';
        nav.style.display = state.gnavless === '1' ? 'none' : '';
      }
    }
    var dept = document.querySelector('.wsu-sandbox-dept');
    if (dept) {
      dept.classList.toggle('wsu-color-scheme--dark', state.deptdark === '1');
      var lockup = dept.querySelector('.wsu-logo-lockup');
      if (lockup) {
        lockup.classList.toggle('wsu-logo-lockup--style-campus', state.dept === 'campus');
        lockup.classList.toggle('wsu-logo-lockup--style-unit', state.dept !== 'campus');
      }
      var coug = dept.querySelector('.wsu-coug-head');
      if (coug) {
        /* className is read-only on SVG elements — must use setAttribute. */
        coug.setAttribute('class', 'wsu-coug-head'
          + (state.coug === 'light' ? ' wsu-coug-head--crimson-light' : '')
          + (state.coug === 'white' ? ' wsu-coug-head--white' : '')
          + (state.coug === 'boxed' ? ' wsu-coug-head--boxed-crimson' : ''));
      }
    }
    var site = document.querySelector('.wsu-sandbox-site');
    if (site) {
      site.classList.toggle('wsu-header-site--dark', state.site === 'dark');
      site.classList.toggle('wsu-header-site--nested', state.site === 'nested');
    }
    var cancel = document.querySelector('.wsu-slate-cancel');
    if (cancel) cancel.classList.toggle('wsu-button--style-outline', state.cancel === '1');

    /*
      Conditional rows. data-when takes AND-ed clauses separated by ';',
      each clause "key=value,value". A row shows only when every clause
      matches, so a setting whose parent is itself hidden stays hidden.
    */
    Array.prototype.forEach.call(panel.querySelectorAll('[data-when]'), function (row) {
      var show = row.getAttribute('data-when').split(';').every(function (clause) {
        var spec = clause.split('=');
        return spec[1].split(',').indexOf(state[spec[0].trim()]) !== -1;
      });
      row.classList.toggle('wsu-sb-hidden', !show);
    });

    document.getElementById('wsu-sandbox-warn').classList.toggle(
      'wsu-sb-hidden', !(state.bar === 'system' &amp;&amp; state.dept !== 'off'));
    document.getElementById('wsu-sandbox-barnote').textContent = BAR_NOTES[state.bar] || '';
    document.getElementById('wsu-sandbox-reqnote').textContent = REQ_NOTES[state.req] || '';
    document.getElementById('wsu-sandbox-linknote').textContent = LINK_NOTES[state.linksize] || '';

    Array.prototype.forEach.call(panel.querySelectorAll('select[data-key]'), function (sel) {
      sel.value = state[sel.getAttribute('data-key')];
    });
    Array.prototype.forEach.call(panel.querySelectorAll('#wsu-sandbox-dock button'), function (b) {
      b.setAttribute('aria-pressed', b.getAttribute('data-corner') === state.corner ? 'true' : 'false');
    });

    var qs = queryString();
    qsField.value = qs || '(all defaults)';
    try {
      localStorage.setItem(KEY, JSON.stringify(state));
      window.history.replaceState(null, '', window.location.pathname + qs + window.location.hash);
    } catch (e) {}
  }

  panel.addEventListener('change', function (e) {
    var key = e.target.getAttribute &amp;&amp; e.target.getAttribute('data-key');
    if (!key) return;
    state[key] = e.target.value;
    apply();
  });

  document.getElementById('wsu-sandbox-collapse').addEventListener('click', function () {
    var next = panel.getAttribute('data-collapsed') === '1' ? '0' : '1';
    panel.setAttribute('data-collapsed', next);
    this.textContent = next === '1' ? '+' : '\u2013';
  });

  document.getElementById('wsu-sandbox-reset').addEventListener('click', function () {
    Object.keys(DEFAULTS).forEach(function (k) { state[k] = DEFAULTS[k]; });
    dock(state.corner);
  });

  function dock(corner) {
    state.corner = corner;
    panel.setAttribute('data-corner', corner);
    panel.style.top = panel.style.left = panel.style.right = panel.style.bottom = '';
    apply();
  }

  Array.prototype.forEach.call(panel.querySelectorAll('#wsu-sandbox-dock button'), function (b) {
    b.addEventListener('click', function () { dock(b.getAttribute('data-corner')); });
  });

  /*
    Drag the title bar; releases snap to the nearest corner. Two guards:
    presses on the collapse button never start a drag, and a press that
    never moves more than 4px is treated as a click, so the panel does not
    re-dock (and visibly bounce) when you just click the bar.
  */
  var grip = document.getElementById('wsu-sandbox-grip'), off = null, moved = false, start = null;
  grip.addEventListener('pointerdown', function (e) {
    if (e.target.closest('button')) return;
    var r = panel.getBoundingClientRect();
    off = { x: e.clientX - r.left, y: e.clientY - r.top };
    start = { x: e.clientX, y: e.clientY };
    moved = false;
    e.preventDefault();
  });
  window.addEventListener('pointermove', function (e) {
    if (!off) return;
    if (!moved) {
      if (Math.abs(e.clientX - start.x) &lt; 4 &amp;&amp; Math.abs(e.clientY - start.y) &lt; 4) return;
      moved = true;
      panel.setAttribute('data-dragging', '1');
      panel.setAttribute('data-corner', '');
      panel.style.right = panel.style.bottom = 'auto';
    }
    panel.style.left = (e.clientX - off.x) + 'px';
    panel.style.top = (e.clientY - off.y) + 'px';
  });
  window.addEventListener('pointerup', function () {
    if (!off) return;
    off = null;
    if (!moved) return;
    panel.removeAttribute('data-dragging');
    var r = panel.getBoundingClientRect();
    dock((r.top + r.height / 2 &lt; window.innerHeight / 2 ? 't' : 'b')
       + (r.left + r.width / 2 &lt; window.innerWidth / 2 ? 'l' : 'r'));
  });

  /*
    Belt and braces for the demo. Slate's markup varies by form and by
    Slate release, so if the XSLT selectors above did not match, decorate
    required questions here instead. Idempotent — it skips anything the
    stylesheet already handled.

    To ship: delete this function. Once we know the real selectors from a
    live form, the XSLT templates alone are correct and this runtime pass
    is dead weight.
  */
  function hydrateRequired() {
    var qs = document.querySelectorAll(
      '.form_question, [data-required], .form_label_required, .required');
    Array.prototype.forEach.call(qs, function (q) {
      var isReq = q.getAttribute('data-required') === '1'
        || /(^|\s)required(\s|$)/.test(q.className)
        || !!q.querySelector('[aria-required="true"], [required]');
      if (!isReq) return;

      var label = q.querySelector('.form_label, label');
      if (label &amp;&amp; !label.querySelector('.wsu-required-star')) {
        var star = document.createElement('span');
        star.className = 'wsu-required-star';
        star.setAttribute('aria-hidden', 'true');
        star.textContent = '*';
        label.appendChild(star);
      }

      if (!q.querySelector('.wsu-required-hint')) {
        var hint = document.createElement('span');
        hint.className = 'wsu-required-hint';
        hint.textContent = 'This field is required.';
        q.appendChild(hint);
      }
    });

    /* Top note, if the form template did not emit one. */
    var form = document.querySelector('form');
    if (form &amp;&amp; qs.length &amp;&amp; !document.querySelector('.wsu-required-note')) {
      var note = document.createElement('div');
      note.className = 'wsu-note wsu-note--size-small wsu-required-note';
      note.innerHTML = '&lt;p class="wsu-note__title"&gt;Required fields&lt;/p&gt;'
        + '&lt;p&gt;Fields marked with a red asterisk '
        + '(&lt;span aria-hidden="true" style="color:#a60f2d;font-weight:600"&gt;*&lt;/span&gt;) '
        + 'must be completed before you can submit this form.&lt;/p&gt;';
      form.insertBefore(note, form.firstChild);
    }

    /* Month / Day / Year selects Slate labels only for screen readers. */
    Array.prototype.forEach.call(
      document.querySelectorAll('select[aria-label]'), function (sel) {
        if (sel.closest('.wsu-subfield')) return;
        var txt = sel.getAttribute('aria-label');
        if (!/^(month|day|year)$/i.test(txt)) return;
        var wrap = document.createElement('span');
        wrap.className = 'wsu-subfield';
        var lab = document.createElement('label');
        lab.className = 'wsu-subfield__label';
        lab.textContent = txt;
        if (sel.id) lab.setAttribute('for', sel.id);
        sel.parentNode.insertBefore(wrap, sel);
        wrap.appendChild(lab);
        wrap.appendChild(sel);
      });

    /* Cancel button, if the template did not catch it. */
    Array.prototype.forEach.call(
      document.querySelectorAll('button, input[type="button"]'), function (b) {
        var t = (b.value || b.textContent || '').trim();
        if (t === 'Cancel') b.classList.add('wsu-slate-cancel');
      });
  }

  hydrateRequired();
  dock(state.corner || 'br');
}());
          </xsl:text>
        </script>
      </xsl:if>
      <!-- SANDBOX:END C -->

    </body>
  </xsl:template>

  <!-- ==========================================================
       XSLT TRANSFORMS — markup we generate or rewrite
       ========================================================== -->

  <!-- The form becomes a callout card. -->
  <xsl:template match="xhtml:form">
    <aside id="wsu-slate-form-card" class="wsu-callout">
      <form>
        <xsl:apply-templates select="@*" />

        <xsl:apply-templates select="node()" />
      </form>
    </aside>
  </xsl:template>

  <!--
    Required fields. Both treatments are emitted; CSS shows one.
    To ship: keep the branch you chose and delete the other, then drop the
    data-wsu-req attribute and its CSS block.
  -->
  <xsl:template match="xhtml:label[contains(@class, 'form_label')]">
    <label>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="node()" />
      <xsl:if test="ancestor::*[@data-required = '1' or contains(@class, 'required')][1]">
        <span class="wsu-required-star" aria-hidden="true">*</span>
      </xsl:if>
    </label>
  </xsl:template>

  <!--
    Every form question. Two jobs:
      * the FIRST question gets the top note prepended, so the note sits
        directly above the fields instead of above the form's own heading
        and description
      * required questions get the per-field hint appended
    CSS decides which of the three markers is visible.
  -->
  <xsl:template match="xhtml:div[contains(@class, 'form_question')]">
    <xsl:if test="not(preceding::*[contains(@class, 'form_question')])
               and (//*[@data-required = '1'] or //*[@aria-required = 'true'])">
      <div class="wsu-note wsu-note--size-small wsu-required-note">
        <p class="wsu-note__title">Required fields</p>
        <p>Fields marked with a red asterisk (<span aria-hidden="true" style="color:#a60f2d;font-weight:600">*</span>) must be completed before you can submit this form.</p>
      </div>
    </xsl:if>

    <div>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="node()" />
      <xsl:if test="@data-required = '1' or contains(@class, 'required') or .//*[@aria-required = 'true']">
        <span class="wsu-required-hint">This field is required.</span>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- Section headings get the crimson mark. -->
  <xsl:template match="xhtml:div[contains(@class, 'form_h2')]">
    <h2 class="wsu-heading--style-marked">
      <xsl:apply-templates select="node()" />
    </h2>
  </xsl:template>

  <!--
    Month / Day / Year: Slate gives these selects an aria-label and no visible
    label. Wrap each in a subfield and promote the aria-label to real text.
  -->
  <xsl:template match="xhtml:select[@aria-label][not(contains(@class, 'form_input'))]">
    <span class="wsu-subfield">
      <label class="wsu-subfield__label">
        <xsl:if test="@id"><xsl:attribute name="for"><xsl:value-of select="@id" /></xsl:attribute></xsl:if>
        <xsl:value-of select="@aria-label" />
      </label>
      <select>
        <xsl:apply-templates select="@*" />
        <xsl:apply-templates select="node()" />
      </select>
    </span>
  </xsl:template>

  <!-- Cancel gets the outline treatment so Submit stays the primary action. -->
  <xsl:template match="xhtml:button[normalize-space(.) = 'Cancel'] | xhtml:input[@type = 'button'][@value = 'Cancel']">
    <button type="button" class="form_button wsu-button wsu-slate-cancel">
      <xsl:attribute name="class">
        <xsl:text>form_button wsu-button wsu-slate-cancel</xsl:text>
        <xsl:if test="$default-outline-cancel = '1'"> wsu-button--style-outline</xsl:if>
      </xsl:attribute>
      <xsl:text>Cancel</xsl:text>
    </button>
  </xsl:template>

  <!-- Submit. -->
  <xsl:template match="xhtml:button[contains(@class, 'form_button')][not(normalize-space(.) = 'Cancel')]">
    <button class="form_button wsu-button">
      <xsl:apply-templates select="@*[name() != 'class']" />
      <xsl:apply-templates select="node()" />
    </button>
  </xsl:template>

  <!-- Slate's data tables pick up the design system table. -->
  <xsl:template match="xhtml:table[not(@role = 'presentation')][not(contains(@class, 'form_layout'))]">
    <table class="wsu-table">
      <xsl:apply-templates select="@*[name() != 'class']" />
      <xsl:apply-templates select="node()" />
    </table>
  </xsl:template>

  <!-- ==========================================================
       Identity — everything not matched above passes through
       ========================================================== -->

  <xsl:template match="xhtml:*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="node()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:attribute name="{name()}"><xsl:value-of select="." /></xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
