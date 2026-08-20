<?xml version="1.0" encoding="utf-8"?>
<!--
  ===========================================================================
  WSU Slate branding — 2.0
  ===========================================================================

  Production stylesheet. No settings overlay: the 1.0 sandbox did its job and
  the design team's feedback is baked in as the defaults below.

  Decisions from the 2026-08-20 review with the WSU web design team:

    * Campus-level and system (tall grid) headers are RESERVED for system
      properties. Both removed \u2014 not offered, not rendered.
    * Global header is the crumb bar, carrying the WSU link only (no campus
      segment).
    * Department header is the unit lockup, light banner, crimson cougar.
      Title reads "FutureCoug".
    * Required fields are marked with "(Required)" inside the label. No
      per-field sentence below the input, no note at the top of the form.

  Everything here is the official WSU Web Design System 3.4.2. The only
  local CSS is in the one block below, and every rule in it is either a
  Slate-specific bug fix or a documented substitution.
  ===========================================================================
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml">

  <xsl:output method="html" indent="no" omit-xml-declaration="yes" encoding="utf-8" />

  <!-- Identity -->
  <xsl:param name="unit-name">FutureCoug</xsl:param>
  <xsl:param name="unit-href">https://admission.wsu.edu/</xsl:param>

  <!--
    The official hosted bundle. It @imports Montserrat, the icon font and
    Swiper, so this one stylesheet is the whole dependency.
  -->
  <xsl:param name="wds-css">https://cdn.web.wsu.edu/designsystem/2.x/dist/bundles/wsu-design-system.css</xsl:param>

  <!-- Content treatments. 1 = on. -->
  <xsl:param name="marked-h2">1</xsl:param>
  <xsl:param name="strip-layout-tables">1</xsl:param>
  <xsl:param name="visible-sublabels">1</xsl:param>
  <xsl:param name="outline-cancel">1</xsl:param>
  <xsl:param name="required-label">(Required)</xsl:param>

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

      <style type="text/css">
        <xsl:text disable-output-escaping="yes">
/* --- required fields --------------------------------------------------- */
/* "(Required)" is emitted into the label. Nothing sits below the input. */
.wsu-required-flag { font-weight: 400; color: #4d4d4d; margin-left: .35em; }

/* --- Month / Day / Year sublabels -------------------------------------- */
/* Slate labels these selects with aria-label only; we promote it to text. */
.wsu-subfield { display: inline-flex; flex-direction: column; }
.wsu-subfield__label { font-size: .8rem; font-weight: 600; color: #4d4d4d; margin-bottom: .2em; }

/* --- Slate layout tables ----------------------------------------------- */
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

/* --- Slate's own modal host -------------------------------------------- */
/*
  dialog_host carries inline left/top but takes its position from Slate's
  stylesheet. Under the design system reset it falls back to static, so a
  hidden ~500px dialog reserves a blank block mid-form (visibility:hidden
  still occupies space). Restoring absolute positioning collapses it and
  leaves the modal working.
*/
.dialog_host { position: absolute; }
.progress_box { position: relative; }

/* --- action buttons ---------------------------------------------------- */
/*
  The kit's base button selectors are more specific than --style-action, so
  they force white text on a light card. The component is meant to run
  without the wsu-button base class; this restores its own colour.
*/
.wsu-slate-submit.wsu-button--style-action { color: #a60f2d; }
        </xsl:text>
      </style>

      <script type="text/javascript">
        <xsl:text disable-output-escaping="yes">
          document.documentElement.setAttribute('data-wsu-striptables', '</xsl:text>
        <xsl:value-of select="$strip-layout-tables" />
        <xsl:text disable-output-escaping="yes">');
        </xsl:text>
      </script>
    </head>
  </xsl:template>

  <xsl:template match="xhtml:body">
    <body>
      <xsl:apply-templates select="@*" />

      <div class="wsu-wrapper-global">
        <div class="wsu-wrapper-site">

          <!-- Global header: crumb bar, WSU link only. -->
          <header class="wsu-header-global wsu-header-global--style-system" aria-label="Washington State University system">
            <ul class="wsu-header-global__menu">
              <li><a href="https://wsu.edu">Washington State University</a></li>
            </ul>
          </header>

          <!-- Department header: unit lockup, light banner, crimson cougar. -->
          <header class="wsu-header-unit" aria-label="Washington State University {$unit-name}">
            <div class="wsu-header-unit__banner">
              <a href="{$unit-href}" class="wsu-logo-lockup wsu-logo-lockup--style-unit">
                <span class="wsu-logo-lockup__icon-wrapper">
                  <svg class="wsu-coug-head" role="img" aria-label="WSU Cougar Head" viewBox="0 0 70.2 69.6"><use href="#wsu-coug" /></svg>
                </span>
                <span class="wsu-logo-lockup__title-wrapper">
                  <span class="wsu-logo-lockup__title"><xsl:value-of select="$unit-name" /></span>
                </span>
              </a>
            </div>
          </header>

          <div class="wsu-wrapper-content">
            <main role="main" id="wsu-content-main" class="wsu-wrapper-main wsu-content wsu-container">
              <article class="wsu-article">
                <xsl:apply-templates select="node()" />
              </article>
            </main>
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
      </div>

      <!-- Cougar head sprite. -->
      <svg width="0" height="0" style="position:absolute;overflow:hidden" aria-hidden="true" focusable="false">
        <symbol id="wsu-coug" viewBox="0 0 70.2 69.6">
          <path d="m42.8 69.6s3.6-1.5 5.5-7.4c1 2.3 1.5 4.8 1.3 7.3-2.3 0.1-4.5 0.2-6.8 0.1zm14.9-11.8c-10.4 1.4-12.2-20.3-12.2-20.3s3.5 11.1 10.9 10.7c7.7-0.4 5.5-12.2 5.5-12.2s7.5 20.2-4.2 21.8zm-47.7-5c-3.3 1-6.6 1.8-10 2.4 0 0 5.9-4.5 10.3-18.3l4.3 3.9-0.8 2.6c1.1 1.5 1.9 3.1 2.5 4.9 1.6-3.6 1.5-7.7-0.3-11.2l-0.5 1.6-1.7-1.5-2.8-2.7c1.2-3.6 3-7 5.3-10.1l0.4 0.4 3.3 3.8-1 1.7c1.5 1.7 2.9 3.4 4.2 5.3 0.6-3.4 0.4-6.8-0.4-10.1l-1.5 1.4-3.6-4.2c4.5-4.7 10-8.2 16.2-10.3-0.4 0.4-0.7 0.8-1 1.3-2 2.9-4.1 8.1-2.4 16.4 0.3 1.3 0.7 3.2 1.1 5.1 0.9 3.8 1.9 8.2 2.2 10.9 0.7 5.7 0.1 9.4-1.8 11.4-1.3 1.4-3.5 2-6.4 1.9v-1.4c0-2.4-0.3-4.8-0.8-7.2l-0.8-2.7-1.2 2.6c-1.9 4.1-8.6 14.1-17.2 16.1 2.6-4.2 4.1-9 4.4-14zm25.4 16.4h-0.5-0.1-0.3c-0.5 0-0.8-0.1-1.2-0.1-0.7-0.1-1.6-0.2-2.6-0.4-6.4-1.1-12.9-1.7-19.4-2 6.2-3.6 10.4-9.9 12-12.5 0.2 1.3 0.3 2.5 0.3 3.8 0 0.8 0 1.6-0.1 2.2l-0.1 1.1 1.1 0.1c0.7 0.1 1.3 0.1 1.9 0.1 3.3 0 5.7-0.8 7.3-2.5 2.4-2.5 3.1-6.7 2.3-13.1-0.4-2.9-1.4-7.4-2.3-11.1-0.5-2-0.9-3.8-1.1-5-1.5-7.6 0.3-12.3 2.1-14.8 1.3-1.9 3.2-3.4 5.5-4.2h0.1l3.3-10.8h1.1l-2.3 10.3c0.7-0.1 1.2-0.2 1.7-0.3l3-9.5h1.1l-2 9.2c2.9-0.4 6.1-0.7 10.3-1 0.8 0.4 1.4 1.1 1.8 1.9l9.8-3 0.4 1.1-9.5 3.7c0.1 0.2 0.2 0.4 0.2 0.6l10.3-1.3 0.2 1.1-10 2c0 0.2 0.1 0.4 0.1 0.6l10.4 0.3v1.1l-10.2 0.4c0 1.2-0.2 2.4-0.5 3.6 0.6 2.1 0.7 4.3 0.3 6.5-1.7-3.9-3-5.1-3-5.1-1.4-0.7-2.9-1-4.5-1-2.5 0-4.8 1.1-6.4 2.9-2.3 2.6-3.5 6-3.3 9.5 0.2 2.4 0.7 5.1 1.4 8.6 0.7 3.6 1.6 8.1 2.3 13.5 0.6 4.1-0.1 7.3-1.8 9.7-1.6 2.1-4 3.4-6.5 3.8h-0.1-0.2-0.1-2.2zm10.4-51.5c-2.1-0.1-4.2 0.4-6 1.3-1.5 1-2.5 2.7-2.6 4.5-0.1 0.6-0.1 1.2 0 1.8 0.8-1.5 2-2.8 3.3-3.9 2.4-1.5 5.1-2.3 7.9-2.4h0.9 0.3c0.4 0 0.7-0.1 0.8-0.2 0-0.1-0.1-0.3-0.4-0.4-1.3-0.5-2.7-0.8-4.2-0.7z" />
        </symbol>
      </svg>
    </body>
  </xsl:template>

  <!-- ==========================================================
       Transforms
       ========================================================== -->

  <!--
    Required fields. "(Required)" goes inside the label, so the requirement
    is announced with the field's name and nothing trails the input.
  -->
  <xsl:template match="xhtml:label[contains(@class, 'form_label')]">
    <label>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="node()" />
      <xsl:if test="ancestor::*[@data-required = '1' or contains(@class, 'required')][1]">
        <span class="wsu-required-flag"><xsl:text> </xsl:text><xsl:value-of select="$required-label" /></span>
      </xsl:if>
    </label>
  </xsl:template>

  <!-- Slate sometimes emits the label as a div. Same treatment. -->
  <xsl:template match="xhtml:div[contains(@class, 'form_label')]">
    <div>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="node()" />
      <xsl:if test="ancestor::*[@data-required = '1' or contains(@class, 'required')][1]">
        <span class="wsu-required-flag"><xsl:text> </xsl:text><xsl:value-of select="$required-label" /></span>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- Section headings. -->
  <xsl:template match="xhtml:div[contains(@class, 'form_h2')]">
    <h2>
      <xsl:attribute name="class">
        <xsl:text>wsu-slate-h2</xsl:text>
        <xsl:if test="$marked-h2 = '1'"> wsu-heading--style-marked</xsl:if>
      </xsl:attribute>
      <xsl:apply-templates select="node()" />
    </h2>
  </xsl:template>

  <!-- Month / Day / Year: promote Slate's aria-label to a visible sublabel. -->
  <xsl:template match="xhtml:select[@aria-label][not(contains(@class, 'form_input'))]">
    <xsl:choose>
      <xsl:when test="$visible-sublabels = '1'">
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
      </xsl:when>
      <xsl:otherwise>
        <select>
          <xsl:apply-templates select="@*" />
          <xsl:apply-templates select="node()" />
        </select>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Cancel keeps the outline treatment so Submit stays primary. -->
  <xsl:template match="xhtml:button[normalize-space(.) = 'Cancel'] | xhtml:input[@type = 'button'][@value = 'Cancel']">
    <button type="button">
      <xsl:attribute name="class">
        <xsl:text>form_button wsu-button wsu-slate-cancel</xsl:text>
        <xsl:if test="$outline-cancel = '1'"> wsu-button--style-outline</xsl:if>
      </xsl:attribute>
      <xsl:text>Cancel</xsl:text>
    </button>
  </xsl:template>

  <!-- Submit. -->
  <xsl:template match="xhtml:button[contains(@class, 'form_button')][not(normalize-space(.) = 'Cancel')]">
    <button class="form_button wsu-button wsu-slate-submit">
      <xsl:apply-templates select="@*[name() != 'class']" />
      <xsl:apply-templates select="node()" />
    </button>
  </xsl:template>

  <!-- Data tables pick up the design system table. -->
  <xsl:template match="xhtml:table[not(@role = 'presentation')][not(contains(@class, 'form_layout'))]">
    <table class="wsu-table wsu-slate-table">
      <xsl:apply-templates select="@*[name() != 'class']" />
      <xsl:apply-templates select="node()" />
    </table>
  </xsl:template>

  <!-- ==========================================================
       Identity — everything else passes through
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
