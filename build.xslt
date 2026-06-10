<?xml version="1.0" encoding="utf-8" ?>
<!--
  WSU ADMISSIONS — Slate global branding template
  build.xslt · v2.0 · 2026-06

  Drop-in replacement for /shared/build.xslt. Wraps every Slate-hosted page
  (forms, events, portals) in the WSU chrome and links the WSU Form Kit CSS.

  WHAT CHANGED FROM THE STOCK FILE
   · Links /shared/wsu-chrome.css + /shared/wsu-forms.css (the kit) AFTER the
     web-design-system stylesheets so the kit wins the cascade with no !important.
   · Loads Montserrat (official WSU web font) alongside the legacy Open Sans.
   · Single-color wordmark (no multi-color W/S/U).
   · Two-layer footer: rich Office-of-Admissions unit footer + thin global bar.
   · Copyright year bumped to 2026.

  DEPLOY: upload to /dev/, Preview a real form, then Publish to /shared/.
  Bump every ?v=YYYYMMDD when you edit a linked CSS file or the cache won't clear.
  A broken build.xslt takes down ALL external pages — TEST INSTANCE ONLY first.
-->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:fw="http://technolutions.com/framework" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xhtml">
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <template path="/shared/base.xslt" xmlns="http://technolutions.com/framework" />
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <script src="/shared/gtm-primary-container.js?v=20250827" />

        <!-- Legacy WSU Web Design System (kept; the kit layers on top) -->
        <link href="/shared/web-design-system/style.css?v=20220215" rel="stylesheet" />
        <link href="/shared/web-design-system-overrides.css?v=20220215" rel="stylesheet" />
        <link href="/shared/build-mobile-global.css" rel="stylesheet" />
        <script src="/shared/build-mobile-global.js" />

        <!-- WSU Form Kit v2.0 — MUST load after the WDS files above -->
        <link href="/shared/wsu-chrome.css?v=20260609" rel="stylesheet" />
        <link href="/shared/wsu-forms.css?v=20260609" rel="stylesheet" />

        <!-- Fonts: Montserrat (official web) + legacy Open Sans for the spine -->
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,600&amp;display=swap" />
        <link rel="stylesheet" id="c_open-sans-css" href="https://fonts.googleapis.com/css?family=Open+Sans%3A400%2C400italic%2C700%2C700italic&amp;subset=latin%2Clatin-ext&amp;ver=4.9.9" type="text/css" media="all" />

        <style>html &gt; body { line-height: normal; } ul.cr, li.cr { margin: 0; padding: 0; } #content { clear: both; padding: 15px; min-height:315px;} #global { float: right; } #global ul, #global li { list-style: none; margin: 0; padding: 0; }</style>

        <!-- Slate-contributed head content (framework CSS, per-form styles, title) -->
        <xsl:apply-templates select="xhtml:html/xhtml:head/node()" />

        <style>html { overflow-x: hidden; }</style>
        <script src="/shared/google-tag-manager.js?v=20231121" />
      </head>
      <body>
        <!-- Google Tag Manager (noscript) -->
        <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-P9RHP4V" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
        <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-N6XQX3R" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
        <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-ML2ZZKHZ" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
        <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-5BGKTN2" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>

        <xsl:copy-of select="xhtml:html/xhtml:body/@*" />

        <!-- Start document wrapper -->
        <div id="page" class="wsu-document-wrapper wsu-wrapper-global">

          <!-- Skip link -->
          <a class="wsu-skip" href="#wsu-content">Skip to content</a>

          <!-- Global header -->
          <header class="wsu-header-global wsu-header-global--dark wsu-header-global--navless" role="banner">
            <a class="wsu-wordmark" href="https://wsu.edu">
              <span class="wsu-coug-head-boxed">
                <svg class="wsu-coug-head-boxed__icon" aria-hidden="true" focusable="false" viewBox="0 0 70.2 69.6" xml:space="preserve" xmlns="http://www.w3.org/2000/svg">
                  <path d="m42.8 69.6s3.6-1.5 5.5-7.4c1 2.3 1.5 4.8 1.3 7.3-2.3 0.1-4.5 0.2-6.8 0.1zm14.9-11.8c-10.4 1.4-12.2-20.3-12.2-20.3s3.5 11.1 10.9 10.7c7.7-0.4 5.5-12.2 5.5-12.2s7.5 20.2-4.2 21.8zm-47.7-5c-3.3 1-6.6 1.8-10 2.4 0 0 5.9-4.5 10.3-18.3l4.3 3.9-0.8 2.6c1.1 1.5 1.9 3.1 2.5 4.9 1.6-3.6 1.5-7.7-0.3-11.2l-0.5 1.6-1.7-1.5-2.8-2.7c1.2-3.6 3-7 5.3-10.1l0.4 0.4 3.3 3.8-1 1.7c1.5 1.7 2.9 3.4 4.2 5.3 0.6-3.4 0.4-6.8-0.4-10.1l-1.5 1.4-3.6-4.2c4.5-4.7 10-8.2 16.2-10.3-0.4 0.4-0.7 0.8-1 1.3-2 2.9-4.1 8.1-2.4 16.4 0.3 1.3 0.7 3.2 1.1 5.1 0.9 3.8 1.9 8.2 2.2 10.9 0.7 5.7 0.1 9.4-1.8 11.4-1.3 1.4-3.5 2-6.4 1.9v-1.4c0-2.4-0.3-4.8-0.8-7.2l-0.8-2.7-1.2 2.6c-1.9 4.1-8.6 14.1-17.2 16.1 2.6-4.2 4.1-9 4.4-14zm25.4 16.4h-0.5-0.1-0.3c-0.5 0-0.8-0.1-1.2-0.1-0.7-0.1-1.6-0.2-2.6-0.4-6.4-1.1-12.9-1.7-19.4-2 6.2-3.6 10.4-9.9 12-12.5 0.2 1.3 0.3 2.5 0.3 3.8 0 0.8 0 1.6-0.1 2.2l-0.1 1.1 1.1 0.1c0.7 0.1 1.3 0.1 1.9 0.1 3.3 0 5.7-0.8 7.3-2.5 2.4-2.5 3.1-6.7 2.3-13.1-0.4-2.9-1.4-7.4-2.3-11.1-0.5-2-0.9-3.8-1.1-5-1.5-7.6 0.3-12.3 2.1-14.8 1.3-1.9 3.2-3.4 5.5-4.2h0.1l3.3-10.8h1.1l-2.3 10.3c0.7-0.1 1.2-0.2 1.7-0.3l3-9.5h1.1l-2 9.2c2.9-0.4 6.1-0.7 10.3-1 0.8 0.4 1.4 1.1 1.8 1.9l9.8-3 0.4 1.1-9.5 3.7c0.1 0.2 0.2 0.4 0.2 0.6l10.3-1.3 0.2 1.1-10 2c0 0.2 0.1 0.4 0.1 0.6l10.4 0.3v1.1l-10.2 0.4c0 1.2-0.2 2.4-0.5 3.6 0.6 2.1 0.7 4.3 0.3 6.5-1.7-3.9-3-5.1-3-5.1-1.4-0.7-2.9-1-4.5-1-2.5 0-4.8 1.1-6.4 2.9-2.3 2.6-3.5 6-3.3 9.5 0.2 2.4 0.7 5.1 1.4 8.6 0.7 3.6 1.6 8.1 2.3 13.5 0.6 4.1-0.1 7.3-1.8 9.7-1.6 2.1-4 3.4-6.5 3.8h-0.1-0.2-0.1-2.2zm10.4-51.5c-2.1-0.1-4.2 0.4-6 1.3-1.5 1-2.5 2.7-2.6 4.5-0.1 0.6-0.1 1.2 0 1.8 0.8-1.5 2-2.8 3.3-3.9 2.4-1.5 5.1-2.3 7.9-2.4h0.9 0.3c0.4 0 0.7-0.1 0.8-0.2 0-0.1-0.1-0.3-0.4-0.4-1.3-0.5-2.7-0.8-4.2-0.7z"></path>
                </svg>
              </span>
              <span class="wsu-wordmark__title">Washington State University</span>
            </a>
            <nav class="wsu-header-global__nav" aria-label="WSU utility">
              <ul class="wsu-menu-utility-horizontal">
                <li><a href="https://foundation.wsu.edu/">Give</a></li>
                <li><a href="https://admission.wsu.edu/apply/as/find-your-application/">Apply</a></li>
                <li><a href="https://wsu.edu/about/statewide/">Locations</a></li>
                <li><a href="https://mywsu.wsu.edu/">My WSU</a></li>
              </ul>
            </nav>
          </header>

          <!-- Content wrapper — Slate injects the form/portal/event here.
               wsu-content carries the kit's form styling + Slate mapping layer. -->
          <div class="wsu-wrapper-site">
            <main id="wsu-content" class="wsu-wrapper-content wsu-content wsu-copy" tabindex="-1">
              <div id="global" />
              <xsl:apply-templates select="xhtml:html/xhtml:body/node()" />
            </main>
          </div>

          <!-- Two-layer footer: rich unit footer + thin global bar -->
          <footer class="wsu-footer-unit">
            <div class="wsu-footer-unit__inner">
              <div>
                <div class="wsu-footer-unit__logo">Office of Admissions</div>
                <div class="wsu-footer-unit__contact">
                  <p>370 Lighty Student Services Building<br />Washington State University<br />PO Box 641067 · Pullman, WA 99164-1067</p>
                  <p>Call or Text: <a href="tel:5095535450">509-553-5450</a></p>
                  <p>Email: <a href="mailto:future.coug@wsu.edu">future.coug@wsu.edu</a></p>
                  <p>Monday&#8211;Friday, 8 a.m. &#8211; 5 p.m.</p>
                </div>
              </div>
              <div class="wsu-footer-unit__nav">
                <p class="wsu-footer-unit__nav-title">Admissions</p>
                <ul>
                  <li><a href="https://admission.wsu.edu/apply/">Apply</a></li>
                  <li><a href="https://admission.wsu.edu/cost/">Cost &amp; Aid</a></li>
                  <li><a href="https://admission.wsu.edu/visit/">Visit &amp; Explore</a></li>
                  <li><a href="https://admission.wsu.edu/learn-at-wsu/">Academic Programs</a></li>
                </ul>
              </div>
              <div class="wsu-footer-unit__nav">
                <p class="wsu-footer-unit__nav-title">Resources For</p>
                <ul>
                  <li><a href="https://admission.wsu.edu/admitted-pullman/">Admitted Students</a></li>
                  <li><a href="https://admission.wsu.edu/information-for-counselors/">Counselors</a></li>
                  <li><a href="https://admission.wsu.edu/family/">Parents &amp; Families</a></li>
                  <li><a href="https://admission.wsu.edu/information-for-veterans-and-military/">Veterans &amp; Military</a></li>
                </ul>
              </div>
            </div>
          </footer>
          <footer class="wsu-footer-global">
            <div class="wsu-footer-global__copyright">&#xA9; Washington State University 2026 &#183; Office of Admissions</div>
            <nav class="wsu-footer-global__nav" aria-label="WSU global">
              <ul class="wsu-menu-utility-horizontal">
                <li><a href="https://access.wsu.edu/">Access</a></li>
                <li><a href="https://policies.wsu.edu/">Policies</a></li>
                <li><a href="https://portal.wsu.edu/">MyWSU</a></li>
                <li><a href="https://socialmedia.wsu.edu/">Follow WSU</a></li>
              </ul>
            </nav>
          </footer>

        </div>
        <!-- End document wrapper -->
      </body>
    </html>
  </xsl:template>

  <!-- Identity template: copy everything else (incl. the form itself) through unchanged -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
