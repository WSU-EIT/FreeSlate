/* ════════════════════════════════════════════════════════════════
   wsu-eit-view.js — SHOWCASE-ONLY "curated view" layer
   ----------------------------------------------------------------
   Reads window.WSU_VIEW (set inline in each index_*.html) and trims the
   Tune panel down to the handful of settings THAT view proposes — or, in
   'presets' mode, replaces the 41 knobs with a 3-way personality picker.

   It changes NOTHING about the kit: build.css / wsu-eit-extras.css and the
   full 41-token configurator in wsu-eit-showcase.js are untouched. This file
   only hides cards the showcase already built and drives the SAME
   --wsu-eit-* custom properties the kit already consumes. Delete the two
   lines that load it and you are back to the full showcase.

   Purpose: give the team five concrete "what people actually want" subsets
   to react to, instead of debating all 41 at once.
   ════════════════════════════════════════════════════════════════ */
(function () {
  var V = window.WSU_VIEW;
  if (!V) return;

  /* the five proposed views + the full set — drives the switcher tabs that
     appear on every one of these pages so the team can flip between them */
  var VIEWS = [
    { id: 'essentials',  file: 'index_essentials.html',      label: 'Essentials',   n: 6 },
    { id: 'readability', file: 'index_readability.html',     label: 'Readability',  n: 8 },
    { id: 'formfeel',    file: 'index_form-feel.html',       label: 'Form feel',    n: 9 },
    { id: 'guardrails',  file: 'index_brand-guardrails.html', label: 'Guardrails',   n: 7 },
    { id: 'presets',     file: 'index_presets.html',         label: 'Presets only', n: 0 },
    { id: 'full',        file: 'index.html',                 label: 'Full set',     n: 41 }
  ];

  function ready(fn) {
    if (document.readyState !== 'loading') fn();
    else document.addEventListener('DOMContentLoaded', fn);
  }
  ready(function () { start(0); });

  /* the showcase builds the Tune cards from a deferred script; wait for them */
  function start(tries) {
    var host = document.getElementById('tune-controls');
    var cards = host ? host.querySelectorAll('.tune-card') : null;
    if ((!cards || !cards.length) && tries < 90) {
      return requestAnimationFrame(function () { start(tries + 1); });
    }
    injectStyle();
    if (V.mode === 'presets') initPresets();
    else initTune(cards || []);
  }

  /* ── shared chrome ─────────────────────────────────────────────── */
  function injectStyle() {
    if (document.getElementById('wsu-view-style')) return;
    var css = '' +
      '.vw-banner{border:0.0625em solid #e2d4d7;background:#fcf6f7;border-left:0.3em solid #a60f2d;border-radius:0.5em;padding:1em 1.15em;margin:0 0 1.1em;}' +
      '.vw-kicker{font:800 .62em/1 Montserrat,sans-serif;letter-spacing:.13em;text-transform:uppercase;color:#a60f2d;margin:0 0 .45em;}' +
      '.vw-title{font:800 1.32em/1.1 Montserrat,sans-serif;color:#262626;margin:0 0 .35em;}' +
      '.vw-blurb{font-size:.9em;line-height:1.5;color:#3a3a3a;margin:0 0 .7em;max-width:60ch;}' +
      '.vw-count{display:inline-block;font:700 .72em Montserrat,sans-serif;color:#595959;background:#fff;border:0.0625em solid #d9d9d9;border-radius:999px;padding:.25em .7em;}' +
      '.vw-tabs{display:flex;flex-wrap:wrap;gap:.4em;margin:.85em 0 0;}' +
      '.vw-tab{font:700 .76em Montserrat,sans-serif;text-decoration:none;color:#262626;background:#fff;border:0.0625em solid #d9d9d9;border-radius:999px;padding:.4em .8em;display:inline-flex;align-items:center;gap:.4em;transition:border-color .12s,color .12s,background .12s;}' +
      '.vw-tab:hover{border-color:#a60f2d;color:#a60f2d;}' +
      '.vw-tab:focus-visible{outline:0.1875em solid #a60f2d;outline-offset:0.125em;}' +
      '.vw-tab--here{cursor:default;}' +
      '.vw-tab .vw-tab__n{font-size:.85em;color:#909090;}' +
      '.vw-tab[aria-current="true"]{background:#a60f2d;border-color:#a60f2d;color:#fff;}' +
      '.vw-tab[aria-current="true"] .vw-tab__n{color:#f3c9d1;}' +
      /* presets bar */
      '.vw-presets{border:0.0625em solid #e2d4d7;background:#fff;border-radius:0.6em;padding:1.15em 1.25em 1.3em;margin:0 0 1.5em;box-shadow:0 0.06em 0.3em rgba(0,0,0,.05);}' +
      '.vw-preset-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(13em,1fr));gap:.7em;margin:.9em 0 .2em;}' +
      '.vw-preset{text-align:left;cursor:pointer;background:#fff;border:0.125em solid #d9d9d9;border-radius:0.5em;padding:.85em .95em;font:inherit;transition:border-color .12s,background .12s;}' +
      '.vw-preset:hover{border-color:#a60f2d;}' +
      '.vw-preset:focus-visible{outline:0.1875em solid #a60f2d;outline-offset:0.125em;}' +
      '.vw-preset[aria-pressed="true"]{border-color:#a60f2d;background:#fcf6f7;}' +
      '.vw-preset__name{font:800 1.02em Montserrat,sans-serif;color:#262626;margin:0 0 .2em;display:flex;align-items:center;gap:.45em;}' +
      '.vw-preset__swatch{width:.85em;height:.85em;border-radius:50%;background:#a60f2d;flex:none;}' +
      '.vw-preset__desc{font-size:.8em;line-height:1.45;color:#595959;margin:0;}' +
      '.vw-preset__tag{display:none;font:700 .6em Montserrat,sans-serif;letter-spacing:.08em;text-transform:uppercase;color:#a60f2d;margin-top:.5em;}' +
      '.vw-preset[aria-pressed="true"] .vw-preset__tag{display:block;}' +
      '.vw-reset{margin-top:.7em;font:700 .76em Montserrat,sans-serif;background:#fff;border:0.0625em solid #767676;border-radius:999px;padding:.4em .85em;cursor:pointer;color:#262626;}' +
      '.vw-reset:hover{background:#f3f3f3;}' +
      '.vw-reset:focus-visible{outline:0.1875em solid #a60f2d;outline-offset:0.125em;}';
    var st = document.createElement('style');
    st.id = 'wsu-view-style';
    st.textContent = css;
    document.head.appendChild(st);
  }

  function switcher() {
    var nav = document.createElement('nav');
    nav.className = 'vw-tabs';
    nav.setAttribute('aria-label', 'Proposed views');
    VIEWS.forEach(function (v) {
      var n = (v.id === 'presets' ? '3' : v.n);
      var label = v.label + ' <span class="vw-tab__n">' + n + '</span>';
      /* the view you're on isn't a link to itself — render it as a
         non-navigating element so clicking it can't trigger a dead reload */
      if (v.id === V.id) {
        var cur = document.createElement('span');
        cur.className = 'vw-tab vw-tab--here';
        cur.setAttribute('aria-current', 'true');
        cur.innerHTML = label;
        nav.appendChild(cur);
      } else {
        var a = document.createElement('a');
        a.className = 'vw-tab';
        a.href = v.file;
        a.innerHTML = label;
        nav.appendChild(a);
      }
    });
    return nav;
  }

  function banner(countText) {
    var b = document.createElement('div');
    b.className = 'vw-banner';
    b.innerHTML =
      '<p class="vw-kicker">Proposed view · pick what the team actually wants</p>' +
      '<h2 class="vw-title">' + V.title + '</h2>' +
      '<p class="vw-blurb">' + V.blurb + '</p>' +
      (countText ? '<span class="vw-count">' + countText + '</span>' : '');
    b.appendChild(switcher());
    return b;
  }

  /* ── tune-subset mode ──────────────────────────────────────────── */
  function initTune(cards) {
    /* open the Tune tab */
    var tab = document.getElementById('railtab-tune');
    if (tab) tab.click();

    var allow = {};
    (V.allow || []).forEach(function (id) { allow[id] = true; });

    var shown = 0;
    [].forEach.call(cards, function (card) {
      var nameEl = card.querySelector('.tune-name');
      var id = nameEl ? nameEl.id.replace(/^tn-/, '') : '';
      if (allow[id]) { shown++; }
      else { card.style.display = 'none'; }
    });

    /* hide any group that has no visible card left */
    [].forEach.call(document.querySelectorAll('.tune-group'), function (g) {
      var anyVisible = [].some.call(g.querySelectorAll('.tune-card'), function (c) {
        return c.style.display !== 'none';
      });
      if (!anyVisible) g.style.display = 'none';
    });

    /* swap the generic intro for this view's banner */
    var railTune = document.getElementById('rail-tune');
    var intro = railTune ? railTune.querySelector('.tune-intro') : null;
    var b = banner(shown + ' of 41 settings shown');
    if (intro) intro.parentNode.replaceChild(b, intro);
    else if (railTune) railTune.insertBefore(b, railTune.firstChild);
  }

  /* ── presets mode (no knobs) ───────────────────────────────────── */
  function initPresets() {
    /* this view is about NOT tuning — hide the Tune tab entirely so the only
       interaction is choosing a personality; the page stays in Browse so the
       whole pattern library re-skins live as you switch */
    var tuneTab = document.getElementById('railtab-tune');
    if (tuneTab) tuneTab.style.display = 'none';

    /* union of every key any preset touches — cleared before each apply so
       presets don't bleed into one another */
    var allKeys = {};
    (V.presets || []).forEach(function (p) {
      Object.keys(p.vars).forEach(function (k) { allKeys[k] = true; });
    });
    var root = document.documentElement;

    function clearAll() { Object.keys(allKeys).forEach(function (k) { root.style.removeProperty(k); }); }

    var bar = document.createElement('div');
    bar.className = 'vw-presets';
    var head = banner('');                 // no count chip for presets
    head.classList.remove('vw-banner');    // re-style: this banner lives inside the card
    head.style.border = 'none';
    head.style.background = 'none';
    head.style.padding = '0';
    head.style.margin = '0';
    head.style.borderLeft = 'none';
    bar.appendChild(head);

    var grid = document.createElement('div');
    grid.className = 'vw-preset-grid';
    var btns = [];
    (V.presets || []).forEach(function (p, i) {
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'vw-preset';
      btn.setAttribute('aria-pressed', 'false');
      btn.innerHTML =
        '<p class="vw-preset__name"><span class="vw-preset__swatch" style="background:' + (p.swatch || '#a60f2d') + '"></span>' + p.name + '</p>' +
        '<p class="vw-preset__desc">' + p.desc + '</p>' +
        '<p class="vw-preset__tag">● Applied — scroll to see the page restyle</p>';
      btn.addEventListener('click', function () {
        clearAll();
        Object.keys(p.vars).forEach(function (k) { root.style.setProperty(k, p.vars[k]); });
        btns.forEach(function (b2) { b2.setAttribute('aria-pressed', 'false'); });
        btn.setAttribute('aria-pressed', 'true');
      });
      btns.push(btn);
      grid.appendChild(btn);
    });
    bar.appendChild(grid);

    var reset = document.createElement('button');
    reset.type = 'button';
    reset.className = 'vw-reset';
    reset.textContent = 'Reset to shipped';
    reset.addEventListener('click', function () {
      clearAll();
      btns.forEach(function (b2) { b2.setAttribute('aria-pressed', 'false'); });
    });
    bar.appendChild(reset);

    /* drop the chooser at the very top of the page content */
    var layout = document.querySelector('.show-layout');
    if (layout && layout.parentNode) layout.parentNode.insertBefore(bar, layout);
  }
})();
