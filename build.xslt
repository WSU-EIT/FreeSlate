<?xml version="1.0" encoding="utf-8" ?>
<!--
  WSU EIT FORMS - Slate global page template for WSU Admissions
  build.xslt - v8 - authored fresh 2026-06-11 (clean-room rewrite; no markup
  carried over from prior WSU templates). Third-party pieces retained by
  necessity: the Technolutions framework contract, the GTM loader scripts,
  Google Fonts / wsu-icons CDN, and the official WSU cougar mark + brand URLs.

  Ships with: build-fonts.css (fonts) + build.css (all styling) + wsu-eit-aria.js
  (accessibility repairs). All four live in /shared/; the Branding Editor's
  Publish writes the build.* trio every time, so Publish IS the deploy.

  Cache rule: bump every ?v= below whenever a linked file changes, or Slate
  serves the stale copy for up to a day.
  Safety rule: a malformed build.xslt breaks EVERY external page - always
  /dev/ + test-instance Preview before Publish.
-->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xhtml">
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <template path="/shared/base.xslt" xmlns="http://technolutions.com/framework" />
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <!-- analytics (third-party loaders, unchanged from instance config) -->
        <script src="/shared/gtm-primary-container.js?v=20250827" />

        <!-- WSU EIT Forms styling layer -->
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
        <link href="/shared/build-fonts.css?v=20260611" rel="stylesheet" />
        <!-- 20260613a: tunable design tokens — hardcoded sizes (link size/weight,
             focus ring, radii, required edge, h1 bar, star color, field
             density, column, wash) promoted to §TOKENS vars so the showcase
             Tune tab can drive them and exports can be adopted verbatim.
             20260612b: Slate's real submit (<button class="default">) now
             painted crimson — the class-less-button guard had excluded it.
             20260612a: production-parity topbar. -->
        <link href="/shared/build.css?v=20260613a" rel="stylesheet" />
        <!-- Opt-in editor components (reel/carousel, FAQ accordion, steps,
             cards, stats, banner, timeline, badges, tables, scroll reveal).
             All CSS-only. Safe to remove: pages lose the extras, nothing
             else changes. -->
        <link href="/shared/wsu-eit-extras.css?v=20260611d" rel="stylesheet" />
        <!-- THE ONE JavaScript exception (dept. policy: CSS-first).
             wsu-eit-aria.js repairs what stylesheets cannot: Slate emits
             internal/hidden fields with no accessible names and empty
             <label> elements; adding aria-labels and removing elements is
             DOM work, impossible in CSS. Removing this line restores those
             WAVE errors but breaks nothing visual. -->
        <script src="/shared/wsu-eit-a11y.js?v=20260612a" defer="defer"><xsl:text> </xsl:text></script>
        <!-- Opt-in behaviors (copy buttons, character counters, local-time
             rendering, FAQ expand-all, static-list filter). Activates ONLY
             on data-eit-* attributes; pages without them are untouched.
             Deadline messaging deliberately NOT here: Slate's deadlines,
             activation dates, and closed messages are the native tools. -->
        <script src="/shared/wsu-eit-extras.js?v=20260611c" defer="defer"><xsl:text> </xsl:text></script>

        <!-- Slate-contributed head content (framework CSS, per-form Edit Styles, title) -->
        <xsl:apply-templates select="xhtml:html/xhtml:head/node()" />

        <style>html { overflow-x: hidden; }</style>
        <script src="/shared/google-tag-manager.js?v=20231121" />
      </head>
      <body>
        <!-- No GTM noscript iframes: tracking-only fallbacks that drew WAVE
             alerts and served no user. Script loaders above cover analytics.
             (Container IDs on record: GTM-P9RHP4V, GTM-N6XQX3R, GTM-ML2ZZKHZ,
              GTM-5BGKTN2.) -->

        <xsl:copy-of select="xhtml:html/xhtml:body/@*" />

        <div id="wsu-eit-frame" class="wsu-eit">
        <!-- ^ class="wsu-eit" is the OWNERSHIP HOOK: build.css hangs its
             global rules (links, type) off this one class, so everything
             inside the frame is provably styled by EIT. See the FIND-IT
             index at the top of build.css. -->

          <a class="wsu-eit-skip" href="#wsu-eit-main">Skip to content</a>

          <header class="wsu-eit-topbar">
            <a class="wsu-eit-mark" href="https://wsu.edu">
              <span class="wsu-eit-mark__crest" aria-hidden="true">
                <svg focusable="false" viewBox="0 0 70.2 69.6" xml:space="preserve" xmlns="http://www.w3.org/2000/svg">
                  <path d="m42.8 69.6s3.6-1.5 5.5-7.4c1 2.3 1.5 4.8 1.3 7.3-2.3 0.1-4.5 0.2-6.8 0.1zm14.9-11.8c-10.4 1.4-12.2-20.3-12.2-20.3s3.5 11.1 10.9 10.7c7.7-0.4 5.5-12.2 5.5-12.2s7.5 20.2-4.2 21.8zm-47.7-5c-3.3 1-6.6 1.8-10 2.4 0 0 5.9-4.5 10.3-18.3l4.3 3.9-0.8 2.6c1.1 1.5 1.9 3.1 2.5 4.9 1.6-3.6 1.5-7.7-0.3-11.2l-0.5 1.6-1.7-1.5-2.8-2.7c1.2-3.6 3-7 5.3-10.1l0.4 0.4 3.3 3.8-1 1.7c1.5 1.7 2.9 3.4 4.2 5.3 0.6-3.4 0.4-6.8-0.4-10.1l-1.5 1.4-3.6-4.2c4.5-4.7 10-8.2 16.2-10.3-0.4 0.4-0.7 0.8-1 1.3-2 2.9-4.1 8.1-2.4 16.4 0.3 1.3 0.7 3.2 1.1 5.1 0.9 3.8 1.9 8.2 2.2 10.9 0.7 5.7 0.1 9.4-1.8 11.4-1.3 1.4-3.5 2-6.4 1.9v-1.4c0-2.4-0.3-4.8-0.8-7.2l-0.8-2.7-1.2 2.6c-1.9 4.1-8.6 14.1-17.2 16.1 2.6-4.2 4.1-9 4.4-14zm25.4 16.4h-0.5-0.1-0.3c-0.5 0-0.8-0.1-1.2-0.1-0.7-0.1-1.6-0.2-2.6-0.4-6.4-1.1-12.9-1.7-19.4-2 6.2-3.6 10.4-9.9 12-12.5 0.2 1.3 0.3 2.5 0.3 3.8 0 0.8 0 1.6-0.1 2.2l-0.1 1.1 1.1 0.1c0.7 0.1 1.3 0.1 1.9 0.1 3.3 0 5.7-0.8 7.3-2.5 2.4-2.5 3.1-6.7 2.3-13.1-0.4-2.9-1.4-7.4-2.3-11.1-0.5-2-0.9-3.8-1.1-5-1.5-7.6 0.3-12.3 2.1-14.8 1.3-1.9 3.2-3.4 5.5-4.2h0.1l3.3-10.8h1.1l-2.3 10.3c0.7-0.1 1.2-0.2 1.7-0.3l3-9.5h1.1l-2 9.2c2.9-0.4 6.1-0.7 10.3-1 0.8 0.4 1.4 1.1 1.8 1.9l9.8-3 0.4 1.1-9.5 3.7c0.1 0.2 0.2 0.4 0.2 0.6l10.3-1.3 0.2 1.1-10 2c0 0.2 0.1 0.4 0.1 0.6l10.4 0.3v1.1l-10.2 0.4c0 1.2-0.2 2.4-0.5 3.6 0.6 2.1 0.7 4.3 0.3 6.5-1.7-3.9-3-5.1-3-5.1-1.4-0.7-2.9-1-4.5-1-2.5 0-4.8 1.1-6.4 2.9-2.3 2.6-3.5 6-3.3 9.5 0.2 2.4 0.7 5.1 1.4 8.6 0.7 3.6 1.6 8.1 2.3 13.5 0.6 4.1-0.1 7.3-1.8 9.7-1.6 2.1-4 3.4-6.5 3.8h-0.1-0.2-0.1-2.2zm10.4-51.5c-2.1-0.1-4.2 0.4-6 1.3-1.5 1-2.5 2.7-2.6 4.5-0.1 0.6-0.1 1.2 0 1.8 0.8-1.5 2-2.8 3.3-3.9 2.4-1.5 5.1-2.3 7.9-2.4h0.9 0.3c0.4 0 0.7-0.1 0.8-0.2 0-0.1-0.1-0.3-0.4-0.4-1.3-0.5-2.7-0.8-4.2-0.7z"></path>
                </svg>
              </span>
              <span class="wsu-eit-mark__name">Washington State University</span>
            </a>
            <nav class="wsu-eit-topbar__menu" aria-label="University quick links">
              <ul>
                <li><a href="https://foundation.wsu.edu/">Give</a></li>
                <li><a href="https://admission.wsu.edu/apply/as/find-your-application/">Apply</a></li>
                <li><a href="https://wsu.edu/about/statewide/">Locations</a></li>
                <li><a href="https://mywsu.wsu.edu/">My WSU</a></li>
              </ul>
            </nav>
          </header>

          <!-- Slate injects the page (form / event / portal) below.
               main.wsu-eit-zone is the single styling hook build.css scopes to. -->
          <main id="wsu-eit-main" class="wsu-eit-zone" tabindex="-1">
            <xsl:apply-templates select="xhtml:html/xhtml:body/node()" />
          </main>

          <footer class="wsu-eit-deck">
            <div class="wsu-eit-deck__cols">
              <div>
                <h2>Office of Admissions</h2>
                <p>370 Lighty Student Services Building<br />Washington State University<br />PO Box 641067 &#xB7; Pullman, WA 99164-1067</p>
                <p>Call or text: <a href="tel:5095535450">509-553-5450</a><br />Email: <a href="mailto:future.coug@wsu.edu">future.coug@wsu.edu</a><br />Monday&#x2013;Friday, 8 a.m.&#x2013;5 p.m.</p>
              </div>
              <div>
                <h2>Admissions</h2>
                <ul>
                  <li><a href="https://admission.wsu.edu/apply/">Apply</a></li>
                  <li><a href="https://admission.wsu.edu/cost/">Cost &amp; Aid</a></li>
                  <li><a href="https://admission.wsu.edu/visit/">Visit &amp; Explore</a></li>
                  <li><a href="https://admission.wsu.edu/learn-at-wsu/">Academic Programs</a></li>
                </ul>
              </div>
              <div>
                <h2>Resources For</h2>
                <ul>
                  <li><a href="https://admission.wsu.edu/admitted-pullman/">Admitted Students</a></li>
                  <li><a href="https://admission.wsu.edu/information-for-counselors/">Counselors</a></li>
                  <li><a href="https://admission.wsu.edu/family/">Parents &amp; Families</a></li>
                  <li><a href="https://admission.wsu.edu/information-for-veterans-and-military/">Veterans &amp; Military</a></li>
                </ul>
              </div>
            </div>
          </footer>
          <footer class="wsu-eit-baseline">
            <div>&#xA9; 2026 Washington State University &#xB7; Office of Admissions &#xB7; <span class="wsu-eit-credit">Built by Enrollment Information Technology</span></div>
            <nav class="wsu-eit-baseline__menu" aria-label="University policies">
              <ul>
                <li><a href="https://access.wsu.edu/">Access</a></li>
                <li><a href="https://policies.wsu.edu/">Policies</a></li>
                <li><a href="https://portal.wsu.edu/">MyWSU</a></li>
                <li><a href="https://socialmedia.wsu.edu/">Follow WSU</a></li>
              </ul>
            </nav>
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>
  <!-- pass-through: everything Slate emits flows out unchanged -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
