<?xml version="1.0" encoding="utf-8" ?>
<!--
  ============================================================================
  WSU Slate global branding template  ·  build.xslt
  WSU Web Design System 2.x  (cdn.web.wsu.edu/designsystem/2.x)
  ============================================================================
  HOW THIS IS SUPPOSED TO WORK  (the sanctioned model)
    Slate renders each external page to XHTML, then runs this XSLT 1.0 transform
    over it. Branding happens in THREE sanctioned ways, none of which fight Slate
    with CSS specificity:

    1. OFFICIAL WSU CHROME (this file). We wrap Slate's page in the same nesting
       admission.wsu.edu uses: wsu-wrapper-global › wsu-header-global (system
       crumb bar) + wsu-header-unit (unit lockup) › wsu-wrapper-site ›
       wsu-wrapper-content › main.wsu-wrapper-main.wsu-content.wsu-container ›
       article.wsu-article › [Slate content]. The CDN bundle skins every native
       field, heading, link and table inside automatically.

    2. SLATE CUSTOM COLOR REPLACEMENT (the fw-* block below). Slate's OWN CSS is
       written as  a{color:var(fw-link-text)}, button{background:var(fw-button-
       default-background)} , etc. So we do NOT override Slate by specificity — we
       hand Slate the WSU palette through its own documented fw-* variables and
       Slate repaints its own chrome on-brand: links, default submit, datepicker,
       dialogs, tabs, validation, table borders, native checkbox/radio. This is
       the fix for Slate's blue links. Ref: Technolutions KB ▸ Branding ▸ Custom
       Color Replacement. The catalog of every hook is slate.html in the kit.

    3. A SHORT LIST OF CUSTOM RULES. Required-field marking, Slate's layout
       tables, Slate's modal host, and the a11y safety net. Everything else is
       official.

  WHAT CHANGED IN 3.0  (from the branding-sandbox review)
    · Crumb bar carries the WSU link only. The campus crumb was dropped: a Slate
      form is not a campus page, and "Pullman" is wrong for online/other-campus
      applicants.
    · The form card is GONE. Wrapping the form in wsu-callout put the whole page
      inside a gray panel, which reads as one enormous field and fights the
      page's own background. Slate's form now sits directly in article.wsu-article.
    · Required fields say "(Required)" INSIDE the label instead of stamping
      "This field is required." under every input. Same information, announced
      with the field's name rather than after it, and it does not double the
      height of a long form. The aria-describedby plumbing that pointed at the
      old hint is therefore gone — the accessible name now carries it.
    · Slate's dialog_host gets its positioning restored (see the CSS note). On
      the live test form this was reserving a ~500px blank block mid-page.
    · Data tables keep wsu-table; layout tables (role="none"/"presentation")
      still get WSU chrome stripped.

  WHY FIELDS NEED NO WSU CLASSES
    Slate emits .form_input / .form_label / .form_button / .form_question. Those
    are still real <input>/<label>/<button> elements, so the bundle's bare-element
    rules skin them, and the fw-* mapping colours Slate's own framework styling.
    The only class that matters is wsu-content on <main> (styles bare buttons).

  FONTS
    The CDN bundle NAMES Montserrat but ships no font files, so we load Montserrat
    from Google Fonts exactly as admission.wsu.edu does. If your network blocks
    fonts.googleapis.com, self-host instead (buildfonts.css + the uploaded TTFs).

  TWO LINES ARE FRAMEWORK CONTRACT — DO NOT REMOVE
    1. <template path="/shared/base.xslt" .../>  pulls in Slate's base template.
    2. <xsl:apply-templates select="xhtml:html/xhtml:body/node()"/> inside
       article.wsu-article is the hand-off where Slate's form lands. Move it, the
       form vanishes.

  DEPLOY  (Database ▸ Branding ▸ Branding Editor)
    Import Current → edit in /dev → validate (xmllint noout) → Preview a REAL
    form → Publish (/dev → /shared). Mobile: Configuration Keys ▸ Branding,
    Privacy & Ping ▸ Mobile Template → /shared/build.xslt.

  <script> PADDING
    Each <script> carries an <xsl:text> newline so it never serializes as a
    self-closing <script/> (which would swallow the rest of the page).
  ============================================================================
-->
<!-- fw namespace = Slate's Framework library. Declaring it enables server-side
     fw:* functions in this transform, e.g. fw:year() for the copyright year. -->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:fw="http://technolutions.com/framework" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xhtml fw">
  <!-- Release version — bump on every publish. Shown as plain text in the footer. -->
  <xsl:variable name="brandVersion" select="'3.0.0'" />
  <!-- ============================================================
       SET THIS PER SECTION. Copy this file for a new section, change the
       one line below, done.
       NOTE: fw:path() sees the PATH only, never the query string. A form
       reached as /register/?id=… matches none of the branches below and
       lands on $unit-name — which is why the page read "Admissions" until
       this was set.
       ============================================================ -->
  <xsl:variable name="unit-name">FutureCoug</xsl:variable>

  <!-- CONDITIONAL BRANDING via Slate's fw: functions.
       Path-specific overrides first, $unit-name as the default. Delete the
       xsl:choose entirely if every page should read the same. -->
  <xsl:variable name="bandTitle">
    <xsl:choose>
      <xsl:when test="contains(fw:path(), '/register/inquiry')">Request Information</xsl:when>
      <xsl:when test="contains(fw:path(), '/apply')">Apply</xsl:when>
      <xsl:otherwise><xsl:value-of select="$unit-name" /></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
      <!-- FRAMEWORK CONTRACT — pulls in Slate's base template. Keep. -->
      <template path="/shared/base.xslt" xmlns="http://technolutions.com/framework" />
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <!-- Preconnects. -->
        <link rel="preconnect" href="https://cdn.web.wsu.edu" crossorigin="crossorigin" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
        <!-- Montserrat — the CDN bundle names it but ships no files, so load it
             from Google Fonts exactly as admission.wsu.edu does. -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&amp;display=swap" />
        <!-- Base reset + WSU icon font + the official 2.x design system bundle.
             Load order is normative: normalize → icons → design system. -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
        <link rel="stylesheet" href="https://cdn.web.wsu.edu/designsystem/1.x/wsu-icons/dist/wsu-icons.bundle.css" />
        <link rel="stylesheet" href="https://cdn.web.wsu.edu/designsystem/2.x/dist/bundles/wsu-design-system.css" />
        <script src="https://cdn.web.wsu.edu/designsystem/2.x/dist/bundles/wsu-design-system.init.js">
          <xsl:text>
          </xsl:text>
        </script>
        <!-- Slate-contributed head content (framework CSS, per-form Edit Styles,
             page <title>). Placed BEFORE our fw-* block so our :root variable
             values win the cascade and Slate consumes OUR palette. -->
        <xsl:apply-templates select="xhtml:html/xhtml:head/node()" />
        <!-- ============================================================
             SLATE CUSTOM COLOR REPLACEMENT + our short list of custom rules.
             This is the sanctioned branding hook, not a specificity override.
             Slate's own CSS reads these fw-* variables and repaints itself.
             Values are the 2025 WSU palette; names are Slate's documented ones
             (Technolutions KB ▸ Branding ▸ Custom Color Replacement).
             ============================================================ -->
        <style>
          <xsl:text>
          :root{
            /* WSU 2025 palette &#x2014; raw values live here ONLY (the CDN exposes no
               :root color vars to reference). */
            --wsu-crimson:#a60f2d; --wsu-crimson-hover:#ca1237; --wsu-crimson-deep:#680222;
            --wsu-dark-gray:#4d4d4d; --wsu-white:#ffffff; --wsu-input-border:#b2b2b2;

            /* Slate's documented framework variables &#x2014; Slate paints itself with these. */
            /* COMPLETE documented Slate Custom Color Replacement set (every variable
               from Technolutions KB &#x25B8; Branding &#x25B8; Custom Color Replacement), mapped to
               the WSU palette. Slate paints its own chrome from these. */
            --fw-body-text:var(--wsu-dark-gray);          /* body text */
            --fw-link-text:var(--wsu-crimson);            /* hyperlinks (the blue-link fix) */
            --fw-active-text:var(--wsu-crimson-hover);    /* link hover / search match */
            --fw-muted-text:#595959;                      /* "loading..." temporary text */
            --fw-input-border:var(--wsu-input-border);    /* text box / select borders */
            --fw-button-background:#e7e7e7;               /* non-default popup buttons */
            --fw-button-default-background:var(--wsu-crimson); /* default button (Submit) */
            --fw-success-text:#2e7d17;                    /* success message text (readable green) */
            --fw-success-accent:#529214;                  /* success border */
            --fw-success-background:#e6efc2;              /* success background */
            --fw-error-background:transparent;            /* required/invalid field wash (WSU: off) */
            --fw-warning-accent:#c69214;                  /* warning border */
            --fw-warning-background:#fffbe6;              /* warning background */
            --fw-datepicker-text:var(--wsu-dark-gray);    /* datepicker day/month text */
            --fw-datepicker-background-active:var(--wsu-crimson);  /* selected date */
            --fw-datepicker-background-hover:#f2f2f2;     /* hovered date */
            --fw-tab-text:#595959;                        /* tabs / subtabs text */
            --fw-tab-text-hover:var(--wsu-crimson);       /* tabs / subtabs hover text */
            --fw-tab-background:#f2f2f2;                   /* tabs / subtabs background */
            --fw-tab-background-hover:#fafafa;            /* tabs / subtabs hover background */
            --fw-suggest-background-hover:#f2f2f2;        /* autosuggest hovered result */
            --fw-table-row-border:#d9d9d9;               /* table row divider */
            --fw-dialog-header:#f2f2f2;                    /* dialog header background */
            --fw-dialog-footer-border:#e5e5e5;           /* dialog body/footer divider */
            accent-color:var(--wsu-crimson);              /* native checkbox / radio */
          }
          /* Keep the unit-header lockup charcoal: Slate's a:link (0,1,1) reaches into
             our chrome and would recolor it. Scope to the lockup ONLY &#x2014; do NOT include
             .wsu-header-global, because the crumb bar (wsu-header-global--style-system)
             styles its own links light (#f2f2f2) on the dark bar, and forcing
             color:inherit there makes them dark-on-dark / illegible. */
          .wsu-header-unit a.wsu-logo-lockup:link,.wsu-header-unit a.wsu-logo-lockup:visited{color:inherit !important;}
          /* Content links: force WSU crimson over Slate's a:link. Belt-and-suspenders
             next to --fw-link-text, because this instance's Slate does not appear to
             honor Custom Color Replacement for links. */
          .wsu-content a:link,.wsu-content a:visited{color:#a60f2d !important;}
          .wsu-content a:hover,.wsu-content a:focus{color:#a60f2d !important;}

          /* REQUIRED FIELDS. 3.0 marks required questions with the word
             "(Required)" appended INSIDE the label (see the transform below), so
             the requirement is part of the field's accessible name and nothing
             trails the input. Replaces the "This field is required." hint that
             sat under every field: same information in words, a third of the
             vertical space. Regular weight so the field name still leads. */
          .wsu-content .wsu-required-flag{font-weight:400;color:var(--wsu-dark-gray);margin-left:.35em;}

          /* LAYOUT-TABLE FIX. Slate builds forms/login with tables it marks
             role="none"/role="presentation" (positioning, not data). The WSU
             bundle styles every bare table element (crimson top border + cell
             gridlines), which bleeds onto those layout tables. Strip WSU table
             chrome from presentational tables ONLY &#x2014; real data tables (no such
             role) keep it. Keyed on Slate's own marker, so it fixes every such
             page automatically, including the login page. */
          .wsu-content table[role="none"],.wsu-content table[role="presentation"],
          .wsu-content table[role="none"] &gt; *,.wsu-content table[role="presentation"] &gt; *,
          .wsu-content table[role="none"] th,.wsu-content table[role="none"] td,
          .wsu-content table[role="presentation"] th,.wsu-content table[role="presentation"] td{
            border:0 !important;background:transparent !important;
          }

          /* SLATE'S OWN MODAL HOST ("More Info" popups).
             Two things were wrong on the live form. First, dialog_host carries
             inline left/top but takes its POSITION from Slate's stylesheet;
             under the design system reset it fell back to static, so the hidden
             ~500px dialog sat in normal flow and reserved a blank block
             mid-page. Second, once shown it was absolutely positioned against
             the document, so it scrolled with the page, ran off the top under
             the header, and had no backdrop.

             Fixed centring in the viewport fixes both. The inline left/top calc
             Slate writes has to be overridden, hence !important — this is the
             one place in this file that needs it. */
          .progress_box{position:static;}
          .dialog_host{
            position:fixed!important;
            left:50%!important;
            top:50%!important;
            right:auto!important;
            bottom:auto!important;
            transform:translate(-50%,-50%);
            width:min(560px,calc(100vw - 2rem));
            max-height:min(80vh,calc(100vh - 4rem));
            display:flex;
            flex-direction:column;
            background:#fff;
            box-shadow:0 10px 40px rgba(0,0,0,.35);
            border-top:4px solid #a60f2d;
          }
          /* Backdrop. z-index:-1 keeps it behind the dialog's own background
             but inside the host's stacking context, so no extra markup. */
          .dialog_host::before{
            content:"";
            position:fixed;
            inset:0;
            background:rgba(0,0,0,.45);
            z-index:-1;
          }
          /* Slate's inner wrappers vary by dialog type; make whichever one
             holds the copy the scrolling region. */
          .dialog_host > *{min-height:0;}
          .dialog_host .dialog_content,
          .dialog_host .dialog_body,
          .dialog_host .dialog{
            overflow-y:auto;
            -webkit-overflow-scrolling:touch;
          }
          .dialog_host .dialog_title,
          .dialog_host .dialog_header{
            padding:1.125rem 1.5rem;
            font-weight:700;
            font-size:1.25rem;
            border-bottom:1px solid #e5e5e5;
            flex:0 0 auto;
          }
          .dialog_host .dialog_content,
          .dialog_host .dialog_body{padding:1.125rem 1.5rem;}
          .dialog_host .dialog_buttons,
          .dialog_host .dialog_footer{
            display:flex;
            justify-content:flex-end;
            gap:.75rem;
            padding:1rem 1.5rem;
            border-top:1px solid #e5e5e5;
            background:#f7f7f7;
            flex:0 0 auto;
          }
          /* The Close button was clipping its own label. */
          .dialog_host button{line-height:1.5;padding:.625rem 1.5rem;}

          /* ============ ACCESSIBILITY (AAA-oriented, structural only) ============
             No WDS colors are overridden here &#x2014; the design-system palette ships as-is
             (per WSU standards). These rules are semantics/visibility helpers only;
             every colour used is a WDS token (--wsu-*). */

          /* A11Y - visible REAL labels for multi-part date selects (Month/Day/Year).
             Slate gives those selects an aria-label only; the transform below turns
             each into a proper visible label element and drops the now-redundant
             aria-label. wsu-dark-gray on white = 8.45:1 (AAA). */
          .wsu-content .wsu-subfield{display:inline-flex;flex-direction:column;vertical-align:top;margin-right:.75rem;}
          .wsu-content .wsu-subfield__label{font-size:.8rem;font-weight:600;color:var(--wsu-dark-gray);margin-bottom:.2em;}

          /* A11Y &#x2014; visible keyboard focus indicator (2.4.7 / focus-appearance).
             Crimson is a WDS token; this is an additive safety net over the bundle. */
          .wsu-content a:focus-visible,.wsu-content button:focus-visible,
          .wsu-content input:focus-visible,.wsu-content select:focus-visible,
          .wsu-content textarea:focus-visible,.wsu-skip-to-main:focus-visible{
            outline:3px solid var(--wsu-crimson);outline-offset:2px;
          }

          /* A11Y &#x2014; respect reduced-motion preference (2.3.3). Only affects users who
             ask for it; no visual change otherwise. */
          @media (prefers-reduced-motion: reduce){
            *,*::before,*::after{animation-duration:.001ms !important;animation-iteration-count:1 !important;transition-duration:.001ms !important;scroll-behavior:auto !important;}
          }
          </xsl:text>
        </style>
        <!-- Instance analytics (served from Slate /shared/). Delete if unused. -->
        <script src="/shared/gtm-primary-container.js">
          <xsl:text>
          </xsl:text>
        </script>
      </head>
      <body>
        <!-- Carry through any attributes Slate put on <body>. -->
        <xsl:copy-of select="xhtml:html/xhtml:body/@*" />
        <!-- ===================== OFFICIAL WSU CHROME ===================== -->
        <div class="wsu-wrapper-global">
          <!-- Official skip link. -->
          <a class="wsu-skip-to-main" href="#wsu-content-main">Skip to content</a>
          <!-- TOP BAR: official system crumb bar — the dark WSU strip
               admission.wsu.edu carries.
               3.0: the WSU link only. The campus crumb ("Pullman") was removed —
               a Slate form is not a campus page, and naming one campus is wrong
               for online and other-campus applicants. Add a second <li> back if
               your form really is campus-specific. -->
          <header class="wsu-header-global wsu-header-global--style-system" role="navigation" aria-label="Washington State University system">
            <ul class="wsu-header-global__menu">
              <li>
                <a href="https://wsu.edu">Washington State University</a>
              </li>
            </ul>
          </header>
          <!-- Brand header, admission.wsu.edu style: wsu-header-unit with a
               wsu-logo-lockup. This is the tick-free official alternative to
               wsu-wordmark — the lockup has no ::after tick. The WSU identity
               lives in the crumb bar above; this lockup carries the unit title.
               Utility bar / mobile-menu toggles are intentionally omitted (they
               open slide-in panels we don't ship on a Slate form). -->
          <header class="wsu-header-unit">
            <xsl:attribute name="aria-label">Washington State University <xsl:value-of select="$bandTitle" /></xsl:attribute>
            <div class="wsu-header-unit__inner">
              <div class="wsu-header-unit__banner">
                <a href="https://wsu.edu" class="wsu-logo-lockup wsu-logo-lockup--style-unit" aria-label="Go to WSU Homepage">
                  <span class="wsu-logo-lockup__icon-wrapper">
                    <svg role="img" aria-labelledby="wsu-coug-head__title" class="wsu-coug-head" enable-background="new 0 0 70.2 69.6" version="1.1" viewBox="0 0 70.2 69.6" xml:space="preserve" xmlns="http://www.w3.org/2000/svg">
                      <title id="wsu-coug-head__title">WSU Cougar Head</title>
                      <path class="st0" d="m42.8 69.6s3.6-1.5 5.5-7.4c1 2.3 1.5 4.8 1.3 7.3-2.3 0.1-4.5 0.2-6.8 0.1zm14.9-11.8c-10.4 1.4-12.2-20.3-12.2-20.3s3.5 11.1 10.9 10.7c7.7-0.4 5.5-12.2 5.5-12.2s7.5 20.2-4.2 21.8zm-47.7-5c-3.3 1-6.6 1.8-10 2.4 0 0 5.9-4.5 10.3-18.3l4.3 3.9-0.8 2.6c1.1 1.5 1.9 3.1 2.5 4.9 1.6-3.6 1.5-7.7-0.3-11.2l-0.5 1.6-1.7-1.5-2.8-2.7c1.2-3.6 3-7 5.3-10.1l0.4 0.4 3.3 3.8-1 1.7c1.5 1.7 2.9 3.4 4.2 5.3 0.6-3.4 0.4-6.8-0.4-10.1l-1.5 1.4-3.6-4.2c4.5-4.7 10-8.2 16.2-10.3-0.4 0.4-0.7 0.8-1 1.3-2 2.9-4.1 8.1-2.4 16.4 0.3 1.3 0.7 3.2 1.1 5.1 0.9 3.8 1.9 8.2 2.2 10.9 0.7 5.7 0.1 9.4-1.8 11.4-1.3 1.4-3.5 2-6.4 1.9v-1.4c0-2.4-0.3-4.8-0.8-7.2l-0.8-2.7-1.2 2.6c-1.9 4.1-8.6 14.1-17.2 16.1 2.6-4.2 4.1-9 4.4-14zm25.4 16.4h-0.5-0.1-0.3c-0.5 0-0.8-0.1-1.2-0.1-0.7-0.1-1.6-0.2-2.6-0.4-6.4-1.1-12.9-1.7-19.4-2 6.2-3.6 10.4-9.9 12-12.5 0.2 1.3 0.3 2.5 0.3 3.8 0 0.8 0 1.6-0.1 2.2l-0.1 1.1 1.1 0.1c0.7 0.1 1.3 0.1 1.9 0.1 3.3 0 5.7-0.8 7.3-2.5 2.4-2.5 3.1-6.7 2.3-13.1-0.4-2.9-1.4-7.4-2.3-11.1-0.5-2-0.9-3.8-1.1-5-1.5-7.6 0.3-12.3 2.1-14.8 1.3-1.9 3.2-3.4 5.5-4.2h0.1l3.3-10.8h1.1l-2.3 10.3c0.7-0.1 1.2-0.2 1.7-0.3l3-9.5h1.1l-2 9.2c2.9-0.4 6.1-0.7 10.3-1 0.8 0.4 1.4 1.1 1.8 1.9l9.8-3 0.4 1.1-9.5 3.7c0.1 0.2 0.2 0.4 0.2 0.6l10.3-1.3 0.2 1.1-10 2c0 0.2 0.1 0.4 0.1 0.6l10.4 0.3v1.1l-10.2 0.4c0 1.2-0.2 2.4-0.5 3.6 0.6 2.1 0.7 4.3 0.3 6.5-1.7-3.9-3-5.1-3-5.1-1.4-0.7-2.9-1-4.5-1-2.5 0-4.8 1.1-6.4 2.9-2.3 2.6-3.5 6-3.3 9.5 0.2 2.4 0.7 5.1 1.4 8.6 0.7 3.6 1.6 8.1 2.3 13.5 0.6 4.1-0.1 7.3-1.8 9.7-1.6 2.1-4 3.4-6.5 3.8h-0.1-0.2-0.1-2.2zm10.4-51.5c-2.1-0.1-4.2 0.4-6 1.3-1.5 1-2.5 2.7-2.6 4.5-0.1 0.6-0.1 1.2 0 1.8 0.8-1.5 2-2.8 3.3-3.9 2.4-1.5 5.1-2.3 7.9-2.4h0.9 0.3c0.4 0 0.7-0.1 0.8-0.2 0-0.1-0.1-0.3-0.4-0.4-1.3-0.5-2.7-0.8-4.2-0.7z"></path>
                    </svg>
                  </span>
                  <span class="wsu-logo-lockup__title-wrapper">
                    <span class="wsu-logo-lockup__title">
                      <xsl:value-of select="$bandTitle" />
                    </span>
                  </span>
                </a>
              </div>
            </div>
          </header>
          <!-- Site + content wells, matching admission.wsu.edu nesting.
               main carries wsu-wrapper-main (layout) + wsu-content (styles bare
               buttons/inputs) + wsu-container (measure/rhythm); the form sits in
               article.wsu-article for article typography. -->
          <div class="wsu-wrapper-site">
            <div class="wsu-wrapper-content">
              <main role="main" id="wsu-content-main" class="wsu-wrapper-main wsu-content wsu-container" tabindex="-1">
                <article class="wsu-article">
                  <!-- FRAMEWORK CONTRACT — the hand-off. Slate's rendered form
                       body is dropped in right here. -->
                  <xsl:apply-templates select="xhtml:html/xhtml:body/node()" />
                </article>
              </main>
            </div>
          </div>
          <!-- Official global footer. Build version appended as plain text. -->
          <footer class="wsu-footer-global">
            <div class="wsu-footer-global__copyright">
              <!-- Year rendered server-side by Slate's fw:year() (Framework library).
                   Requires xmlns:fw on the stylesheet root, declared above. -->
              <xsl:text>&#xA9; Washington State University </xsl:text>
              <xsl:value-of select="fw:year()" />
              <xsl:text> &#xB7; branding v</xsl:text>
              <xsl:value-of select="$brandVersion" />
            </div>
            <nav class="wsu-footer-global__navigation" aria-label="WSU footer menu" id="wsu-footer-global">
              <ul class="wsu-menu-tertiary">
                <li>
                  <a href="https://access.wsu.edu/">Access</a>
                </li>
                <li>
                  <a href="https://policies.wsu.edu/">Policies</a>
                </li>
                <li>
                  <a href="https://portal.wsu.edu/">MyWSU</a>
                </li>
                <li>
                  <a href="https://socialmedia.wsu.edu/">Follow&#xA0;WSU</a>
                </li>
              </ul>
            </nav>
          </footer>
        </div>
        <!-- =================== END OFFICIAL WSU CHROME =================== -->
        <!-- Official 2.x behaviour bundle — last in body so it runs against a
             complete DOM. Padded. -->
        <script src="https://cdn.web.wsu.edu/designsystem/2.x/dist/bundles/wsu-design-system.js">
          <xsl:text>
          </xsl:text>
        </script>
      </body>
    </html>
  </xsl:template>
  <!-- ############################################################
       TRANSFORMS
       These run against Slate's INPUT XHTML, so every element is matched with
       the xhtml: prefix. Comment any one out to turn it off.
       ############################################################ -->
  <!--
    NOTE ON THE REMOVED FORM CARD (was SHOWCASE 1)
    2.3.2 wrapped every <form> in <aside class="wsu-callout">, which the bundle
    renders as a gray panel with a top accent. On a real Slate form that reads as
    one enormous input field and fights the page background, so it is gone. If
    you ever want it back, it was exactly:
        <xsl:template match="xhtml:form">
          <aside class="wsu-callout">
            <xsl:copy><xsl:apply-templates select="@* | node()" /></xsl:copy>
          </aside>
        </xsl:template>
  -->
  <!-- SLATE SECTION HEADERS BECOME REAL WSU MARKED HEADINGS.
       Slate emits section headers as an element carrying class form_h2. We REPLACE
       it with a real h2 (so it picks up the bundle's h1-h6 typography) AND add the
       wsu-heading style-marked class (the crimson mark under the text). -->
  <xsl:template match="xhtml:*[contains(concat(' ', normalize-space(@class), ' '), ' form_h2 ')]">
    <h2 class="wsu-heading--style-marked">
      <xsl:apply-templates select="node()" />
    </h2>
  </xsl:template>
  <!-- DATA TABLES GET wsu-table.
       Layout tables (role=none/presentation) are excluded so the layout-table
       strip rule above still wins on the login page. -->
  <xsl:template match="xhtml:table[not(@role='none') and not(@role='presentation')]">
    <xsl:copy>
      <xsl:attribute name="class">
        <xsl:value-of select="normalize-space(concat(@class, ' wsu-table'))" />
      </xsl:attribute>
      <xsl:apply-templates select="@*[name() != 'class'] | node()" />
    </xsl:copy>
  </xsl:template>
  <!-- SECONDARY BUTTON VARIANT.
       If Slate labels a button "Cancel", tag it as the WSU outline/secondary
       button so Submit stays the only filled action. Matching on button text is
       fragile — verify against your real forms before relying on it. -->
  <xsl:template match="xhtml:button[normalize-space(.)='Cancel']">
    <xsl:copy>
      <xsl:attribute name="class">
        <xsl:value-of select="normalize-space(concat(@class, ' wsu-button wsu-button--style-outline'))" />
      </xsl:attribute>
      <xsl:apply-templates select="@*[name() != 'class'] | node()" />
    </xsl:copy>
  </xsl:template>
  <!-- ============================================================
       REQUIRED FIELDS — "(Required)" INSIDE THE LABEL.
       Slate marks required questions with data-required="1" (editors set
       "required" once in Slate; they never type helper text). We append the word
       to the question's own label, so:
         · it is conveyed in WORDS, not by an asterisk or colour alone (3.3.2);
         · it lands in the field's ACCESSIBLE NAME, announced with the field
           rather than after it, so no aria-describedby plumbing is needed;
         · a long form does not grow a line under every single input.
       Scoped to the label that is a DIRECT child of the required question, so
       instructional-text blocks that also carry form_label are untouched.
       Reword in one place to change site-wide.
       ============================================================ -->
  <xsl:template match="xhtml:*[contains(concat(' ', normalize-space(@class), ' '), ' form_label ')][parent::xhtml:div[contains(concat(' ', normalize-space(@class), ' '), ' form_question ')][@data-required='1']]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
      <span class="wsu-required-flag">(Required)</span>
    </xsl:copy>
  </xsl:template>
  <!-- ============================================================
       A11Y — MULTI-PART DATE SELECTS GET REAL, VISIBLE LABELS.
       Slate renders Month/Day/Year as three select elements with an aria-label
       only. We give each a real visible label (for=id, both visible AND
       programmatic), and DROP the now-redundant aria-label so the accessible name
       comes from the real label (no double naming).
       ============================================================ -->
  <xsl:template match="xhtml:select[@aria-label='Month' or @aria-label='Day' or @aria-label='Year']">
    <span class="wsu-subfield">
      <label class="wsu-subfield__label" for="{@id}">
        <xsl:value-of select="@aria-label" />
      </label>
      <xsl:copy>
        <xsl:apply-templates select="@*[name() != 'aria-label']" />
        <xsl:apply-templates select="node()" />
      </xsl:copy>
    </span>
  </xsl:template>
  <!-- ============================================================
       IDENTITY PASS-THROUGH — MUST BE LAST, MUST BE PRESENT.
       Everything Slate emits that we did not explicitly place above flows out
       unchanged. Without it, XSLT's built-in defaults strip unmatched elements
       to text and the form vanishes.
       ============================================================ -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
