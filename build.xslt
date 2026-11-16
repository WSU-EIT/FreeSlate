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

    2. SLATE CUSTOM COLOR REPLACEMENT (the fw-* block in build.css). Slate's OWN CSS is
       written as  a{color:var(fw-link-text)}, button{background:var(fw-button-
       default-background)} , etc. So we do NOT override Slate by specificity — we
       hand Slate the WSU palette through its own documented fw-* variables and
       Slate repaints its own chrome on-brand: links, default submit, datepicker,
       dialogs, tabs, validation, table borders, native checkbox/radio. Slate's
       /shared/base.css paints links with its color variables directly (the
       variables named c0000FFFF for blue and cFF0000FF for red), so those two are
       set as well; that is the fix for Slate's blue links. Ref: Technolutions KB ▸ Branding ▸
       Custom Color Replacement. The catalog of every hook is slate.html in the kit.

    3. A SHORT LIST OF CUSTOM RULES. Required-field marking, Slate's layout
       tables, Slate's modal host, and the a11y safety net. Everything else is
       official.

  WHAT CHANGED IN 3.0.22
    · The "(Required)" marker in a question label now looks like the one on
      wsu.edu's own forms (for example wsu.edu/digital-accessibility/questions):
      red, italic, regular weight, slightly smaller than the label. It was
      dark gray, upright, and the label's size. The four values are copied
      from the stylesheet of Gravity Forms, the form tool behind WSU's
      WordPress forms; the red is listed in build.css's palette under its own
      heading with a link to that stylesheet, because the WSU design system
      has no color for this marker. On white it is 5.85:1 (AA; the gray was
      8.59:1), and 4.89:1 on the highlight a missed required question gets.
    · Only the style changes. The marker is still the word "(Required)" inside
      the label, written by the same templates below, so screen readers and
      the accessible name are exactly as before. In build.xslt only the
      version number changes.

  WHAT CHANGED IN 3.0.21
    · build.css now writes every color once, in a palette at the top of the
      file. Each palette entry is named after its official source (the WSU
      design system's source palette on GitHub, Slate's own default, or the
      WSU Spine) and links to it. Everything below the palette refers to a
      palette name: no color value appears anywhere else in the file, and the
      FreeSlate build refuses a build.css that breaks this rule.
    · Each design system color now has ONE value: the one the published
      stylesheet on cdn.web.wsu.edu writes. 3.0.20 spelled some grays two
      ways (the published value in some rules, the hex from the source's
      comment in others). Five values change, each to an official one:
        gray 70 (required flag, date sub-labels, datepicker text): #4d4d4d to #4c4c4c
        gray 10 (pop-up buttons): #e6e6e6 to #e5e5e5
        gray 15 (table row divider): #d9d9d9 to #d8d8d8
        tab hover background: #fafafa to gray 0, #f7f7f7 (#fafafa was not a palette color)
        divider under the stacked sidebar: #eee to gray 10, #e5e5e5 (#eee came
          from the 2021 overrides file and was not a palette color)
      The first three are one step out of 255 and can't be seen.
    · No rule is added, removed or reordered. In build.xslt only the version
      number changes.

  WHAT CHANGED IN 3.0.20
    · Links /shared/build.css, the stylesheet in Slate's Branding Editor.
      3.0.19 linked /shared/base.css, which is Slate's own platform file (the
      Branding Editor doesn't show or change it), so 3.0.19 pages got Slate's
      stock rules last (blue links, Arial) and none of ours.
    · The CSS is the same as 3.0.19's: every color an official WSU color, or
      Slate's own default where WSU has none.

  WHAT CHANGED IN 3.0.19 (withdrawn: see 3.0.20)
    · The CSS moves out of this file into a stylesheet, so how the forms
      look is edited in one stylesheet in Slate's Branding Editor. The rules
      are the same, unchanged. This file links base.css at the end of the
      <head>, where the <style> block was, so the rules still come after the
      WSU design system and Slate's CSS. Slate's stock base.css rules (Arial
      12px, blue links, old layout widths) are dropped: the WSU design system
      and our rules already replaced them. Nothing visible changes.
    · When you change base.css, bump brandVersion here too: the link carries
      it as ?v=, so browsers fetch the new file right away.
    · Every color in base.css is now an official WSU color, or Slate's own
      default where WSU has none (each is listed, with evidence, in the
      Slate HTML Cleaner's XSLT & CSS tab): the required-question highlight
      after submit is the official crimson accent #fae6ea (was #f9e5e9), popup
      buttons the official gray 10 #e6e6e6 (was #e7e7e7), success text the WSU
      text color #262626 (was #2e7d17), the warning background Slate's own
      #ffffcc (was #fffbe6). The unused crimson-deep variable is removed.

  WHAT CHANGED IN 3.0.18
    · A label holding a "(More Info)" pop-up had a blank gap of about 84px
      before "(Required)" (e.g. First/given name on the application). The
      pasted pop-up block is a hidden box Slate takes out of the layout
      (position:absolute); this file put it back in (position:static), so
      the hidden box took up space. That rule is removed. Clicking
      "(More Info)" works as before: Slate moves the pop-up into its own
      box at the end of the page, which the rules below still center.
      Slate's loading spinner is not affected.

  WHAT CHANGED IN 3.0.17
    · Portal buttons with their own CSS (e.g. class="application-button" on
      /portal/nep_app) were crimson text on crimson. The cause was this
      file's rule forcing every content link crimson with !important, which
      beat the portal's own white. That rule is gone. Links are crimson the
      way Slate intends: its /shared/base.css colors links with its color
      variable c0000FFFF (blue) and hover with cFF0000FF (red), and those are
      now set to WSU crimson. Every link checked on four wst-2 pages keeps
      its color; only the Skip to content link (shown on Tab) goes from blue
      to crimson. Error text Slate colors with cFF0000FF turns crimson too.

  WHAT CHANGED IN 3.0.16
    · The release version is written into every page's <head> as an HTML
      comment and a meta tag, so View Source shows which build.xslt a page
      was rendered with. Nothing visible changes.

  WHAT CHANGED IN 3.0.15
    · Withdraws 3.0.13 and 3.0.14, which styled accordions and show/hide
      sections with CSS of our own. Only the official design system's own
      files style page content. Same CSS as 3.0.12.

  WHAT CHANGED IN 3.0.12
    · Links in content with class="wsu-button" were crimson text on a
      crimson button (unreadable): the rule that forces content links
      crimson also caught buttons. Buttons are left out of it now and get
      the official white text.

  WHAT CHANGED IN 3.0.11
    · Phones: loads Slate's stock /shared/build-mobile-global.css and .js
      again, as the original template did. Without them, two-column portal
      pages (e.g. /portal/visit) did not stack on a phone: the calendar
      covered the text and the text column was 3px wide. They also give the
      application menu a dropdown and data tables a card layout on phones.

  WHAT CHANGED IN 3.0.10
    · Event calendars: available dates were invisible (white on white) on
      /portal/visit. The layout-table reset matched cells of any table
      nested inside a Slate layout table; it now matches only the layout
      table's own cells, so the portal's crimson date fill shows again.
    · Crumb bar: now the official markup from admission.wsu.edu
      (aria-label="WSU system", no role) instead of role="presentation".

  WHAT CHANGED IN 3.0.9
    · Slate's body-text color variable (fw-body-text) is now the 2.x body
      color #262626, not dark gray #4d4d4d. Slate paints its status
      messages ("To log in, please enter..."), typed input text, non-default
      popup buttons and table-row links with it; they now match the page.

  WHAT CHANGED IN 3.0.8
    · Form controls use the official face. Slate's stock CSS forced Arial on
      buttons (!important), text inputs, selects and textareas; the 2.x
      bundle wants Montserrat on buttons and the inherited page font
      (Montserrat) on inputs. Found by the UI tool's new comparison against
      the official 2.x bundle.

  WHAT CHANGED IN 3.0.7
    · Lockup link: removed aria-label="Go to WSU Homepage". The visible text
      is the unit title, so the label hid it from voice-control users (axe
      label-content-name-mismatch, WCAG 2.5.3 Label in Name). Its name now
      comes from the visible title, as on admission.wsu.edu.
    · Crumb bar: role="navigation" is not allowed on header (axe
      aria-allowed-role). Now role="presentation", which ARIA allows on
      header, so it is not a second banner next to the unit header. Same
      markup, classes and look as the official crumb bar.

  WHAT CHANGED IN 3.0.6
    · Ported the intent of the web team's 2021 Slate overrides
      (/shared/web-design-system-overrides.css) using 2.x values: group
      question labels (Birthdate, Address, radio groups) styled like every
      other label, the application sidebar styled as the 2.x vertical menu
      and stacked under 1040px, and event calendar availability colors.

  WHAT CHANGED IN 3.0.5
    · Slate's primary button in popups (e.g. "Create Application" in the
      "Let's Get Started" dialog) was dark gray text on crimson, 1.1:1.
      Dialogs sit outside .wsu-content, so the WDS button rule never applied.
      Now white on crimson, crimson-light on hover, matching WDS buttons.

  WHAT CHANGED IN 3.0.4
    · A required label written as paragraphs (a question, then a consent or
      help paragraph, e.g. "May we text you?") gets "(Required)" at the end
      of its first non-empty paragraph instead of after the fine print.
    · No "(Required)" on login forms (any form with a password input):
      Slate's 150px label column clipped it, and both fields are obviously
      required. Register and reset keep theirs.

  WHAT CHANGED IN 3.0.3
    · "(Required)" now reaches grouped questions. Birthdate and address
      render as div.form_question > fieldset > div.form_label, so 3.0.2's
      "label is a direct child of the question" match skipped them. The
      template now also matches a label that is a direct child of a
      fieldset inside a required question.
    · "(Required)" on Slate's built-in pages such as /account/register.
      They have no form_question markup; Slate marks required controls with
      data-validate="{ required: true }", so a label whose control (or
      fieldset of controls) carries that is flagged.

  WHAT CHANGED IN 3.0.2
    · Dialog hugs Slate's content. Slate's inner dialog box has its own fixed
      width, narrower than our 560px host, which left an empty strip on the
      right (the gray block in 3.0, white in 3.0.1). The host is now
      width:fit-content, capped at 560px / the viewport.

  WHAT CHANGED IN 3.0.1
    · Required-field error highlight restored. 3.0 set fw-error-background to
      transparent, so after an incomplete submit nothing marked which questions
      were missing. It is now a light crimson tint (#f9e5e9); body text on it
      stays AAA.
    · Dialog backdrop fixed. 3.0 centred .dialog_host with transform, which made
      the position:fixed ::before backdrop size itself to the dialog instead of
      the viewport — it showed as a gray block on the right of the popup. The
      dialog is now centred with inset:0 + margin:auto, the backdrop is a
      100vmax box-shadow, and z-index keeps it above the WSU header.

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
  <!-- Release version — bump on every publish. Written into <head> (3.0.16). -->
  <xsl:variable name="brandVersion" select="'3.0.22'" />
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
  <!-- C# equivalent of the page template. Runs ONCE for the whole document:
       builds the WSU page and drops Slate's own head and body content into it.

         XElement Page(XDocument slate)
         {
             var head = slate.Root.Element("head");
             var body = slate.Root.Element("body");
             return new XElement("html", new XAttribute("lang", "en"),
                 new XElement("head",
                     MetaAndCdnLinks(),                  // fonts, normalize, wsu-icons, 2.x bundle
                     head.Nodes().Select(Visit),         // Slate's own CSS, scripts, title
                     InlineStyle()),                     // fw-* palette + the short rule list
                 new XElement("body",
                     body.Attributes(),                  // keep whatever Slate put on body
                     WsuHeader(bandTitle),
                     new XElement("main",
                         new XElement("article", new XAttribute("class", "wsu-article"),
                             body.Nodes().Select(Visit))),   // THE hand-off: every template below runs from here
                     WsuFooter(year: Fw.Year())));
         } -->
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
      <!-- FRAMEWORK CONTRACT — pulls in Slate's base template. Keep. -->
      <template path="/shared/base.xslt" xmlns="http://technolutions.com/framework" />
      <head>
        <!-- 3.0.16: the build.xslt version, visible in View Source. The meta tag
             is a backup in case Slate drops comments from the page. -->
        <xsl:comment><xsl:value-of select="concat(' WSU build.xslt ', $brandVersion, ' ')" /></xsl:comment>
        <meta name="wsu-build-xslt-version" content="{$brandVersion}" />
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
        <!-- 3.0.11: Slate's stock phone stylesheet, loaded by the original
             template and dropped in the 3.x rewrite. Below 736px it stacks
             Slate's layout tables (two-column portals such as /portal/visit),
             turns data tables into cards, makes the application sidebar full
             width and popups full screen. Served from this instance's /shared/. -->
        <link rel="stylesheet" href="/shared/build-mobile-global.css" />
        <script src="https://cdn.web.wsu.edu/designsystem/2.x/dist/bundles/wsu-design-system.init.js">
          <xsl:text>
          </xsl:text>
        </script>
        <!-- Slate-contributed head content (framework CSS, per-form Edit Styles,
             page <title>). Placed BEFORE our fw-* block so our :root variable
             values win the cascade and Slate consumes OUR palette. -->
        <xsl:apply-templates select="xhtml:html/xhtml:head/node()" />
        <!-- 3.0.20: the WSU styles (Slate Custom Color Replacement and our custom
             rules) live in build.css, edited in Slate's Branding Editor (Slate
             serves it as /shared/build.css; it doesn't link it by itself).
             Linked HERE, after Slate's CSS and the WSU design system, they come
             last in the cascade, exactly where the <style> block was before
             3.0.19. The ?v= is this file's version: bump brandVersion whenever
             build.css changes, so browsers fetch the new copy (Slate lets them
             keep /shared/ files for a day). -->
        <link rel="stylesheet" href="/shared/build.css?v={$brandVersion}" />
        <!-- Instance analytics (served from Slate /shared/). Delete if unused. -->
        <script src="/shared/gtm-primary-container.js">
          <xsl:text>
          </xsl:text>
        </script>
        <!-- 3.0.11: the stock phone script that goes with the stylesheet above.
             Below 736px it swaps the application menu for a dropdown and labels
             each data-table cell with its column name. Needs Slate's jQuery and
             FW objects, which Slate loads first in the head. -->
        <script src="/shared/build-mobile-global.js">
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
          <!-- 3.0.10: same markup as admission.wsu.edu, financialaid.wsu.edu and
               its.wsu.edu (labelled header, no role). Tested against 3.0.7's
               role="presentation": axe gives each exactly one best-practice
               note and no WCAG issue, so the official markup wins. -->
          <header class="wsu-header-global wsu-header-global--style-system" aria-label="WSU system">
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
                <a href="https://wsu.edu" class="wsu-logo-lockup wsu-logo-lockup--style-unit">
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
          <!-- Official global footer. -->
          <footer class="wsu-footer-global">
            <div class="wsu-footer-global__copyright">
              <!-- Year rendered server-side by Slate's fw:year() (Framework library).
                   Requires xmlns:fw on the stylesheet root, declared above. -->
              <xsl:text>&#xA9; Washington State University </xsl:text>
              <xsl:value-of select="fw:year()" />
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
  <!-- ============================================================
       HOW TO READ THE TEMPLATES BELOW (C# MENTAL MODEL)
       ============================================================
       The whole stylesheet behaves like ONE recursive visitor. Slate calls it
       once on its rendered page; every template is one "case" in it.

         XNode Visit(XNode node)
         {
             // Each <xsl:template match="..."> below is one of these cases.
             // XSLT picks the most specific pattern that matches; anything
             // nothing matches falls through to Identity (the last template).
             foreach (var t in templatesBySpecificity)
                 if (t.Matches(node)) return t.Body(node);
             return Identity(node);
         }

       Translation table:
         <xsl:template match="P">              if (node matches P) { ...body... }
         <xsl:apply-templates select="X"/>     foreach (var n in X) output.Add(Visit(n));
         <xsl:copy>...</xsl:copy>              new XElement(el.Name, ...)   (same tag, children supplied by the body)
         <xsl:value-of select="X"/>            output.Add(new XText(X))
         a literal tag, e.g. <h2 class="a">     new XElement("h2", new XAttribute("class", "a"), ...)
         @class                                el.Attr("class")             (null when missing)
         node()                                el.Nodes()                   (child elements AND text)
         parent::X  /  .//X                    el.Parent  /  el.Descendants()
         contains(concat(' ', normalize-space(@class), ' '), ' x ')
                                               el.HasClass("x")             (whole-word class test, so
                                                                             "form_label" does not match
                                                                             "form_label_extra")
       Helpers the pseudo-code uses:
         string Attr(this XElement e, string n) => e.Attribute(n)?.Value;
         bool HasClass(this XElement e, string c) =>
             (e.Attr("class") ?? "").Split(' ', RemoveEmptyEntries).Contains(c);
         XElement RequiredFlag() =>
             new XElement("span", new XAttribute("class", "wsu-required-flag"), "(Required)");
       ============================================================ -->
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
  <!-- C#:
         if (el.HasClass("form_h2"))
             return new XElement("h2",
                 new XAttribute("class", markedHeadingClass),   // the class written in the template below
                 el.Nodes().Select(Visit));                      // keep the heading text; drop Slate's own tag and attributes
  -->
  <xsl:template match="xhtml:*[contains(concat(' ', normalize-space(@class), ' '), ' form_h2 ')]">
    <h2 class="wsu-heading--style-marked">
      <xsl:apply-templates select="node()" />
    </h2>
  </xsl:template>
  <!-- DATA TABLES GET wsu-table.
       Layout tables (role=none/presentation) are excluded so the layout-table
       strip rule above still wins on the login page. -->
  <!-- C#:
         if (el.Name == "table" && el.Attr("role") != "none" && el.Attr("role") != "presentation")
             return new XElement("table",
                 new XAttribute("class", NormalizeSpace(el.Attr("class") + " wsu-table")),
                 el.Attributes().Where(a => a.Name != "class"),  // every other attribute unchanged
                 el.Nodes().Select(Visit));                       // rows and cells keep being visited
  -->
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
  <!-- C#:
         if (el.Name == "button" && NormalizeSpace(el.Value) == "Cancel")
             return new XElement("button",
                 new XAttribute("class", NormalizeSpace(el.Attr("class") + " " + outlineButtonClasses)),  // as written below
                 el.Attributes().Where(a => a.Name != "class"),
                 el.Nodes().Select(Visit));
  -->
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
  <!-- 3.0.3: grouped questions wrap their label in a fieldset. Verified on
       live markup (wst.test, Oct 2026):
         div.form_question[data-required] > label.form_label              (text fields)
         div.form_question[data-required] > fieldset > div.form_label     (birthdate, address)
       Address sub-labels (Country, Street…) sit one level deeper, inside a
       div, so they are not flagged; the group label carries it. -->
  <!-- C#:
         bool IsRequiredQuestion(XElement q) =>
             q != null && q.HasClass("form_question") && q.Attr("data-required") == "1";

         // match: the question's own label, either directly inside the
         // question or directly inside a fieldset that is directly inside it
         if (el.HasClass("form_label") &&
             (IsRequiredQuestion(el.Parent) ||
              (el.Parent?.Name == "fieldset" && IsRequiredQuestion(el.Parent.Parent))))
         {
             var copy = new XElement(el.Name, el.Attributes());
             var firstP = el.Elements("p")                   // direct child paragraphs only
                            .FirstOrDefault(p => p.Value.Replace('\u00A0', ' ').Trim() != "");
             if (firstP != null)
             {
                 // Paragraph label ("May we text you?" + consent text):
                 // flag goes at the end of the first non-empty paragraph.
                 foreach (var child in el.Nodes())
                     copy.Add(child == firstP                // generate-id(.) = generate-id($firstP)
                         ? new XElement("p", firstP.Attributes(), firstP.Nodes().Select(Visit), RequiredFlag())
                         : Visit(child));
             }
             else
             {
                 // Plain label ("First Name"): flag goes at the end.
                 copy.Add(el.Nodes().Select(Visit), RequiredFlag());
             }
             return copy;
         }
  -->
  <xsl:template match="xhtml:*[contains(concat(' ', normalize-space(@class), ' '), ' form_label ')][parent::xhtml:*[contains(concat(' ', normalize-space(@class), ' '), ' form_question ')][@data-required='1'] or parent::xhtml:fieldset[parent::xhtml:*[contains(concat(' ', normalize-space(@class), ' '), ' form_question ')][@data-required='1']]]">
    <!-- A label written as paragraphs (question, then a consent or help
         paragraph) gets the flag at the end of its first non-empty
         paragraph, so it reads "May we text you? (Required)" instead of
         trailing the fine print. Plain labels get it at the end as before. -->
    <xsl:variable name="firstP" select="xhtml:p[normalize-space(translate(., '&#xA0;', ' '))][1]" />
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:choose>
        <xsl:when test="$firstP">
          <xsl:for-each select="node()">
            <xsl:choose>
              <xsl:when test="generate-id(.) = generate-id($firstP)">
                <xsl:copy>
                  <xsl:apply-templates select="@* | node()" />
                  <span class="wsu-required-flag">(Required)</span>
                </xsl:copy>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="." />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()" />
          <span class="wsu-required-flag">(Required)</span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <!-- ============================================================
       A11Y — MULTI-PART DATE SELECTS GET REAL, VISIBLE LABELS.
       Slate renders Month/Day/Year as three select elements with an aria-label
       only. We give each a real visible label (for=id, both visible AND
       programmatic), and DROP the now-redundant aria-label so the accessible name
       comes from the real label (no double naming).
       ============================================================ -->
  <!-- C#:
         var part = el.Attr("aria-label");
         if (el.Name == "select" && (part == "Month" || part == "Day" || part == "Year"))
             return new XElement("span", new XAttribute("class", "wsu-subfield"),
                 new XElement("label",
                     new XAttribute("class", "wsu-subfield__label"),
                     new XAttribute("for", el.Attr("id")),   // for="{@id}": ties the label to this select
                     part),                                  // visible text: Month / Day / Year
                 new XElement("select",
                     el.Attributes().Where(a => a.Name != "aria-label"),  // drop the now-redundant aria-label
                     el.Nodes().Select(Visit)));                          // the options, unchanged
  -->
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
       REQUIRED FIELDS ON SLATE'S BUILT-IN PAGES (e.g. /account/register).
       These pages are not built with the form builder: no form_question,
       no data-required. Slate instead puts the rule on the control itself,
       data-validate="{ required: true, help: '...' }", and enforces it with
       a JavaScript alert. So: any label whose for= points at a control
       that is required (or at a fieldset holding one, e.g. Birthdate's
       Month/Day/Year) gets "(Required)". form_label labels are excluded;
       the form-builder template above owns those.
       3.0.4: skipped on login forms (any form with a password input). The
       fields are self-evidently required, and Slate's login layout fixes the
       label column at 150px with overflow hidden, which clipped the flag.
       ============================================================ -->
  <!-- C#:
         // xsl:key is an index built ONCE per page, before any template runs:
         var byId = slate.Descendants()
                         .Where(e => e.Attr("id") != null)
                         .ToLookup(e => e.Attr("id"));          // key('by-id', x) is byId[x]

         bool IsRequiredControl(XElement e) =>
             (e.Attr("data-validate") ?? "").Replace(" ", "").Contains("required:true");

         // match: a plain label (not a form-builder form_label) whose for= points
         // at a required control, or at a fieldset that contains one
         // (Birthdate's for="birthdate" points at the fieldset around Month/Day/Year)
         // ...except on a login form (any form with a password box): everyone
         // knows both fields are required, and Slate's 150px label column
         // clips "Password (Required)" (table.plain th has overflow: hidden).
         bool IsLoginForm(XElement e) =>
             e.Ancestors("form").Any(f => f.Descendants("input").Any(i => i.Attr("type") == "password"));

         if (el.Name == "label" && el.Attr("for") != null && !el.HasClass("form_label") &&
             !IsLoginForm(el) &&
             byId[el.Attr("for")].Any(t => IsRequiredControl(t) || t.Descendants().Any(IsRequiredControl)))
             return new XElement("label", el.Attributes(), el.Nodes().Select(Visit), RequiredFlag());
  -->
  <xsl:key name="by-id" match="xhtml:*[@id]" use="@id" />
  <xsl:template match="xhtml:label[@for][not(contains(concat(' ', normalize-space(@class), ' '), ' form_label '))][not(ancestor::xhtml:form[.//xhtml:input[@type='password']])][key('by-id', @for)[contains(translate(@data-validate, ' ', ''), 'required:true') or .//xhtml:*[contains(translate(@data-validate, ' ', ''), 'required:true')]]]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
      <span class="wsu-required-flag">(Required)</span>
    </xsl:copy>
  </xsl:template>
  <!-- ============================================================
       IDENTITY PASS-THROUGH — MUST BE LAST, MUST BE PRESENT.
       Everything Slate emits that we did not explicitly place above flows out
       unchanged. Without it, XSLT's built-in defaults strip unmatched elements
       to text and the form vanishes.
       ============================================================ -->
  <!-- C#: the default case, reached when no template above matched.
         return node switch
         {
             XElement e => new XElement(e.Name,
                               e.Attributes(),                  // attributes copied as-is
                               e.Nodes().Select(Visit)),        // and keep visiting children, so a
                                                                // form_label deep inside still gets flagged
             _          => node                                 // text, comments: copied unchanged
         };
  -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
